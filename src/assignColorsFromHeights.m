function [ colors ] = assignColorsFromHeights( heights, ordered )
%ASSIGNCOLORSFROMHEIGHTS

minHeight = min(heights);
maxHeight = max(heights);

colors = zeros(size(ordered, 1), 3);

for i = 1:size(ordered, 1)
	colors(i, 1) = (ordered(i, 11) - minHeight) / (maxHeight - minHeight);
	colors(i, 1) = round(245 * colors(i)) + 10;
    colors(i, 2) = colors(i, 1);
    colors(i, 3) = colors(i, 1);
end;

end

