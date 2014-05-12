function [ transformed ] = perspective(scene, origin, lookAt, d)
%PROJECT Projects a 3D scene to 2D screen
%   scene: a list of all the triangles of the scene
%          as an n x 9 matrix (three vertex per line)
%   origin: origin of the projection plane (3D line vector)
%   lookAt: the point towards which the camera is pointing (3D line vector)
%   d: distance of the screen from the projection origin (focal distance)

	% We use homogeneous coordinates
	transform = zeros(4);
	
	% ----- Center origin
	transform(:, 4) = [origin 1]';
	
	% ----- Rotate
	w = (lookAt - origin)';
	u = [-w(3); 0; w(1)]; % orthogonal to w
	v = cross(u, w);
	% Normalize
	w = w ./ norm(w);
	u = u ./ norm(u);
	v = v ./ norm(v);
	transform(1:3, 1:3) = [u v w];
	
	% ----- Perspective
	% Made easy by the use of homogeneous coordinates
	transform(4, 3) = (1 ./ d);
	transform
	
	% ----- Apply transform on each triangle and output
	transformed = zeros(size(scene));
	% For each triangle in the scene
	for i = 1:size(scene, 1)
		% Use homogeneous coordinates
		triangleH = zeros(4, 4);
		triangleH(1:3, 1:3) = reshape(scene(i, :), 3, 3)';
		triangleH(4, 4) = 1;
		
		triangleH = triangleH * transform;
		triangle = triangleH(1:3, 1:3);
		triangle = triangle + triangleH(1:3, 4) * ones(1, 3);
		triangle = (triangle ./ triangleH(4, 4));
		% Apply projection and output
		transformed(i, :) = reshape(triangle, 1, 9);
	end;
end

