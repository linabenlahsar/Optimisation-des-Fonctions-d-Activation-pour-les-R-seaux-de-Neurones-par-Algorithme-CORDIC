function metrics = error_metrics(approximation, reference)
%ERROR_METRICS Return MSE, MAE, and maximum absolute error.

    if ~isequal(size(approximation), size(reference))
        error('metrics:SizeMismatch', ...
              'approximation and reference must have the same size.');
    end
    if isempty(approximation)
        error('metrics:EmptyInput', 'Inputs must not be empty.');
    end

    difference = approximation(:) - reference(:);

    metrics.mse = mean(difference.^2);
    metrics.mae = mean(abs(difference));
    metrics.max_abs_error = max(abs(difference));
end
