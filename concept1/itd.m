%% itd.m

%%

clear all
close all

s = tf('s');
k = 1.5;
T = 4;
L = 2;

G = k/(T*s+1)/(2*T*s+1)*exp(-L*s);

Npoints = 1000;
Tmax = 15;
ymax = 1.2;
time = linspace(0,Tmax,Npoints);

[y,t] = step(G,time);

dy = gradient(y,t);
[~,ii] = max(dy);
t0 = t(ii) - y(ii)/dy(ii);
y0 = 0;

a = dy(ii)*t0;

yincr = y(ii)/2;
t1 = t(ii) - yincr/dy(ii);
t2 = t(ii) + yincr/dy(ii);
y1 = y(ii)-yincr;
y2 = y(ii)+yincr;
y3 = dcgain(G);
t3 = (y3-y(ii))/dy(ii)+t(ii);
y5 = 1.2*dcgain(G);
t5 = (y5-y(ii))/dy(ii)+t(ii);

y4 = 0.63*y3;
ind = y>0;
t4 = interp1(y(ind),t(ind),y4);

figure(1); clf; hold on
figuresize(12,10,'cm')
box on
yline(0)
ylim([-1.5*a ymax])

plot(t,y,'linewidth',1)

xxlim = xlim();

xlabel('Time, s')
title('Amplitude response to step input')

print -dpdf itd.pdf

%%

figure(2); clf; hold on
figuresize(12,10,'cm')
box on
yline(0)
ylim([-1.5*a ymax])

plot(t,y,'-','linewidth',0.4,'linewidth',5,color=0.9*[1 1 1])

h = plot(t(ii),y(ii),'s','markersize',6);
h.MarkerFaceColor = h.Color;

plot([0 t5],[-a y5],'-','markersize',15,'color',h.Color,linewidth=1)
h3 = plot([t0 t0],[-1.5*a y5],color=h.Color,linewidth=1);
text(t(ii),y(ii),"  point of maximum slope",'color',h.Color)

xt = xticks();
xticks([0,t0,10,t4,20,30,40,50])
xticklabels(["$0$","$\tau$","","","","","",""]);
set(gca,TickLabelInterpreter="LaTeX",XTickLabelRotation=0)
yticks([-a,0, 0.25, 0.5, 0.75, 0.63*y3, 1.25, 1.5])
yticklabels(["$-a$","0","","","","","","K"])

xlabel('Time, s')
title('Amplitude response to step input')

xlim(xxlim)

print -dpdf itd-at.pdf
