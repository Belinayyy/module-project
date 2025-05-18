%% THE FIRST CODE
% LED control simulation with voice recording

% Adjustment of voice recording
fs = 44100;        % sample frequency CD format
sec = 3;          % recording time(second)

rec = audiorecorder(fs, 8, 1); % 8-bit mono recording

disp('3-second voice being recorded...');
recordblocking(rec, sec);
disp('Recording completed!');

% Take the data
data = getaudiodata(rec);

% Sound amplification (gain)
gain = 8;
data_high = gain * data;

% Average sound power calculation
avg = mean(abs(data_high));

% To define threshold
threshold = 0.1;

% LED control
if avg > threshold
    status = 'LED ON';
else
    status = 'LED OFF';
end

% To print results
fprintf('Average sound intensity: %.2f\n', avg);
fprintf('LED status: %s\n', status);

% Plotting
time = linspace(0, sec, length(data));
plot(time, data_high, 'g');
hold on;
yline(threshold, 'r--');
xlabel('Time (second)');
ylabel('Amplitude');
title(['LED: ' status]);
legend('Signal', 'Threshold');

%% THE SECOND CODE
% LED Brightness vs Microphone Voltage and LED Current

% Constants
gain = 100;
Vf = 2;
R_led = 150;

% Microphone voltages: from loud (-50mV) to silence (0V)
mic_v = linspace(-0.05, 0, 500);  % in Volts

% Op-amp output: Vout = gain * (0 - mic_v)
vout = gain * -mic_v;

% Brightness model: only active if Vout > Vf
brightness = max(0, vout - Vf);

% LED current (only when Vout > Vf)
I_led = brightness / R_led;

% Plot 1: Brightness vs Mic Voltage
figure;
plot(mic_v * 1000, brightness, 'b', 'LineWidth', 2); hold on;
title('LED Brightness vs Microphone Voltage');
xlabel('Mic Voltage (mV)');
ylabel('LED Brightness');
grid on; grid minor;

% Plot 2: Brightness vs LED Current
figure;
plot(I_led * 1000, brightness, 'm', 'LineWidth', 2); hold on;
title('LED Brightness vs LED Current');
xlabel('LED Current (mA)');
ylabel('LED Brightness');
grid on; grid minor;

% Info box
disp('Simulation Info:');
disp(['Gain = ', num2str(gain)]);
disp(['LED turns on after ', num2str(Vf), ' V']);
disp(['Brightness = Vout - Vf (if Vout > Vf)']);