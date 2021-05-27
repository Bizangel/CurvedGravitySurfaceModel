clear all
px0 = 0;
vx0 = 0;

f =  @(x) 3*x^3-2*x;

ti = 0;
tf = 10;

step = 0.01;

x0 = [vx0 px0]';

[t,x] = ode45(@ODEx,ti:step:tf,x0);

X = x(:,2);
vx = x(:,1);

Y = arrayfun(f,X);

% plot(X,Y)

% %  Animate

v = VideoWriter('modelo1.mp4','MPEG-4');
v.FrameRate=30;

[m, n] = size(X);
open(v);
graph_x = -20:0.01:20;
graph_y = arrayfun(f,graph_x);
for i=1:m
    
    hold on
    plot(X(i),Y(i),'Marker','.','MarkerSize',15);    
    plot(graph_x,graph_y)
    
    
    
    xlim([-5, 5]);
    ylim([-1.5, 1.5]);
    
    F = getframe(gcf); % getframe
    writeVideo(v,F); %add frame
    hold off
    cla
    
    

    
end
close(v)

function xp = ODEx(t,x)
    dfdx = @(x) 9*x^2-2;
%     dfdx = @(x) cos(x);
    
    friction_coeff = 0.3;
    
    g = -1;
    
    alpha = atan(dfdx(x(2)));
    
    xp(1) = g*sin(alpha)*cos(alpha) - x(1)*friction_coeff;
    xp(2) = x(1); % dx - X
    
    xp = xp';
end