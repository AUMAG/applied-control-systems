%% My first Bode plot

xline = @(x,varargin) plot([x x],ylim(),varargin{:});

s = tf('s');
GH = 100*(s+1)/(s+10)/(s+100);
[mag,pha,freq] = bode(GH);

figure(1); clf; hold on
figuresize(10,10,'cm')
subplot(2,1,1); cla; hold on
box on

plot(squeeze(freq),20*log10(squeeze(mag)),'linewidth',1)

grid on
set(gca,'xscale','log')
ylabel('Magnitude, dB')
xticklabels([])
ylim([-45 5])
xline(1,'--','color','red')
xline(10,'--','color','red')
xline(100,'--','color','red')

subplot(2,1,2); cla; hold on
box on

plot(squeeze(freq),squeeze(pha),'linewidth',1)

grid on
set(gca,'xscale','log')
yticks(-90:45:90)
ylim([-110 110])
ylabel('Phase, deg.')
xlabel('Frequency, rad/s')
xline(1,'--','color','red')
xline(10,'--','color','red')
xline(100,'--','color','red')

subplot(2,1,1);
set(gca,'units','normalized');
pos = get(gca,'position');
set(gca,'position',pos+[0 -0.1 0 0])

print -dpdf bode1.pdf

%%

figure(2); clf; hold on
figuresize(10,10,'cm')

%<*bode2>
s = tf('s');

GH = 100*(s+1)/(s+10)/(s+100);

bodeplot(GH)
%</bode2>

print -dpdf bode2.pdf
