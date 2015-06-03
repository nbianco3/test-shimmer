filepath = 'C:\Users\Nick\Documents\Parkinson Mobility Study\Data\BicepEMG.dat';
[sensorNamesCellArray, signalNamesCellArray, formatNamesCellArray, signalUnitsCellArray, sensorDataArray] = loadshimd(filepath);
time = (sensorDataArray(:,1)-sensorDataArray(1,1))/1000;
signal = sensorDataArray(:,2);
Fs = 1024;

%% Noise Analysis
figure(1)
plot(signal)
[x,~] = ginput(2);

L = length(signal(x(1):x(2)));
y = signal(x(1):x(2));

NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.
figure(2)
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Noise')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')

%% Signal Analysis
figure(3)
plot(signal)
[x,~] = ginput(2);

L = length(signal(x(1):x(2)));
y = signal(x(1):x(2));

NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.
figure(4)
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Signal')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')