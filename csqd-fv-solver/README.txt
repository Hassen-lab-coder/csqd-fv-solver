# csqd-fv-solver

Finite-volume solver for the lowest electronic states of a spherical
core/shell/shell semiconductor quantum dot with graded interfaces, an
(optionally off-centre) hydrogenic donor, and axial magnetic and electric
fields. MATLAB R2019 or later, no toolboxes.

![benchmark](figures/benchmark_E_vs_B.png)

*Lowest m = 0, ±1, ±2 levels of a ZnS/CdS/ZnS dot versus magnetic field,
(a) without and (b) with an on-centre donor. Reproduces Figs. 3–4 of
Toscano-Negrette et al., Nanomaterials 13, 550 (2023).*

## Model

Effective-mass, BenDaniel–Duke Hamiltonian in cylindrical coordinates (r, z):

    [ -(hbar^2/2) grad . (1/m*) grad + hbar^2 m^2 / (2 m* r^2) + hbar e B m / (2 m*)
      + e^2 B^2 r^2 / (8 m*) + e F_z z + V(rho) - kappa e^2 / (4 pi eps0 eps(rho) |r - r0|) ] R = E R

* azimuthal quantum number m conserved; one 2-D solve per m
* position-dependent m*, V, eps with error-function graded interfaces of width w_i
  (w_i = 0 gives abrupt interfaces)
* donor at r0 = (0, 0, z0); z0 = 0 recovers the on-centre case
* Dirichlet wall on the sphere rho = R3

## Numerical method

* cell-centred finite-volume grid on [0, R3] x [-R3, R3], spacing h
* radial measure r dr dz built into the operator: generalised symmetric
  eigenproblem H psi = E D psi with D = diag(r)
* 1/m* averaged at cell faces (current conservation across interfaces)
* graded profiles and the Coulomb term averaged over ns x ns sub-samples per cell
* lowest eigenpairs by shift-invert Lanczos (`eigs`), shift placed just below
  the lowest level

## Run

    run_tests        % four analytic validation tests, about 2 min
    run_benchmark    % ZnS/CdS/ZnS reference dot: E(B), E(F), figures/*.png

Edit `params/params_benchmark.m` to change materials or geometry.

## Validation

Output of `run_tests` (MATLAB R2019b, h = 0.10 nm unless stated):

| test | criterion | result |
|---|---|---|
| infinite spherical well (uniform m*, no fields) | < 1 % vs ħ²x²/2m*R² with wall at R3 + h/2 | 0.22 / 0.26 / 0.17 % for l = 0, 1, 2 — PASS |
| confined hydrogen (R3 = 7.6 a_B*, on-centre donor) | donor ground state within 2 % of −Ry* | −13.605 vs −13.606 meV (0.008 %) — PASS |
| Zeeman (B = 30 T) | E(m,B) = E(−m,−B); E(+1) − E(−1) within 2μ_B B/m* of core and well | 18.258 meV in [13.89, 18.28]; symmetry error 0 — PASS |
| grid convergence, donor on (h = 0.14 → 0.08 nm) | ΔE < 0.5 meV between the two finest grids | ΔE1 = 0.000, ΔE2 = 0.001, ΔE_b = 0.001 meV — PASS |
| sub-cell sampling, donor on (ns = 2 → 10) | reported | ΔE1 = 0.014 meV, ΔE_b = 0.001 meV |

Convergence table (ZnS/CdS/ZnS geometry, m = 0, B = F = 0, donor on):

| h (nm) | E1 (meV) | E2 (meV) | E_b (meV) |
|---|---|---|---|
| 0.14 | 5.630 | 13.965 | 24.375 |
| 0.12 | 5.619 | 13.955 | 24.375 |
| 0.10 | 5.608 | 13.948 | 24.376 |
| 0.08 | 5.608 | 13.947 | 24.376 |

### Comparison with the published reference

Toscano-Negrette et al., Nanomaterials 13, 550 (2023): ZnS/CdS/ZnS,
R1 = 4, R2 = 11, R3 = 12 nm, abrupt interfaces, on-centre donor.
Material parameters as in `params/params_benchmark.m`.

| quantity (m = 0) | B = 0 | B = 15 T | B = 30 T |
|---|---|---|---|
| E1, no donor | 29.98 | 30.99 | 33.86 |
| E2, no donor | 37.93 | 38.55 | 40.35 |
| E3, no donor | 53.10 | 53.89 | 56.29 |
| E1, donor | 5.61 | 6.57 | 9.33 |
| E2, donor | 13.95 | 14.54 | 16.27 |
| E3, donor | 29.82 | 30.57 | 32.88 |
| E_b | 24.38 | 24.42 | 24.53 |

| quantity (m = 0) | F = 0 | F = 50 kV/cm |
|---|---|---|
| E1, no donor | 29.98 | 6.78 |
| E1, donor | 5.61 | −16.66 |
| E_b | 24.38 | 23.44 |

The full m = 0, ±1, ±2 level structure versus B and F (figures/) agrees
with the published figures: zero-field l-multiplet degeneracies, Zeeman
splitting with the characteristic minimum of the m < 0 branches, and the
Stark lowering of the levels. Published values are available only as
figures; agreement is at the level of graphical reading (about 1 meV).

## Pitfalls this implementation avoids

* **Shift far below the spectrum.** A shift-invert shift of −1000 meV maps
  the wanted eigenvalues onto a cluster of relative width 1e-3; `eigs` then
  mis-orders or duplicates members of the m = ±1 multiplets as B varies,
  producing jagged curves. The shift is set just below the lowest level.
* **Missing r measure.** Omitting D = diag(r) gives a non-symmetric problem
  and spurious complex eigenvalues.
* **Averaging m* instead of 1/m*** at cell faces breaks current conservation
  at interfaces.
* **Wrong vector-potential sign** swaps the m = +1 / −1 ordering; the Zeeman
  test catches it.
* **Coulomb term at cell centres only** shifts E_b by several meV; see the
  sub-sampling rows of `test_convergence`.
* **Dirichlet wall position.** On a cell-centred grid the wall is effectively
  at R3 + h/2; the infinite-well test quantifies this O(h) effect.

## Roadmap

Graded ZnSe/InP/ZnS layout with off-centre donor: parameter file and figure
scripts will be released with the corresponding publication.

## Citation

[Your name], *csqd-fv-solver: finite-volume solver for core/shell/shell
quantum dots*, GitHub, 2026. Reference system: R. G. Toscano-Negrette et al.,
Nanomaterials 13, 550 (2023), doi:10.3390/nano13030550.

## Licence

MIT