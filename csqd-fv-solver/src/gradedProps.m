function [invm, V, eps] = gradedProps(Rs, geo, p)
% Graded material profiles P(rho) = P1 + (P2-P1) S1 + (P3-P2) S2,
% S_i = 1/2 [1 + erf(2 (rho - R_i)/w_i)]  (Heaviside step when w_i = 0).
S = cell(1,2);
for i = 1:2
    if geo.w(i) > 0, S{i} = 0.5*(1 + erf(2*(Rs - geo.Rl(i))/geo.w(i)));
    else,            S{i} = double(Rs > geo.Rl(i));
    end
end
m   = p.mat.m(1)   + (p.mat.m(2)  -p.mat.m(1))  *S{1} + (p.mat.m(3)  -p.mat.m(2))  *S{2};
V   = p.mat.V(1)   + (p.mat.V(2)  -p.mat.V(1))  *S{1} + (p.mat.V(3)  -p.mat.V(2))  *S{2};
eps = p.mat.eps(1) + (p.mat.eps(2)-p.mat.eps(1))*S{1} + (p.mat.eps(3)-p.mat.eps(2))*S{2};
invm = 1 ./ m;
end