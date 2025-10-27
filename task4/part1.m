filename = 'lotto.csv';
delimiter = ';';
try
    data = dlmread(filename, delimiter);
catch
    data = readmatrix(filename, 'Delimiter', delimiter);
end

numbers = data(:, 5:10);

all_numbers = numbers(:);

figure;
histogram(all_numbers, 'BinMethod', 'integers', 'Normalization', 'count');
title('Overall Frequency of Each Lotto Number');
xlabel('Lotto Number');
ylabel('Total Times Drawn');

xlim([0 50]);
grid on;

years = data(:, 4);
median_year = median(years);


early_indices = (years <= median_year);
late_indices = (years > median_year);

early_numbers = data(early_indices, 5:10);
late_numbers = data(late_indices, 5:10);

all_early_numbers = early_numbers(:);
all_late_numbers = late_numbers(:);

figure;

subplot(2, 1, 1);
histogram(all_early_numbers, 'BinMethod', 'integers', 'Normalization', 'probability');
title(['Early Period (<= ' num2str(median_year) ')']);
xlabel('Lotto Number');
ylabel('Proportion');
xlim([0 50]);
grid on;

subplot(2, 1, 2);
histogram(all_late_numbers, 'BinMethod', 'integers', 'Normalization', 'probability');
title(['Late Period (> ' num2str(median_year) ')']);
xlabel('Lotto Number');
ylabel('Proportion');
xlim([0 50]);
grid on;