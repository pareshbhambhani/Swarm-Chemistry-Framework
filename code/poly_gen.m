%% Polygon Coordinate generator function
function pos = poly_gen(N)
global centerX centerY;
angle = 2*pi/N;
centerX = 50;
centerY = 50;
radius = 50;
pos = zeros(N,2);
for i = 1:N
    pos(i,1) = centerX + radius * sin(i * angle) +0 ;
    pos(i,2) = centerY + radius * cos(i * angle) -0;
end
% %Rotation matrix
% R = [cos(pi/4),-sin(pi/4);sin(pi/4),cos(pi/4)];
% 
% for i = 1:N
%     pos(i,:) = R*pos(i,:)';
% end