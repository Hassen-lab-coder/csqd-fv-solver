function ok = test_confined_hydrogen(h)
% Large uniform sphere + on-centre donor: the donor ground state must tend to
% -Ry* = -Ry0 m*/eps^2 (finite-size correction is exponentially small for R3 >> a*).
if nargin < 1, h = 0.20; end
p = constants();
ms = 0.1; es = 10;
p.mat.m = ms*[1 1 1]; p.mat.eps = es*[1 1 1]; p.mat.V = [0 0 0];
geo.Rl = [10 20 40]; geo.w = [0 0]; geo.z0 = 0; geo.h = h; geo.ns = 6;
G  = buildGrid(geo, p);
E0 = states(G, p, 0, 0, 0, 0, 1);          % no donor  (= spherical well ground state)
E1 = states(G, p, 0, 0, 0, 1, 1);          % with donor
Eb = E0 - E1;
Ryst = p.Ry0 * ms / es^2;   aB = p.aB0 * es / ms;
fprintf('\n[confined hydrogen, R3 = %g nm = %.1f a_B*, h = %.2f nm]\n', geo.Rl(end), geo.Rl(end)/aB, h);
fprintf('   E0 (well)  = %8.3f meV\n', E0);
fprintf('   E1 (donor) = %8.3f meV,  -Ry* = %8.3f meV,  dev = %.3f %%\n', E1, -Ryst, 100*(E1+Ryst)/Ryst);
fprintf('   E_b = E0 - E1 = %.3f meV\n', Eb);
ok = abs(E1/(-Ryst) - 1) < 0.02;
pf = {'FAIL','PASS'};  fprintf('   -> %s\n', pf{ok+1});
end