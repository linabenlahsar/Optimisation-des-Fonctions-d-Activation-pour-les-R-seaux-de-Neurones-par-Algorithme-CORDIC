%HYPERBOLIC_REPETITION_DEMO Measure the effect of repeated iterations.

root_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(root_dir, 'src'));

test_angle = 0.9;
iteration_counts = 1:20;
reference = tanh(test_angle);

error_without_repetitions = zeros(size(iteration_counts));
error_with_repetitions = zeros(size(iteration_counts));

for index = 1:numel(iteration_counts)
    n_iter = iteration_counts(index);

    without_repetitions = ...
        cordic_hyperbolic_core(test_angle, n_iter, false);
    with_repetitions = ...
        cordic_hyperbolic_core(test_angle, n_iter, true);

    error_without_repetitions(index) = ...
        abs(without_repetitions - reference);
    error_with_repetitions(index) = ...
        abs(with_repetitions - reference);
end

figure('Name', 'Hyperbolic repeated iterations', 'Color', 'w');
semilogy(iteration_counts, max(error_without_repetitions, eps), ...
         'r-o', 'LineWidth', 1.5, 'DisplayName', 'Without repetitions');
hold on;
semilogy(iteration_counts, max(error_with_repetitions, eps), ...
         'b-s', 'LineWidth', 1.5, 'DisplayName', 'With repetitions');
xline(4, 'k--', 'repeat 4');
xline(13, 'k--', 'repeat 13');
grid on;
xlabel('Highest iteration index');
ylabel('Absolute error at z = 0.9');
title('Why hyperbolic CORDIC repeats selected iterations');
legend('Location', 'southwest');
