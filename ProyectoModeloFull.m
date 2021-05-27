clear all
%%  Parámetros Problema 
%%% Función que sea derivable dos veces, y las derivadas dependan de x

f = @(x) sin(3*x) + cos(x);
x0 = 0.6632;
y0 = 1.701516;

% f = @(x) exp(-x);
% x0 = 0;
% y0 = 1;

g = -5;
friction = 0.5;

%% Parametros Integración
ti = 0;
step = 0.01;
tf = 5;
t = ti:step:tf;

%% Paramétros Misc
filename = 'modelo2.mp4';
graph_xlim = [0 6];
graph_ylim = [-2 2];


%% Execution
p0 = [x0 y0 0 0]';
sols = odewrap(p0,f,t,g,friction);


% % Se anima el problema
X = sols(:,1);
Y = sols(:,2);
VX = sols(:,3);
VY = sols(:,4);

x = sym('x');
dfdx = matlabFunction( diff(f(x)) );
dfdx2 = matlabFunction( diff(dfdx(x)) );
    
% % Se realiza la animación
v = VideoWriter(filename,'MPEG-4');
v.FrameRate=30;

[m, n] = size(X);
open(v);
for i=1:m
    hold on
%     Se gráfica la particula
    plot(X(i),Y(i),'Marker','.','MarkerSize',15)
%     Se gráfica la velocidad de la particula
    plot([X(i), X(i) + VX(i)], [Y(i), Y(i) + VY(i) ])
    %     Se gráfica el vector perpendicular a la normal, la fuerza
    %     centripeta.
    vsquare = (VX(i)^2 + VY(i)^2);
    alpha = atan(dfdx( X(i) ));
    roh = ((1 + (dfdx( X(i) ))^2 )^(3/2))/abs(dfdx2( X(i) ));
    plot([X(i), X(i) - sin(alpha)*(vsquare/roh)*sign(dfdx2(X(i)))], [Y(i), Y(i) + cos(alpha)*(vsquare/roh)*sign(dfdx2(X(i))) ])
    
    %     Se gráfica la función original de referencia
    plot(graph_xlim(1):step:graph_xlim(2), arrayfun(f,graph_xlim(1):step:graph_xlim(2)))
    xlim(graph_xlim);
    ylim(graph_ylim);
        
    F = getframe(gcf); % getframe
    writeVideo(v,F); %add frame
    
   
    hold off
    cla
end

close(v)
