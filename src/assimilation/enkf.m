% =========================================== %
% 系集卡爾曼濾波
% 定義：對模式場進行前向濾波得到分析場
% 公式：
%   (1) F = V(xf)
%   (2) K = F * H' / (R + H * F * H')
%   (3) xa = xf + K * (xo + epsilon - H * xf)
%   (4) A = V(xa)
% =========================================== %

function [xa, A] = enkf(xf, xo, R, H)

% 生成高斯分布的觀測誤差
R = (R + R')/2;
N = size(xf, 1);
m = size(H, 1);
S = chol(R, 'lower');
epsilon = randn(N, m) * S';

% Stochastic EnKF
F = cov(xf);                                    % 模式誤差協方差
K = R + H * F * H'; K = F * H' / K;             % 卡爾曼增益
xa = xf + (xo(:)' + epsilon - xf * H') * K';    % 分析場
A = cov(xa);                                    % 分析誤差協方差

end