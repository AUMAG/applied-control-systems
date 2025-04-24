
%<*part1>
% Plot Bode, Nyquist and Nichols 
myTF = tf(<NUMERATOR>, <DENOMINATOR>)
BoFig = figure; bode(myTF); grid on;
NyFig = figure; nyquist(myTF); grid on;
NiFig = figure; nichols(myTF); grid on;
%</part1>


%<*part2>
%Code to plot the Bode, Nyquist, and Nichols charts
ModelName = '<INSERT NAME OF SIMULINK MODEL HERE>';
FreqRange = <INSERT VECTOR OF FREQUENCIES HERE>;
for i = 1:length(FreqRange)
	Freq_i = FreqRange(i)
	% Run Simulation
	set_param(gcs,'SimulationCommand','start') 
	% Pause script to allow simulation to run
	pause(11)
	% Extract data (excluding 1st half transient effects)
	outputData = <NAME OF OUTPUT SIGNAL>.signals.values;
	inputData = <NAME OF INPUT SIGNAL>.signals.values;
   	% Calculate amplitude:
   	pks = findpeaks(outputData);
    	trphs = -findpeaks(-outputData);
    	amp(i) = (median(pks)-median(trphs))/2;
    	ampdB(i) = mag2db(amp(i));
%</part2>
%<*part3>
    % Calculate phase (using cross correlation)
    [Corr, phi] = xcorr(outputData,inputData);
    [~, maxi] = max(Corr); % index of maximum correlation
    T = 2*pi/Freq_i;
    phaseOffset = -(2*pi*phi(maxi)*ts/T); % phase difference (rad)
    phaseOffset = mod(phaseOffset,2*pi)-2*pi; % modulo phase 
    phase(i) = phaseOffset*180/pi; % convert to degrees
end

% Replot Bode
BoFig = figure;
omega = logspace(0,2,101);
[m,p] = bode(myTF,omega);
subplot(2,1,1);
semilogx(omega,mag2db(m(:)));
grid on;
subplot(2,1,2);
semilogx(omega,p(:));
grid on;

% Plotting results 
figure(BoFig); subplot(2,1,1); hold on; semilogx(<FREQUENCY>,<MAGNITUDE>,'ro');
figure(BoFig); subplot(2,1,2); hold on; semilogx(<FREQUENCY>,<PHASE>,'ro');
figure(NyFig); hold on; plot(<REAL PART>,<IMAGINARY PART>,'ro');
figure(NiFig); hold on; plot(<PHASE>,<MAGNITUDE>,'ro');

%</part3>

