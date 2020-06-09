clear all

F = 10;
c_x = 0.01;
c_y = 0.03;

%% Anchor Above

Torque_Above = [];
for x = [0.01:0.001:0.03];
    for y = [0:0.001:0.03];
        theta = atan((c_y + y)/(c_x + x));
        Torque_val = [x y (F*sin(theta)*x-F*cos(theta)*(y+c_y/2))];
        Torque_Above = cat(1,Torque_Above, Torque_val);
    end
end

[Torque_Above_max,idx] = max(Torque_Above(:,3));

%% Anchor Between

Torque_Between = [];
for x = [0.01:0.001:0.03];
    for y = [0:0.001:c_y];
        if y <= c_y/2
            theta = atan(y/(c_x + x));
            Torque_val = [x y (F*sin(theta)*x+F*cos(theta)*(c_y/2-y))];
            Torque_Between = cat(1,Torque_Between, Torque_val);
        else
            theta = atan(y/(c_x + x));
            Torque_val = [x y (F*sin(theta)*x-F*cos(theta)*(y-c_y/2))];
            Torque_Between = cat(1,Torque_Between, Torque_val);
        end
    end
end

[Torque_Between_max,idx] = max(Torque_Between(:,3));

%% Anchor Below

Torque_Below = [];
for x = [0.01:0.001:0.03];
    for y = [0:0.001:0.01];
        theta = atan(y/(c_x + x));
        Torque_val = [x y (F*cos(theta)*(y+c_y/2)) - F*sin(theta)*x];
        Torque_Below = cat(1,Torque_Below, Torque_val);
    end
end

[Torque_Below_max, idx] = max(Torque_Below(:,3));

%% Visualization

x_coord = Torque_Below(:,1)';
y_coord = Torque_Below(:,2)';
Torque_fin = Torque_Below(:,3)';

xlin=linspace(min(x_coord),max(x_coord),100);
ylin=linspace(min(y_coord),max(y_coord),100);
[X,Y]=meshgrid(xlin,ylin);
Z=griddata(x_coord,y_coord,Torque_fin,X,Y,'cubic'); 

% visualization
mesh(X,Y,Z);
axis tight; hold on
plot3(x_coord,y_coord,Torque_fin,'.', 'MarkerSize',15)
xlabel('x')
ylabel('y')

%% Maximum torque and x,y-coordinate value

max_Torque = max(Torque_fin);
max_idx = find(Torque_fin == max_Torque);
disp(Torque_Below(max_idx,:))