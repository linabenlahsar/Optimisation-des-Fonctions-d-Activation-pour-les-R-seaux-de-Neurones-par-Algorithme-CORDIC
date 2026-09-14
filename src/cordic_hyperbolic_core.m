function [tanh_value, residual] = cordic_hyperbolic_core(z, n_iter, use_repetitions)
%CORDIC_HYPERBOLIC_CORE Approximate tanh(z) in the convergence interval.
%   TANH_VALUE = CORDIC_HYPERBOLIC_CORE(Z, N_ITER) uses hyperbolic
%   rotation-mode CORDIC. Iterations 4, 13, 40, ... are repeated to
%   preserve convergence.
%
%   The returned ratio y/x is independent of the hyperbolic CORDIC gain,
%   so no explicit gain compensation is needed for tanh.

    if nargin < 3
        use_repetitions = true;
    end

    if ~isscalar(z) || ~isfinite(z)
        error('cordic:InvalidInput', 'z must be a finite scalar.');
    end
    if ~isscalar(n_iter) || n_iter < 1 || n_iter ~= floor(n_iter)
        error('cordic:InvalidIterationCount', ...
              'n_iter must be a positive integer.');
    end

    repeat_indices = [];
    repeated_index = 4;
    while repeated_index <= n_iter
        repeat_indices(end + 1) = repeated_index; %#ok<AGROW>
        repeated_index = 3 * repeated_index + 1;
    end

    x = 1.0;
    y = 0.0;
    residual = z;

    for k = 1:n_iter
        step_count = 1;
        if use_repetitions && any(repeat_indices == k)
            step_count = 2;
        end

        shift = 2^(-k);
        angle = atanh(shift);

        for repeated_step = 1:step_count %#ok<NASGU>
            direction = sign(residual);
            if direction == 0
                direction = 1;
            end

            next_x = x + direction * shift * y;
            next_y = y + direction * shift * x;
            residual = residual - direction * angle;
            x = next_x;
            y = next_y;
        end
    end

    tanh_value = y / x;
end
