function y = cordic_tanh(z, n_iter)
%CORDIC_TANH Approximate tanh element-wise with hyperbolic CORDIC.
%   Y = CORDIC_TANH(Z, N_ITER) accepts a scalar, vector, or matrix.
%   Inputs outside the core convergence interval are repeatedly halved.
%   The result is reconstructed with tanh(2x) = 2*tanh(x)/(1+tanh(x)^2).

    if nargin < 2
        n_iter = 16;
    end
    if ~isnumeric(z) || any(~isfinite(z(:)))
        error('cordic:InvalidInput', 'z must contain finite numeric values.');
    end
    if ~isscalar(n_iter) || n_iter < 1 || n_iter ~= floor(n_iter)
        error('cordic:InvalidIterationCount', ...
              'n_iter must be a positive integer.');
    end

    convergence_limit = 1.0;
    y = zeros(size(z));

    for sample_index = 1:numel(z)
        reduced_z = z(sample_index);

        if reduced_z == 0
            y(sample_index) = 0;
            continue;
        end

        reduction_count = 0;
        while abs(reduced_z) > convergence_limit
            reduced_z = reduced_z / 2;
            reduction_count = reduction_count + 1;
        end

        approximation = cordic_hyperbolic_core(reduced_z, n_iter, true);

        for reconstruction_step = 1:reduction_count %#ok<NASGU>
            approximation = 2 * approximation / (1 + approximation^2);
        end

        y(sample_index) = max(-1, min(1, approximation));
    end
end
