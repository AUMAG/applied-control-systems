%% fotd.m

%%

clear all
close all

s = tf('s');
k = 1.5;
T = 4;
L = 2;

G = k/(T*s+1)/(2*T*s+1)*exp(-L*s);

Npoints = 1000;
Tmax = 50;
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
ylim([-1.5*a y5])

plot(t,y,'linewidth',1)
plot([0, Tmax],[y3, y3],"k--")

xlabel('Time, s')
title('Amplitude response to step input')

print -dpdf fotd.pdf

%%

figure(2); clf; hold on
figuresize(12,10,'cm')
box on
yline(0)
ylim([-1.5*a y5])

plot(t,y,'-','linewidth',0.4,'linewidth',5,color=0.9*[1 1 1])

h = plot(t(ii),y(ii),'s','markersize',6);
h.MarkerFaceColor = h.Color;

plot([0 t5],[-a y5],'-','markersize',15,'color',h.Color)
col63 = [0.2 0.65 0.2];
h3 = plot([0 t4 t4],[y4 y4 y5],color=col63);
h3 = plot([t4 t4],[-1.5*a y5],color=col63);
h2 = plot(t4,y4,'d','markersize',6,color=col63);
h2.MarkerFaceColor = h3.Color;

plot([0, Tmax],[y3, y3],"k--")

text(t4,y4,"  63% of steady state",color=col63)
text(t(ii),y(ii),"  point of maximum slope",'color',h.Color)
h3 = plot([t0 t0],[-1.5*a y5],color=h.Color);

xt = xticks();
xticks([0,t0,10,t4,20,30,40,50])
xticklabels(["$0$","$\tau$","","$\tau+T_{63}$","","","",""]);
set(gca,TickLabelInterpreter="LaTeX",XTickLabelRotation=0)
yticks([-a,0, 0.25, 0.5, 0.75, 0.63*y3, 1.25, 1.5])
yticklabels(["$-a$","0","","","","$0.63 K$","","$K$"])

xlabel('Time, s')
title('Amplitude response to step input')

print -dpdf fotd-LT.pdf

%%

kk = y3;
LL = t0;
TT = t4-t0;
G2 = kk/(TT*s+1)*exp(-LL*s);

figure(3); clf; hold on
figuresize(12,10,'cm')
box on

[yy,tt] = step(G2,time);
plot(t,y,':','linewidth',0.4,'linewidth',1)
plot(tt,yy,'linewidth',1)



xlabel('Time, s')
ylabel('Amplitude')

%print -dpdf fotd-2est3.pdf
