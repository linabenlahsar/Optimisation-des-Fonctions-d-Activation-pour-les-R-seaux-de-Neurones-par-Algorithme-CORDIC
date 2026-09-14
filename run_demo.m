%RUN_DEMO Run the regression tests and the main reproducible studies.

root_dir = fileparts(mfilename('fullpath'));
addpath(fullfile(root_dir, 'src'));
addpath(fullfile(root_dir, 'tests'));

run_tests;

run(fullfile(root_dir, 'experiments', 'compare_methods.m'));
run(fullfile(root_dir, 'experiments', 'sweep_cordic_iterations.m'));
run(fullfile(root_dir, 'experiments', 'sweep_lut_sizes.m'));
run(fullfile(root_dir, 'experiments', 'hyperbolic_repetition_demo.m'));
