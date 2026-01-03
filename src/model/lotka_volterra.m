% ============================================================================================================================= %
% Lotka-Volterra 方程式
% 定義：兔子、狐狸、熊的數量變化關係
% 公式：
%   (1) rate_x = alpha_x * x * (1 - x / K) - beta_y * (x / (1 + eta_y * x)) * y
%   (2) rate_y = alpha_y * (beta_y * x_past / (1 + eta_y * x_past)) * y_past - gamma_y * y - beta_z * (y / (1 + eta_z * y)) * z
%   (3) rate_z = alpha_z * (beta_z * y_past / (1 + eta_z * y_past)) * z_past - gamma_z * z
% ============================================================================================================================= %

% Lotka-Volterra with RK4 -> 積分後得到數量
function next_state = lotka_volterra(t, now_state, past_state, dt)

% k1
xt = now_state;
k1 = lv_base_model(t, xt, past_state);

% k2
xt = now_state + k1 * (dt / 2);
k2 = lv_base_model(t, xt, past_state);

% k3
xt = now_state + k2 * (dt / 2);
k3 = lv_base_model(t, xt, past_state);

% k4
xt = now_state + k3 * dt;
k4 = lv_base_model(t, xt, past_state);

next_state = now_state + dt * (k1 + 2 * k2 + 2 * k3 + k4) / 6;

end

% Lotka-Volterra -> 積分前為變化率
function rate = lv_base_model(t, now_state, past_state)

gamma_y = 1 / 54;                                       % 自然死亡率 = 1 / 平均壽命（月）
gamma_z = 1 / 300;
beta_y = 0.02;                                          % 捕獲成功率
beta_z = 0.01;
eta_y = 1 / 25;                                         % 處理時間
eta_z = 1 / 10;

x_now = now_state(1); x_past = past_state(1);           % 狀態
y_now = now_state(2); y_past = past_state(2); 
z_now = now_state(3); z_past = past_state(3);
alpha_x = growth_rate_rabbit(t);                         % 自然增加率
alpha_y = growth_rate_fox(t, beta_y, eta_y, gamma_y);
alpha_z = growth_rate_bear(t, beta_z, eta_z, gamma_z);
K = environment_capacity(t);                            % 環境負載力

rate = zeros(size(now_state));
rate(1) = alpha_x * x_now * (1 - x_now / K) - beta_y * (x_now / (1 + eta_y * x_now)) * y_now;
rate(2) = alpha_y * (beta_y * x_past / (1 + eta_y * x_past)) * y_past - gamma_y * y_now - beta_z * (y_now / (1 + eta_z * y_now)) * z_now;
rate(3) = alpha_z * (beta_z * y_past / (1 + eta_z * y_past)) * z_past - gamma_z * z_now ;

end