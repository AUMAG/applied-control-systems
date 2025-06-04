%% Linearisation

clearvars
clc

%<*param>
param.c   = 1;         % kg/s
param.mu0 = 4*pi*1e-7; % N/A^2
param.a   = 0.025;     % m
param.Br  = 1.3;       % T
param.rho = 7500;      % kg/m^3
param.g   = 9.81;      % m/s^2
param.gap = 16*param.a;
param.vol = param.a^3;
param.mass = param.rho*param.vol;
param.magn_x = param.Br/param.mu0*param.vol;
%</param>

%<*forces>
f_mag = @(x) (3/2) * param.mu0 * param.magn_x^2 ./ x.^4; % attraction by default
f_attr = @(gd,x) f_mag(-gd/2+x);
f_repl = @(gd,x) f_mag(+gd/2+x);
f_spring = @(gd,x) f_attr(gd,x) + f_repl(gd,x);
%</forces>

%<*plot1>
figure(1); clf; hold on; box on
displ = linspace(-param.gap/4,param.gap/4);
plot(displ,f_attr(param.gap,displ))
plot(displ,f_repl(param.gap,displ))
plot(displ,f_spring(param.gap,displ))

yline(param.mass*param.g,'--',"Weight")
xlabel("Displacement, x"); ylabel("Force, N")
legend("Attraction","Repulsion","Total")
%</plot1>

%<*plot2>
figure(2); clf; hold on; box on
displ = linspace(-param.gap/4,param.gap/4);
for gap = (13:20)*param.a
  plot(displ,f_spring(gap,displ))
end
yline(param.mass*param.g,'--',"Weight")
xlabel("Displacement, x"); ylabel("Force, N")
ylim([0 5])
%</plot2>

%% Dynamic model
%
% Let's implement the ODE. Take the sum of forces:
% $$ m\ddot x = - c \dot x + k(x) $$

%<*msd>
function dq = magspring_dyn(q,param)
  x   = q(1,:);
  dx  = q(2,:);

  f_mag = @(x) (3/2) * param.mu0 * param.magn_x^2 ./ x.^4; % attraction by default
  f_spring = @(gd,x) f_mag(-gd/2+x) + f_mag(+gd/2+x);

  ddx = f_spring(param.gap,x)/param.mass - param.c/param.mass*dx - param.g;
  dq  = [dx; ddx];
end
%</msd>

%<*ode>
tmax = 2; % s
x0  = -0.05; % initial position, m
dx0 = 0; % initial velocity, m/s
[t,x] = ode45(@(tt,xx) magspring_dyn(xx,param),[0 tmax],[x0; dx0]);
%</ode>

%<*plot3>
figure(3); clf; hold on; box on
yyaxis left; plot(t,1000*x(:,1),'.-')
yyaxis right; plot(t,1000*x(:,2),'.-')
box on; grid on
xlabel("Time, s")
yyaxis left; ylabel("Displacement, mm")
yyaxis right; ylabel("Velocity, mm/s")
%</plot3>


%% Vector field

%<*quiv1>
x1_0 = 0.08;
x2_0 = 1;
x1range = linspace(-x1_0,x1_0,21);
x2range = linspace(-x2_0,x2_0,21);
[x1,x2] = meshgrid(x1range,x2range);
x1x2 = transpose([x1(:),x2(:)]);
dx1dx2 = magspring_dyn(x1x2,param);
%</quiv1>

%<*quiv2>
yscale = 10; % just for better plotting
figure(4); clf; hold on; box on
quiver(x1x2(1,:),x1x2(2,:)/yscale,dx1dx2(1,:),dx1dx2(2,:)/yscale)
xlabel("Displacement $x_1$",Interpreter="LaTeX")
ylabel("Velocity $x_2$/"+yscale,Interpreter="LaTeX")
axis square
axis(1.2*[-x1_0 x1_0 -x2_0/yscale x2_0/yscale])
%</quiv2>


%% Phase portrait

clc

%<*phase1>
figure(101); clf; tiledlayout(1,2);

tmax = 2; x1_max = 0.1; x2_max = 1;
x1range = linspace(-x1_max,x1_max,7);
x2range = linspace(-x2_max,x2_max,7);
[x1_0,x2_0] = meshgrid(x1range,x2range);
%</phase1>

%<*phase2>
for ii = 1:numel(x1_0(:))
  [t,x] = ode45(@(tt,xx) magspring_dyn(xx,param),[0 tmax],[x1_0(ii); x2_0(ii)]);

  isstable = x(end,2) < 1e-3; % if mass comes to rest
  if isstable, col = "black"; else, col = "red"; end

  nexttile(1); hold on; grid on; box on
  plot(t(1,1),x(1,1),".",MarkerSize=10,Color=col); % plot initial state
  plot(t(:,1),x(:,1),color=col)

  nexttile(2); hold on; grid on; box on
  plot(x(1,1),x(1,2),".",MarkerSize=10,Color=col); % plot initial state
  plot(x(:,1),x(:,2),color=col)
end
%</phase2>

%<*phase3>
nexttile(1)
xlabel("Time, $t$, s",Interpreter="LaTeX")
ylabel("Displacement, $x_1$, m",Interpreter="LaTeX")
axis square
title("Time evolution of states")

nexttile(2)
xlabel("Displacement, $x_1$, m",Interpreter="LaTeX")
ylabel("Velocity, $x_2$, m/s",Interpreter="LaTeX")
yylim = ylim(); ythresh = x2_max*1.5;
ylim([max(yylim(1),-ythresh),min(yylim(2),+ythresh)]); % limit y axis if unstable
axis square
title("State trajectories (phase portrait)")
%</phase3>

nexttile(1)
xlim([0 0.5*tmax])

nexttile(2)
xlim([-0.125 0.125])
ylim([-1.25 1.25])
figuresize(20,10,"cm")
saveas(gcf,"magspringportrait.pdf")


%% Linearise

clc

% find equilibrium points:

%<*root>
x_eq1 = fzero(@(x) f_spring(param.gap,x)-param.mass*param.g , -0.01);
x_eq2 = fzero(@(x) f_spring(param.gap,x)-param.mass*param.g , +0.01);
%</root>

%<*deriv>
k_mag = @(x) -6 * param.mu0 * param.magn_x^2 ./ x.^5;
k_spring = @(gd,x) k_mag(-gd/2+x) + k_mag(+gd/2+x);

figure(11); clf; hold on; box on
displ = linspace(-param.gap/4,param.gap/4,20);
plot(displ,k_spring(param.gap,displ))
plot(displ,gradient(f_spring(param.gap,displ),displ(2)-displ(1)),'.')
legend("Analytical","Numerical")
ylabel("Derivative of force, N/m")
xlabel("Displacement, m")
%</deriv>

%% Response at first equilibrium point

%<*ss>
k_lin1 = k_spring(param.gap,x_eq1);
M = param.mass;

A1 = [0, 1; k_lin1/M, -param.c/M];
B1 = [0; 1/M];
C1 = [1, 0]; % displacement output
D1 = 0;

magss1 = ss(A1,B1,C1,D1);
%</ss>

%<*lin>
figure(8); clf; hold on; box on

x0  = -0.01; % initial position, m
dx0 = 0; % initial velocity, m/s

[y,t] = initial(magss1,[x0; dx0]);
plot(t,1000*y)

[t,x] = ode45(@(tt,xx) magspring_dyn(xx,param),[0 t(end)],[x_eq1+x0; dx0]);
plot(t,1000*(x(:,1)-x_eq1),'--')

xlim([0 t(end)])
xlabel("Time, s")
ylabel("Displacement, mm")
legend("Linear","Nonlinear")
title("Unforced response from inital condition")
%</lin>


%% Step response

%<*step>
stepinfo(magss1)

figure(9)
sp = stepplot(magss1);
sp.Characteristics.SettlingTime.Visible = "on";
sp.Characteristics.PeakResponse.Visible = "on";
%</step>

%% Frequency response

%<*frf>
figure(10)
bp = bodeplot(magss1);
bp.Characteristics.FrequencyPeakResponse.Visible = "on";
%</frf>