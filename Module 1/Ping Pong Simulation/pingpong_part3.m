function [res,U_Events] = pingpong(v_i,w);
    %Simulation for a Ping Pong Robot
    %Olin Mechanics, Spring 2012
    %Inputs: Initial Velocity, Initial Angular Velocity (column vectors)
    %Outputs: Position of Ball as it Flies, Position of Special Events
    %Special Event 1: Ball Hits Table, Event 2: Ball Crosses Net
    %Feb 3 2012; by Nick Eyre

    %Set Initial Paremeters & Physical Properties
    m = .0023;  %Mass of Ball - kg
    Cd = 0.5;   %Drag coefficient
    Cm = 0.6;   %Magnus coefficient
    A = 1.1e-3; %Cross-Sectional Area - m^2
    p = 1.2;    %Density of Air, kg/m^3
    g = 9.8;	%Accleration of Gravity - m/s^2
    R = .0189;  %meters
    
    %Set Initial Conditions
    r_i = [0 0 0.2];	%Initial Position
    %v_i = [1 0 0];  %Initial Velocity     
    %w = [0 0 0];    %Angular Velocity
    
    %Create Unit Vectors
    i_hat = [1 0 0]';
    j_hat = [0 1 0]';
    k_hat = [0 0 1]';
    w_hat = w'/norm(w);
    
    %Time Options
    t = 20;     %Max Length of Simulation (s)
    q = 200;    %Resolution (point/sec);
    
    %Run ODE45 DiffEQ Solver
    initial = [r_i';v_i'];
    time = [0:1/q:t];
    options = odeset('Events', @events);
    [T,U,T_Events,U_Events] = ode23(@diffeq,time,initial,options);
    
    %Plot Path of Ball
    res = U(:,1:3);
    %Plot Top View
    subplot(2,1,1)
    hold off
    plot(res(:,1),res(:,2));
    title('Top View')
    %Plot Side View
    subplot(2,1,2)
    hold off
    plot(res(:,1),res(:,3));
    title('Side View')
    
    function res = diffeq(t,U);
        %Differential Equation Function for Solving with ode45
        %Inputs: Time, Input Vector
        %Input Vector: Position;Velocity (column vectors)
        %Outputs: Output Vector
        %Output Vector: Velocity;Acceleration (column vectors)
        
        %Unpack Vector
        r = U(1:3);
        v = U(4:6);
        
        %Calculate Unit Vectors and Magnitude
        v_hat = v/norm(v);
        v_mag = norm(v);
        
        %Calculate Derivatives
        r_dot = v;
        v_dot = -g*k_hat - 1/(2*m)*Cd*p*A*v_mag^2*v_hat...
            + 1/(2*m)*Cm*p*A*R*cross(w,v)';
        
        %Pack Result Vector
        res = [r_dot;v_dot];
    end

    function [value,isterminal,direction] = events(t,W)
        %Used by odeset to determine special event conditions for ode45 DiffEQ Solver
        %Condition 1: Ball Hits Table Moving Down, Is Terminal
        %Condition 2: Ball Crosses Net, Moving Towards Net, Is Not Terminal
        %Input: Time, [Position;Velocity]
        
        value = [W(3), W(1)-1.37];
        isterminal = [1 0]; %Stop integration if height crosses zero
        direction = [ -1 1]; %But only if it is moving downward
    end

end