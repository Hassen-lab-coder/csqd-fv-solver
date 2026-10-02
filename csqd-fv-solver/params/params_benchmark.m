function [p, geo, ttl] = params_benchmark()
% ZnS/CdS/ZnS core/shell/shell QD, on-centre donor, abrupt interfaces.
% Reference: Toscano-Negrette et al., Nanomaterials 13, 550 (2023).
% !! Check every value against Table 1 of the reference before release.
p = constants();
p.mat.m   = [0.25 0.19 0.25];         % [core shell1 shell2]  (m0)
p.mat.eps = [8.9  8.3  8.9 ];
p.mat.V   = [800  0    800 ];         % meV; well = CdS shell
geo.Rl = [4 11 12];                   % R1 R2 R3 (nm)
geo.w  = [0 0];                       % abrupt interfaces
geo.z0 = 0;                           % on-centre donor
geo.h  = 0.10;                        % grid spacing (nm)
geo.ns = 6;                           % sub-samples per cell and direction
ttl = 'ZnS/CdS/ZnS (Toscano-Negrette 2023): R_1 = 4, R_2 = 11, R_3 = 12 nm';
end