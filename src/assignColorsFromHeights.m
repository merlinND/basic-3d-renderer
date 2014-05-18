function [ colors ] = assignColorsFromHeights( heights, ordered )
%ASSIGNCOLORSFROMHEIGHTS

minHeight = min(heights);
maxHeight = max(heights);

colors = zeros(size(ordered, 1), 1);

for i = 1:size(ordered, 1)
	colors(i) = (ordered(i, 11) - minHeight) / (maxHeight - minHeight);
	colors(i) = round(245 * colors(i)) + 10;
end;

end

