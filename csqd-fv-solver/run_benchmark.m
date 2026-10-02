%% Reproduction of the energy-vs-B and energy-vs-F figures of
%  Toscano-Negrette et al., Nanomaterials 13, 550 (2023), ZnS/CdS/ZnS QD,
%  on-centre donor, abrupt interfaces. Prints the numbers used in the README.
clear; clc; close all;
for d = {'src','params','tests'}, if isfolder(d{1}), addpath(d{1}); end, end
if ~isfolder('figures'), mkdir('figures'); end
[p, geo, ttl] = params_benchmark();
G = buildGrid(geo, p);
fprintf('Grid: %d active cells, h = %.3f nm, ns = %d\n', G.n, geo.h, geo.ns);
tag = {'no donor','donor'};

Bvec = sort([0:2:30, 15]);        % 0,2,...,30 T plus 15 T
Fvec = 0:5:50;                    % kV/cm
mB = [0 1 -1 2 -2];  nB = [3 2 2 1 1];
mF = [0 1 2];        nF = [3 2 1];

EB = cell(2,1); EF = cell(2,1);
fprintf('Sweeping B ...\n');
for ik = 1:2
    kappa = ik-1;
    for im = 1:numel(mB)
        Em = zeros(numel(Bvec), nB(im));
        for ib = 1:numel(Bvec)
            Em(ib,:) = states(G, p, mB(im), Bvec(ib), 0, kappa, nB(im));
        end
        EB{ik}{im} = Em;
    end
end
fprintf('Sweeping F ...\n');
for ik = 1:2
    kappa = ik-1;
    for im = 1:numel(mF)
        Em = zeros(numel(Fvec), nF(im));
        for iF = 1:numel(Fvec)
            Em(iF,:) = states(G, p, mF(im), 0, Fvec(iF), kappa, nF(im));
        end
        EF{ik}{im} = Em;
    end
end
EbB = EB{1}{1}(:,1) - EB{2}{1}(:,1);
EbF = EF{1}{1}(:,1) - EF{2}{1}(:,1);
i15 = find(Bvec == 15, 1);
i50 = find(Fvec == 50, 1);

%% ---------------- numbers for the README table ----------------
fprintf('\n--- energy vs magnetic field (m = 0) ---\n');
fprintf('%-22s %10s %10s %10s\n', 'quantity', 'B = 0', 'B = 15 T', 'B = 30 T');
for ik = 1:2
    E = EB{ik}{1};
    for j = 1:size(E,2)
        fprintf('E%d (m=0, %-8s) %10.2f %10.2f %10.2f\n', ...
                j, tag{ik}, E(1,j), E(i15,j), E(end,j));
    end
end
fprintf('%-22s %10.2f %10.2f %10.2f\n', 'E_b (meV)', EbB(1), EbB(i15), EbB(end));

fprintf('\n--- energy vs electric field (m = 0) ---\n');
fprintf('%-22s %10s %10s\n', 'quantity', 'F = 0', 'F = 50 kV/cm');
for ik = 1:2
    E = EF{ik}{1};
    for j = 1:size(E,2)
        fprintf('E%d (m=0, %-8s) %10.2f %10.2f\n', j, tag{ik}, E(1,j), E(end,j));
    end
end
fprintf('%-22s %10.2f %10.2f\n', 'E_b (meV)', EbF(1), EbF(i50));

%% ---------------- figures ----------------
f1 = figure('Color','w','Position',[60 80 1000 560]);
for ik = 1:2
    ax = subplot(1,2,ik); hold(ax,'on'); box(ax,'on'); grid(ax,'on');
    plotFamily(ax, Bvec, EB{ik}, mB, 'B');
    xlim(ax, [0 Bvec(end)*1.12]);
    xlabel(ax,'magnetic field (T)'); ylabel(ax,'energy (meV)');
    title(ax, sprintf('(%c) %s', 'a'+ik-1, tag{ik}));
end
sgtitle([ttl ', F_z = 0']);
print(f1, fullfile('figures','benchmark_E_vs_B.png'), '-dpng', '-r200');

f2 = figure('Color','w','Position',[80 100 1000 560]);
for ik = 1:2
    ax = subplot(1,2,ik); hold(ax,'on'); box(ax,'on'); grid(ax,'on');
    plotFamily(ax, Fvec, EF{ik}, mF, 'F');
    xlim(ax, [0 Fvec(end)*1.12]);
    xlabel(ax,'electric field (kV/cm)'); ylabel(ax,'energy (meV)');
    title(ax, sprintf('(%c) %s', 'a'+ik-1, tag{ik}));
end
sgtitle([ttl ', B = 0']);
print(f2, fullfile('figures','benchmark_E_vs_F.png'), '-dpng', '-r200');

fprintf('\nFigures written to figures/\n');