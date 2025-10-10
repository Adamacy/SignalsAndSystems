close all;
clear all;
clc;

data = load("signal.mat");
x = data.t_and_s(:, 1);
y = data.t_and_s(:, 2);
plot(x, y)

x_min = min(x);
x_max = max(x);

x_norm = 2 * ((x - x_min) / (x_max - x_min)) - 1;

hold on

plot(x_norm, y);

save("signal-norm.mat", "x_norm", "y");