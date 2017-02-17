%%Function for all the plots

function plots(list,plot_params)

global N Ngrid t mass;
pos = plot_params.pos;
x_grid = plot_params.x_grid;
y_grid = plot_params.y_grid;
force_grid_x = plot_params.force_grid_x;
force_grid_y = plot_params.force_grid_y;
force_grid_xy = plot_params.force_grid_xy;
index = plot_params.index;
potential = plot_params.potential;
t = plot_params.t;
step = plot_params.step;
acc = plot_params.acc;

%POSITION
if any(ismember(list,'position'))
    for i = 1:N
    figure(02)
    plot(pos(i,1),pos(i,2),'o'); hold on;
    quiver(pos(:,1),pos(:,2),(mass*acc(:,1)),(mass*acc(:,2)),0.5) %Show forces on agents
    %quiver(x_grid,y_grid,force_grid_x,force_grid_y,1) %show forces at grid
    %y_max_03 = max([y_max_03 pos(i,2)]);
    axis([ (mean(pos(:,1)-2*Ngrid)), (mean(pos(:,1)+2*Ngrid)),(mean(pos(:,2)-2*Ngrid)), (mean(pos(:,2)+2*Ngrid))]);
    axis square;
    grid on;
    %line(pos(index,1),pos(index,2)) %show interconnected lines
    set(gcf,'Outerposition',[100, 550, 575, 500 ])
    end
end
hold off;

%POTENTIAL FIELD
if any(ismember(list,'potential'))
    %Surface
    figure(03)
    surfc(x_grid,y_grid,potential)
    colorbar;
    axis square;
    set(gcf,'Outerposition',[675, 550, 575, 500 ])
    zlim([-3500 0]);
    view([10 60]);
    %countour
    figure(04)
    contourf(x_grid,y_grid,potential)
    axis square;
    colorbar;
    set(gcf,'Outerposition',[1250, 550, 575, 500 ])
end


%  TOTAL DISTANCE
if any(ismember(list,'distance'))
dist = []; %seperation between individual agents
for i = 1:N
    temp = 0;
   for k = 1:N
       d = pos(i,:)-pos(k,:);
       d = sqrt(d(1,1)^(2) + d(1,2)^(2));
       temp = temp + d;
   end
   dist(i) = temp;
end
figure(05)
for i = 1:N
    plot(t, dist(i),'.')
    hold on;
end
axis square;
set(gcf,'Outerposition',[100, 50, 575, 500 ]) 
end

% TOTAL FORCE SYSTEM
if any(ismember(list,'force_system'))
figure(06)
plot(t,norm(mean(mass*acc)),'.')
hold on;
axis square;
set(gcf,'Outerposition',[675, 50, 575, 500 ])
end

t = t + step
drawnow;
pause(0.0);