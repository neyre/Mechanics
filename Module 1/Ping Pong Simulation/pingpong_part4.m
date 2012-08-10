r = [14:.1:20]; %Range to Test
w = [0 0 0];    %Initial Spin
results = [];

clf
hold on

for i=r
    if(i>0)
        result = 0;
        v = [i 0 0];   %Initial Velocity
        [res,events] = pingpongrobot_part3(v,w);
        %events
        %pause
        %If Successfully Gets Over Net
        if(events(1,3) > .1525)
            %If Doesn't Go Past Table
            if(events(2,1) < 2.74)
                result = 1;
            end
        end
        
        results = [results;[i,result]];
        plot(i,result); hold on;
        
    end
end

results