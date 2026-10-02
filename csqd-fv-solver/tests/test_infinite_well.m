function ok = test_infinite_well(h)
if nargin < 1, h = 0.10; end
p = constants();
p.mat.m = [0.1 0.1 0.1]; p.mat.eps = [10 10 10]; p.mat.V = [0 0 0];
geo.Rl = [4 8 12]; geo.w = [0 0]; geo.z0 = 0; geo.h = h; geo.ns = 2;
G = buildGrid(geo, p);
E = states(G, p, 0, 0, 0, 0, 3);
x = [pi 4.493409 5.763459];
Eex = p.hb2_2m0 * x.^2 / (0.1 * geo.Rl(end)^2);
% Dirichlet wall is effectively at R3 + h/2 (cell-centred grid): report both
Eex2 = p.hb2_2m0 * x.^2 / (0.1 * (geo.Rl(end)+h/2)^2);
fprintf('\n[infinite well, h = %.2f nm]\n   l   E_num     E_exact   dev%%   E_exact(R3+h/2)  dev%%\n', h);
for j = 1:3
    fprintf('  %2d  %8.3f  %8.3f  %5.2f   %8.3f  %5.2f\n', j-1, E(j), Eex(j), ...
        100*(E(j)-Eex(j))/Eex(j), Eex2(j), 100*(E(j)-Eex2(j))/Eex2(j));
end
ok = all(abs(E - Eex2)./Eex2 < 0.01);
pf = {'FAIL','PASS'};  fprintf('   -> %s\n', pf{ok+1});
end