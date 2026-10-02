function [E, Psi] = states(G, p, m, B, F, kappa, nev)
% Lowest nev eigenpairs of the symmetric-definite pencil (H, D = diag(r)).
% Energies ascending (row vector), eigenvectors r-normalised.
%
% Notes on the eigensolver:
%  * A shift far below the spectrum (e.g. -1000 meV) makes the transformed
%    eigenvalues 1/(E - sigma) nearly degenerate, and eigs then mis-orders or
%    duplicates members of the m = +/-1 multiplets as B and F vary. The shift
%    is therefore placed just below the lowest level, where the wanted states
%    are well separated.
%  * nev + 3 eigenvalues are requested and the lowest nev kept, so a shuffled
%    multiplet can never produce oscillating curves.
    Veff = p.hb2_2m0 * m^2 ./ (G.m .* G.r.^2) ...    % centrifugal
         + p.muB  * B * m ./ G.m ...                  % Zeeman
         + p.cdia * B^2 * G.r.^2 ./ G.m ...           % diamagnetic
         + p.eF   * F * G.z ...                       % electric field
         + G.V ...                                    % graded confinement
         - kappa * p.e2_4pie0 * G.coul;               % off-centre donor
    Hs = G.K + spdiags(G.r .* Veff, 0, G.n, G.n);

    nreq = min(nev + 3, G.n - 2);

    % deterministic start vector matched to the azimuthal symmetry
    % (the m ~= 0 states vanish on the axis, so a constant v0 is a poor start)
    v0 = G.r.^abs(m) .* exp(-G.R/3);
    if ~any(v0), v0 = ones(G.n,1); end
    v0 = v0 / norm(v0);

    % stage 1: cheap estimate of the lowest level
        o1 = struct('tol', 1e-6,  'maxit', 300,  'p', max(30, 4*nreq), 'v0', v0);
    [~, Ed1] = eigs(Hs, G.D, 1, -1000, o1);
    sigma = real(Ed1(1)) - 1;        % just below the spectrum -> (H - sigma D) is SPD

    % stage 2: accurate solve with the shift close to the wanted eigenvalues
       o2 = struct('tol', 1e-12, 'maxit', 3000, 'p', max(40, 8*nreq), 'v0', v0);
    [Psi, Ed] = eigs(Hs, G.D, nreq, sigma, o2);

    [E, ord] = sort(real(diag(Ed)));
    E   = E(1:nev);
    Psi = real(Psi(:, ord(1:nev)));
    for j = 1:nev
        Psi(:,j) = Psi(:,j) / sqrt(sum(G.r .* Psi(:,j).^2));
    end
end