% compute_distance.m
%
% Solves the range finder problem using cross-correlation to find time delay.
%
% Loads data from .dat files (tx_short.dat, rx_short.dat, rx_long.dat)

clear;
clc;

% --- Load Data ---
try
    % Load data from the .dat files provided in the course
    tx_signal_short = load('tx_short.dat');
    rx_signal_short = load('rx_short.dat');
    rx_signal_long  = load('rx_long.dat');
    
    % Manually define parameters from problem description
    fs = 1e6;       % 1 MHz sampling rate
    v_sound = 340;  % 340 m/s speed of sound
    
catch
    fprintf('Error: Could not load .dat files.\n');
    fprintf('Please make sure tx_short.dat, rx_short.dat, and rx_long.dat are in the same folder as this script.\n');
    return;
end

fprintf('--- Problem 1: Range Finder (using .dat files) ---\n\n');

% --- Theoretical Questions ---
%
% Q: How can you compute a time shift between two signals using cross-correlation?
% A: The cross-correlation function c(k) = xcorr(rx, tx) measures the
%    similarity between the received signal (rx) and a time-shifted
%    (lagged) version of the transmitted signal (tx). The lag 'k' at which
%    the cross-correlation function has its maximum absolute value
%    corresponds to the most likely time shift (in samples) between
%    the two signals. We use [c, lags] = xcorr(rx, tx) to get both the
%    correlation values and the corresponding sample lags.
%
% Q: How can you transform a time shift expressed in samples to a time
%    shift expressed in seconds?
% A: If the sampling rate is 'fs' (in samples/sec, or Hz), then the
%    sampling period (time per sample) is Ts = 1/fs.
%    To convert a shift of 'sample_shift' samples to 'time_shift' seconds:
%
%      time_shift = sample_shift / fs
%
% Q: How can you compute a distance to the object knowing the time it
%    took the signal to travel from the sensor to the object and back?
% A: The 'time_shift' calculated from cross-correlation is the
%    Round-Trip Time (RTT). The signal travels to the object (distance 'd')
%    and back (distance 'd'), for a total distance of '2d'.
%    Given the speed of sound 'v_sound':
%
%      Total_Distance = Speed * Total_Time
%      2 * d = v_sound * time_shift
%
%    Solving for 'd', we get:
%
%      d = (v_sound * time_shift) / 2
%

% --- Part 1: Short Signal (One Period) ---
fprintf('--- Analyzing Short Signal ---\n');

% Compute cross-correlation
% 'tx_signal_short' is our template (what we sent)
% 'rx_signal_short' is what we received
[c_short, lags_short] = xcorr(rx_signal_short, tx_signal_short);

% Find the lag corresponding to the maximum correlation
[~, max_idx] = max(abs(c_short));
sample_shift_short = lags_short(max_idx);

% Convert sample shift to time shift
time_shift_short = sample_shift_short / fs;

% Convert time shift to distance
distance_short = (v_sound * time_shift_short) / 2;

fprintf('Sample shift: %d samples\n', sample_shift_short);
fprintf('Time shift:     %.6f seconds\n', time_shift_short);
fprintf('Calculated distance: %.3f m\n', distance_short);
fprintf('(Expected: 0.34 m)\n\n');

% --- Part 2: Long Signal (Multiple Periods / Reflections) ---
fprintf('--- Analyzing Long Signal ---\n');

% Q: How can you handle multiple periods of the signal? If you
%    cross-correlate the whole signals will there be one distinct maximum
%    or multiple ones? How can you separate periods?
%
% A: If the transmitted signal has 10 periods and the received signal also
%    has 10 periods (from one reflection), cross-correlating them will
%    produce a large correlation region with many peaks, making it hard to
%    find the *exact* start.
%
%    A much better method (which also handles multiple *reflections*) is
%    to use the SHORT signal (one period) as a "matched filter" or
%    "template". We cross-correlate this short template against the LONG
%    received signal.
%
%    This will produce a distinct peak in the correlation output for *every*
%    reflection of the template found in the received signal. We can then
%    find all these peaks to identify all the reflections.
%
%    We use the 'findpeaks' function for this.

% Cross-correlate the long *received* signal with the short *transmitted* template
[c_long, lags_long] = xcorr(rx_signal_long, tx_signal_short);

% Use findpeaks to find all significant peaks
% 'MinPeakHeight': Ignore peaks smaller than 30% of the max (filters noise)
% 'MinPeakDistance': Peaks must be at least 150 samples apart (prevents
%                    finding multiple peaks for the same pulse)
[pks, locs] = findpeaks(abs(c_long), ...
                        'MinPeakHeight', 0.3 * max(abs(c_long)), ...
                        'MinPeakDistance', 150);

% Get the sample shifts from the peak locations
sample_shifts_long = lags_long(locs);

% Convert sample shifts to time shifts
time_shifts_long = sample_shifts_long / fs;

% Convert time shifts to distances
distances_long = (v_sound * time_shifts_long) / 2;

fprintf('Detected %d reflections.\n', length(distances_long));
fprintf('Calculated distances (m):\n');
% Display as a row vector
disp(distances_long');
fprintf('(Expected: 0.340 m, 0.374 m, ... , 0.646 m)\n');

% --- Plotting Results (Optional) ---
figure('Name', 'Range Finder Analysis');

% Plot Short Signal Analysis
subplot(2, 1, 1);
plot(lags_short, abs(c_short));
hold on;
plot(sample_shift_short, abs(c_short(max_idx)), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
hold off;
title(sprintf('Short Signal Cross-Correlation (Peak at %d samples)', sample_shift_short));
xlabel('Lag (samples)');
ylabel('Absolute Correlation');
grid on;

% Plot Long Signal Analysis
subplot(2, 1, 2);
plot(lags_long, abs(c_long));
hold on;
plot(lags_long(locs), pks, 'rv', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
hold off;
title(sprintf('Long Signal Cross-Correlation (Found %d peaks)', length(locs)));
xlabel('Lag (samples)');
ylabel('Absolute Correlation');
grid on;


