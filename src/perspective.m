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
	w = (lookAt - origin)';
	u = [w(2); -w(1); 0]; % orthogonal to w
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
	rotation
	
	% ----- Perspective
	% Made easy by the use of homogeneous coordinates
	perspective = identity;
	perspective(4, 3) = (1 ./ d);
	
	% ----- Apply transform to each triangle and output
	transformed = zeros(size(scene));
	% For each triangle in the scene
	for i = 1:size(scene, 1)
		for j = 1:3:9
			% Use homogeneous coordinates
			triangleH = [scene(i, j:(j+2)) 1]';
			
			triangleH = perspective * inv(rotation)...
						* inv(translation) * triangleH;
			
			% Apply homogeneous factor
			triangle = triangleH(1:3) ./ triangleH(4);

			% Output
			transformed(i, j:(j+2)) = triangle';
		end;
	end;
end

