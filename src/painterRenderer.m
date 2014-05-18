function [ ] = painterRenderer( ordered, density, axes, cmap, colors )
%PAINTERRENDERER

figure(1);
clf();

xMin = axes(1);
xMax = axes(2);
yMin = axes(3);
yMax = axes(4);

% TODO: determine image size based on pixel density per unit
buffer = ones(density * round(yMax - yMin), density * round(xMax - xMin));
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
    
    triangle = triangle .* (density - 1);
	
	% TODO: only draw if it is on screen
	buffer = fillTriangleBuffer(buffer, triangle, colors(i));
end;


colormap(1 - cmap);
image(imrotate(fliplr(buffer), 180));

end

