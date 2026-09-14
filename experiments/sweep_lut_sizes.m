%SWEEP_LUT_SIZES Measure accuracy vs LUT size and interpolation method.

root_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(root_dir, 'src'));

x = linspace(-4, 4, 4001);
reference = tanh(x);
entry_counts = [16, 32, 64, 128, 256];

nearest_mse = zeros(size(entry_counts));
linear_mse = zeros(size(entry_counts));

for index = 1:numel(entry_counts)
    nearest = lut_tanh(x, entry_counts(index), -4, 4, 'nearest');
    linear = lut_tanh(x, entry_counts(index), -4, 4, 'linear');

    nearest_metrics = error_metrics(nearest, reference);
    linear_metrics = error_metrics(linear, reference);

    nearest_mse(index) = nearest_metrics.mse;
    linear_mse(index) = linear_metrics.mse;
end

fprintf('\nLUT size sweep on [-4, 4]\n');
fprintf('%8s %16s %16s %12s\n', ...
        'Entries', 'Nearest MSE', 'Linear MSE', 'MSE ratio');
for index = 1:numel(entry_counts)
    fprintf('%8d %16.4e %16.4e %12.2f\n', ...
            entry_counts(index), nearest_mse(index), linear_mse(index), ...
            nearest_mse(index) / linear_mse(index));
end

figure('Name', 'LUT size sweep', 'Color', 'w');
loglog(entry_counts, nearest_mse, 'r-o', ...
       'LineWidth', 1.8, 'DisplayName', 'Nearest neighbour');
hold on;
loglog(entry_counts, linear_mse, 'b-s', ...
       'LineWidth', 1.8, 'DisplayName', 'Linear interpolation');
grid on;
xlabel('Number of LUT entries');
ylabel('MSE');
title('LUT accuracy and memory trade-off');
legend('Location', 'southwest');
