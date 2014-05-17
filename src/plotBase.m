function plotBase( origin, u, v, w )
%PLOTBASE Plot the given base in 3D
%	origin, u, v, w are expected to be column vectors

	figure;
	starts = ones(3, 1) * origin;
	ends = [u v w]';
	quiver3(starts(:, 1), starts(:, 2), starts(:, 3),...
			ends(:, 1), ends(:, 2), ends(:, 3));

end

