function M12 = dipoleElement(G, Psi1, Psi2)
% Reduced dipole matrix element <psi1| z |psi2> in nm (r-normalised eigenvectors).
M12 = sum(G.r .* Psi1 .* G.z .* Psi2);
end