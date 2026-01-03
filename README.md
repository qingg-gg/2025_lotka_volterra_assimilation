## Lotka-Volterra 方程式模擬
這個專案針對 Lotka-Volterra 方程式進行部分參數的更動、擴充後進行模擬，同時透過 EnKF 與 EnKS 進行資料同化。
本專案作為大氣資料同化導論之期末報告使用，展示課程所學的資料同化理論與技術。

### 專案結構
```
└─ src/     
  ├─ model                      模型
  │ ├─ growth_rate_rabbit.m     兔子的自然增長率
  │ ├─ growth_rate_fox.m        狐狸的轉化率
  │ ├─ growth_rate_bear.m       棕熊的轉化率
  │ ├─ environment_capacity.m   環境負載力
  │ └─ lotka_volterra.m         更動後的 Lotka-Volterra 方程式
  ├─ assimilation               資料同化
  │ └─ enkf.m                   Stochastic EnKF
  │ └─ rts.m                    RTS Smoother
  └─ main.m                 程式切入點
```

### 技術說明
待補。

### 快速執行
- Clone 此專案後，使用 Matlab 開啟 .prj 檔，並可以執行 main.m 得到結果。
- main.m 中可以修改觀測與模型運行的資訊（如觀測誤差、模型誤差、實驗時長）。
- model 中可以修改個別物種的參數（如捕獲率、自然死亡率）。

### License
本專案僅供課程報告使用。