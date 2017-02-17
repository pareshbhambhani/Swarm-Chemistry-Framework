%%Swarm chem script version 0.7 Modularized

% Initialization
clear all, close all, clc, format compact;

%% Swarm parameters
global N v_norm v_max c1 c2 c3 c4 c5 Ngrid mass t;
N = 7 ; %number of agents
v_norm = 19.75; %agent normal speed
v_max = 0.76; %agent max speed
c1 = 0.5; %cohesion
c2 = 0.5; %alignment
c3 = 50.15; %separation
c4 = 0; %Probability of random steering
c5 = 0.0; %Pacekeeping


%% Timer params
t = 0 ;
x_01 = zeros(N,1);
x_02 = 0;
%x_03 = 0;
startSpot = -1;
interv = 135 ; 
step = 1 ;
y_max_01 = 0; %y axis limit for figure 01
y_max_02 = 0; %y axis limit for figure 02
y_max_03 = 0; %y axis limit for figure 03
col_number = 1;


%% Initialize
Ngrid = 40;
mass = 1; %mass of individual agent
[I,J] = meshgrid(1:N);
index = [I(:) J(:)].';
pos = position('rand'); % Options:rand,poly_reg,poly_center,manual
vel_curr = zeros(N,2);
r = rand;
%Create pausing button
h = createButton;
pause(0.01); % To create the button.

%% Loop
while (t < interv)
%% Average posn and vel
pos_avg = mean(pos);
pos_avg = repmat(pos_avg,N,1); %Create N by 1 matrix with same pos_avg value
vel_avg = mean(vel_curr);
vel_avg = repmat(vel_avg,N,1);

%% update acc
sep = []; %seperation between individual agents
for i = 1:N
   temp = zeros(1,2);
   for k = 1:N
       d = (pos(i,:)-pos(k,:));
       if d ~=0
           temp = temp + d/(norm(d)^2);
       end
   end
   sep(i,:) = temp;
end
sep
 acc = c1*(pos_avg - pos) + c2*(vel_avg - vel_curr) + c3*(sep) %Cohesion, alignment and separation
 
 if r < c4
     rand_range = [(5-(-5)).*rand(N,1) + (-5),(5-(-5)).*rand(N,1) + (-5)];
     acc = acc + rand_range;
 end
 
 %% Force and Potential
 
 %Creating Grid
 x_lin = linspace((mean(pos(:,1)-2*Ngrid)), (mean(pos(:,1)+2*Ngrid)),Ngrid); %generate grid points
 y_lin = linspace((mean(pos(:,2)-2*Ngrid)), (mean(pos(:,2)+2*Ngrid)),Ngrid);
 spacing = ((mean(pos(:,1)+2*Ngrid)) - (mean(pos(:,1)-2*Ngrid)))/(Ngrid-1);
 [x_grid,y_grid] = meshgrid(x_lin,y_lin);

%Force at grid points
[force_grid_x,force_grid_y,force_grid_xy] = force(pos,vel_curr,x_grid,y_grid); %See force function for details

%Potential at grid points
 potential = intgrad2(-force_grid_x,-force_grid_y,spacing,spacing,0); %see intgrad2 for details
 
 %% update vel and position
 vel_new = vel_curr + acc; %update vel with acc
 vel_new = min(v_max/norm(vel_new),1)*vel_new; %prohibit overspeeding
 vel_new = c5*(v_norm/norm(vel_new))*(vel_new) + (1-c5)*vel_new; %Pacekeeping
 
vel_curr = vel_new
% temp = [];
% for i = 1:N
%     temp(i) = norm(vel_curr(i,:));
% end
% temp
pos = pos + vel_curr

%% Plot

plot_params.pos = pos;
plot_params.x_grid = x_grid;
plot_params.y_grid = y_grid;
plot_params.force_grid_x = force_grid_x;
plot_params.force_grid_y = force_grid_y;
plot_params.force_grid_xy = force_grid_xy;
plot_params.index = index;
plot_params.potential = potential;
plot_params.t = t;
plot_params.step = step;
plot_params.acc = acc;


plots({'position','potential','distance','force_system'},plot_params); %options: position,potential,distance,force_system

% SPEED
% for i = 1:N
%     figure(01)
%     subplot(ceil(N/2),2,i);
%     v = vel_curr(i,:);
%     x_01(i,col_number) = norm(v);
%     %x_01
%     %x_01 = [x_01 , norm(v)]
%     y_max_01 = max([y_max_01 norm(v)]);
%     plot(x_01(i,:)); hold on;
%     axis([ startSpot, (t/step+20), -1.25*y_max_01 , 1.25*y_max_01 ]);
%     title(['Agent ' int2str(i) ' Speed vs time'])
%     xlabel('Time')
%     ylabel('Speed')
%     grid
% end
% x_01 = horzcat(x_01,zeros(N,1));
% col_number = col_number + 1

% KE
% for i = 1:N
%     figure(02)
%     subplot(N,1,i);
%     v = vel_curr(i,:);
%     ke = 0.5 * mass * norm(v)^2;
%     x_02 = [x_02 , ke];
%     y_max_02 = max([y_max_02 ke])
%     plot(x_02); hold on;
%     axis([ startSpot, (t/step+50), -1.25*y_max_02 , 1.25*y_max_02 ]);
%     title(['Agent ' int2str(i) ' KE vs time'])
%     xlabel('Time')
%     ylabel('KE')
%     grid
% end


% FORCE FIELD
% %surface
% figure(04)
% surfc(x_grid,y_grid,force_grid_xy)
% colorbar;
% axis square;
% zlim([0 100]);
% set(gcf,'Outerposition',[675, 550, 575, 500 ])
% %contour
% figure(05)
% contourf(x_grid,y_grid,force_grid_xy)
% axis square;
% colorbar;
% set(gcf,'Outerposition',[1250, 550, 575, 500 ])
% %Total force at all the points
% figure(06)
% plot(t,(sum(force_grid_xy(:))),'.')
% ylim([(0.9*sum(force_grid_xy(:))) (1.1*sum(force_grid_xy(:)))]);
% hold on
% grid on
% set(gcf,'Outerposition',[100, 50, 575, 500 ])


% if ((t/step)-250 < 0)
%           startSpot = 0;
%       else
%           startSpot = (t/step)-250;
% end
%      axis([ startSpot, (t/step+50), -0.3 , 1 ]);
%      grid
%       t = t + step;
%       drawnow;
%       pause(0.01)     
      
end

close(h);


