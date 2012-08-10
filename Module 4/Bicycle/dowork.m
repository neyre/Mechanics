speeds = [1:1:20];
    
for i=1:length(speeds)
    times(i)=bikesim(speeds(i));
end

clf
plot(speeds,times)