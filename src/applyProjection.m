function [ vertices, depths ] = applyProjection( M, triangles )
%APPLYPROJECTION

sz = size(triangles, 1);
vertices = zeros(sz, 3, 2);
depths = zeros(sz, 1);

for i=1:sz
    s1 = triangles(i, 1) * M;
    s2 = triangles(i, 1) * M;
    s3 = triangles(i, 1) * M;
    vertices(i, 1, 1) = s1(1);
    vertices(i, 1, 2) = s1(2);
    vertices(i, 2, 1) = s2(1);
    vertices(i, 2, 2) = s2(2);
    vertices(i, 3, 1) = s3(1);
    vertices(i, 3, 2) = s3(2);
    
    depths(i) = (s1(3) + s2(3) + s3(3)) / 3;
end

end

