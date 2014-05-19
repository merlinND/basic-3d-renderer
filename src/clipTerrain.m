function [ heightMap ] = clipTerrain( heightMap, clippingValue )
%CLIPTERRAIN

sz = size(heightMap);

for i=1:sz(1)
    for j=1:sz(2)
        if heightMap(i, j) < clippingValue
            heightMap(i, j) = clippingValue;
        end
    end
end
end

