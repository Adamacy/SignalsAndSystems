close all;
clear all;
clc;
T = 0.005; % Sampling Period
t_end = 20;
t = 0 : T : t_end;
A = 2.5; % Amplitude
f = 1/10; %Hz
signal = A * sin(2*pi*f*t);

plot(t, signal);
xlabel("Time");
ylabel("sin(4pit)*2.5");
title("Sine wave");

hold on;

mu = 0;
sigma = 0.1;

noise = 0.1 * randn(size(signal));

x_noisy = signal + noise;

plot(t, x_noisy);
grid on;