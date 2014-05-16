function [ scene ] = tesselation( heightMap )
%TESSELATION Convert an height map to an array of triangles
%
% Arguments:
% - heightMap: the height map to convert
%
% Returns:
% - scene: the resulting array of triangles

sz = size(heightMap);

scene = zeros(2 * (sz(1)-1) * (sz(2)-1), 3, 3);

idx = 1;

for i=1:sz(1)-1
    for j=1:sz(2)-1
        % upper left triangle
        scene(idx, 1, 1) = i;
        scene(idx, 1, 2) = j;
        scene(idx, 1, 3) = heightMap(i, j);
        scene(idx, 2, 1) = i + 1;
        scene(idx, 2, 2) = j;
        scene(idx, 2, 3) = heightMap(i + 1, j);
        scene(idx, 3, 1) = i;
        scene(idx, 3, 2) = j + 1;
        scene(idx, 3, 3) = heightMap(i, j + 1);
        idx = idx + 1;
        
        % lower right triangle
        scene(idx, 1, 1) = i + 1;
        scene(idx, 1, 2) = j + 1;
        scene(idx, 1, 3) = heightMap(i + 1, j + 1);
        scene(idx, 2, 1) = i + 1;
        scene(idx, 2, 2) = j;
        scene(idx, 2, 3) = heightMap(i + 1, j);
        scene(idx, 3, 1) = i;
        scene(idx, 3, 2) = j + 1;
        scene(idx, 3, 3) = heightMap(i, j + 1);
        idx = idx + 1;
    end
end

end

