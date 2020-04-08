function u = MPC(state, t, ref, param)

% state = [x, y, yaw, delta]
% u = [v_des, delta_des]
% ref = [x_ref; y_ref; yaw_ref; v_ref; k_ref; t_ref];

deg2rad = pi / 180;

id_x = 1;
id_y = 2;
id_yaw = 3;
id_vel = 4;
id_curve = 5;
id_time = 6;

% --- convex optimization ---
%   minimize for x, s.t.
%   J(x) = 1/2 * x' * H * x + f' * x, 
%   A*x <= b,   lb <= x <= ub
a1 = B' * C' * Q * C * B + R;
a2 = (C * A * x0 + C * W - Y_ref)' * Q * C * B;

H = (a1 + a1')/2;
f = a2;
A = [];
b = [];

options = optimoptions('quadprog','Algorithm','interior-point-convex', 'Display', 'off');
[x, fval, exitflag, output, lambda] = quadprog(H,f,A,b,[],[],lb,ub,[],options);

end 


function [Ad,Bd,wd,Cd] = get_linearized_matrix(dt,ref,L,tau)

end

function x_next = calc_kinematics_model(x, u, dt, v, L, tau)

    % x = [x, y, yaw, delta]
    x_next = zeros(4,1);
    yaw = x(3);
    delta = x(4);
    
    % x
    x_next(1) = x(1) + v*cos(yaw)*dt;
    % y
    x_next(2) = x(2) + v*sin(yaw)*dt;
    % yaw
    x_next(3) = x(3) + v*tan(delta)/L*dt;
    % delta
    x_next(4) = x(4) - (x(4) - u)/tau*dt;

end