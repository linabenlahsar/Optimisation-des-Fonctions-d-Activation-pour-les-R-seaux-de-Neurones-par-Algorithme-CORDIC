function y = taylor_tanh(x, order)
%TAYLOR_TANH Approximate tanh with a Maclaurin polynomial.
%   Supported orders are 1, 3, 5, and 7. The approximation is local and
%   diverges rapidly outside the neighbourhood of zero.

    if nargin < 2
        order = 7;
    end
    if ~any(order == [1, 3, 5, 7])
        error('taylor:InvalidOrder', 'Supported orders are 1, 3, 5, and 7.');
    end

    y = x;
    if order >= 3
        y = y - x.^3 / 3;
    end
    if order >= 5
        y = y + 2 * x.^5 / 15;
    end
    if order >= 7
        y = y - 17 * x.^7 / 315;
    end
end
