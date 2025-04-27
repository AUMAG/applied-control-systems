%% Vector Field and Phase Portrait

%% Mass-spring-damper
%
% Let's solve an ODE numerically. Take the mass-spring-damper model:
% $$ m\ddot x = - k x - c \dot x $$

k = 10; % stiffness, N/m
c = 1; % damping, kg/s
m = 2; % mass, kg

function dq = mass_spring_damper(q,param)
  k = param(1); c = param(2); m = param(3);
  x   = q(1,:);
  dx  = q(2,:);
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

figure(33); clf;
box on; grid on

tmax = 50; % s
x0  = [-0.1 0 0.1 0]; % initial position, m
dx0 = [0 0.2 0 -0.2]; % initial velocity, m/s
for ii = 1:4
  [t,x] = ode45(@(tt,xx) mass_spring_damper(xx,[k,c,m]),[0 tmax],[x0(ii); dx0(ii)]);
  subplot(1,2,1); hold on
  h1 = plot(t(1,1),x(1,1),".",MarkerSize=15);
  plot(t(:,1),x(:,1),color=h1.Color)
  subplot(1,2,2); hold on
  h1 = plot(x(1,1),x(1,2),".",MarkerSize=15);
  plot(x(:,1),x(:,2),color=h1.Color)
end
subplot(1,2,1)
xlabel("$t$",Interpreter="LaTeX")
ylabel("$x_1$",Interpreter="LaTeX")
axis square
subplot(1,2,2)
xlabel("$x_1$",Interpreter="LaTeX")
ylabel("$x_2$",Interpreter="LaTeX")
axis square
%</msd>

mass_spring_damper([1 2;2 4],[k,c,m])

figure(4); clf; hold on
x1range = linspace(-1,1,20);
x2range = linspace(-1,1,20);
[x1,x2] = meshgrid(x1range,x2range);
Fx12 = mass_spring_damper(transpose([x1(:),x2(:)]),[k,c,m])
quiver(x1,x2,reshape(Fx12(1,:),size(x1)),reshape(Fx12(2,:),size(x2)))