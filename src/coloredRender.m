function coloredRender(triangles, caption)
%COLOREDRENDER Display the given list of 3D triangles using Matlab's fill
%function, and choosing the triangle's color based on its height
%   triangles: An n x 9 matrix (three vertex per line)

	minHeight = min([triangles(:, 3); triangles(:, 6); triangles(:, 9)]);
	maxHeight = max([triangles(:, 3); triangles(:, 6); triangles(:, 9)]);
	
	figure(1);
	hold on;
	if (nargin > 1)
		title(caption)
	end;
	
	for i = 1:size(triangles, 1)
		triangle = reshape(triangles(i, :)', 3, 3)';
		
		% Use third coordinate to determine color
		meanHeight = mean(triangle(:, 3));
		c = (meanHeight - minHeight) / (maxHeight - minHeight);
		c = [1 1 1] * (1 - c);
		
		fill(triangle(:, 1), triangle(:, 2), c);
	end;

end

