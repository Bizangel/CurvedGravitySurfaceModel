function sols = odewrap(x0,f, t, g, friction_coeff)
    x = sym('x');
    dfdx = matlabFunction( diff(f(x)) );
    
    dfdx2 = matlabFunction( diff(dfdx(x)) );
    
    [~,sols] = ode15s(@ODEx,t,x0);
    
    function xp = ODEx(t,x)
    %     Se cálcula el ángulo
        alpha = atan(dfdx( x(1) ));
    %     Se cálcula la curvatura en el punto
        roh = ((1 + (dfdx( x(1) ))^2 )^(3/2))/abs(dfdx2( x(1) ));

        xp(1) = x(3);
        xp(2) = x(4);

        gx = sin(alpha)*g;
        v = sqrt(x(3)^2 + x(4)^2);

    %      Ecuaciones de Fuerza-Aceleración
        xp(3) = cos(alpha)*gx - (v^2/roh)*sin(alpha)*sign(dfdx2(x(1))) - x(3)*friction_coeff;  
        xp(4) = sin(alpha)*gx + (v^2/roh)*cos(alpha)*sign(dfdx2(x(1))) - x(4)*friction_coeff;  

        xp = xp';
    end

end