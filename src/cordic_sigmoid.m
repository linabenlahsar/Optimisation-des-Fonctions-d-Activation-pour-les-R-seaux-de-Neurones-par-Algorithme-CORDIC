function y = cordic_sigmoid(x, n_iter)
%CORDIC_SIGMOID Approximate the logistic sigmoid with CORDIC tanh.
%   sigmoid(x) = 0.5 * (1 + tanh(x/2)).

    if nargin < 2
        n_iter = 16;
    end

    y = 0.5 * (1 + cordic_tanh(x / 2, n_iter));
end
