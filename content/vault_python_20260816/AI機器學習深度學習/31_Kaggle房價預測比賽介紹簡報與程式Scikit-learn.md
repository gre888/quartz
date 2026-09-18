以下我直接依照你上傳的 Notebook 內容，整理成一份可以拿來**上課複習、Kaggle 實作、Scikit-learn / ITS 考試準備**的完整筆記。

> **這份整理以 Notebook 實際程式與輸出為主**。其中 Notebook 有幾個「註解寫的預期結果」和「實際執行結果」不同，我會特別標出，避免你考試時混淆。

# Kaggle 房價預測＋Scikit-learn 完整重點

## 一、先理解整個 Kaggle 題目的本質

這份 Notebook 使用的是 Kaggle 經典的：

**House Prices: Advanced Regression Techniques**

目標：

> 根據房屋的各種特徵，預測房屋售價 `SalePrice`。

例如：

|特徵|意義|
|---|---|
|OverallQual|房屋整體品質|
|GrLivArea|地上居住面積|
|YearBuilt|建造年份|
|TotalBsmtSF|地下室總面積|
|GarageArea|車庫面積|
|FullBath|完整浴室數|
|Neighborhood|社區|
|SalePrice|房屋售價|

其中：

```text
X = 房屋特徵
        ↓
Machine Learning Model
        ↓
Y = SalePrice
```

因此這是一個：

# **監督式學習 → 迴歸 Regression**

不是分類。

---

# 二、為什麼是「迴歸」？

這是非常重要的考試觀念。

## Classification 分類

預測的是「類別」。

例如：

```text
垃圾郵件 / 非垃圾郵件
男 / 女
貓 / 狗
會買 / 不會買
```

輸出通常是：

```text
0 / 1
A / B / C
```

---

## Regression 迴歸

預測的是「連續數值」。

例如：

```text
房價 = 250000
股價 = 185.32
氣溫 = 28.5
薪資 = 52000
```

房價：

```text
SalePrice = 208500
```

是一個數值，因此：

> **房價預測 = Regression**

---

# 三、Notebook 整體流程

這份 Notebook 可以濃縮成：

```text
① import 套件
      ↓
② 讀取 train.csv / test.csv
      ↓
③ 分離 Id 與 SalePrice
      ↓
④ SalePrice log1p
      ↓
⑤ train + test 合併
      ↓
⑥ 缺失值處理
      ↓
⑦ 數值偏態處理
      ↓
⑧ Feature Engineering
      ↓
⑨ One-Hot Encoding
      ↓
⑩ 建立多種 Regression Model
      ↓
⑪ 5-Fold Cross Validation
      ↓
⑫ 比較 RMSE
      ↓
⑬ GridSearchCV 調參
      ↓
⑭ 選模型
      ↓
⑮ fit 全部 train
      ↓
⑯ predict test
      ↓
⑰ expm1 還原價格
      ↓
⑱ 建立 submission.csv
      ↓
⑲ Kaggle 上傳
```

這一張流程圖非常值得記。

---

# 四、資料讀取

Notebook：

```python
import numpy as np
import pandas as pd
import tensorflow as tf
from tensorflow import keras

np.random.seed(42)
tf.random.set_seed(42)

train = pd.read_csv('train.csv')
test = pd.read_csv('test.csv')
```

---

## `pd.read_csv()`

用途：

> 讀取 CSV 檔案成為 Pandas DataFrame。

例如：

```python
train = pd.read_csv('train.csv')
```

就是把：

```text
train.csv
```

讀進：

```text
train
```

---

# 五、`shape` 是什麼？

Notebook：

```python
print(train.shape, test.shape)
```

結果：

```text
(1460, 81) (1459, 80)
```

意思：

### train

```text
1460 rows
81 columns
```

### test

```text
1459 rows
80 columns
```

為什麼 train 比 test 多一欄？

因為：

```text
train 有 SalePrice
test 沒有 SalePrice
```

---

# 六、`Id` 與 Target

Notebook：

```python
train_id = train['Id']
test_id = test['Id']
```

把 ID 保存起來。

接著：

```python
y = np.log1p(train.pop('SalePrice'))
```

這一行非常重要。

---

## `SalePrice` 是 Target

Machine Learning：

```text
Features X
       ↓
   Model
       ↓
Target y
```

本題：

```text
X = 房屋特徵
y = SalePrice
```

所以：

```python
y = train['SalePrice']
```

概念上就是：

> 把房價當成模型要預測的答案。

---

# 七、為什麼使用 `pop()`？

Notebook：

```python
train.pop('SalePrice')
```

`pop()` 不只是取得欄位，它還會：

> **取得欄位，同時從原 DataFrame 移除該欄位。**

例如：

```python
y = train.pop('SalePrice')
```

相當於：

```text
SalePrice → y
```

同時：

```text
train 裡面不再有 SalePrice
```

這很重要，因為模型訓練時不能把答案本身當作 Feature。

---

# 八、為什麼 `SalePrice` 要 `log1p()`？

Notebook：

```python
y = np.log1p(train.pop('SalePrice'))
```

也就是：

```text
log1p(x) = log(1+x)
```

例如：

```python
np.log1p(100)
```

等於：

```text
log(101)
```

---

## 為什麼房價要取 Log？

房價資料通常具有：

> **右偏 / skewed distribution**

也就是：

```text
大部分房子價格比較集中
少數豪宅價格非常高
```

造成：

```text
右尾很長
```

取 log 可以讓數值分布比較穩定。

---

## 考試記法

看到：

```python
np.log1p()
```

想到：

> **Log transformation / 對數轉換**

目的通常包括：

- 降低偏態
    
- 壓縮極端值
    
- 讓數值分布比較穩定
    

---

# 九、為什麼最後又使用 `expm1()`？

預測時：

```python
preds_log = best_model.predict(X_test)
```

這時候模型預測的是：

```text
log(1 + SalePrice)
```

所以要還原：

```python
preds = np.expm1(preds_log)
```

因為：

```text
expm1(x) = exp(x) - 1
```

因此：

```text
log1p()
   ↓
模型
   ↓
expm1()
```

就是：

> **先 Log，再反 Log。**

---

# 十、Train + Test 合併

Notebook：

```python
train = train.drop(columns=['Id'])
test = test.drop(columns=['Id'])

n_train = len(train)

full = pd.concat([train, test], axis=0).reset_index(drop=True)
```

結果：

```text
(2919, 79)
```

因為：

```text
1460 + 1459 = 2919
```

---

# 十一、為什麼把 train / test 合併？

主要目的是：

> **讓類別編碼與缺失值處理保持一致。**

例如：

```text
Train:
A
B
C

Test:
A
B
D
```

如果分開做 One-Hot Encoding，很容易產生不同欄位。

合併後：

```text
A
B
C
D
```

再一起：

```python
pd.get_dummies()
```

就能得到一致的 Feature 欄位。

---

# 十二、缺失值 Missing Value

Notebook 首先指定：

```python
none_cols = [
    'Alley',
    'BsmtQual',
    'BsmtCond',
    ...
]
```

然後：

```python
full[none_cols] = full[none_cols].fillna('None')
```

意思：

> 某些欄位的 `NaN` 並不是「資料遺失」，而是代表「沒有這個設施」。

例如：

```text
GarageType = NaN
```

可能代表：

> 沒有車庫。

所以填：

```text
None
```

比直接填：

```text
平均值
```

更合理。

---

# 十三、`fillna()`

考試很常出現。

```python
df['A'].fillna(value)
```

用途：

> 填補缺失值。

例如：

```python
df['Age'] = df['Age'].fillna(df['Age'].median())
```

---

# 十四、Median 與 Mode

Notebook：

```python
num_cols = full.select_dtypes(
    include=['int64', 'float64']
).columns

cat_cols = full.select_dtypes(
    include=['object']
).columns
```

先把資料分成：

```text
數值型 Numeric
類別型 Categorical
```

---

## Numeric

```python
full[c] = full[c].fillna(full[c].median())
```

使用：

> **Median 中位數**

---

## Categorical

```python
full[c] = full[c].fillna(full[c].mode()[0])
```

使用：

> **Mode 眾數**

---

# 十五、為什麼數值資料常用 Median？

因為房價資料可能有：

```text
極端值 / Outlier
```

例如：

```text
100
110
120
130
5000
```

平均值會被 5000 拉高。

但 Median：

```text
120
```

受到極端值影響比較小。

所以：

```text
Numerical → Median
Categorical → Mode
```

是這份 Notebook 的處理方式。

---

# 十六、`select_dtypes()`

這是 Pandas 很重要的函式。

```python
full.select_dtypes(include=['int64', 'float64'])
```

找：

> 數值型欄位

而：

```python
full.select_dtypes(include=['object'])
```

找：

> 字串／類別欄位

---

# 十七、Skew 偏態

Notebook：

```python
from scipy.stats import skew

skewed = full[num_cols].apply(skew)
skewed = skewed[abs(skewed) > 0.75].index
```

意思：

> 找出偏態程度大於 0.75 的數值欄位。

---

## `skew`

用途：

> 衡量資料分布的偏態程度。

大致理解：

```text
skew ≈ 0
→ 分布較對稱

skew > 0
→ 右偏

skew < 0
→ 左偏
```

---

# 十八、對偏態欄位做 Log

Notebook：

```python
full[skewed] = np.log1p(full[skewed])
```

所以這裡又出現：

```python
np.log1p()
```

流程：

```text
找 Numeric
    ↓
計算 skew
    ↓
abs(skew) > 0.75
    ↓
log1p()
```

---

# 十九、Feature Engineering

這是這份 Notebook 很重要的地方。

Feature Engineering：

> **利用原始資料創造更有意義的新特徵。**

---

# 二十、TotalSF

Notebook：

```python
full['TotalSF'] = (
      full['TotalBsmtSF']
    + full['1stFlrSF']
    + full['2ndFlrSF']
)
```

建立：

```text
TotalSF
```

概念：

```text
地下室面積
+
一樓面積
+
二樓面積
=
總面積
```

這就是：

> Feature Engineering

---

# 二十一、HouseAge

```python
full['HouseAge'] = (
    full['YrSold']
    - full['YearBuilt']
)
```

意思：

```text
房屋出售年份
-
建造年份
=
房屋年齡
```

例如：

```text
YrSold = 2010
YearBuilt = 2000

HouseAge = 10
```

---

# 二十二、RemodAge

```python
full['RemodAge'] = (
    full['YrSold']
    - full['YearRemodAdd']
)
```

代表：

> 距離房屋最後翻修有多久。

---

# 二十三、IsRemodeled

```python
full['IsRemodeled'] = (
    full['YearBuilt'] != full['YearRemodAdd']
).astype(int)
```

如果：

```text
YearBuilt != YearRemodAdd
```

表示曾經翻修。

轉成：

```text
True → 1
False → 0
```

---

# 二十四、`astype(int)`

非常常考。

```python
.astype(int)
```

用途：

> 把資料型態轉換成整數。

例如：

```text
True
False
```

變成：

```text
1
0
```

---

# 二十五、TotalBath

Notebook：

```python
full['TotalBath'] = (
    full['FullBath']
    + 0.5 * full['HalfBath']
    + full['BsmtFullBath']
    + 0.5 * full['BsmtHalfBath']
)
```

這是「加權 Feature」。

例如：

```text
FullBath = 2
HalfBath = 1
BsmtFullBath = 1
BsmtHalfBath = 0
```

則：

```text
TotalBath
= 2
+ 0.5
+ 1
+ 0
= 3.5
```

---

# 二十六、Ordinal Encoding

Notebook：

```python
qual_map = {
    'Ex':5,
    'Gd':4,
    'TA':3,
    'Fa':2,
    'Po':1,
    'None':0
}
```

這是：

> **Ordinal Encoding / 序位編碼**

因為品質本身有順序：

```text
Ex > Gd > TA > Fa > Po > None
```

轉成：

```text
5 > 4 > 3 > 2 > 1 > 0
```

---

# 二十七、Ordinal Encoding vs One-Hot Encoding

這個很重要。

### Ordinal Encoding

有「順序」：

```text
差 → 普通 → 好 → 非常好
```

可以：

```text
1 → 2 → 3 → 4
```

---

### One-Hot Encoding

沒有自然順序：

```text
Taipei
Taichung
Kaohsiung
```

不能說：

```text
Taipei > Taichung > Kaohsiung
```

所以使用：

```text
0/1 dummy variables
```

---

# 二十八、Binary Features

Notebook：

```python
full['HasPool'] = (full['PoolArea'] > 0).astype(int)
```

如果：

```text
PoolArea > 0
```

則：

```text
HasPool = 1
```

否則：

```text
HasPool = 0
```

---

同樣：

```python
Has2ndFloor
HasGarage
HasFireplace
```

都是：

> **Binary Feature 二元特徵**

---

# 二十九、One-Hot Encoding

Notebook：

```python
cat_cols = full.select_dtypes(
    include=['object']
).columns

full = pd.get_dummies(
    full,
    columns=cat_cols,
    drop_first=True
)
```

---

## `pd.get_dummies()`

用途：

> 把類別資料轉成 0 / 1 的數值欄位。

例如：

```text
Color

Red
Blue
Green
```

可能變成：

```text
Color_Blue
Color_Green
```

---

# 三十、`drop_first=True`

這個很重要。

```python
pd.get_dummies(..., drop_first=True)
```

代表：

> 少保留一個 dummy category。

例如原本：

```text
A
B
C
```

不需要：

```text
A
B
C
```

三個欄位都保留。

可以：

```text
B
C
```

透過「都不是 B / C」知道是 A。

主要可以避免：

> Dummy Variable Trap / 完全共線性問題。

---

# 三十一、Feature 數量變化

Notebook：

```text
(2919, 79)
```

經過 Feature Engineering + One-Hot：

```text
(2919, 237)
```

也就是：

```text
79 features
    ↓
Feature Engineering
    ↓
Categorical Encoding
    ↓
237 features
```

這很正常。

因為一個類別欄位可能被拆成多個 0/1 欄位。

---

# 三十二、建立 Scikit-learn Model

Notebook 使用：

```python
from sklearn.pipeline import Pipeline
from sklearn.linear_model import Ridge, Lasso, ElasticNet
from sklearn.ensemble import RandomForestRegressor
from sklearn.ensemble import GradientBoostingRegressor
from sklearn.preprocessing import RobustScaler
```

這裡有：

```text
Ridge
Lasso
ElasticNet
Random Forest
Gradient Boosting
```

全部都是：

> **Regression**

---

# 三十三、Pipeline

Notebook：

```python
def linear_pipe(model):
    return Pipeline([
        ('scaler', RobustScaler()),
        ('model', model)
    ])
```

Pipeline：

```text
資料
 ↓
Scaler
 ↓
Model
 ↓
Prediction
```

優點：

> 把多個 Machine Learning 步驟串在一起。

---

# 三十四、為什麼 Linear Model 使用 RobustScaler？

Notebook：

```python
RobustScaler()
```

RobustScaler 對：

> **Outlier / 極端值**

比較具有抵抗力。

它主要利用：

```text
Median
IQR
```

進行縮放。

因此房價這類可能有極端值的資料，可以使用 RobustScaler。

---

# 三十五、Ridge Regression

Notebook：

```python
Ridge(alpha=10.0)
```

Ridge 是：

> **L2 Regularization**

概念：

```text
Linear Regression
+
L2 penalty
=
Ridge
```

目的：

> 抑制模型係數過大、降低 Overfitting。

---

# 三十六、Lasso Regression

Notebook：

```python
Lasso(
    alpha=5e-4,
    max_iter=20000,
    random_state=42
)
```

Lasso 是：

> **L1 Regularization**

最大特色：

> 可以讓某些係數變成 0。

因此具有：

> Feature Selection

的效果。

---

# 三十七、ElasticNet

Notebook：

```python
ElasticNet(
    alpha=5e-4,
    l1_ratio=0.9
)
```

ElasticNet：

> **L1 + L2**

所以可以記：

```text
Ridge
→ L2

Lasso
→ L1

ElasticNet
→ L1 + L2
```

---

# 三十八、三種 Linear Regression 考試比較

|Model|Regularization|
|---|---|
|Linear Regression|無|
|Ridge|L2|
|Lasso|L1|
|ElasticNet|L1 + L2|

這張非常重要。

---

# 三十九、Random Forest

Notebook：

```python
RandomForestRegressor(
    n_estimators=500,
    max_depth=15,
    min_samples_leaf=3,
    n_jobs=-1,
    random_state=42
)
```

Random Forest：

> 很多 Decision Trees 組合起來。

概念：

```text
Tree 1
Tree 2
Tree 3
...
Tree 500
   ↓
平均
   ↓
Regression Prediction
```

---

# 四十、`n_estimators`

例如：

```python
n_estimators=500
```

代表：

> 建立 500 棵樹。

通常：

```text
n_estimators 越大
→ 模型計算量越大
```

---

# 四十一、`max_depth`

```python
max_depth=15
```

限制：

> Decision Tree 最大深度。

太深：

```text
容易 Overfitting
```

太淺：

```text
可能 Underfitting
```

---

# 四十二、`min_samples_leaf`

```python
min_samples_leaf=3
```

代表：

> 一個 Leaf 至少需要多少樣本。

可以幫助限制樹過度生長。

---

# 四十三、`n_jobs=-1`

```python
n_jobs=-1
```

通常表示：

> 使用所有可用 CPU 核心進行平行運算。

考試看到：

```python
n_jobs=-1
```

就想到：

> **平行運算 / 使用全部 CPU cores**

---

# 四十四、Gradient Boosting

Notebook：

```python
GradientBoostingRegressor(
    n_estimators=3000,
    learning_rate=0.02,
    max_depth=4,
    subsample=0.8
)
```

Gradient Boosting 的概念：

```text
Model 1
 ↓
找錯誤
 ↓
Model 2 修正
 ↓
找錯誤
 ↓
Model 3 修正
 ↓
...
 ↓
最終模型
```

也就是：

> 後面的模型逐步修正前面模型的錯誤。

---

# 四十五、Random Forest vs Gradient Boosting

非常值得比較。

|Random Forest|Gradient Boosting|
|---|---|
|Bagging 類型|Boosting 類型|
|多棵樹獨立建立|樹依序建立|
|降低 Variance|強調修正錯誤|
|可以平行|主要具有序列性|
|不需要 Scaler|不需要 Scaler|

這份 Notebook 特別寫了：

```python
# Tree 不需要 scaler
```

所以：

```text
Ridge / Lasso / ElasticNet
→ RobustScaler

RF / GBR
→ 不需要 scaler
```

---

# 四十六、Cross Validation

Notebook：

```python
from sklearn.model_selection import KFold, cross_val_score
```

建立：

```python
kf = KFold(
    n_splits=5,
    shuffle=True,
    random_state=42
)
```

這就是：

# **5-Fold Cross Validation**

---

# 四十七、什麼是 K-Fold？

假設：

```text
全部資料
████████████████████
```

切成 5 份：

```text
① ② ③ ④ ⑤
```

第一次：

```text
Test: ①
Train: ②③④⑤
```

第二次：

```text
Test: ②
Train: ①③④⑤
```

一直到：

```text
Test: ⑤
Train: ①②③④
```

最後得到：

```text
5 個分數
```

再計算：

```text
Mean
Std
```

---

# 四十八、為什麼要 Cross Validation？

不要只切一次：

```text
Train
Test
```

因為一次切分可能剛好：

```text
資料太簡單
```

或：

```text
資料太難
```

Cross Validation 可以讓模型評估更穩定。

---

# 四十九、`shuffle=True`

```python
shuffle=True
```

代表：

> 在切 Fold 前先打亂資料。

---

# 五十、`random_state=42`

```python
random_state=42
```

用途：

> 固定隨機結果，使實驗具有可重現性。

這也是考試常見觀念。

---

# 五十一、RMSE

Notebook：

```python
scoring='neg_root_mean_squared_error'
```

RMSE：

# Root Mean Squared Error

公式概念：

RMSE=1n∑(yi−y^i)2RMSE = \sqrt{ \frac{1}{n} \sum(y_i-\hat y_i)^2 }

其中：

```text
y_i
= 真實值

ŷ_i
= 預測值
```

---

# 五十二、RMSE 越高越好還是越低越好？

答案：

# **越低越好**

因為：

```text
RMSE = 預測誤差
```

誤差越小：

```text
模型越接近真實值
```

---

# 五十三、為什麼 Scikit-learn 使用 `neg_root_mean_squared_error`？

Notebook：

```python
scoring='neg_root_mean_squared_error'
```

這是很多人第一次看到會困惑的地方。

Scikit-learn 的 scoring API 有「越高越好」的設計，因此 error 類指標會用：

```text
negative error
```

所以：

```text
-0.12
-0.13
-0.14
```

如果比較 scoring：

```text
-0.12 > -0.13 > -0.14
```

但是轉回真正 RMSE：

```text
0.12
0.13
0.14
```

真正 RMSE：

> **越低越好**

Notebook：

```python
return -neg_mse
```

就是把它轉回正值。

---

# 五十四、Notebook 實際 Cross Validation 結果

實際執行輸出：

```text
ridge   0.1316 ± 0.0199
lasso   0.1313 ± 0.0191
elnet   0.1315 ± 0.0188
rf      0.1437 ± 0.0176
gbr     0.1276 ± 0.0186
```

這裡一定要注意：

**這才是 Notebook 實際執行得到的結果。**

因此這一次：

```text
GBR → 0.1276
Lasso → 0.1313
ElasticNet → 0.1315
Ridge → 0.1316
RF → 0.1437
```

RMSE 是：

> 越低越好。

---

# 五十五、Notebook 的「預期輸出」與實際輸出不同

原 Notebook 註解寫：

```text
ridge   0.1217
lasso   0.1208
elnet   0.1212
rf      0.1402
gbr     0.1228
```

但實際執行：

```text
ridge   0.1316
lasso   0.1313
elnet   0.1315
rf      0.1437
gbr     0.1276
```

因此複習時：

> **以實際執行輸出為準。**

---

# 五十六、GridSearchCV

Notebook：

```python
from sklearn.model_selection import GridSearchCV
```

建立：

```python
grid = GridSearchCV(
    linear_pipe(
        Lasso(
            max_iter=20000,
            random_state=42
        )
    ),
    param_grid={
        'model__alpha': [
            1e-4,
            3e-4,
            5e-4,
            1e-3,
            3e-3
        ]
    },
    scoring='neg_root_mean_squared_error',
    cv=kf,
    n_jobs=-1
)
```

---

# 五十七、GridSearchCV 是做什麼？

一句話：

> **自動嘗試不同參數組合，找出最佳參數。**

這叫：

# Hyperparameter Tuning

---

# 五十八、這裡調的是什麼？

Lasso：

```python
alpha
```

測試：

```text
0.0001
0.0003
0.0005
0.001
0.003
```

最後：

```text
best alpha = 0.001
```

---

# 五十九、`model__alpha` 為什麼有兩個底線？

這是 Pipeline 的重要語法。

Pipeline：

```python
Pipeline([
    ('scaler', RobustScaler()),
    ('model', Lasso())
])
```

模型名字叫：

```text
model
```

模型參數：

```text
alpha
```

所以 GridSearchCV：

```python
model__alpha
```

意思：

```text
Pipeline 裡面的 model
        ↓
它的 alpha
```

記法：

```text
step名稱__參數名稱
```

---

# 六十、Notebook 實際 GridSearch 結果

```text
best alpha = {'model__alpha': 0.001}
best CV    = 0.1308
```

所以：

```text
Lasso alpha
原本 = 0.0005
GridSearch = 0.001
```

---

# 六十一、Submission

Notebook：

```python
best_model = models['lasso']
```

選擇 Lasso。

然後：

```python
best_model.fit(X_train, y_train)
```

意思：

> 用全部 Training Data 訓練模型。

---

# 六十二、`fit()`

Machine Learning 最重要的函式之一：

```python
model.fit(X_train, y_train)
```

意思：

> **訓練模型。**

---

# 六十三、`predict()`

```python
preds_log = best_model.predict(X_test)
```

意思：

> 使用已訓練好的模型對 Test Data 預測。

所以：

```text
fit()
→ 訓練

predict()
→ 預測
```

這兩個一定要會。

---

# 六十四、還原房價

模型輸出：

```text
log(SalePrice + 1)
```

因此：

```python
preds = np.expm1(preds_log)
```

還原成：

```text
SalePrice
```

---

# 六十五、`np.clip()`

Notebook：

```python
preds = np.clip(
    preds,
    a_min=1.0,
    a_max=None
)
```

意思：

> 最低限制為 1。

避免預測出：

```text
0
```

或：

```text
負數
```

---

# 六十六、建立 Submission

```python
sub = pd.DataFrame({
    'Id': test_id,
    'SalePrice': preds,
})
```

建立：

```text
Id
SalePrice
```

兩欄。

然後：

```python
sub.to_csv(
    'submission.csv',
    index=False
)
```

輸出：

```text
submission.csv
```

---

# 六十七、為什麼 `index=False`？

如果不寫：

```python
index=False
```

Pandas 可能把 DataFrame index 也輸出成一欄。

Kaggle submission 通常不需要這個 index。

所以：

```python
to_csv(..., index=False)
```

代表：

> 不輸出 DataFrame index。

---

# 六十八、健全性檢查

Notebook：

```python
assert sub.shape == (1459, 2)
assert sub['SalePrice'].notna().all()
assert (sub['SalePrice'] > 0).all()
```

---

## `assert`

用途：

> 檢查條件是否成立。

如果：

```python
assert True
```

正常。

如果：

```python
assert False
```

會產生：

```text
AssertionError
```

---

# 六十九、三個檢查

### ① Shape

```python
assert sub.shape == (1459, 2)
```

確認：

```text
1459 rows
2 columns
```

---

### ② 沒有 NaN

```python
sub['SalePrice'].notna().all()
```

確認：

> 所有價格都有值。

---

### ③ 全部大於 0

```python
(sub['SalePrice'] > 0).all()
```

確認：

> 沒有負數或 0。

---

# 七十、Notebook 的實際 Submission

前幾筆：

```text
Id      SalePrice
1461    112458.23
1462    154505.87
1463    179377.66
1464    196513.97
1465    205161.12
```

最後：

```text
rows = 1459
mean = 177,915
```

所以 Submission 有：

```text
1459 筆
```

---

# 七十一、Stacking

Notebook 接著使用：

```python
from sklearn.ensemble import StackingRegressor
```

Stacking 是：

> **把多個不同模型的預測，再交給另一個模型做最後組合。**

---

# 七十二、Stacking 結構

Notebook：

```text
Lasso
ElasticNet
GBR
RF
   ↓
Base Models
   ↓
預測結果
   ↓
Ridge
   ↓
Final Prediction
```

其中：

```python
final_estimator=Ridge(alpha=1.0)
```

Ridge 就是：

> Meta Model / Final Estimator

---

# 七十三、為什麼要 Stacking？

不同模型可能擅長不同事情。

例如：

```text
Lasso
→ 線性關係

GBR
→ 非線性關係

RF
→ Tree-based pattern

ElasticNet
→ Regularized linear model
```

把它們組合起來：

> 有機會利用不同模型的優勢。

---

# 七十四、OOF

Notebook：

```python
cv=kf
```

Stacking 會利用 Cross Validation 產生：

> **Out-of-Fold predictions（OOF）**

概念：

```text
Fold 1 → 預測 Fold 1
Fold 2 → 預測 Fold 2
...
Fold 5 → 預測 Fold 5
```

這些預測提供給：

```text
Meta Model
```

訓練。

---

# 七十五、這份 Notebook 的 Stacking 實際結果

原註解寫：

```text
stacking 0.1154 ± 0.0124
```

但是實際執行：

```text
stacking 0.1243 ± 0.0205
```

所以複習時：

> **實際結果是 0.1243 ± 0.0205。**

---

# 七十六、Stacking 為什麼非常慢？

這份 Notebook：

```text
Lasso
ElasticNet
GBR
RF
```

再加：

```text
5-Fold CV
```

Stacking 需要反覆訓練 Base Models。

尤其：

```python
gbr
n_estimators=3000
```

還有：

```python
rf
n_estimators=500
```

所以計算量很大。

Notebook 實際還出現：

```text
KeyboardInterrupt
```

表示：

> 執行時間太久，被中斷。

這不是 Python 語法錯誤。

而是：

> **計算時間／資源問題。**

---

# 七十七、進階 Stacking

Notebook 後面加入：

```python
from lightgbm import LGBMRegressor
from xgboost import XGBRegressor
```

因此模型更多：

```text
Lasso
ElasticNet
GBR
XGBoost
LightGBM
```

---

# 七十八、XGBoost

Notebook：

```python
xgb_model = XGBRegressor(
    max_depth=3,
    learning_rate=0.02,
    n_estimators=2200,
    subsample=0.7,
    colsample_bytree=0.7,
    random_state=42,
    n_jobs=-1
)
```

XGBoost：

> **Extreme Gradient Boosting**

屬於：

> Gradient Boosting Tree 家族。

---

# 七十九、LightGBM

Notebook：

```python
lgb_model = LGBMRegressor(
    objective='regression',
    num_leaves=6,
    learning_rate=0.03,
    n_estimators=1500,
    max_depth=4,
    feature_fraction=0.2,
    bagging_fraction=0.8,
    bagging_freq=5
)
```

LightGBM：

> Microsoft 開發的 Gradient Boosting framework。

也是：

> Tree-based boosting model。

---

# 八十、XGBoost / LightGBM 在這份課程中要怎麼理解？

先不要背非常複雜的數學。

記：

```text
Random Forest
→ 很多 Tree 平行組合

Gradient Boosting
→ Tree 一棵一棵修正錯誤

XGBoost
→ 強化版 Gradient Boosting

LightGBM
→ 高效率 Gradient Boosting
```

---

# 八十一、XGBoost / LightGBM 與房價預測

房價通常存在大量：

```text
非線性關係
```

例如：

```text
房屋品質 ↑
+
面積 ↑
+
地段好
+
車庫
+
翻修
```

不是單純：

```text
房價 = 面積 × 固定價格
```

可能存在：

```text
OverallQual × GrLivArea
```

這種交互關係。

Tree Boosting 對這種：

> **非線性 + Feature Interaction**

通常很有用。

---

# 八十二、進階 Feature Engineering

Notebook：

```python
full_opt['TotalSF_x_OverallQual'] = (
    full_opt['TotalSF']
    * full_opt['OverallQual']
)
```

這就是：

# Interaction Feature

意思：

```text
總面積 × 房屋品質
```

---

另外：

```python
full_opt['Neighborhood_Rich'] = (
    full_opt['OverallQual']
    * full_opt['GrLivArea']
)
```

也是：

> 特徵交互作用。

---

# 八十三、Interaction Feature 是什麼？

原本：

```text
X1
X2
```

創造：

```text
X1 × X2
```

例如：

```text
面積 × 品質
```

模型就可以更容易學到：

> 「大房子 + 高品質」的共同效果。

---

# 八十四、bool 轉 float

Notebook：

```python
if full_opt[col].dtype == 'bool':
    full_opt[col] = full_opt[col].astype(float)
```

目的：

> 確保所有 Feature 都是數值型態。

例如：

```text
True
False
```

轉成：

```text
1.0
0.0
```

---

# 八十五、進階 Stacking 結果

Notebook 實際輸出：

```text
優化後的 Stacking CV RMSE:
0.1249 ± 0.0195
```

並成功產生：

```text
submission_optimized_stacking.csv
```

---

# 八十六、注意：Notebook 並不是「越複雜一定越好」

這份 Notebook 很適合讓你理解一件事：

```text
模型越多
≠
一定越準
```

實際結果：

```text
GBR
0.1276

一般 Stacking
0.1243

進階 Stacking
0.1249
```

所以增加：

```text
XGBoost
LightGBM
```

並沒有在這次 CV 中讓結果優於：

```text
一般 Stacking
```

而且計算成本更高。

---

# 八十七、Notebook 的模型比較

依照**實際 Notebook 輸出**：

|模型|CV RMSE|Std|
|---|--:|--:|
|Ridge|0.1316|0.0199|
|Lasso|0.1313|0.0191|
|ElasticNet|0.1315|0.0188|
|Random Forest|0.1437|0.0176|
|Gradient Boosting|0.1276|0.0186|
|Stacking|0.1243|0.0205|
|Optimized Stacking|0.1249|0.0195|

**注意：這只是這份 Notebook、這組前處理與參數下的 CV 結果，不代表這些模型在所有資料集都具有相同表現。**

---

# 八十八、Scikit-learn 必背 API

這份 Notebook 裡面最重要的 Scikit-learn：

```python
Pipeline
Ridge
Lasso
ElasticNet
RandomForestRegressor
GradientBoostingRegressor
RobustScaler
KFold
cross_val_score
GridSearchCV
StackingRegressor
```

---

# 八十九、Scikit-learn 最重要的共同介面

幾乎所有模型都：

```python
model.fit(X_train, y_train)
```

訓練。

然後：

```python
model.predict(X_test)
```

預測。

所以：

```text
fit()
→ Learn

predict()
→ Predict
```

---

# 九十、完整 Machine Learning 架構

可以把整份 Notebook 記成：

```text
                 Data
                  │
                  ▼
          ┌───────────────┐
          │ Preprocessing │
          └───────────────┘
                  │
       ┌──────────┼──────────┐
       ▼          ▼          ▼
   Missing     Scaling     Encoding
   Values                  One-Hot
       │          │          │
       └──────────┼──────────┘
                  ▼
       Feature Engineering
                  │
                  ▼
              X_train
                  │
                  ▼
        ┌─────────────────┐
        │ Machine Learning│
        │     Models      │
        └─────────────────┘
                  │
          ┌───────┼────────┐
          ▼       ▼        ▼
        Lasso    GBR       RF
          │       │        │
          └───────┼────────┘
                  ▼
         Cross Validation
                  │
                  ▼
             RMSE 評估
                  │
                  ▼
           GridSearchCV
                  │
                  ▼
           最終模型 fit
                  │
                  ▼
             X_test
                  │
                  ▼
             predict()
                  │
                  ▼
              expm1()
                  │
                  ▼
          submission.csv
```

---

# 九十一、ITS 考試最容易考的觀念

## ① `fit()` 是什麼？

> 訓練模型。

---

## ② `predict()` 是什麼？

> 進行預測。

---

## ③ `train_test_split` 用途？

> 將資料分成訓練集與測試集。

---

## ④ KFold 是什麼？

> K-Fold Cross Validation。

---

## ⑤ `n_splits=5`？

> 分成 5 個 Fold。

---

## ⑥ `shuffle=True`？

> 切 Fold 前先打亂資料。

---

## ⑦ `random_state=42`？

> 固定隨機結果，使結果可重現。

---

## ⑧ RMSE 越高越好？

❌ 錯。

> **越低越好。**

---

## ⑨ Ridge 是 L1 還是 L2？

> **L2**

---

## ⑩ Lasso？

> **L1**

---

## ⑪ ElasticNet？

> **L1 + L2**

---

## ⑫ `RobustScaler`？

> 對 Outlier 較具抵抗力的特徵縮放方法。

---

## ⑬ `pd.get_dummies()`？

> One-Hot Encoding。

---

## ⑭ `drop_first=True`？

> 去掉第一個 dummy category。

---

## ⑮ `fillna()`？

> 填補缺失值。

---

## ⑯ `median()`？

> 中位數。

---

## ⑰ `mode()`？

> 眾數。

---

## ⑱ `astype(int)`？

> 轉成整數型態。

---

## ⑲ `astype(float)`？

> 轉成浮點數型態。

---

## ⑳ `np.log1p()`？

> `log(1+x)`。

---

## ㉑ `np.expm1()`？

> `exp(x)-1`，常用來還原 `log1p()`。

---

# 九十二、Linear Model vs Tree Model

這份 Notebook 可以整理成：

|類型|模型|Scaling|
|---|---|---|
|Linear|Ridge|需要|
|Linear|Lasso|需要|
|Linear|ElasticNet|需要|
|Tree|Random Forest|通常不需要|
|Tree|Gradient Boosting|通常不需要|
|Tree Boosting|XGBoost|通常不需要|
|Tree Boosting|LightGBM|通常不需要|

這是非常實用的判斷方式。

---

# 九十三、房價預測為什麼可以用很多不同模型？

因為：

```text
X
↓
SalePrice
```

本質是 Regression。

所以可以嘗試：

```text
Linear Regression
Ridge
Lasso
ElasticNet
Random Forest
Gradient Boosting
XGBoost
LightGBM
Stacking
```

再用：

```text
Cross Validation
```

比較。

---

# 九十四、最重要的「模型選擇」觀念

不要記成：

> 「Lasso 一定最好。」

也不要記成：

> 「XGBoost 一定最好。」

正確觀念：

```text
資料
 ↓
前處理
 ↓
多個模型
 ↓
Cross Validation
 ↓
Metric
 ↓
比較結果
 ↓
選擇適合這次資料與任務的模型
```

也就是：

# **用驗證結果選模型，而不是憑模型名字選。**

---

# 九十五、房價預測的核心公式

整份 Notebook 可以濃縮成：

### 原始目標

SalePriceSalePrice

### 轉換

y=log⁡(1+SalePrice)y=\log(1+SalePrice)

### 模型

X→Model→log⁡(1+SalePrice)X \rightarrow Model \rightarrow \log(1+SalePrice)

### 預測後

SalePrice^=ey^−1\hat{SalePrice} = e^{\hat y}-1

Python：

```python
y = np.log1p(SalePrice)

model.fit(X_train, y)

pred_log = model.predict(X_test)

pred = np.expm1(pred_log)
```

這四段非常值得背。

---

# 九十六、這份 Notebook 最重要的 10 個關鍵字

如果考前只剩幾分鐘，先背：

```text
1. Regression
2. Target
3. Missing Value
4. Feature Engineering
5. One-Hot Encoding
6. Scaling
7. Cross Validation
8. RMSE
9. GridSearchCV
10. Stacking
```

---

# 九十七、考試版一頁速記

```text
Kaggle House Prices
====================

問題：
房價預測 → Regression

Target：
SalePrice

資料：
train = 1460 × 81
test  = 1459 × 80

前處理：
--------------------
Id → 保存後移除
SalePrice → log1p()
Missing Value → fillna()
Numeric → median
Categorical → mode
Skew > 0.75 → log1p()

Feature Engineering：
--------------------
TotalSF
HouseAge
RemodAge
IsRemodeled
TotalBath
HasPool
Has2ndFloor
HasGarage
HasFireplace

Encoding：
--------------------
Ordinal Encoding
One-Hot Encoding
pd.get_dummies()
drop_first=True

Models：
--------------------
Ridge → L2
Lasso → L1
ElasticNet → L1 + L2
Random Forest → Tree Ensemble
Gradient Boosting → Boosting
XGBoost → Gradient Boosting
LightGBM → Gradient Boosting
Stacking → 多模型 + Meta Model

Scaling：
--------------------
Ridge / Lasso / ElasticNet
→ RobustScaler

Tree Models
→ 通常不需要 Scaling

Validation：
--------------------
KFold
n_splits=5
shuffle=True
random_state=42

Metric：
--------------------
RMSE
越低越好

Hyperparameter：
--------------------
GridSearchCV

Pipeline：
--------------------
scaler
   ↓
model

Training：
--------------------
fit()

Prediction：
--------------------
predict()

還原：
--------------------
log1p()
   ↓
model
   ↓
expm1()

Submission：
--------------------
Id
SalePrice

to_csv(..., index=False)
```

---

# 九十八、你這份 Notebook 最值得真正理解的「一條主線」

不要把它當成一堆零散 Python 語法。

真正的思考流程是：

```text
我有房屋資料
       ↓
資料裡有文字、數字、缺失值
       ↓
Machine Learning 不能直接吃這些東西
       ↓
所以我要做 Preprocessing
       ↓
缺失值處理
       ↓
類別轉數字
       ↓
偏態處理
       ↓
Feature Engineering
       ↓
得到 X
       ↓
SalePrice 是 y
       ↓
因為 y 是連續數值
       ↓
所以使用 Regression
       ↓
建立多個 Regression Models
       ↓
用 Cross Validation 評估
       ↓
RMSE 越低越好
       ↓
GridSearchCV 找參數
       ↓
選模型
       ↓
fit 全部 train
       ↓
predict test
       ↓
expm1 還原房價
       ↓
輸出 submission.csv
       ↓
上傳 Kaggle
```

**這才是這份課程最核心的 Machine Learning 思維。**

---

## 最後：把它跟你前面學的「迴歸分析」串起來

你前面整理的迴歸課程，現在可以直接接上這份 Kaggle Notebook：

```text
迴歸 Regression
       │
       ├── Linear Regression
       │       ├── Ridge
       │       ├── Lasso
       │       └── ElasticNet
       │
       ├── Tree Regression
       │       └── Random Forest
       │
       ├── Boosting Regression
       │       ├── Gradient Boosting
       │       ├── XGBoost
       │       └── LightGBM
       │
       └── Ensemble
               └── Stacking
```

所以你現在學到的其實不是「一個 Kaggle 房價程式」，而是一個完整的：

# **資料前處理 → 特徵工程 → 迴歸模型 → Cross Validation → 超參數最佳化 → Ensemble → 預測 → Kaggle Submission**

Machine Learning 實戰流程。