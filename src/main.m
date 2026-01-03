% ========================================================= %
% 程式切入點
% 定義：使用改良版 Lotka-Volterra 與 EnKS 進行 OSSE 試驗
% 流程：
%   (1) 設定參數
%   (2) 進行 OSSE：真值、觀測值、純模型、EnKF、EnKS（EnKF + RTS）
%   (3) 結果繪圖
% ========================================================= %

clc; clear; close all;
addpath '/Users/tiffany/Documents/NCKU/114-1 大氣資料同化導論/報告/lveq_data_assimilation/src/model'
addpath '/Users/tiffany/Documents/NCKU/114-1 大氣資料同化導論/報告/lveq_data_assimilation/src/assimilation'

% Set parameters
months = 6000; dt = 1;                                  % 時間
std_x_observation = 4; std_y_observation = 2;           % 觀測
std_model = [3, 2, 0.5]; num_ensemble = 50;             % 模型
past_state = [60; 25; 2]; now_state = [60; 25; 2];      % 初始狀態

% 真值
truth = zeros(3, months);
truth(:, 1) = now_state;
for i = 2: months
    if i >= 3, past_state(1) = truth(1, i - 2)'; else, past_state(1) = now_state(1); end
    if i >= 20
        past_state(2) = truth(2, i - 19)';
        past_state(3) = truth(3, i - 19)';
    else
        past_state(2) = now_state(2);
        past_state(3) = now_state(3);
    end
    truth(:, i) = max(0, lotka_volterra(i, truth(:, i - 1), past_state, dt));
end

% 觀測值
observation = zeros(2, months);
observation(1, :) = truth(1, :) + randn(1, months) * std_x_observation;
observation(2, :) = truth(2, :) + randn(1, months) * std_y_observation;

% 純模型
model = zeros(num_ensemble, 3, months);
model(:, 1, 1) = truth(1, 1) + randn(num_ensemble, 1) * std_model(1);
model(:, 2, 1) = truth(2, 1) + randn(num_ensemble, 1) * std_model(2);
model(:, 3, 1) = truth(3, 1) + randn(num_ensemble, 1) * std_model(3);
for i = 2: months
    for j = 1: num_ensemble
        now_state = model(j, :, 1);
        if i >= 3, past_state(1) = model(j, 1, i - 2)'; else, past_state(1) = now_state(1); end
        if i >= 20
            past_state(2) = model(j, 2, i - 19)';
            past_state(3) = model(j, 3, i - 19)';
        else
            past_state(2) = now_state(2);
            past_state(3) = now_state(3);
        end
        model(j, :, i) = lotka_volterra(i, model(j, :, i - 1), past_state, dt);
    end
end
model_avg = squeeze(mean(model, 1));

% EnKF
R = diag([std_x_observation^2 std_y_observation^2]); H = [1 0 0; 0 1 0];
wenkf = zeros(num_ensemble, 3, months);
wenkf(:, :, 1) = enkf(model(:, :, 1), observation(:, 1), R, H);
for i = 2: months
    for j = 1: num_ensemble
        now_state = model(j, :, 1);
        if i >= 3, past_state(1) = wenkf(j, 1, i - 2)'; else, past_state(1) = now_state(1); end
        if i >= 20
            past_state(2) = wenkf(j, 2, i - 19)';
            past_state(3) = wenkf(j, 3, i - 19)';
        else
            past_state(2) = now_state(2);
            past_state(3) = now_state(3);
        end
        wenkf(j, :, i) = lotka_volterra(i, wenkf(j, :, i - 1), past_state, dt);
    end
    if mod(i, 12) == 0
        wenkf(:, :, i) = enkf(wenkf(:, :, i), observation(:, i), R, H);
    end
end
enkf_avg = squeeze(mean(wenkf, 1));

% EnKS
wenks = zeros(num_ensemble, 3, months);
wenks(:, :, months) = wenkf(:, :, months);
for i = months - 1: -1: 1
    wenks(:, :, i) = rts(wenkf(:, :, i), wenks(:, :, i + 1), wenkf(:, :, i + 1));
end
enks_avg = squeeze(mean(wenks, 1));

% Plot results
t = 0: 1: months - 1;

figure; grid on; hold on;
plot(t, truth(1, :));
plot(t, model_avg(1, :));
plot(t, enkf_avg(1, :));
plot(t, enks_avg(1, :));
for i = 1: months
    if mod(i, 12) == 0, scatter(i, observation(1, i), 'green', 'Marker', '.'); end
end
xlabel('Time (Month)')
ylabel('Number of Rabbits (Count)')
legend('Model Truth', 'Model Only', 'EnKF', 'EnKS', 'Observation')
title('3 Speices Model (Rabbits)')

figure; grid on; hold on;
plot(t, truth(2, :));
plot(t, model_avg(2, :));
plot(t, enkf_avg(2, :));
plot(t, enks_avg(2, :));
for i = 1: months
    if mod(i, 12) == 0, scatter(i, observation(2, i), 'green', 'Marker', '.'); end
end
xlabel('Time (Month)')
ylabel('Number of Foxes (Count)')
legend('Model Truth', 'Model Only', 'EnKF', 'EnKS', 'Observation')
title('3 Speices Model (Foxes)')

figure; grid on; hold on;
plot(t, truth(3, :));
plot(t, model_avg(3, :));
plot(t, enkf_avg(3, :));
plot(t, enks_avg(3, :));
xlabel('Time (Month)')
ylabel('Number of Bears (Count)')
legend('Model Truth', 'Model Only', 'EnKF', 'EnKS')
title('3 Speices Model (Bears)')

figure; hold on; grid on;
plot3(truth(1, :), truth(2, :), truth(3, :));
plot3(model_avg(1, :), model_avg(2, :), model_avg(3, :));
plot3(enkf_avg(1, :), enkf_avg(2, :), enkf_avg(3, :));
plot3(enks_avg(1, :), enks_avg(2, :), enks_avg(3, :));
view(3);
xlabel('Number of Rabbits (Count)')
ylabel('Number of Foxes (Count)')
zlabel('Number of Bears (Count)')
legend('Model Truth', 'Model Only', 'EnKF', 'EnKS')
title('3 Speices Model Trajectory')