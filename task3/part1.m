clc;
clear;
close all;

mu_x = -4.2;
sigma_x = 2.3;  
N = 20;         
num_bins = 10;
value_range = [-15, 5];

x_raw = mu_x + sigma_x * randn(N, 1);

x_filtered = x_raw(x_raw >= value_range(1) & x_raw < value_range(2));

N_filtered = length(x_filtered);

figure;
hold on;

mu_est_x = mean(x_filtered);
sigma_est_x = std(x_filtered);

disp('--- Analysis for N=20 ---');
disp(['True Mean (mu_x):       ', num2str(mu_x)]);
disp(['Estimated Mean (mu_hat_x): ', num2str(mu_est_x)]);
disp(['True Std (sigma_x):     ', num2str(sigma_x)]);
disp(['Estimated Std (sigma_hat_x): ', num2str(sigma_est_x)]);


h = histogram(x_filtered, num_bins, 'Normalization', 'pdf');

x_values = linspace(value_range(1), value_range(2));

pdf_estimated = normpdf(x_values, mu_est_x, sigma_est_x);
plot(x_values, pdf_estimated, 'g--', 'LineWidth', 2);

pdf_true = normpdf(x_values, mu_x, sigma_x);
plot(x_values, pdf_true, 'r-', 'LineWidth', 2);

title(['Normalized Histogram (N=', num2str(N_filtered), ') vs. PDFs']);
xlabel('Signal Value');
ylabel('Probability Density');
legend('Normalized Histogram (Data)', ...
       ['Est. PDF (\mu_h=' num2str(mu_est_x, '%.2f') ', \sigma_h=' num2str(sigma_est_x, '%.2f') ')'], ...
       ['True PDF (\mu=' num2str(mu_x) ', \sigma=' num2str(sigma_x) ')']);
grid on;
hold off;

N_large = 10000;
num_bins_large = 50;

x_raw_large = mu_x + sigma_x * randn(N_large, 1);
x_filtered_large = x_raw_large(x_raw_large >= value_range(1) & x_raw_large < value_range(2));
N_filtered_large = length(x_filtered_large);

mu_est_x_large = mean(x_filtered_large);
sigma_hat_x_large = std(x_filtered_large);


disp(' ');
disp(['--- Analysis for N=', num2str(N_large), ' ---']);
disp(['Samples after filtering: ', num2str(N_filtered_large)]);
disp(['True Mean (mu_x):       ', num2str(mu_x)]);
disp(['Estimated Mean (mu_hat_x): ', num2str(mu_est_x_large)]);
disp(['True Std (sigma_x):     ', num2str(sigma_x)]);
disp(['Estimated Std (sigma_hat_x): ', num2str(sigma_hat_x_large)]);


figure;
hold on;

histogram(x_filtered_large, num_bins_large, 'Normalization', 'pdf');


pdf_estimated_large = normpdf(x_values, mu_est_x_large, sigma_hat_x_large);
plot(x_values, pdf_estimated_large, 'g--', 'LineWidth', 2);

plot(x_values, pdf_true, 'r-', 'LineWidth', 2);

title(['Normalized Histogram (N=', num2str(N_filtered_large), ') vs. PDFs']);
xlabel('Signal Value');
ylabel('Probability Density');
legend('Normalized Histogram (Data)', ...
       ['Est. PDF (\mu_h=' num2str(mu_est_x_large, '%.2f') ', \sigma_h=' num2str(sigma_hat_x_large, '%.2f') ')'], ...
       ['True PDF (\mu=' num2str(mu_x) ', \sigma=' num2str(sigma_x) ')']);
grid on;
hold off;