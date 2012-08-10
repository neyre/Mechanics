function ans = thrust(t)
%Returns Thrust of C6 Rocket at time t after ignition
%Uses Linear Interpolation from data on data sheet
%Inputs: t, Outputs: Thrust

    %Load Data from Data Sheet
    T = [0 0.0310 0.0920 0.1390 0.1920 0.2090 0.2310 0.2480 0.2920 ...
        0.3700 0.4750 0.6710 0.7020 0.7230 0.8500 1.0630 1.2110 1.2420 ...
        1.3030 1.4680 1.6560 1.8210 1.8340 1.8470 1.8600];
    F = [0 0.9460 4.8260 9.9360 14.0900 11.4460 7.3810 6.1510 5.4890 ...
        4.9210 4.4480 4.2580 4.5420 4.1640 4.4480 4.3530 4.3530 4.0690 ...
        4.2580 4.3530 4.4480 4.4480 2.9330 1.3250 0];
    
    %If Not in Range, Return No Thrust
    %If In Range, Return Linear Interpolation based on Data from Data Sheet
    if(t < T(1) || t > T(end))
        ans = 0;
    else
        ans = interp1(T,F,t);
    end
    
end