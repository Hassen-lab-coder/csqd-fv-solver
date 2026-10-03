# Validation report — csqd-fv-solver

**Author:** Hassen Dakhlaoui · **Date:** [fill in] · **Code:** [repository link]
## 1. Scope

Lowest conduction-band states of a spherical core/shell/shell quantum dot in the
effective-mass BenDaniel–Duke approximation, with error-function graded
interfaces, a hydrogenic donor at (0, 0, z₀), and axial magnetic and electric
fields. Two-dimensional (r, z) finite-volume discretisation, generalised
symmetric eigenproblem, shift-invert Lanczos.

Numerical setup: MATLAB R2019b, grid spacing h = 0.10 nm, 6 × 6 sub-cell
averaging, Dirichlet wall on the sphere ρ = R₃.

## 2. Analytic tests

| Test | Quantity | Numerical | Exact / bound | Status |
|---|---|---|---|---|
| Infinite spherical well, R = 12 nm, m\* = 0.1 | E (l = 0, 1, 2) [meV] | 25.953 / 53.116 / 87.308 | 25.897 / 52.979 / 87.160 (wall at R + h/2) | PASS (< 0.3 %) |
| Confined hydrogen, R = 7.6 a_B\* | E₁ₛ [meV] | −13.605 | −Ry\* = −13.606 | PASS (0.008 %) |
| Zeeman, B = 30 T | E₊₁ − E₋₁ [meV] | 18.258 | within [13.89, 18.28] = 2μ_B B/m\* range | PASS |
| Zeeman symmetry | \|E(m,B) − E(−m,−B)\| | < 10⁻¹² meV | 0 | PASS |

## 3. Convergence (donor on, m = 0)

ZnS/CdS/ZnS geometry, B = F = 0:

| h (nm) | E₁ (meV) | E₂ (meV) | E_b (meV) |
|---|---|---|---|
| 0.14 | 5.630 | 13.965 | 24.375 |
| 0.12 | 5.619 | 13.955 | 24.375 |
| 0.10 | 5.608 | 13.948 | 24.376 |
| 0.08 | 5.608 | 13.947 | 24.376 |

Sub-cell sampling at h = 0.10 nm:

| n_s | E₁ (meV) | E_b (meV) |
|---|---|---|
| 2 | 5.595 | 24.375 |
| 4 | 5.614 | 24.375 |
| 6 | 5.608 | 24.376 |
| 10 | 5.609 | 24.376 |

Energies are converged to better than 0.01 meV with respect to h and 0.02 meV
with respect to n_s.

## 4. Reproduction of a published result

Reference: R. G. Toscano-Negrette et al., *Nanomaterials* **13**, 550 (2023) —
ZnS/CdS/ZnS dot, R₁ = 4 nm, R₂ = 11 nm, R₃ = 12 nm, abrupt interfaces,
on-centre donor.

![Energy levels versus magnetic field](../FIGURES/benchmark_E_vs_B.png)

| Quantity (m = 0) | B = 0 | B = 15 T | B = 30 T |
|---|---|---|---|
| E₁, no donor | 29.98 | 30.99 | 33.86 |
| E₂, no donor | 37.93 | 38.55 | 40.35 |
| E₃, no donor | 53.10 | 53.89 | 56.29 |
| E₁, donor | 5.61 | 6.57 | 9.33 |
| E₂, donor | 13.95 | 14.54 | 16.27 |
| E₃, donor | 29.82 | 30.57 | 32.88 |
| E_b | 24.38 | 24.42 | 24.53 |

| Quantity (m = 0) | F = 0 | F = 50 kV/cm |
|---|---|---|
| E₁, no donor | 29.98 | 6.78 |
| E₁, donor | 5.61 | −16.66 |
| E_b | 24.38 | 23.44 |

The full m = 0, ±1, ±2 level structure versus B and F reproduces the published
figures: zero-field l-multiplet degeneracies, Zeeman splitting with the
characteristic minimum of the m < 0 branches, and the Stark lowering of the
levels. Published values are available only graphically; agreement is at the
level of graphical reading, about 1 meV.

## 5. Statement

All validation tests pass. The solver reproduces the analytic limits to better
than 0.3 %, is grid-converged to better than 0.01 meV, and reproduces the
published reference system within graphical accuracy.

*Hassen Dakhlaoui*
