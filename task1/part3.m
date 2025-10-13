close all;
clear all;
clc;

data = load("signal.mat");
x = data.t_and_s(:, 1);
y = data.t_and_s(:, 2);
plot(x, y)

y_min = min(y);
y_max = max(y);
y_norm = 2 * ((y - y_min) / (y_max - y_min)) - 1;

hold on

plot(x, y_norm);

save("signal-norm.mat", "x_norm", "y");