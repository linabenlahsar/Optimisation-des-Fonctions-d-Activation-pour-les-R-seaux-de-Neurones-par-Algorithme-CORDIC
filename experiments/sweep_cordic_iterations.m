%SWEEP_CORDIC_ITERATIONS Measure CORDIC accuracy vs iteration count.

root_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(root_dir, 'src'));

x = linspace(-4, 4, 4001);
reference = tanh(x);
iteration_counts = 4:2:20;

mse_values = zeros(size(iteration_counts));
max_error_values = zeros(size(iteration_counts));

for index = 1:numel(iteration_counts)
    approximation = cordic_tanh(x, iteration_counts(index));
    metrics = error_metrics(approximation, reference);
    mse_values(index) = metrics.mse;
    max_error_values(index) = metrics.max_abs_error;
end

fprintf('\nCORDIC iteration sweep on [-4, 4]\n');
fprintf('%10s %14s %14s\n', 'Iterations', 'MSE', 'Max error');
for index = 1:numel(iteration_counts)
    fprintf('%10d %14.4e %14.4e\n', iteration_counts(index), ...
            mse_values(index), max_error_values(index));
end

figure('Name', 'CORDIC iteration sweep', 'Color', 'w');
semilogy(iteration_counts, mse_values, 'b-o', ...
         'LineWidth', 1.8, 'DisplayName', 'MSE');
hold on;
semilogy(iteration_counts, max_error_values, 'r-s', ...
         'LineWidth', 1.8, 'DisplayName', 'Maximum absolute error');
xline(16, 'k--', '16 iterations', 'LineWidth', 1.2);
grid on;
xlabel('Number of CORDIC iterations');
ylabel('Measured error');
title('Hyperbolic CORDIC convergence');
legend('Location', 'southwest');
