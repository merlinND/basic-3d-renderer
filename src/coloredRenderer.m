function coloredRenderer(triangles, heights, d, fov, aspectRatio, caption)
%COLOREDRENDER Display the given list of 3D triangles using Matlab's fill
%function, and choosing the triangle's color based on its height
%   triangles: An n x 9 matrix (three vertex per line)
%	height: An n x 1 vector (one height value per triangle)

	minHeight = min(heights);
	maxHeight = max(heights);
	
	figure(1);
    clf();
	hold on;
	if (nargin > 5)
		title(caption)
	end;
	
	for i = 1:size(triangles, 1)
		triangle = reshape(triangles(i, :)', 3, 3)';
		
		% Use height to determine color
		c = (heights(i) - minHeight) / (maxHeight - minHeight);
		c = [1 1 1] * (1 - c);
		
		fill(triangle(:, 1), triangle(:, 2), c);
	end;
    axis(getAxes(d, fov, aspectRatio));
end

