# CORDIC-Based Activation Functions

A reproducible MATLAB/Octave study of hardware-oriented approximations for neural-network activation functions.

The project compares hyperbolic CORDIC, lookup tables (LUTs), and truncated Taylor series for approximating `tanh(x)` and `sigmoid(x)`. It focuses on numerical accuracy, convergence, and implementation trade-offs that matter in resource-constrained embedded and FPGA systems.

> Scope: this repository is an algorithmic reference model. It does not claim post-synthesis FPGA area, timing, power, or fixed-point results.

## Highlights

- Hyperbolic CORDIC with the required repeated iterations (4, 13, 40, ...)
- Range reduction and reconstruction using the tanh double-angle identity
- LUT approximation with nearest-neighbour or linear interpolation
- Taylor approximations of orders 1, 3, 5, and 7
- Reproducible MSE, MAE, and maximum-error measurements
- Automated MATLAB/Octave tests; no hand-written performance curves

With 16 CORDIC iterations, the double-precision reference model is tested on 4,001 points over `[-4, 4]` with the following acceptance criteria:

- MSE below `2e-11`
- maximum absolute error below `2e-5`

These are software-reference results, not RTL synthesis measurements.

## Repository structure

```text
.
├── src/                         Reusable approximation functions
├── experiments/                 Reproducible numerical studies and plots
├── tests/                       Deterministic regression tests
├── docs/methodology.md          Equations, assumptions, and limitations
├── .github/workflows/octave.yml Continuous integration
└── run_demo.m                   Run tests and the main experiments
```

## Quick start

MATLAB:

```matlab
run_demo
```

GNU Octave:

```bash
octave --no-gui --quiet run_demo.m
```

Run only the tests:

```matlab
addpath('src');
addpath('tests');
run_tests;
```

## Main experiments

- `compare_methods.m`: CORDIC vs LUT vs Taylor, with metrics computed from the generated samples
- `sweep_cordic_iterations.m`: accuracy as a function of the iteration count
- `sweep_lut_sizes.m`: LUT size/interpolation trade-off
- `hyperbolic_repetition_demo.m`: effect of repeated hyperbolic iterations

## Engineering notes

CORDIC replaces general multiplications used by transcendental functions with an iterative sequence of additions, subtractions, shifts, and a small table of constants. The MATLAB/Octave implementation uses floating-point arithmetic to establish a reference. A synthesizable implementation still requires an explicit fixed-point format, saturation/rounding rules, a micro-architecture, and post-synthesis validation.

## Maintainer

Lina Benlahsar — Electronics and Embedded Systems engineering student at ENSEIRB-MATMECA, Bordeaux INP.
