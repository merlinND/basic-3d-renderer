function [ colors ] = assignColorsFromHeights( heights, ordered, randomness )
%ASSIGNCOLORSFROMHEIGHTS An [r g b] color with values between 0 and 1

	minHeight = min(heights);
	maxHeight = max(heights);

	palette = getPalette(randomness);
	colors = zeros(size(ordered, 1), 3);
	
	for i = 1:size(ordered, 1)
		index = (ordered(i, 11) - minHeight) / (maxHeight - minHeight);
		index = floor(254 * index) + 1;
		
		colors(i, 1) = palette(index, 1);
		colors(i, 2) = palette(index, 2);
		colors(i, 3) = palette(index, 3);
	end;
end

function [ palette ] = getPalette(randomness)
%GETPALETTE Generate the color palette
%	A 255 x 3 vector, with an [r g b] color for each "height level"
%	In order to use, normalize the heights and pick the corresponding color
%	Could also be used directly with the `colormap` matlab function.
	
	palette = zeros(255, 3);
	
	% First roughly define the colors and corresponding height
	palette = fillRows(palette, 1, 2, [0.16, 0.5, 0.73]); % Sea
	palette = fillRows(palette, 3, 6, [0.98, 0.97, 0.73]); % Sand
	palette = fillRows(palette, 7, 65, [0.15 0.68 0.38]); % Grass
	palette = fillRows(palette, 66, 180, [0.5 0.5 0.5]); % Mountain
	palette = fillRows(palette, 181, 255, [0.95 0.95 0.95]); % Snow
	
	% Then apply random perturbations in light intensity
	perturbation = rand(length(palette), 1) - 0.5 * ones(length(palette), 1);
	perturbation = perturbation * [1 1 1]; % Make [r g b]
	palette = palette + randomness * perturbation;
	% Clip values
	palette = min(1, palette);
	palette = max(0, palette);
end

function [ buffer ] = fillRows(buffer, start, finish, value)

	buffer(start:finish, :) = ones(finish - start + 1, 1) * value;

end
