function zBufferTest

% Final image
im=zeros(200,200,3);

% Z-Buffer
ZB=zeros(200,200);

% Triangle 1
P11=[40 40];
P12=[70 95];
P13=[140 80];
Bary1=20;
Couleur1=[1 1 0.5]; % Yellow

% Triangle 2
P21=[40 40];
P22=[70 95];
P23=[30 140];
Bary2=40;
Couleur2=[1 0.5 1]; % Magenta

% Triangle 3
P31=[70 30];
P32=[110 55];
P33=[40 160];
Bary3=30; % ou 10 ou 50
Couleur3=[0.5 1 1]; % Cyan

% Filling the Z-Buffer
ZB = fillTriangleBuffer(ZB, [P11; P12; P13], Bary1);
ZB = fillTriangleBuffer(ZB, [P21; P22; P23], Bary2);
ZB = fillTriangleBuffer(ZB, [P31; P32; P33], Bary3);

% Filling the image
im = fillTriangleImage(im, ZB, [P11; P12; P13], Bary1, Couleur1);
im = fillTriangleImage(im, ZB, [P21; P22; P23], Bary2, Couleur2);
im = fillTriangleImage(im, ZB, [P31; P32; P33], Bary3, Couleur3);

% Display
figure(1)
image(im)

end
