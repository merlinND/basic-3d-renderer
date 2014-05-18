%% *LANDSCAPE GENERATION & RENDERING*

%% TERRAIN GENERATION

%% Define a basic terrain
% We'll start with a very simple heightMap from the terrain we want to
% render. We'll do that with a small matrix.
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
scale = 100;

previewRenderer(terrain, scale);

%% Refine terrain
% On this part, we'll use the Diamond-Square Algorithm to create a much
% more complex terrain.
nPasses = 2;
scale = scale/(2^nPasses);
terrainFine = diamondSquare(terrain, nPasses, .1);

previewRenderer(terrainFine, scale);

%% GRAPHIC PIPELINE

%% 1 Scene Generation

%% 1.1 Terrain Tesselation
% We are going to generate triangles from the height maps. We'll call it a
% scene.
scene = tesselation(terrainFine, scale);

%% 1.2 Mesh import
% Add/Import objects into the scene

%% 2 Vertex shader
% Apply a projection that transforms the scene from the 3D world to the 2D
% world keeping track of the vertices distance from the camera (Z-Buffer).

% Define a camera
origin = [0 0 700];
lookAt = [100 100 600];

% Define a perspective
d = 100;
fov = (pi / 2);
ratio = (16 / 9);

% Apply the perspective
transformed = perspective(scene, origin, lookAt, d);

% Color definition height list
heights = mean([scene(:, 3) scene(:, 6) scene(:, 9)], 2);

% Simple renderer
coloredRenderer(transformed, heights, d, fov, ratio);

%% 3 Pixel Shader

%% 3.1 Rasterization via the Painter's Algorithm
% Compute each triangle's barycenter's distance to the camera
% ordered = [vertices distance originalHeight] (one line per triangle)
figure(1);
clf();

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

%% 3.1 Rasterization via the Z-Buffer
% TODO
