function [ scene ] = tesselation( heightMap, scale )
%TESSELATION Convert an height map to an array of triangles
%
% Arguments:
% - heightMap: the height map to convert
% - scale: the factor to apply to x and y coordinates
%
% Returns:
% - scene: the resulting array of triangles

	sz = size(heightMap);

	scene = zeros(2 * (sz(1)-1) * (sz(2)-1), 9);

	idx = 1;

	for i=1:sz(1)-1
		for j=1:sz(2)-1
			% upper left triangle
			scene(idx, 1) = i;
			scene(idx, 2) = j;
			scene(idx, 3) = heightMap(i, j);
			scene(idx, 4) = i + 1;
			scene(idx, 5) = j;
			scene(idx, 6) = heightMap(i + 1, j);
			scene(idx, 7) = i;
			scene(idx, 8) = j + 1;
			scene(idx, 9) = heightMap(i, j + 1);

			idx = idx + 1;

			% lower right triangle
			scene(idx, 1) = i + 1;
			scene(idx, 2) = j + 1;
			scene(idx, 3) = heightMap(i + 1, j + 1);
			scene(idx, 4) = i + 1;
			scene(idx, 5) = j;
			scene(idx, 6) = heightMap(i + 1, j);
			scene(idx, 7) = i;
			scene(idx, 8) = j + 1;
			scene(idx, 9) = heightMap(i, j + 1);
			idx = idx + 1;
		end
	end
	
	% Scale x and y coordinates
	scene(:, 1:2) = scene(:, 1:2) * scale;
	scene(:, 4:5) = scene(:, 4:5) * scale;
	scene(:, 7:8) = scene(:, 7:8) * scale;
end

