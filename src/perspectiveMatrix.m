function [ P ] = perspectiveMatrix( fov, aspectRatio, zNear, zFar )
%LOOKATCAMERA Generates a projection matrix to be used after camera
%projection
%
% Parameters:
% - fov: field of view in radians
% - aspectRatio: ratio of the projected screen
% - zNear: distance for object clipping near the camera
% - zFar: distance for object clipping far from the camera
%
% Returns:
% - P: a 4x4 perspective matrix
%
% See also: gluPerspective

f = cot(fov/2);

P = [f/aspectRatio 0 0                         0;
     0             f 0                         0;
     0             0 (zFar+zNear)/(zNear-zFar) (2*zFar*zNear)/(zNear-zFar);
     0             0 -1                        0];

end

