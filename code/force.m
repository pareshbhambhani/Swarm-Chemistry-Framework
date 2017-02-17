%%Function to calculate forces at grid points

function [force_grid_x,force_grid_y,force_grid_xy] = force(pos,vel_curr,x_grid,y_grid)
global Ngrid N c1 c2 c3 c4 c5 mass ;

 force_grid_x = zeros(Ngrid,Ngrid);
 force_grid_y = zeros(Ngrid,Ngrid);
 for i = 1:Ngrid
     for j = 1:Ngrid
         pos_temp = vertcat(pos,[x_grid(j,i),y_grid(j,i)]);
         pos_avg_temp = mean(pos_temp);
         %pos_avg_temp = repmat(pos_avg_temp,(N+1),1);
         vel_curr_temp = vertcat(vel_curr,[0,0]);
         vel_avg_temp = mean(vel_curr_temp);
         %vel_avg_temp = repmat(vel_avg_temp,(N+1),1);
         sep_temp = []; %seperation between individual agents and grid point
         for a = 1:N+1
            temp = zeros(1,2);
            for b = 1:N+1
                d = pos_temp(a,:)-pos_temp(b,:);
                if d~=0
                temp = temp + d/(norm(d)^2);
                end
            end
            sep_temp(a,:) = temp;
         end
        K = mass*(c1*(pos_avg_temp - [x_grid(j,i),y_grid(j,i)]) + c2*(vel_avg_temp - [0,0]) + c3*(sep_temp((N+1),:))); % F= m*a. Unit mass considered here.
        %K = c1*(pos_avg_temp - [x_grid(j,i),y_grid(j,i)]) + c3*(sep_temp((N+1),:)); % F= m*a. Unit mass considered here.
        force_grid_x(j,i) = K(1);
        force_grid_y(j,i) = K(2);
        
     end
 end
 %[Dx_grid,Dy_grid] = gradient(force_grid,(((mean(pos(:,1)+50))-(mean(pos(:,1)-50)))/Ngrid));
 force_grid_xy = sqrt((force_grid_x.^2 + force_grid_y.^2));