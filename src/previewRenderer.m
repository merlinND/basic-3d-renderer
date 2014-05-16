function [ ] = previewRenderer( heightMap )
%PREVIEWRENDERER Renders an heightmap with surf
sz = size(heightMap);
surf(0:100:(sz(2)-1)*100, 0:100:(sz(1)-1)*100, heightMap);
end

