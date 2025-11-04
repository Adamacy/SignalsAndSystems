% compute_phase.m
%
% Solves the phase detection problem using quadrature demodulation
% (cross-correlation with sin and cos at lag 0).
%
% ASSUMES the file 'unsynchronized_signals.mat' exists.
% (Run 'create_phase_data.m' first if it does not)

clear;
clc;

fprintf('--- Problem 2: Phase Detection ---\n\n');

% --- Load Data ---
try
    load('unsynchronized_signals.mat');
catch
    fprintf('Error: Could not load unsynchronized_signals.mat\n');
    fprintf('Please run create_phase_data.m first.\n');
    return;
end

% --- Theoretical Questions ---
%
% Let y(t) = cos(2*pi*f*t) (reference)
% Let x(t) = A*cos(2*pi*f*t + phi) (received signal)
%
% Q: Compute equation for the value of Ryx(0) of cross-correlation
%    ... for a normalized (divided by the number of samples)
%    cross-correlation...
%
% A: The normalized cross-correlation at lag 0 is:
%    Ryx(0) = (1/N) * sum[n=0 to N-1] ( y(n) * x(n) )
%    Ryx(0) = (1/N) * sum[ cos(2*pi*f*t) * A*cos(2*pi*f*t + phi) ]
%
%    Using the identity cos(a)cos(b) = 1/2 * [cos(a-b) + cos(a+b)]:
%    Let a = 2*pi*f*t + phi and b = 2*pi*f*t
%    a-b = phi
%    a+b = 4*pi*f*t + phi
%
%    Ryx(0) = (1/N) * sum[ A/2 * (cos(phi) + cos(4*pi*f*t + phi)) ]
%    Ryx(0) = (A/2) * (1/N) * sum[cos(phi)] + (A/2) * (1/N) * sum[cos(4*pi*f*t + phi)]
%
%    The first term is the average of a constant: (1/N) * N * cos(phi) = cos(phi)
%    The second term is the average of a cosine wave at frequency 2f.
%
% Q: What is the value of Ryx(0) when the number of samples goes to infinity?
% A: As N -> infinity (or just over a few full periods), the average of
%    the 2f term (cos(4*pi*f*t + phi)) goes to 0.
%    Therefore, the equation simplifies to:
%
%      Ryx(0) = (A/2) * cos(phi)
%
% Q: How to use the calculated value to compute A and phi? Is it
%    sufficient to use cross-correlation with cos(2*pi*f*t) only?
%
% A: No, it is not sufficient. We have one equation, C = Ryx(0) = (A/2)*cos(phi),
%    but two unknowns (A and phi).
%
%    To solve this, we must introduce a second reference signal that is
%    90 degrees out of phase: the "quadrature" signal.
%
%    Let z(t) = sin(2*pi*f*t)
%
%    Now we compute Rzx(0) = (1/N) * sum[ sin(2*pi*f*t) * A*cos(2*pi*f*t + phi) ]
%    Using sin(a)cos(b) = 1/2 * [sin(a-b) + sin(a+b)]:
%    Let a = 2*pi*f*t and b = 2*pi*f*t + phi
%    a-b = -phi
%    a+b = 4*pi*f*t + phi
%
%    Rzx(0) = (1/N) * sum[ A/2 * (sin(-phi) + sin(4*pi*f*t + phi)) ]
%    Since sin(-phi) = -sin(phi), and the 2f term averages to 0:
%
%      Rzx(0) = -(A/2) * sin(phi)
%
%    Now we have a system of 2 equations:
%    1) C = Ryx(0) = (A/2) * cos(phi)
%    2) S_prime = Rzx(0) = -(A/2) * sin(phi)
%
%    Let S = -S_prime = (A/2) * sin(phi).
%
%    We can solve for phi using atan2 (which correctly handles all quadrants):
%    S / C = ( (A/2) * sin(phi) ) / ( (A/2) * cos(phi) ) = tan(phi)
%
%      phi = atan2(S, C)  =  atan2(-Rzx(0), Ryx(0))
%
%    We can solve for A by squaring and adding:
%    C^2 + S^2 = (A/2)^2 * cos^2(phi) + (A/2)^2 * sin^2(phi) = (A/2)^2
%
%      A = 2 * sqrt( C^2 + S^2 ) = 2 * sqrt( Ryx(0)^2 + (-Rzx(0))^2 )
%

% --- MATLAB Implementation ---

[num_signals, N] = size(rx_signals);
t = (0:N-1)' / fs; % Time vector (as column)

% 1. Generate reference signals
y_ref_cos = cos(2*pi*f_signal*t);
z_ref_sin = sin(2*pi*f_signal*t);

% 2. Initialize result arrays
calculated_A = zeros(num_signals, 1);
calculated_phi_rad = zeros(num_signals, 1);

% 3. Process each signal
for i = 1:num_signals
    % Get the i-th signal as a column vector
    x = rx_signals(i, :)';
    
    % Compute C = Ryx(0)
    % (1/N) * (y_ref_cos' * x) is the normalized dot product
    C = (1/N) * (y_ref_cos' * x);
    
    % Compute S_prime = Rzx(0)
    S_prime = (1/N) * (z_ref_sin' * x);
    
    % We need S = (A/2)*sin(phi), which is -S_prime
    S = -S_prime;
    
    % Solve for Amplitude (A)
    calculated_A(i) = 2 * sqrt(C^2 + S^2);
    
    % Solve for Phase (phi)
    calculated_phi_rad(i) = atan2(S, C);
end

% Convert phase to degrees for easier reading
calculated_phi_deg = rad2deg(calculated_phi_rad);

% 4. Display results
fprintf('--- Calculated Amplitudes and Phases ---\n');
results_table = table((1:num_signals)', calculated_A, calculated_phi_deg, ...
    'VariableNames', {'Signal', 'Amplitude_A', 'Phase_degrees'});

disp(results_table);

