%% *LANDSCAPE GENERATION & RENDERING*

%% TERRAIN GENERATION

%% Define a basic terrain
% We'll start with a very simple heightMap from the terrain we want to
% render. We'll do that with a small matrix.
terrain = [
	  670   672   670   675   690   680   650   675   690   680   700   892   895;
      680   665   640   630   650   645   630   628   648   650   680   875   893;
      630   615   585   580   585   600   590   610   603   603   630   850   895;
      595   568   555   560   575   580   575   570   580   610   625   800   850;
      550   540   538   550   595   575   600   570   575   620   613   700   730;
      525   530   538   550   603   625   615   580   570   610   590   610   720;
      545   540   538   597   575   605   593   578   573   593   608   595   695;
      615   560   543   579   569   560   563   570   580   595   619   638   650;
      625   598   560   559   586   558   578   585   600   615   655   680   683;
      610   600   610   605   615   618   625   638   648   665   680   700   705
];
scale = 100;

previewRenderer(terrain, scale);

%% Refine terrain
% On this part, we'll use the Diamond-Square Algorithm to create a much
% more complex terrain.
nPasses = 2;
scale = scale/(2^nPasses);
terrainFine = diamondSquare(terrain, nPasses, .1);

previewRenderer(terrainFine, scale);

%% GRAPHIC PIPELINE

%% 1 Scene Generation

%% 1.1 Terrain Tesselation
% We are going to generate triangles from the height maps. We'll call it a
% scene.
scene = tesselation(terrainFine, scale);

%% 1.2 Mesh import
% Add/Import objects into the scene

%% 2 Vertex shader
% Apply a projection that transforms the scene from the 3D world to the 2D
% world keeping track of the vertices distance from the camera (Z-Buffer).

% Define a camera
origin = [-100 -100 1000];
lookAt = [1200 1200 10];

% Define a perspective
d = 100;
fov = (pi / 3);
ratio = (16 / 9);

% Apply the perspective
transformed = perspective(scene, origin, lookAt, d);


%% 3 Pixel Shader

%% 3.1 Simple rendering

% Color definition height list
heights = mean([scene(:, 3) scene(:, 6) scene(:, 9)], 2);

% Simple renderer
coloredRenderer(transformed, heights, d, fov, ratio);

%% 3.2 Distance calculation & reordering

ordered = reorder(transformed, origin, heights);

%% 3.3 Color palette generation

greymap = ((0:255) / 255)' * [1 1 1];
colors = assignColorsFromHeights(heights, ordered);

%% 3.4 Rasterization via the Painter's Algorithm

density = 20;

painterRenderer( ordered, density, getAxes(d, fov, ratio), colors );

%% 3.5 Rasterization via the Z-Buffer

zBuffer = genZBuffer( ordered, density, getAxes(d, fov, ratio) );

zBufferRenderer( ordered, zBuffer, density, getAxes(d, fov, ratio), colors );