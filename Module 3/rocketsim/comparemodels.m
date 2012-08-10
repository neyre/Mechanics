[T1,H1] = model1();
[T2,H2] = model2();
[T3,H3] = model3();
[T4,H4] = model4();

clf
hold all
plot(T1,H1);
plot(T2,H2);
plot(T3,H3);
plot(T4,H4);
xlabel('Time (s)','FontSize',12)
ylabel('Height (m)','FontSize',12)
title('Comparison of Rocket Models','FontSize',14)
legend('Constant Thrust Model','Constant Thrust Model with Drag','Improved Engine Model','Improved Engine Model with Drag','Location','SouthEast')
axis([0,T3(end),0,H3(end)])