
figure(1); clf; box on
figuresize(10,8,"cm")
%<*load>
load iddata2 z2;
plot(z2)
%</load>
saveas(gcf,"idtime.pdf")

figure(2); clf; hold on; box on
figuresize(10,8,"cm")
%<*frf>
% numerical frequency response
% (signal processing toolbox)
[frf,freq] = tfestimate(...
  z2.InputData,z2.OutputData,...
  [],[],[],1/z2.Ts);
plot(freq,mag2db(abs(frf)))

% identified frequency response
sys = tfest(z2,2,1);
[mag,pha] = bode(sys,2*pi*freq);
plot(freq,mag2db(mag(:)))
%</frf>

xlabel("Frequency, Hz")
ylabel("Magnitude, dB")
legend("Measured","Estimated")

saveas(gcf,"idfreq.pdf")