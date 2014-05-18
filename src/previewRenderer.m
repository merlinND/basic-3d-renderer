function [ ] = previewRenderer( heightMap, scale )
%PREVIEWRENDERER Renders an heightmap with surf at a given scale

sz = size(heightMap);
surf(0:scale:(sz(2)-1) * scale, 0:scale:(sz(1)-1) * scale, heightMap);

end

