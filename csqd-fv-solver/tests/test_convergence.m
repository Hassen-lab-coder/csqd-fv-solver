function ok = test_convergence()
[p, geo] = params_benchmark();
hs = [0.14 0.12 0.10 0.08];  nss = [2 4 6 10];
fprintf('\n[grid convergence, donor on, m = 0, B = 0]\n     h     ns     E1        E2        Eb\n');
E = zeros(numel(hs),3);
for i = 1:numel(hs)
    g = geo; g.h = hs(i); G = buildGrid(g, p);
    e1 = states(G, p, 0, 0, 0, 1, 2); e0 = states(G, p, 0, 0, 0, 0, 1);
    E(i,:) = [e1(1) e1(2) e0-e1(1)];
    fprintf('  %5.2f  %3d  %8.3f  %8.3f  %8.3f\n', hs(i), geo.ns, E(i,:));
end
fprintf('   sub-sampling at h = %.2f:\n', geo.h);
for i = 1:numel(nss)
    g = geo; g.ns = nss(i); G = buildGrid(g, p);
    e1 = states(G, p, 0, 0, 0, 1, 1); e0 = states(G, p, 0, 0, 0, 0, 1);
    fprintf('  %5.2f  %3d  %8.3f  %8s  %8.3f\n', geo.h, nss(i), e1, '-', e0-e1);
end
dE = abs(E(end,:) - E(end-1,:));
fprintf('   change h 0.10 -> 0.08: dE1 = %.3f, dE2 = %.3f, dEb = %.3f meV\n', dE);
ok = all(dE < 0.5);
pf = {'FAIL','PASS'};  fprintf('   -> %s\n', pf{ok+1});
end