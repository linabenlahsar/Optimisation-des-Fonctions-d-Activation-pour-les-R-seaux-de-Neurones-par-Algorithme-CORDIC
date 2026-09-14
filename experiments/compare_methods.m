%COMPARE_METHODS Compare CORDIC, LUT, and Taylor approximations.

root_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(root_dir, 'src'));

x = linspace(-4, 4, 4001);
reference = tanh(x);

names = {'CORDIC (16 iterations)', ...
         'LUT (32, nearest)', ...
         'LUT (16, linear)', ...
         'Taylor (order 7)'};

approximations = {
    cordic_tanh(x, 16), ...
    lut_tanh(x, 32, -4, 4, 'nearest'), ...
    lut_tanh(x, 16, -4, 4, 'linear'), ...
    taylor_tanh(x, 7)
};

fprintf('\nApproximation metrics on [-4, 4]\n');
fprintf('%-25s %12s %12s %12s\n', 'Method', 'MSE', 'MAE', 'Max error');

figure('Name', 'Activation approximation comparison', 'Color', 'w');

subplot(1, 2, 1);
plot(x, reference, 'k-', 'LineWidth', 2, 'DisplayName', 'Reference');
hold on;
plot(x, approximations{1}, 'b--', 'LineWidth', 1.5, ...
     'DisplayName', names{1});
plot(x, approximations{2}, 'r-.', 'LineWidth', 1.2, ...
     'DisplayName', names{2});
plot(x, approximations{3}, 'g:', 'LineWidth', 1.5, ...
     'DisplayName', names{3});
grid on;
xlim([-4, 4]);
ylim([-1.1, 1.1]);
xlabel('x');
ylabel('tanh(x)');
title('Reference and bounded approximations');
legend('Location', 'southeast');

subplot(1, 2, 2);
hold on;
for method_index = 1:numel(approximations)
    metrics = error_metrics(approximations{method_index}, reference);
    fprintf('%-25s %12.4e %12.4e %12.4e\n', ...
            names{method_index}, metrics.mse, metrics.mae, ...
            metrics.max_abs_error);

    absolute_error = abs(approximations{method_index} - reference);
    semilogy(x, max(absolute_error, eps), 'LineWidth', 1.5, ...
             'DisplayName', names{method_index});
end
grid on;
xlim([-4, 4]);
xlabel('x');
ylabel('Absolute error');
title('Measured approximation error');
legend('Location', 'northwest');
