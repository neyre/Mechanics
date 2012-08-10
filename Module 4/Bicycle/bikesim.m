function res = bikesim(NumberOfSpeeds)
%Bicycle Acceleration Simulation by Nick Eyre, April 2012
%Inputs: Number of Speeds
%Outputs: 

    %Input Parameters
    WheelDiam = .66;  %Wheel Diameter (meters);
    FastestRatio = 3; %Fastest Gear Ratio;
    SlowestRatio = 1; %Slowest Gear Ratio
    %NumberOfSpeeds = 1; %Number of Gear Ratios
    Mass = 82;      %Total Mass (kg);
    MomentInertia = .256;   %Moment of Inertia for One Wheel (kg-m^2)
    Rho = 1.225;    %Air Density (kg/m3)
    Cd = 2.2;       %Drag Coefficient
    Area = .5;     %Frontal Area (m2)
    SimTime = 100;  %Time to Simulate (s)
    TimeStep = .1;  %Simulation TimeStep
    EndDistance = 200;  %End Distance (meters)
    
    %Calculated Parameters & State Variables
    WheelRadius = WheelDiam / 2; 
    Ratios = linspace(SlowestRatio,FastestRatio,NumberOfSpeeds);
    CurrentRatio = 1;
    ShiftTimes = [0];
    
    %Setup and Run Simulations
    Initial = [0;0;0;0];
    Time = [0:TimeStep:SimTime];
    Options = odeset('Events', @events);
    [T,U] = ode45(@diffeq,Time,Initial,Options);
    
    %Visualize Data
    U(:,2) = U(:,2) * 2.237;    %Convert m/s to mph
    res = T(end); %Output Quarter Mile Time
    clf; hold all;
    AX = plotyy(T,U(:,2),T,U(:,1));
    xlabel('Time (sec)','FontSize',12);
    set(get(AX(1),'Ylabel'),'String','Velocity (mph)','FontSize',12) 
    set(get(AX(2),'Ylabel'),'String','Position (m)','FontSize',12) 
    title('Bicycle Acceleration on 200m Sprint','FontSize',14)
    
    %Plot Vertical Lines at Shift Points
    for i=ShiftTimes
        plot([i i],[0 1e9],'k--');
    end 

    function out=diffeq(T,U)
        %Differential Equation Function for Solving with ode45
        %Inputs: Time, Input Vector
        %Input Vector: position,velocity,wheel angular position,wheel angular velocity
        %Outputs: Output Vector
        %Output Vector: velocity,acceleration,wheel angular velocity,wheel angular acceleration

        %Unpack Vector
        X = U(1);  %Position
        V = U(2);  %Velocity
        ThetaWheel = U(3);  %Wheel Angular Position
        OmegaWheel = U(4);  %Wheel Angular Velocity
        
        %Determine if Shift
        if(CurrentRatio < length(Ratios))
        	OmegaPedalsNow = OmegaWheel / Ratios(CurrentRatio);
            OmegaPedalsNext= OmegaWheel / Ratios(CurrentRatio+1);
            [TorqueNow,PowerNow] = torque(OmegaPedalsNow);
            [TorqueNext,PowerNext] = torque(OmegaPedalsNext);
            if(PowerNext > PowerNow)
                CurrentRatio = CurrentRatio+1;
                ShiftTimes(CurrentRatio) = T;
            end
        end

        %Calculate Derived State Variables
        OmegaPedals = OmegaWheel / Ratios(CurrentRatio);
        [TorquePedals,PowerCurrent] = torque(OmegaPedals);
        TorqueWheel = TorquePedals / Ratios(CurrentRatio);
        
        %Calculate Derivatives
        X_Dot = V;
        V_Dot = (TorqueWheel/WheelRadius - .5*Rho*Cd*Area*V^2) / ...
            (Mass + 2*MomentInertia/WheelRadius^2);
        ThetaWheel_Dot = OmegaWheel;
        OmegaWheel_Dot = V_Dot / WheelRadius;

        %Pack Result Vector
        out = [X_Dot;V_Dot;ThetaWheel_Dot;OmegaWheel_Dot];
    end

    function [T,P]=torque(W)
        %Returns Torque and Power of the Rider Given a Rotational Velocity
        %Inputs: Omega (rad/sec), Outputs: Torque (N-m), Power (W)
        
        %Convert rad/sec to rpm
        rpm=W*60/2/pi;
        
        %Return Torque in ft-lbs as a function of rpm
        if(rpm<100)
            T=150;
        elseif(rpm<0)
            T=0;
        elseif(rpm>224)
            T=0;
        else
            T=3.704e-007*rpm^4-0.0002094*rpm^3+0.03182*rpm^2-1.456*rpm+150;
        end
        
        %Convert Torque to N-m and Calculate Power
        T = T*1.356;
        P = W.*T;
    end
    function [value,isterminal,direction] = events(t,W)
        %Used by odeset to determine end condition for Simulation
        %End condition is Position = MaxDistance (miles)
        Condition = EndDistance; %Miles to Meters
        value = W(1) - Condition;
        isterminal = 1;
        direction = 1;
    end

end