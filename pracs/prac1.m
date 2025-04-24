% Applied Control Systems
% Practical Week 2
% Sean McGowan 24/4/25


A = [0 1; 0 -10.98];
B = [0; 238.68];
C = [1 0];
D = [0];

%<*part1>
% Define A, B, C, and D matrices here
A = 
B = 
C = 
D =

% Set up state space model
model_inertia_disk = ss(A,B,C,D); 

% Define state, input, and output names
State_names = str2mat('theta','omega');
set(model_inertia_disk,'StateName',Statenames);
set(model_inertia_disk,'InputName',{'V\_{command}'},...
'OutputName',{'theta'}); 

% Simulate system response to a step input
step(model_inertia_disk)
%</part1>




%<*part2>
% ITD parameters
a = 
L = 

% Define ITD model
s = tf('s');
ITD_inertia_disk = a/(L*s)*exp(-s*L);

% Simulate system response to a step input
step(ITD_inertia_disk)


%</part2>

