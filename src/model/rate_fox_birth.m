% ====================================================================================== %
% 狐狸的轉化效率
% 定義：狐狸食用一隻兔子，可以產生的狐狸數量，考量 6 月為出生率高峰
% 公式：
%   (1) alpha = alpha_amplitude * exp(-((m - m_peak)^2) / (2 * sigma^2)), m = t % 12
%   (2) alpha_base = r, r = ln(R0) / (T * 12)
%   (3) alpha_amplitude = eta_y * (r + gamma_y) / beta_y
%   (4) R0 = 每年胎數 * 每胎數量 * 幼體存活率 * 平均壽命 -> 設一年一胎、存活率 20%、平均壽命 4.5 年
%   (5) T = 性成熟歲數 + 平均壽命 / 2 -> 設性成熟歲數 0.8 歲
% ====================================================================================== %

function alpha = rate_fox_birth(t, beta_y, eta_y, gamma_y)

alpha_base = 0.04;                                      % 最低增長率 -> 設每胎數量 2 隻
alpha_amplitude = eta_y * (0.04 + gamma_y) / beta_y;    % 增長率變動幅度 -> 設每胎數量 5 隻
m = mod(t - 3, 12) + 1;                                 % 兩個月前的月份
m_peak = 6;                                             % 出生率高峰（6 月）
sigma = 1.1;                                            % 繁殖期（3～5 月）

alpha = alpha_base + alpha_amplitude .* exp(-((m - m_peak).^2) / (2 * sigma^2));

end