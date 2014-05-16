function [ im ] = basicRenderer( W, H, vertices, depths, colors )
%BASICRENDERER

sz = size(vertices, 1);

im = zeros(H, W, 3);
zb = zeros(sz, 1);

for i=1:sz
    im = fillTriangleImage(im, zb, vertices(i), depths(i), [50 50 50]);
end

end

