%% Main Neurosynth Driver

clc; clear; close all;

clear sound;


%% Load an audio sample

[input,fs] = audioread('floaty-sad.wav');
%[input,fs] = audioread('cortege.wav');
%[input,fs] = audioread('winters tale.wav');

% Since file is mono keep the left channel
input = input(:,1);

% Keep only the first few seconds
%stop_time = 20;
%stop_idx = fs*stop_time;
%v = v(1:stop_idx);

figure;
dt = 1/fs;
t = 0:dt:(length(input)*dt)-dt;
plot(t,input); xlabel('Seconds'); ylabel('Amplitude');
grid on;
grid minor

%% Process the audio with an MLP

% ------------------------------------------------------------------------
% User controllable parameters
% ------------------------------------------------------------------------

% Vibrato Frequencies
f_trem_1 = 3;
f_trem_2 = 5;
f_trem_3 = 7;

% Vibrato depths
d1 = 1;
d2 = 1;
d3 = 1;

% Biases
b1 = 1;
b2 = 1;

%     bias1-layer2 layer1.1-layer2   layer1.2-layer2  layer1.3-layer2
w1 = [0            1                 0.1              1;
      0            1                 10               1;
      0            0.1               5                1];

%     bias2-output layer2.1-output  layer2.2-output  layer2.3-output
w2 = [0            3                 1                5];
% ------------------------------------------------------------------------

% ------------------------------------------------------------------------
% Internal Design
% ------------------------------------------------------------------------

% Split the audio signal into three channels
x11 = input';
x12 = input';
x13 = input';

% Run each channel through a filter
filter_order = 1;

fc1    = 300;  % Cut off frequency for channel 1 lowpass
fc2_lo = 250;  % Cut off frequency for low side of channel 2 bandpass 
fc2_hi = 2000; % Cut off frequency for high side of channel 2 bandpass
fc3    = 1000; % Cut off frequency for channel 2 highpass

[butter_b1, butter_a1]       = butter(filter_order, fc1/(fs/2));
[butter_b2_lo, butter_a2_lo] = butter(filter_order, fc2_lo/(fs/2));
[butter_b2_hi, butter_a2_hi] = butter(filter_order, fc2_hi/(fs/2), 'high');
[butter_b3, butter_a3]       = butter(filter_order, fc3/(fs/2), 'high');

x11 = filter(butter_b1, butter_a1, x11);
x12 = filter(butter_b2_lo, butter_a2_lo, x12);
x12 = filter(butter_b2_hi, butter_a2_hi, x12);
x13 = filter(butter_b3, butter_a3, x13);

f_plot_span = logspace(1,4,200);
figure;
freqz(butter_b1, butter_a1, f_plot_span, fs);
hold on;
freqz(butter_b2_lo, butter_a2_lo, f_plot_span, fs);
freqz(butter_b2_hi, butter_a2_hi, f_plot_span, fs);
freqz(butter_b3, butter_a3, f_plot_span, fs);
title('Filter Design');

% Set up the LFOs
time = 1:length(input);
time = time./fs;

a1 = d1*(0.5*sin(2*pi*f_trem_1*time) + 0.5) + 1 - d1;
a2 = d2*(0.5*sin(2*pi*f_trem_2*time) + 0.5) + 1 - d2;
a3 = d3*(0.5*sin(2*pi*f_trem_3*time) + 0.5) + 1 - d3;

figure; plot(time, a1, 'b'); hold on; plot(time, a2, 'r'); plot(time, a3, 'g');
grid on; grid minor; title('Vibrato Design'); xlabel('Time (s)'); ylabel('Amplitude');

% Apply the tremelos - pre MLP
x11 = a1.*x11;
x12 = a2.*x12;
x13 = a3.*x13;

x1 = [x11; x12; x13];

[~,N] = size(x1);

% MLP Layer 1
x1 = [b1*ones(1,N); x1];
v1 = w1*x1;
y1 = tanh(v1);

% MLP Layer 2
x2 = [b2*ones(1,N); y1];

% Apply the tremelos - post MLP
x2(2,:) = a1.*x2(2,:);
x2(3,:) = a2.*x2(3,:);
x2(4,:) = a3.*x2(4,:);

v2 = w2*x2;
%y = tanh(v2);

% Divide by 3 to bring gain back down
output = tanh(v2./3);

sound(output,fs);
%sound(input,fs);
