%% Time delays

close all
clear all


%%

figure(99); clf; hold on
figuresize(12,12,'cm')

s = tf('s');
GH1 = 1/(s+1);
GH2 = GH1; GH2.OutputDelay = 0.1; 

nyquist(GH1,GH2)

axis([-0.2 1.2 -0.7 0.7])

for ff = [0.5 1 2 4 8]
  [re1,im1] = nyquist(GH1,ff);
  [re2,im2] = nyquist(GH2,ff);
  plot([re1 re2],[im1 im2],'k.-','markersize',8)
  t = text(re2,im2,[num2str(ff),' ']);
  set(t,'horizontalalignment','r')
  if ff == 0.5
    set(t,'horizontalalignment','l')
    set(t,'verticalalignment','t')
  end
  if ff == 1
    set(t,'verticalalignment','t')
  end
end

legend('T=0','T=0.1')

print -dpdf timedelaynyq.pdf

%%

figure(11)
bode(GH1,GH2)

%%

figure(2); clf; hold on
figuresize(12,12,'cm')

s = tf('s');
TD = exp(-s);
bode(TD)

print -dpdf puretimedelaybode.pdf