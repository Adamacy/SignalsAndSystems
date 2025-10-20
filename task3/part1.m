%% Class Exercise: Normal Distribution Sampling and Estimation

% Clear environment
clc;
clear;
close all;

%% Initial Parameters
mu_x = -4.2;    % True mean
sigma_x = 2.3;  % True standard deviation
N = 20;         % Number of samples
num_bins = 10;
value_range = [-15, 5];

%% Generate 20 Samples
% Generate N samples from N(mu_x, sigma_x^2)
% randn(N, 1) gives N(0, 1), so we scale and shift:
x_raw = mu_x + sigma_x * randn(N, 1);

%% a. Filter samples and plot histogram
% Discard samples outside the range [-15, 5)
x_filtered = x_raw(x_raw >= value_range(1) & x_raw < value_range(2));

% Get the actual number of samples used
N_filtered = length(x_filtered);
disp(['Initial N=20, Samples after filtering: ', num2str(N_filtered)]);

% Create the figure
figure;
hold on; % Hold the plot for adding PDFs

%% b. Compute empirical estimates
% Treat the distribution as unknown, using only the filtered samples
mu_hat_x = mean(x_filtered);
sigma_hat_x = std(x_filtered); % Sample standard deviation (N-1 denominator)

% Display results
disp('--- Analysis for N=20 ---');
disp(['True Mean (mu_x):       ', num2str(mu_x)]);
disp(['Estimated Mean (mu_hat_x): ', num2str(mu_hat_x)]);
disp(['True Std (sigma_x):     ', num2str(sigma_x)]);
disp(['Estimated Std (sigma_hat_x): ', num2str(sigma_hat_x)]);

%% e. Normalize the histogram
% We do this before plotting the PDFs.
% 'Normalization', 'pdf' makes the area of the histogram sum to 1.
h = histogram(x_filtered, num_bins, 'Normalization', 'pdf');

%% c. Draw PDF with estimated parameters
% Create a range of x-values for plotting the smooth PDF curves
x_values = linspace(value_range(1), value_range(2), 200);

% Calculate the PDF using estimated parameters
pdf_estimated = normpdf(x_values, mu_hat_x, sigma_hat_x);
plot(x_values, pdf_estimated, 'g--', 'LineWidth', 2);

%% d. Draw PDF with true parameters
% Calculate the PDF using true parameters
pdf_true = normpdf(x_values, mu_x, sigma_x);
plot(x_values, pdf_true, 'r-', 'LineWidth', 2);

%% Finalize the N=20 plot
title(['Normalized Histogram (N=', num2str(N_filtered), ') vs. PDFs']);
xlabel('Signal Value');
ylabel('Probability Density');
legend('Normalized Histogram (Data)', ...
       ['Est. PDF (\mu_h=' num2str(mu_hat_x, '%.2f') ', \sigma_h=' num2str(sigma_hat_x, '%.2f') ')'], ...
       ['True PDF (\mu=' num2str(mu_x) ', \sigma=' num2str(sigma_x) ')']);
grid on;
hold off;

%% f. Experiment with increasing N and number of bins

% --- New Parameters ---
N_large = 10000;
num_bins_large = 50; % Increase bins to see finer detail

% --- Generate and Filter ---
x_raw_large = mu_x + sigma_x * randn(N_large, 1);
x_filtered_large = x_raw_large(x_raw_large >= value_range(1) & x_raw_large < value_range(2));
N_filtered_large = length(x_filtered_large);

% --- (b) Compute Estimates ---
mu_hat_x_large = mean(x_filtered_large);
sigma_hat_x_large = std(x_filtered_large);

% Display results
disp(' '); % Add a space
disp(['--- Analysis for N=', num2str(N_large), ' ---']);
disp(['Samples after filtering: ', num2str(N_filtered_large)]);
disp(['True Mean (mu_x):       ', num2str(mu_x)]);
disp(['Estimated Mean (mu_hat_x): ', num2str(mu_hat_x_large)]);
disp(['True Std (sigma_x):     ', num2str(sigma_x)]);
disp(['Estimated Std (sigma_hat_x): ', num2str(sigma_hat_x_large)]);

% --- (a, c, d, e) Plot ---
figure;
hold on;
% (a, e) Normalized histogram
histogram(x_filtered_large, num_bins_large, 'Normalization', 'pdf');

% (c) Estimated PDF
pdf_estimated_large = normpdf(x_values, mu_hat_x_large, sigma_hat_x_large);
plot(x_values, pdf_estimated_large, 'g--', 'LineWidth', 2);

% (d) True PDF
% pdf_true is the same as before
plot(x_values, pdf_true, 'r-', 'LineWidth', 2);

% --- Finalize the N=10000 plot ---
title(['Normalized Histogram (N=', num2str(N_filtered_large), ') vs. PDFs']);
xlabel('Signal Value');
ylabel('Probability Density');
legend('Normalized Histogram (Data)', ...
       ['Est. PDF (\mu_h=' num2str(mu_hat_x_large, '%.2f') ', \sigma_h=' num2str(sigma_hat_x_large, '%.2f') ')'], ...
       ['True PDF (\mu=' num2str(mu_x) ', \sigma=' num2str(sigma_x) ')']);
grid on;
hold off;