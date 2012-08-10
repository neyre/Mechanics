function doublependulum
    %Simulation and Animation for a Double-Pendulum System
    %Olin Mechanics, Spring 2012
    %Inputs: none; Outputs: none
    %Feb 3 2012; by Nick Eyre

    %Set Initial Paremeters & Physical Properties
    m1 = 1;             %kg
    m2 = 1;             %kg
    L1 = 1;             %m
    L2 = 1;             %m
    g = 9.8;           %m/s^2
    
    %Set Initial Conditions
    theta1_i = pi/2;    %rad
    theta2_i = pi/2;    %rad
    theta1_dot_i = 0;   %rad/s
    theta2_dot_i = 0;   %rad/s
    
    %Time Options
    t = 20;     %Length of Simulation (s)
    p = 100;    %Frames Per Second
    
    %View Options.  1=On, 0=Off;
    velocity_vectors    = 1;    %Show Velocity Vectors
    acceleration_vectors= 1;    %Show Acceleration Vectors
    show_bars           = 1;	%Show Pendulum Rods
    pause_after_frame   = 0;    %Pause After Each Frame
    
    %Run ODE45 DiffEQ Solver
    initial = [theta1_i,theta2_i,theta1_dot_i,theta2_dot_i];
    time = [0:(1/p):t];
    [T,U] = ode23(@diffeq,time,initial);
    
    %Animate
    animate(T,U);
    
    function res = diffeq(t,U);
        %Differential Equation Function for Solving with ode45
        %Inputs: Time, Input Vector
        %Input Vector: theta1,theta2,theta1_dot,theta2_dot
        %Outputs: Output Vector
        %Output Vector: theta1_dot,theta2_dot,theta1_ddot,theta2_ddot
        
        %Unpack Vector
        theta1 = U(1);`
        theta2 = U(2);
        theta1_dot = U(3);
        theta2_dot = U(4);
        
        %Calculate Accelleration Derivatives
        theta1_ddot= (-g*(2*m1+m2)*sin(theta1)-m2*g*sin(theta1-2*theta2)...
        	-2*sin(theta1-theta2)*m2*(L2*theta1_dot^2+L1*theta1_dot^2*cos(theta1-theta2)))...
            /(L1*(2*m1+m2-m2*cos(2*theta1-2*theta2)));
        theta2_ddot= (2*sin(theta1-theta2)*(theta1_dot^2*L1*(m1+m2)+...
            g*(m1+m2)*cos(theta1)+theta2_dot^2*L2*m2*cos(theta1-theta2)))...
            /(L2*(2*m1+m2-m2*cos(2*theta1-2*theta2)));
        
        %Pack Result Vector
        res = [theta1_dot;theta2_dot;theta1_ddot;theta2_ddot];
    end

    function animate(T,U)
        %Animates the movement of the double pendulum
        %Inputs: Time Vector, Input Vector
        %Input Vector: theta1,theta2,theta1_dot,theta2_dot
        
        %Unpack Vector
        theta1 = U(:,1);
        theta2 = U(:,2);
        theta1_dot = U(:,3);
        theta2_dot = U(:,4);
        
        %Set Axes with Origin at Center
        minmax = 1.4*(L1+L2);
        minmax = [-minmax,minmax,-minmax,minmax];
        
        %Steps Through Each Time Step and Plot Frame
        for i=1:length(T)
            
            %Setup Graph
            clf;
            axis(minmax);
            hold on;
            axis square;
            
            %Convert Natural to Cartesian
            x1 = sin(theta1(i))*L1;
            y1 = -cos(theta1(i))*L1;
            x2 = sin(theta2(i))*L2+x1;
            y2 = -cos(theta2(i))*L2+y1;
            
            %If Plotting Pendulum Bars is Enabled,
            %Plot Pendulum Bars as Lines
            if(show_bars) == 1
                plot([0 x1],[0 y1],'k');
                plot([x1 x2],[y1 y2],'k');
            end
            
            %Plot Pendulum Mass Positions as Points 
            plot(x1,y1,'k.','MarkerSize',20);
            plot(x2,y2,'k.','MarkerSize',20);
            
            %If Plotting Velocity Vectors is On
            if(velocity_vectors == 1)
                %Convert Natural to Cartesian
                x1_v = L1*theta1_dot(i)*cos(theta1(i));
                y1_v = L1*theta1_dot(i)*sin(theta1(i));
                x2_v = x1_v+L2*theta2_dot(i)*cos(theta2(i));
                y2_v = y1_v+L2*theta2_dot(i)*cos(theta2(i));
                
                %Plot Velocity Vectors as Lines
                plot([x1 x1_v+x1],[y1 y1_v+y1],'r');
                plot([x2 x2_v+x2],[y2 y2_v+y2],'r');
            end
            
            %If Plotting Acceleration Vectors is On
            if(acceleration_vectors == 1)
                %Calcuate Angular Acceleration from Angular Position/Velocity
                theta1_ddot= (-g*(2*m1+m2)*sin(theta1(i))-m2*g*sin(theta1(i)-2*theta2(i))...
                    -2*sin(theta1(i)-theta2(i))*m2*(L2*theta1_dot(i)^2+L1*theta1_dot(i)^2*cos(theta1(i)-theta2(i))))...
                    /(L1*(2*m1+m2-m2*cos(2*theta1(i)-2*theta2(i))));
                theta2_ddot= (2*sin(theta1(i)-theta2(i))*(theta1_dot(i)^2*L1*(m1+m2)+...
                    g*(m1+m2)*cos(theta1(i))+theta2_dot(i)^2*L2*m2*cos(theta1(i)-theta2(i))))...
                    /(L2*(2*m1+m2-m2*cos(2*theta1(i)-2*theta2(i))));
                
                %Convert Natural to Cartesian
                x1_a = L1*theta1_ddot*cos(theta1(i)) - L1*theta1_dot(i)^2*sin(theta1(i));
                y1_a = L1*theta1_ddot*sin(theta1(i)) + L1*theta1_dot(i)^2*cos(theta1(i));
                x2_a = x1_a+L2*theta2_ddot*cos(theta2(i)) - L2*theta2_dot(i)^2*sin(theta2(i))
                y2_a = y1_a+L2*theta2_ddot*sin(theta2(i)) + L2*theta2_dot(i)^2*cos(theta2(i))
                
                %Plot Acceleration Vectors as Lines
                plot([x1 x1_a+x1],[y1 y1_a+y1],'g');
                plot([x2 x2_a+x2],[y2 y2_a+y2],'g');
            end
            
            %If Pause is Enabled, Pause Between Frames
            if(pause_after_frame == 1)
                pause
            end
            
            %Draw Frame of Animation
            drawnow;
        end
    end

end