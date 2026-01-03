% =========================================== %
% Rauch-Tung-Striebel 平滑器
% 定義：對分析場進行後向濾波得到平滑場
% 公式：
%   (1) B = Cov(xa_t0, xf_t1) * V(xf_t1^(-1))
%   (2) xs_t0 = xa_t0 + B * (xs_t1 - xf_t1)
% =========================================== %

function xs_t0 = rts(xa_t0, xs_t1, xf_t1)

part = size(xa_t0, 2);
cv1 = cov([xa_t0, xf_t1]); cv1 = cv1(1: part, part + 1: end);
cv2 = cov(xf_t1);

B = cv1 / cv2;                          % 平滑增益
xs_t0 = xa_t0 + (xs_t1 - xf_t1) * B';   % 平滑場

end