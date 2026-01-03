% ===================================================================================== %
% 棕熊的轉化率
% 定義：棕熊食用一隻狐狸，可以產生的棕熊數量，考量 6 月為出生率高峰
% 公式：
%   (1) alpha = alpha_amplitude * exp(-((m - m_peak)^2) / (2 * sigma^2)), m = t % 12
%   (2) alpha_base = r, r = ln(R0) / (T * 12)
%   (3) alpha_amplitude = eta_z * (r + gamma_z) / beta_z, r = ln(R0) / (T * 12)
%   (4) R0 = 每年胎數 * 每胎數量 * 幼體存活率 * 平均壽命 -> 設五年一胎、存活率 50%、平均壽命 25 年
%   (5) T = 性成熟歲數 + 平均壽命 / 2 -> 設性成熟歲數 5 歲
% ===================================================================================== %

function alpha = rate_bear_birth(t, beta_z, eta_z, gamma_z)

alpha_base = 0.1;
alpha_amplitude = eta_z * (0.008 + gamma_z) / beta_z;   % 增長率變動幅度 -> 設每胎數量 2 隻
m = mod(t - 19, 12) + 1;                                % 十八個月前的月份
m_peak = 6;                                             % 出生率高峰（6 月）
sigma = 1.1;                                            % 繁殖期（3～5 月）

alpha = alpha_base + alpha_amplitude .* exp(-((m - m_peak).^2) / (2 * sigma^2));

end