function [ C ] = lookAtCamera( eye, center, up )
%LOOKATCAMERA Defines a lookAt camera
%
% Parameters:
% - eye: 3D coordinates for the point of view
% - center: 3D coordinates for the looked at location
% - up: direction of the projection on the 3 axis
%
% Returns:
% - C: a 4x4 camera matrix
%
% See also: gluLookAt

F = center - eye;

f = F/norm(F);

UP = up/norm(up);

s = f .* UP;

u = f .* s/norm(s);

C = [s(1)  s(2)  s(3)  0;
     u(1)  u(2)  u(3)  0;
     -f(1) -f(2) -f(3) 0;
     0     0     0     1];
end

