r_v = [11:.1:20]; %Range to Test
r_w = [-100:5:100];    %Range to Test
results = zeros(length(r_w),length(r_v));

clf
hold on

for v_i=1:length(r_v)
    for w_i=1:length(r_w)
        if(r_v(v_i) ~= 0)
            result = 0;
            v = [r_v(v_i) 0 0];   %Initial Velocity
            w = [0 r_w(w_i) 0];   %Initial Angular Velocity

            [res,events] = pingpongrobot_part3(v,w);

            %If Successfully Gets Over Net
            if(events(1,3) > .1525)
                %If Doesn't Go Past Table
                if(events(2,1) < 2.74)
                    result = 1;
                else
                    result = 2;
                end
            end

            results(w_i,v_i) = result;
        end
    end
end

clf,hold on
for i=1:length(r_v);    %step through velocities
    for j=1:length(r_w); %step through angular velocities
        color = 'r.';   %Doesn't Go Over Net
        if(results(j,i) == 1)
            color = 'g.';   %Success
        else
            if(results(j,i) == 2)
            color = 'b.';   %Goes Over Table
            end
        end
        plot(r_v(i),r_w(j),color,'MarkerSize',20);
    end
end
ylabel('Initial J Angular Velocity (rad/s)');
xlabel('Inital I Velocity (m/s)');
title('Effect of Topspin/Backspin on Successful Serves')