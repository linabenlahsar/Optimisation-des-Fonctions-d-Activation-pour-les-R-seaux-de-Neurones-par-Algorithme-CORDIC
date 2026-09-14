function y = lut_tanh(x, n_entries, x_min, x_max, method)
%LUT_TANH Approximate tanh with a uniformly sampled lookup table.
%   METHOD is 'nearest' or 'linear'. Inputs are saturated to [X_MIN, X_MAX].

    if nargin < 5
        method = 'nearest';
    end
    if nargin < 4
        x_max = 4;
    end
    if nargin < 3
        x_min = -4;
    end

    if ~isscalar(n_entries) || n_entries < 2 || n_entries ~= floor(n_entries)
        error('lut:InvalidSize', 'n_entries must be an integer >= 2.');
    end
    if ~isscalar(x_min) || ~isscalar(x_max) || x_min >= x_max
        error('lut:InvalidRange', 'x_min must be smaller than x_max.');
    end
    if ~strcmpi(method, 'nearest') && ~strcmpi(method, 'linear')
        error('lut:InvalidMethod', 'method must be nearest or linear.');
    end

    x_clipped = max(x_min, min(x_max, x));
    table_x = linspace(x_min, x_max, n_entries);
    table_y = tanh(table_x);

    position = (x_clipped - x_min) / (x_max - x_min) * (n_entries - 1);

    if strcmpi(method, 'nearest')
        index = round(position) + 1;
        y = table_y(index);
        return;
    end

    lower_index = floor(position) + 1;
    upper_index = min(lower_index + 1, n_entries);
    fraction = position - floor(position);

    y = (1 - fraction) .* table_y(lower_index) + ...
        fraction .* table_y(upper_index);
end
