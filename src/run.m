% Array giving the altitude (in meters) of points from a regular grid
% with a cell size of 100m:
% - x goes from 0 to (13-1)*100 meters
% - y goes from 0 to (10-1)*100 meters
%
% In order to preview this terrain, just run:
% > surf(0:100:(13-1)*100,0:100:(10-1)*100, terrain);
terrain = [
	  670   672   670   675   690   680   650   675   690   680   700   892   895;
      680   665   640   630   650   645   630   628   648   650   680   875   893;
      630   615   585   580   585   600   590   610   603   603   630   850   895;
      595   568   555   560   575   580   575   570   580   610   625   800   850;
      550   540   538   550   595   575   600   570   575   620   613   700   730;
      525   530   538   550   603   625   615   580   570   610   590   610   720;
      545   540   538   597   575   605   593   578   573   593   608   595   695;
      615   560   543   579   569   560   563   570   580   595   619   638   650;
      625   598   560   559   586   558   578   585   600   615   655   680   683;
      610   600   610   605   615   618   625   638   648   665   680   700   705
];
% Convert index -> meters
scale = 100;

%% Simple 3D preview
surf(0:scale:(13-1) * scale, 0:scale:(10-1) * scale, terrain);

%% Refine terrain using the diamond-square algorithm
scale = 100;
nPasses = 2;
terrainFine = diamondSquare(terrain, nPasses, .1);
scale = (scale / (2 ^ nPasses));

sz = size(terrainFine);
surf(0:scale:(sz(2)-1) * scale, 0:scale:(sz(1)-1) * scale, terrainFine);

%% Tesselate (generate triangles from the heightmap)
scene = tesselation(terrain, scale);

%% Apply a perspective projection
origin = [100 100 700];
lookAt = [600 600 10];
d = 100;
fov = (pi / 2);
ratio = (16 / 9);

% Test triangles
triangles = [
	0 0 0 1 0 0 1 1 0;
	%0 -1 1 4 3 1 2 4 1;
	%2 1 -1 -4 -3 -1 7 8 -1;
];

%transformed = perspective(triangles, origin, lookAt, d);
transformed = perspective(scene, origin, lookAt, d);

% Sample rendering using Matlab's 2D drawing functions
heights = mean([scene(:, 3) scene(:, 6) scene(:, 9)], 2);
coloredRender(transformed, heights, 'Testing the renderer');
axis(getAxes(d, fov, ratio));

%% Rasterize using painter's algorithm

% Compute each triangle's barycenter's distance to the camera
% ordered = [vertices distance originalHeight] (one line per triangle)
ordered = [transformed zeros(size(transformed, 1), 2)];
for i = 1:size(ordered, 1)
	triangle = reshape(ordered(i, 1:9)', 3, 3);
	barycenter = sum(triangle, 2) ./ 3;
	distance = norm(barycenter - origin');
	ordered(i, 10) = distance;
	ordered(i, 11) = heights(i);
end;
% Render the far-away triangles first,
% they will then be covered up by nearer ones
ordered = sortrows(ordered, -10);

minHeight = min(heights);
maxHeight = max(heights);
axes = getAxes(d, fov, ratio);
xMin = axes(1); xMax = axes(2); yMin = axes(3); yMax = axes(4);

% TODO: determine image size based on pixel density per unit
buffer = ones(round(yMax - yMin), round(xMax - xMin));
offset = -[(xMin + 1) (yMin + 1)];
for i = 1:size(ordered, 1)
	triangle = [ordered(i, 1:2); ordered(i, 4:5); ordered(i, 7:8)];
	% The image buffer is 1-indexed
	% (origin is in a corner, not at the center)
	triangle = triangle + (ones(3, 1) * offset);
	
	% Clip to screen
	triangle = max(triangle, 1);
	triangle(:, 1) = min(triangle(:, 1), size(buffer, 2) - 1);
	triangle(:, 2) = min(triangle(:, 2), size(buffer, 1) - 1);
	
	% TODO: only draw if it is on screen
	
	% Fill image buffer inside this triangle
	% TODO: refactor color mapping
	color = (ordered(i, 11) - minHeight) / (maxHeight - minHeight);
	color = round(245 * color) + 10;
	buffer = fillTriangleBuffer(buffer, triangle, color);
end;

greymap = ((0:255) / 255)' * [1 1 1];
colormap(1 - greymap);
image(imrotate(fliplr(buffer), 180));

%% Rasterize using Z-buffer
% TODO
