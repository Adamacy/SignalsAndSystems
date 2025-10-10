close all;
clear all;
clc;
function kff = calculateKff(signal)
     rms_value = rms(signal);
     
    arv = mean(abs(signal));
    disp(arv)
    if arv == 0
        kff = 0; 
    else
        kff = rms_value / arv;
    end
end

y = load("form.dat");
plot(y);

kff = calculateKff(y);

figure;

t = 0 : 0.00001 : 2;
f = 5;
A = 5.12;

bipolar_wave = sawtooth(2 * pi * f * t);
unipolar_sawtooth = A * (bipolar_wave + 1) / 2;

kff_sawtooth = calculateKff(unipolar_sawtooth);

disp("Custom signal Form Factor: " + kff);
disp("Sawtooth signal Form Factor: " + kff_sawtooth);
disp("Difference in Form Factor between two signals");
disp(kff_sawtooth - kff);

disp("The tolerance of both signals are so small that Form Factor is almost the same");
disp("The change in amplitude or frequency doesn't change the Form Factor because " + ...
    "it's more likely to show the waveform shape rather than magnitiude or peaks");

plot(t, unipolar_sawtooth);
