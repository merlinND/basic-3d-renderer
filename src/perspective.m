function [ transformed ] = perspective(scene, origin, lookAt, d)
%PROJECT Projects a 3D scene to 2D screen
%   scene: a list of all the triangles of the scene
%          as an n x 9 matrix (three vertex per line)
%   origin: origin of the projection plane (3D line vector)
%   lookAt: the point towards which the camera is pointing (3D line vector)
%   d: distance of the screen from the projection origin (focal distance)
	
	% We use homogeneous coordinates
	identity = eye(4);
	
	% ----- Center origin
	translation = identity;
	translation(1:3, 4) = origin';
	
	% ----- Rotate
	w = (origin - lookAt)';
	% TODO: find a way to compute u even when w = [0 0 100]
	u = cross([0 0 1], w)'; % orthogonal to w and horizontal
	v = cross(u, w);
	% Normalize
	w = w ./ norm(w);
	u = u ./ norm(u);
	v = v ./ norm(v);
	rotation = identity;
	rotation(1:3, 1:3) = [u v w];
	
	% Display base (debug)
	%r = rotation(1:3, 1:3);
	%plotBase(origin, r(:, 1), r(:, 2), r(:, 3));
	
	% ----- Perspective
	% Made easy by the use of homogeneous coordinates
	perspective = identity;
	perspective(4, 3) = (1 ./ d);
	
	% ----- Apply transform to each triangle and output
	transformed = zeros(size(scene));
	ir = inv(rotation);
	it = inv(translation);
	% For each triangle in the scene
	for i = 1:size(scene, 1)
		% Use homogeneous coordinates
		triangleH = [reshape(scene(i, :), 3, 3); ones(1, 3)];

		triangleH = perspective * ir * it * triangleH;
		% Apply homogeneous factor
		triangle = triangleH(1:3, 1:3) ./ (ones(3, 1) * triangleH(4, :));

		% Output
		transformed(i, :) = reshape(triangle, 1, 9);
	end;
end

