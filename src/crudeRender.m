function crudeRender(triangles, caption)
%CRUDERENDER Display the given list of trianges using Matlab's fill
%function
%   triangles: An n x 6 matrix (three vertex per line)
%   If the triangles are given in 3D (n x 9), their third coordinate is ignored.

	% Ignore 3D coordinate
	if (size(triangles, 2) == 9)
		triangles = [triangles(:, 1:2) triangles(:, 4:5) triangles(:, 7:8)];
	end;
	
	% Number of triangles to render
	colors = ['r', 'g', 'b', 'y', 'w', 'k'];
	nc = length(colors);
	
	figure(1);
	hold on;
	if (nargin > 1)
		title(caption)
	end;
	
	for i = 1:size(triangles, 1)
		triangle = reshape(triangles(i, :), 3, 2);
		fill(triangle(:, 1), triangle(:, 2), colors(mod(i, nc)));
	end;

end

