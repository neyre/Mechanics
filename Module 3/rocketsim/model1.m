function [T,Ht] = model1
%Rocket Simulation v1
%Inputs: None, %Outputs: [Time, Height(T)]
%Simulates the flight of the C6 model rocket w/ Constant Thrust (no Drag)

%Simulation Parameters
n = 1000;       %Number of Data Points

%System Constants
p = 1.225;      %Air Density (kg / m^3)
Cd = 0;      %Drag Coefficient
d = .0343;      %Rocket Diameter (m)
A = pi*(d/2)^2; %Rocket Cross Sectional Area (m^2)
Mp = .0108;     %Propellant Mass (kg)
Mi = .1173;     %Initial Launch Mass
It = 8.82;      %Total Impulse (Newton-Seconds)
Tf = 1.86;      %Burn Time (s)
g = 9.8;        %Acceleration of Gravity (m/s^2)
Ft = 4.74;      %Average Thrust (N)

%%%%%%%%%%%%%%%%%%%
%%% BOOST PHASE %%%
%%%%%%%%%%%%%%%%%%%

%Setup Initial Conditions and run ODE45 Solver
initial = [0;0;Mi];
time = linspace(0,Tf,n);
[Tb, Ub] = ode45(@boost, time, initial);

function res=boost(t, U)
    %Differential Equation Function for Solving with ode45
    %Inputs: Time, Input Vector
    %Input Vector: velocity,height,mass
    %Outputs: Output Vector
    %Output Vector: acceleration,velocity,mass rate of change

    %Unpack Vector
    H_Dot = U(1);  %Velocity
    H     = U(2);  %Height
    M     = U(3);  %Mass

    %Calculate Acceleration
    H_DDot = Ft/M - g - .5/M*Cd*p*A*H_Dot^2;

    %Calculate Mass Rate of Change as Function of Current Thrust
    M_Dot = -Ft*Mp/It;

    %Pack Result Vector
    res = [H_DDot; H_Dot; M_Dot];
end

%%%%%%%%%%%%%%%%%%%
%%% COAST PHASE %%%
%%%%%%%%%%%%%%%%%%%

%Setup Initial Conditions and run ODE45 Solver
initial = Ub(end,:);
time = linspace(Tb(end),Tb(end)+10,n);
options = odeset('Events', @events);
[Tc, Uc] = ode45(@coast, time, initial,options);

function res=coast(t, U)
    %Differential Equation Function for Solving with ode45
    %Inputs: Time, Input Vector
    %Input Vector: velocity,height,mass
    %Outputs: Output Vector
    %Output Vector: acceleration,velocity,mass rate of change

    %Unpack Vector
    H_Dot = U(1);  %Velocity
    H     = U(2);  %Height
    M     = U(3);  %Mass

    %Get Current Thrust
    Ft = thrust(t);  %Rocket Thrust

    %Calculate Acceleration
    H_DDot = Ft/M - g - .5/M*Cd*p*A*H_Dot^2;

    %Pack Result Vector
    res = [H_DDot; H_Dot; 0];
end

function [value,isterminal,direction] = events(t,W)
    %Used by odeset to determine end condition for Coast Phase
    %End condition is Velocity = 0
    %Input: Time, [Velocity, Position, Mass]

    value = W(1);
    isterminal = 1;
    direction = -1;
end

%%%%%%%%%%%%%%%%%%%%%%
%%% COMBINE PHASES %%%
%%% & RETURN H(T)  %%%
%%%%%%%%%%%%%%%%%%%%%%

T  = [Tb;Tc];
Ht = [Ub(:,2);Uc(:,2)];

end