function [ colorsOut ] = applyPhongIllumination( triangles, lightSource, camera, colors )
%APPLYPHONGILLUMINATION Apply Phong's simplified illumination model with an
%ambient, specular and diffuse component.
%Returns:
%	The new colors with variation applied
	colorsOut = zeros(size(colors));
	
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
		
		% Ambient
		% TODO: should depend on the characteristics of the light source
		La = 0.18;
		
		% Diffuse
		Ld = dot(surfaceToLight, normal);
		
		% Specular
		symetric = centroid - surfaceToLight + 2 * dot(surfaceToLight, normal) * normal;
		surfaceToSymetric = (symetric - normal);
		surfaceToSymetric = surfaceToSymetric / norm(surfaceToSymetric);
		
		alpha = 30; % TODO: shoud be determined by the material
		Ls = dot(surfaceToEye, surfaceToSymetric);
		Ls = Ls ^ alpha;
		
		% L is the final coefficient (0..1) applied as a result
		% TODO: the coefficients should be determined per material
		L = (1 * La + 0.7 * Ld + 0.8 * Ls);
		% TODO: find a better solution than simple clipping?
		L = max(0, L);
		L = min(1, L);
		
		colorsOut(i, :) = L * colors(i, :);
	end;
end

