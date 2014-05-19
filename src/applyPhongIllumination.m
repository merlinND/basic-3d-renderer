function [ colors ] = applyPhongIllumination( triangles, lightSource, camera, colors )
%APPLYPHONGILLUMINATION Apply Phong's simplified illumination model with an
%ambient, specular and diffuse component.
%Returns:
%	The new colors with variation applied
	
	% TODO: simple material system to differentiate water

	% For each surface
	for i = 1:size(triangles, 1)
		% One triangle per column
		triangle = reshape(triangles(i, 1:9), 3, 3);
		
		centroid = mean(triangle, 2)';
		surfaceToLight = (lightSource - centroid);
		surfaceToLight = surfaceToLight / norm(surfaceToLight);
		surfaceToEye = (camera - centroid);
		surfaceToEye = surfaceToEye / norm(surfaceToEye);
		
		normal = - cross(triangle(:, 2) - triangle(:, 1), triangle(:, 3) - triangle(:, 1));
		normal = normal' / norm(normal);
		
		% Ambient: TODO
		La = 0.8;
		
		% Diffuse
		Ld = dot(normal, surfaceToLight) / (norm(normal) * norm(surfaceToLight));
		
		% Specular
		symetric = centroid - surfaceToLight + 2 * (dot(surfaceToLight, normal) * normal);
		surfaceToSymetric = (symetric - normal);
		
		alpha = 1; % TODO: shoud be determined by the material
		Ls = dot(-surfaceToEye, surfaceToSymetric);
		Ls = Ls / (norm(surfaceToEye) * norm(surfaceToSymetric));
		Ls = Ls ^ alpha;
		
		% L is the final coefficient (0..1) applied as a result
		L = (La + 0.5 * Ld + 0.1 * Ls);
		L = max(0, L);
		
		colors(i, :) = L * colors(i, :);
	end;
	
	% TODO: renormalize colors rather than clip?
	colors = min(1, colors);
end

