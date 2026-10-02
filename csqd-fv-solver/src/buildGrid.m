function G = buildGrid(geo, p)
% Cell-centred (r,z) grid on [0,R3] x [-R3,R3]; cells outside the sphere removed
% (Dirichlet). Sub-cell averaged graded 1/m*, V and the off-centre Coulomb term
% 1/[eps(rho) sqrt(r^2 + (z - z0)^2)]. Returns symmetrised kinetic matrix K and D = diag(r).
    h  = geo.h;  R3 = geo.Rl(end);  ns = geo.ns;
    Nr = round(R3/h);  Nz = 2*Nr;
    r  = ((1:Nr)' - 0.5)*h;
    z  = ((1:Nz)' - 0.5)*h - R3;
    [Rg, Zg] = ndgrid(r, z);
    RR = sqrt(Rg.^2 + Zg.^2);

    off = ((1:ns) - 0.5)/ns - 0.5;
    invm2 = zeros(Nr,Nz); V2 = zeros(Nr,Nz); coul = zeros(Nr,Nz); wsum = zeros(Nr,Nz);
    for a = 1:ns
        for bb = 1:ns
            rs = Rg + off(a)*h;  zs = Zg + off(bb)*h;
            Rs = sqrt(rs.^2 + zs.^2);
            [im, Vs, es] = gradedProps(Rs, geo, p);
            dist  = sqrt(rs.^2 + (zs - geo.z0).^2);          % electron-donor distance
            invm2 = invm2 + rs.*im;   V2 = V2 + rs.*Vs;
            coul  = coul  + rs./(es.*dist);   wsum = wsum + rs;
        end
    end
    invm2 = invm2./wsum;  V2 = V2./wsum;  coul = coul./wsum;

    rf = (0:Nr)'*h;
    invm_r = zeros(Nr+1, Nz);
    invm_r(2:Nr,:) = 0.5*(invm2(1:Nr-1,:) + invm2(2:Nr,:));
    invm_r(1,:) = invm2(1,:);  invm_r(Nr+1,:) = invm2(Nr,:);
    cr = p.hb2_2m0 * (rf*ones(1,Nz)) .* invm_r / h^2;

    invm_z = zeros(Nr, Nz+1);
    invm_z(:,2:Nz) = 0.5*(invm2(:,1:Nz-1) + invm2(:,2:Nz));
    invm_z(:,1) = invm2(:,1);  invm_z(:,Nz+1) = invm2(:,Nz);
    cz = p.hb2_2m0 * (r*ones(1,Nz+1)) .* invm_z / h^2;

    diagK = cr(1:Nr,:) + cr(2:Nr+1,:) + cz(:,1:Nz) + cz(:,2:Nz+1);
    N = Nr*Nz;  idx = reshape(1:N, Nr, Nz);
    I1 = idx(1:Nr-1,:); J1 = idx(2:Nr,:); W1 = -cr(2:Nr,:);
    I2 = idx(:,1:Nz-1); J2 = idx(:,2:Nz); W2 = -cz(:,2:Nz);
    K = sparse([idx(:); I1(:); J1(:); I2(:); J2(:)], ...
               [idx(:); J1(:); I1(:); J2(:); I2(:)], ...
               [diagK(:); W1(:); W1(:); W2(:); W2(:)], N, N);

    act  = find(RR(:) <= R3);
    G.n  = numel(act);  G.act = act;  G.Nr = Nr;  G.Nz = Nz;  G.rc = r;  G.zc = z;
    G.K  = K(act,act);
    G.r  = Rg(act);  G.z = Zg(act);  G.R = RR(act);
    G.m  = 1./invm2(act);  G.V = V2(act);  G.coul = coul(act);
    G.D  = spdiags(G.r, 0, G.n, G.n);
end