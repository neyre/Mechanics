function wavesim
%Simulation of a Sine Wave oscillating with the Wave Equation in Discrete Space
%Breaks up a "String" into chunks and simulates the movement of the
%discrete chunks using ODE45.
%Inputs: None, Outputs: None
%
%by Nick Eyre (neyre@students.olin.edu) - May 1, 2012

%System Parameters
n = 100;    %Number of "Chunks"
l = 1;      %Length of String
lambda = 1;      %Lambda
tension = 2;    %Tension
A = 1;          %Amplitude
humps = 1;      %Humps in Wave

%Simulation Parameters
TimeStep = .025;
SimTime = 20;
pause_after_frame = 1;

%Set Initial Conditions and define h(x,0) and h_dot(x,0)
X = linspace(0,l,n)';   %Column Vector of X Positions of "Chunks"
Hi = A*sin(humps*pi*X/l);
Vi = zeros(n,1);        %Column Vector of Initial Velcities of "Chunks"
Lambda = lambda*ones(n,1);

%Run Simulation & Animate
Initial = [Hi;Vi];
Time = [0:TimeStep:SimTime];
[T,U]=ode45(@diffeq,Time,Initial);
animate(T,U);

function out=diffeq(T,U)
%Calculates Differential Equations for the Wave
    %Unpack Input Vector
    H = U(1:n);
    V = U(n+1:end);

    %Setup Derivative Vectors
    H_Dot = V;
    V_Dot = zeros(n,1);
    
    %Calculate Second Derivatives
    for i=[2:n-1]
        V_Dot(i)=tension/Lambda(i)*(H(i-1)-2*H(i)+H(i+1))/(l/n)^2;
    end

    %Return Output Vector
    out = [H_Dot;V_Dot];      
end

function animate(T,U)
    %Unpack Input Vector
    H = U(:,1:n);
        
    %Set Axes
    minmax = abs(max(max(H)));
    minmax = [0,l,-minmax,minmax];
        
        %Steps Through Each Time Step and Plot Frame
        for i=1:length(T)
            
            %Setup Graph
            clf;
            axis(minmax);
            hold on;
            
            plot(X,H(i,:));
            
            %If Pause is Enabled, Pause Between Frames
            if(pause_after_frame == 1)
                pause
            end
            
            %Draw Frame of Animation
            drawnow;
        end
    end

end