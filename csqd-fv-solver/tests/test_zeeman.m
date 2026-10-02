function ok = test_zeeman()
p = constants(); [p, geo] = params_benchmark();
G = buildGrid(geo, p);
B = 30;
Ep = states(G, p,  1,  B, 0, 0, 1);
Em = states(G, p, -1,  B, 0, 0, 1);
Es = states(G, p, -1, -B, 0, 0, 1);
lo = 2*p.muB*B/max(p.mat.m); hi = 2*p.muB*B/min(p.mat.m);
fprintf('\n[Zeeman, B = %g T]\n   E(+1,B) - E(-1,B) = %.3f meV, allowed [%.2f, %.2f]\n', B, Ep-Em, lo, hi);
fprintf('   |E(+1,B) - E(-1,-B)| = %.2e meV (must be ~0)\n', abs(Ep - Es));
ok = (Ep-Em > lo) && (Ep-Em < hi) && abs(Ep-Es) < 1e-6;
pf = {'FAIL','PASS'};  fprintf('   -> %s\n', pf{ok+1});
end