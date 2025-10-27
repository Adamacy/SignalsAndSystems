close all;
clear all;
clc;

v = load("u.dat");

R = 0.01;

p_inst = v.^2 / R;
P_avg_total = mean(p_inst);
plot(v);
disp("The average power of the signal is: " + P_avg_total + "W");

num_samples = length(v);
window_fraction = 0.10 * num_samples;

k_round = round(0.10 * num_samples);
p_avg_moving_round = movmean(p_inst, k_round);
P_max = max(p_avg_moving_round);

%hold on;
%figure;
%
% plot(p_avg_moving_round)

disp("The maximum power for 10% of the signal is: " + P_max + "W");

