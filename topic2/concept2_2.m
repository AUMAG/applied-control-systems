%% Vector Field and Phase Portrait

%% Model

%<*msdnl>
k = 10;  % stiffness, N/m
m = 2;   % mass, kg
c = 100; % nonlinear damping term

tmax = 10; % s
x1_0 = 0.1; % initial position, m
x2_0 = 0.0; % initial velocity, m/s

function dq = mass_spring_damper_nonlin(q,param)
  k = param(1); c = param(2); m = param(3);
  x   = q(1,:);
  dx  = q(2,:);
  ddx = - k/m*x - c/m.*sign(dx).*dx.^2;
  dq  = [dx; ddx];
end
%</msdnl>


function dq = mass_spring_damper_lin(q,param)
  k = param(1); c = param(2); m = param(3);
  x   = q(1,:);
  dx  = q(2,:);
%<*msdlin>
  ddx = - k/m*x - c/m*dx/100;
%</msdlin>
  dq  = [dx; ddx];
end

%% Plot

%<*plot1>
[t,x] = ode45(@(tt,xx) mass_spring_damper_nonlin(xx,[k,c,m]),[0 tmax],[x1_0; x2_0]);

figure(3); clf; hold on
plot(t,x)
box on; grid on
xlabel("Time, s")
ylabel("Signal")
legend("Displacement","Velocity")
%</plot1>


%% Vector field

%<*quiv1>
x1range = linspace(-x1_0,x1_0,10);
x2range = linspace(-x1_0,x1_0,10);
[x1,x2] = meshgrid(x1range,x2range);
x1x2 = transpose([x1(:),x2(:)]);
dx1dx2 = mass_spring_damper_nonlin(x1x2,[k,c,m]);
%</quiv1>

%<*quiv2>
figure(4); clf; hold on; box on
quiver(x1x2(1,:),x1x2(2,:),dx1dx2(1,:),dx1dx2(2,:))
xlabel("$x_1$",Interpreter="LaTeX")
ylabel("$x_2$",Interpreter="LaTeX")
axis square
axis(1.2*[-x1_0 x1_0 -x1_0 x1_0])
%</quiv2>

figure(44); clf; hold on
box on
x1range = linspace(-x1_0,x1_0,10);
x2range = linspace(-x1_0,x1_0,10);
[x1,x2] = meshgrid(x1range,x2range);
dx1dx2 = mass_spring_damper_lin(transpose([x1(:),x2(:)]),[k,c,m]);
quiver(x1x2(1,:),x1x2(2,:),dx1dx2(1,:),dx1dx2(2,:))
xlabel("$x_1$",Interpreter="LaTeX")
ylabel("$x_2$",Interpreter="LaTeX")
axis square
axis(1.2*[-x1_0 x1_0 -x1_0 x1_0])


%% Phase portrait

%<*phase>
figure(101); clf;
tmax = 10; % s
x1_0 = [-0.1 -0.01 0.1 0.01]; % initial positions, m
x2_0 = [0 0.2 0 -0.2]; % initial velocities, m/s
for ii = 1:4
  [t,x] = ode45(@(tt,xx) mass_spring_damper_nonlin(xx,[k,c,m]),[0 tmax],[x1_0(ii); x2_0(ii)]);
  subplot(1,2,1); hold on; box on; grid on
  h1 = plot(t(1,1),x(1,1),".",MarkerSize=15); % plot initial state
  plot(t(:,1),x(:,1),color=h1.Color)
  subplot(1,2,2); hold on; box on; grid on
  h1 = plot(x(1,1),x(1,2),".",MarkerSize=15); % plot initial state
  plot(x(:,1),x(:,2),color=h1.Color)
end
%</phase>
subplot(1,2,1)
xlabel("$t$",Interpreter="LaTeX")
ylabel("$x_1$",Interpreter="LaTeX")
axis square
subplot(1,2,2)
xlabel("$x_1$",Interpreter="LaTeX")
ylabel("$x_2$",Interpreter="LaTeX")
axis square
