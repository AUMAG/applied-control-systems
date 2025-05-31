%% pade_test.m

close all

tau = 2;
tmax = 6;

figure(1); clf; hold on; box on

plot([0 tau tau tmax],[0 0 1 1],'--',color="red",linewidth=2)
xlabel('Time, s')
ylabel('Amplitude')

figure(2); clf; hold on; box on
yticks([-1080:180:0])
xlabel('Frequency, rad/s')
ylabel('Phase, deg.')

ff = logspace(-2,2);
plot( ff, -ff*tau*180/pi ,'--',color="red",linewidth=2)
ylim([-1080, 0])

for  nn = 1:2:7

  [num,den] = pade(2,nn);
  Gpade = tf(num,den);
  figure(1);
  [y,t] = step(Gpade,tmax);
  plot(t,y)

  figure(2);
  [mag,pha,freq] = bode(Gpade);
  plot(freq,pha(:)-pha(1))
  set(gca,XScale="log")

end

figure(1);
figuresize(10,8,"cm")
saveas(gcf,"pade-step.pdf")

figure(2);
figuresize(10,8,"cm")
saveas(gcf,"pade-phase.pdf")

%%

tau = 2;
[num,den] = pade(tau,1);
Gpade = tf(num,den)

[num,den] = pade(tau,2);
Gpade = tf(num,den)

[num,den] = pade(tau,3);
Gpade = tf(num,den)

[num,den] = pade(tau,4);
Gpade = tf(num,den)

