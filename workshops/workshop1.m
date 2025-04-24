%<*part1>
%% My first Matlab workshop

%% Part 1

tmax = 10; % seconds
fn1 = 0.5; % Hz
fn2 = 0.8; % Hz
t = linspace(0,tmax);
y = sin(2*pi*fn1*t) + sin(2*pi*fn2*t);

figure(1); clf; hold on
plot(t,y)
box on; grid on
xlabel("Time, s")
ylabel("Signal")
%</part1>

%<*part2>
%% Part 2
y1 = 2*sin(2*pi*fn1*t);
y2 = 3*sin(2*pi*fn2*t);

figure(2); clf; hold on
plot(t,y1)
plot(t,y2)
plot(t,y1+y2,LineWidth=2)
box on; grid on
xlabel("Time, s")
ylabel("Signal")
%</part2>

%<*msd>
%% Mass-spring-damper
%
% Let's solve an ODE numerically. Take the mass-spring-damper model:
% $$ m\ddot x = - k x - c \dot x $$

k = 10; % stiffness, N/m
c = 1; % damping, kg/s
m = 2; % mass, kg

function dq = mass_spring_damper(q,param)
  k = param(1); c = param(2); m = param(3);
  x   = q(1);
  dx  = q(2);
  ddx = - k/m*x - c/m*dx;
  dq  = [dx; ddx];
end

tmax = 10; % s
x0  = 0.1; % initial position, m
dx0 = 0; % initial velocity, m/s
[t,x] = ode45(@(tt,xx) mass_spring_damper(xx,[k,c,m]),[0 tmax],[x0; dx0]);

figure(3); clf; hold on
plot(t,x)
box on; grid on
xlabel("Time, s")
ylabel("Signal")
legend("Displacement","Velocity")
%</msd>

%<*pz>
%% Mass-spring-damper in the frequency domain
%
% Let's solve an ODE numerically. Take the mass-spring-damper model:
%
% $$ P(s) = \frac{1}{ms^2+cs+k} $$

k = 10; % stiffness, N/m
c = 1; % damping, kg/s
m = 2; % mass, kg

s = tf('s'); % "complex frequency, s"
P = 1/(m*s^2+c*s+k);

tmax = 10; % s
figure(4); clf; tiledlayout(2,1);

nexttile; 
[y,t] = impulse(P,tmax);
plot(t,y);
xlabel("Time, s"); ylabel("Displacement, m")
title("Impulse response")

nexttile; 
[y, t] = step(P,tmax);
plot(t,y);
xlabel("Time, s"); ylabel("Displacement, m")
title("Step response")
%</pz>
