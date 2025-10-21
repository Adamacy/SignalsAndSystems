close all;
clear all;
clc;

function y_normalized = normalize(y)
    y_min = min(y);
    y_max = max(y);
    y_normalized = 2 * ((y - y_min) / (y_max - y_min)) - 1;
end

data = load("signal.mat");
x = data.t_and_s(:, 1);
y = data.t_and_s(:, 2);
plot(x, y)

y_norm = normalize(y);

hold on

plot(x, y_norm);

save("signal-norm.mat", "x", "y_norm");