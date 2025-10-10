close all;
clear all;
clc;
sawtooth_form_factor = 2/sqrt(3);
sawtooth_arv = 2.5599;


rms = sawtooth_form_factor * sawtooth_arv;
disp("Rms value is = " + rms);

disp("This method will work with other signals if we know the form factor which " + ...
    "is known becuse it doesn't change with amplitude or frequency. For example " + ...
    "the form factor of sine wave is 1.11 if we apply it to our formula it will give as" + ...
    "the correct results.")
disp("in example of sine wave it is better to use π/2√2 because in computer " + ...
    "calculation it's more accurate than writing 1.11")