# Methodology and limitations

## Hyperbolic CORDIC

The hyperbolic rotation-mode recurrence used by the reference model is

```text
x_(i+1) = x_i + d_i y_i 2^(-i)
y_(i+1) = y_i + d_i x_i 2^(-i)
z_(i+1) = z_i - d_i atanh(2^(-i))
```

where `d_i = sign(z_i)`. The ratio `y/x` converges to `tanh(z)`. Because the scale factor appears in both coordinates, it cancels in this ratio.

Hyperbolic CORDIC does not converge correctly with a simple one-pass sequence. Selected indices must be repeated. Starting at 4, the sequence follows

```text
i_(n+1) = 3 i_n + 1
```

which gives 4, 13, 40, 121, ...

## Range reduction

The core is evaluated only after repeatedly halving inputs whose magnitude is greater than 1. The original value is reconstructed with

```text
tanh(2x) = 2 tanh(x) / (1 + tanh(x)^2)
```

This makes the software reference usable beyond the native convergence interval without silently saturating the residual angle.

## Other approximations

The LUT implementation uses uniformly spaced samples and supports:

- nearest-neighbour lookup: no interpolation arithmetic
- linear interpolation: lower error at the cost of extra arithmetic

The Taylor implementation includes orders 1, 3, 5, and 7. It is deliberately evaluated outside its useful local interval in the comparison experiment to expose its divergence rather than hide it.

## Metrics

Every plot derives its values from evaluated samples. The project reports:

- mean squared error (MSE)
- mean absolute error (MAE)
- maximum absolute error

No convergence or training curve is hard-coded.

## Hardware interpretation

This code is a floating-point numerical reference, not synthesizable RTL. A hardware implementation must additionally define:

1. input and internal fixed-point formats;
2. rounding and saturation behaviour;
3. iterative or pipelined micro-architecture;
4. constant storage and control logic;
5. latency, throughput, area, timing, and power measurement after synthesis.

This distinction prevents software-level error results from being presented as FPGA implementation results.
