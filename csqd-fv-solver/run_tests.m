for d = {'src','params','tests'}, if isfolder(d{1}), addpath(d{1}); end, end
r = [test_infinite_well(0.10), test_confined_hydrogen(0.20), test_zeeman(), test_convergence()];
fprintf('\n%d / 4 tests passed\n', sum(r));