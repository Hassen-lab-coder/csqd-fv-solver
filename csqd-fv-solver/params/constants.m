function p = constants()
% Physical constants in the working units meV, nm, T, kV/cm.
p.hb2_2m0  = 38.0998;                 % hbar^2/(2 m0)        [meV nm^2]
p.e2_4pie0 = 1439.964;                % e^2/(4 pi eps0)      [meV nm]
p.muB      = 5.7883818e-2;            % hbar e/(2 m0)        [meV/T]
p.cdia     = p.muB^2/(4*p.hb2_2m0);   % e^2/(8 m0)           [meV nm^-2 T^-2]
p.eF       = 0.1;                     % e * (1 kV/cm)        [meV/nm]
p.Ry0      = 13605.69;                % Rydberg              [meV]
p.aB0      = 0.0529177;               % Bohr radius          [nm]
end