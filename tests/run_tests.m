function run_tests
%RUN_TESTS Deterministic regression tests for the approximation functions.

    test_dir = fileparts(mfilename('fullpath'));
    root_dir = fileparts(test_dir);
    addpath(fullfile(root_dir, 'src'));

    x = linspace(-4, 4, 4001);
    reference = tanh(x);

    cordic_result = cordic_tanh(x, 16);
    cordic_metrics = error_metrics(cordic_result, reference);

    assert(all(isfinite(cordic_result)));
    assert(all(cordic_result >= -1 & cordic_result <= 1));
    assert(max(abs(cordic_result + fliplr(cordic_result))) < 1e-12);
    assert(cordic_metrics.mse < 2e-11);
    assert(cordic_metrics.max_abs_error < 2e-5);

    sigmoid_result = cordic_sigmoid(x, 16);
    sigmoid_reference = 1 ./ (1 + exp(-x));
    sigmoid_metrics = error_metrics(sigmoid_result, sigmoid_reference);

    assert(all(sigmoid_result >= 0 & sigmoid_result <= 1));
    assert(sigmoid_metrics.max_abs_error < 1e-5);

    lut_nearest = lut_tanh(x, 32, -4, 4, 'nearest');
    lut_linear = lut_tanh(x, 32, -4, 4, 'linear');
    nearest_metrics = error_metrics(lut_nearest, reference);
    linear_metrics = error_metrics(lut_linear, reference);

    assert(linear_metrics.mse < nearest_metrics.mse);

    local_x = linspace(-0.5, 0.5, 1001);
    order_3 = taylor_tanh(local_x, 3);
    order_7 = taylor_tanh(local_x, 7);
    order_3_metrics = error_metrics(order_3, tanh(local_x));
    order_7_metrics = error_metrics(order_7, tanh(local_x));

    assert(order_7_metrics.mse < order_3_metrics.mse);

    fprintf('All tests passed.\n');
    fprintf('CORDIC-16 MSE on [-4, 4]: %.4e\n', cordic_metrics.mse);
    fprintf('CORDIC-16 max error:       %.4e\n', ...
            cordic_metrics.max_abs_error);
end
