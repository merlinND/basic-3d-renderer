function axes = getAxes( d, fieldOfView, ratio )
%SETUPAXES Set 2D axes (depending on origin, d and field of view)
%	fieldOfView: total view angle in radians
%
%Returns:
%	axes = [xMin, xMax, yMin, yMax]

	deltaX = d * tan(fieldOfView / 2);
	deltaY = deltaX / ratio;
	
	axes = zeros(1, 4);
	axes(1) = -deltaX;
	axes(2) = deltaX;
	axes(3) = -deltaY;
	axes(4) = deltaY;
	
	% Force the window to respect our aspect ratio
	set(gca, 'DataAspectRatio', [1 1 1]);
	
end