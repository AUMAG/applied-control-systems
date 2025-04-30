%% sotd 2 real

figure(1); clf; hold on
figuresize(12,10,'cm')

%<*sotd2real>
s = tf('s');
k = 1.5;
T1 = 4;
T2 = 8;
L = 2;

G1  = k/(T1*s+1)*exp(-L*s);
G2  = k/(T2*s+1)*exp(-L*s);
G12 = k/(T1*s+1)/(T2*s+1)*exp(-L*s);

step(G1,G2,G12);
legend('G1','G2','G12')
%</sotd2real>

yline(0.63*k);
xline(L+T1);
xline(L+T2);
xline(L+T1+T2);

legend('G1','G2','G12')

%print -dpdf sotd-2real.pdf

%% sotd 2 real vs fotd

figure(1); clf; hold on
figuresize(12,10,'cm')

%<*sotd2realVSfotd>
s = tf('s');
k = 1.5;
T1 = 4;
T2 = 8;
L = 2;

G2r = k/(T1*s+1)/(T2*s+1)*exp(-L*s);
G1r = k/((T1+T2)*s+1)*exp(-L*s);

step(G2r,G1r)
legend('G2r','G1r')
%</sotd2realVSfotd>

%print -dpdf 2real-v-1real.pdf



%% sotd 2 complex

clear all
close all

s = tf('s');

figure(1);
figuresize(12,10,'cm')

%<*sotd2complex>
L    = 0.5;  k  = 1.5;
zeta = 0.4;  wn = 2;

G  = k*wn^2*exp(-L*s)/...
     (s^2+2*zeta*wn*s+wn^2);
step(G)
%</sotd2complex>

%print -dpdf sotd-2complex.pdf


%% sotd annotated graph

figure(10); clf; hold on
figuresize(14,12)
box on
set(gca,'layer','top','TickLabelInterpreter','latex')
xlabel('Time')
title('Amplitude response to step input')

s = tf('s');
L = 1;
k = 1;
ee = 0.1;
rr = 0.2;
zeta = 0.27;
wn = 2;

grey = 0.6*[1 1 1];

G  = k*wn^2*exp(-L*s)/...
     (s^2+2*zeta*wn*s+wn^2);

Tmax = 8;
time = linspace(0,Tmax,10000);
[y,t] = step(G,time);

marker = {'marker','d','markeredgecolor','none','markerfacecolor',[0 0 0]};

p = patch([Tmax 0 0 Tmax],[k+ee k+ee k-ee k-ee],[0.9 1 0.9],'edgecolor','none');

plot(t,y,'linewidth',2,'color',[0.1 0.8 0.3])

[ymax,imax] = max(y);
plot(t(imax),ymax,marker{:})
Tp = t(imax);
Yp = y(imax);
plot([0 Tp Tp],[Yp Yp 0],'-','color',grey)


plot(L,0,marker{:})

ind1 = find(y<=rr,1,'last');
plot(t(ind1),y(ind1),marker{:})
plot([0 t(ind1) t(ind1)],[y(ind1) y(ind1) 0],'-','color',grey)
Tr1 = t(ind1);

ind2 = find(y>=k-rr,1,'first');
plot(t(ind2),y(ind2),marker{:})
plot([0 t(ind2) t(ind2)],[y(ind2) y(ind2) 0],'-','color',grey)
Tr2 = t(ind2);


ind1 = find(y<=(k-ee)|y>=(k+ee),1,'last');
Ts = t(ind1);
plot(t(ind1),y(ind1),marker{:})
xline(Ts,'color',grey)

yline(k,'color',grey);

xticks([0,L,Tr1,Tr2,Tp,Ts])
xticklabels(["$0$","$\tau$","$t_1$","$t_2$","$T_p$","$T_s$"])

yticks(sort([0 k+ee k k-ee k-rr rr Yp]))
yticklabels(["$0$","$0.1K$","$0.9K$","$(1-\epsilon)K$","$K$","$(1+\epsilon)K$","$y_p$"])

print -dpdf sotd-annot.pdf



%% sotd model

s = tf('s');

L = 0;
k = 1;
zeta = 0.32;
wn = 2;
alpha = 1/wn;

G  = k*wn^2*exp(-L*s)/...
     (s^2+2*zeta*wn*s+wn^2)/(alpha*s+1);

time = linspace(0,10,1000);
[y,t] = step(G,time);

dy = gradient(y,t);
[~,imax] = max(dy);
L = t(imax) - y(imax)/dy(imax);

[PKS,LOCS]= findpeaks(y);
LOCS = LOCS(1:2);
d = (y(LOCS(1))-k)/(y(LOCS(2))-k)
zeta_est = 1/sqrt(1+(2*pi/(log(d)))^2)

Tpp = t(LOCS(2))-t(LOCS(1))
wn_est = 2*pi/Tpp

info = stepinfo(G);
os = info.Overshoot/100;
Ts = info.SettlingTime;

zeta_est2 = 1/sqrt(1+(pi/(log(os)))^2)

G2  = k*wn_est^2*exp(-L*s)/...
     (s^2+2*zeta_est*wn_est*s+wn_est^2);

G3  = k*wn_est^2*exp(-L*s)/...
     (s^2+2*zeta_est2*wn_est*s+wn_est^2);

[y2,t2] = step(G2,time);
[y3,t3] = step(G3,time);

figure(20); clf; hold on; box on
figuresize(12,10)
plot(t,y)
plot(t(LOCS),y(LOCS),'.','markersize',20)
for ii = 1:2
  text(t(LOCS(ii)),y(LOCS(ii))*1.08,sprintf('$y=%1.2f$',y(LOCS(ii))),...
    'interpreter','latex',...
    'horizontalalignment','center',...
    'verticalalignment','bottom')
  text(t(LOCS(ii)),y(LOCS(ii))*1.02,sprintf('$t=%1.2f$',t(LOCS(ii))),...
    'interpreter','latex',...
    'horizontalalignment','center',...
    'verticalalignment','bottom')
end
yline(k,'--')
xlabel('Time, s')

plot([L t(imax) t(imax)],[0 y(imax) 0],'-','color','red')
plot(t(imax),y(imax),'d','MarkerFaceColor','red','MarkerEdgeColor','none')
text(t(imax)*1.1,y(imax)/2,sprintf('$L=%1.2f$',L),'interpreter','latex','horizontalalignment','left')

print -dpdf sotd-3pole.pdf

figure(21); clf; hold on; box on
figuresize(12,10)
grey = 0.6*[1 1 1];
plot(t,y,':','linewidth',2)
plot(t2,y2,'linewidth',1)
plot(t3,y3,'linewidth',1.5)
yline(k,'--')
xlabel('Time, s')

l = legend('Plant','Model ($\zeta$ from O/S)','Model ($\zeta$ from $d$)');
set(l,'interpreter','latex')

%print -dpdf sotd-3pole-models.pdf


%% sysid

clc
T = 16
k = 40
wr = 2*pi/T
d = 0.16/0.02
zz=1/sqrt(1+(2*pi/log(d))^2)
wn=0.4*sqrt(1-zz^2)
m = k/wn^2
c = 2*zz*sqrt(k*m)