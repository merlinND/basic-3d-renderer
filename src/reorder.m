function [ ordered ] = reorder( transformed, origin, heights )
%REORDER Reorder a list of triangles from the farest to the nearest

ordered = [transformed zeros(size(transformed, 1), 2)];
for i = 1:size(ordered, 1)
	triangle = reshape(ordered(i, 1:9)', 3, 3);
	barycenter = sum(triangle, 2) ./ 3;
	distance = norm(barycenter - origin');
	ordered(i, 10) = distance;
	ordered(i, 11) = heights(i);
end;
ordered = sortrows(ordered, -10);

end

