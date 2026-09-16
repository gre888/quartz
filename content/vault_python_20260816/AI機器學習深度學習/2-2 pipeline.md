這一份比前面的 **Step 1～9 資料前處理**更進一步，已經進入完整的 **Machine Learning 機器學習流程**。

你可以把它記成：

> **資料 → 前處理 Pipeline → 模型 → 評估 → 調參 → 比較模型 → 預測 → Kaggle Submission**

下面我用「上課重點＋考試容易考」的方式整理。

---

# Titanic 機器學習完整流程

## 整體流程

```
a. 安裝套件
       ↓
b. 讀取 train / test
       ↓
c. ColumnTransformer 前處理
       ↓
d. Pipeline + Logistic Regression
       ↓
e. 模型評估
       ↓
f. GridSearchCV 調參
       ↓
g. Random Forest
       ↓
h. 最佳 Random Forest 預測
       ↓
i. 產生 Kaggle Submission
```

---

# a. 環境準備與套件安裝

```
pip install pandas numpy scikit-learn
```

三個主要套件：

|套件|用途|
|---|---|
|`pandas`|資料處理|
|`numpy`|數值運算|
|`scikit-learn`|機器學習|

---

# b. 資料讀取與初步檢視

```
import pandas as pd
import numpy as np

train_df = pd.read_csv('train.csv')
test_df = pd.read_csv('test.csv')
```

這裡有兩份資料：

```
train.csv
↓
有答案 Survived
↓
用來訓練模型

test.csv
↓
沒有 Survived
↓
最後拿來預測
```

---

## 查看前五筆

```
print(train_df.head())
```

`head()`：

> 查看前 5 筆資料。

---

## 查看缺失值

```
print(train_df.isnull().sum())
```

記住：

```
isnull()
↓
判斷缺失

sum()
↓
計算數量
```

所以：

```
df.isnull().sum()
```

就是：

> 查看每個欄位有幾個缺失值。

---

# c. ColumnTransformer 建立前處理流程

這一段是整份程式的**核心**。

需要：

```
from sklearn.pipeline import Pipeline
from sklearn.impute import SimpleImputer
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.compose import ColumnTransformer
```

---

# ① 先把欄位分成兩類

## 數值型

```
numeric_features = [
    'Age',
    'Fare',
    'SibSp',
    'Parch'
]
```

這些是數字：

```
Age
Fare
SibSp
Parch
```

---

## 類別型

```
categorical_features = [
    'Pclass',
    'Sex',
    'Embarked'
]
```

這些代表分類資料。

例如：

```
Sex
male / female

Embarked
S / C / Q
```

---

# ② 數值型 Pipeline

```
numeric_transformer = Pipeline(steps=[
    ('imputer', SimpleImputer(strategy='median')),
    ('scaler', StandardScaler())
])
```

這裡有兩個步驟。

### 第一步：補缺失值

```
SimpleImputer(strategy='median')
```

使用：

> **中位數**

補缺失值。

---

### 第二步：標準化

```
StandardScaler()
```

將數值資料進行 Scaling。

所以：

```
數值資料
 ↓
median 補值
 ↓
StandardScaler
```

---

# ③ 類別型 Pipeline

```
categorical_transformer = Pipeline(steps=[
    ('imputer', SimpleImputer(strategy='most_frequent')),
    ('onehot', OneHotEncoder(handle_unknown='ignore'))
])
```

也是兩個步驟。

### 第一步

```
SimpleImputer(strategy='most_frequent')
```

使用：

> **出現最多的值（眾數）**

補缺失值。

---

### 第二步

```
OneHotEncoder(handle_unknown='ignore')
```

把類別資料轉成 One-Hot。

例如：

```
Sex

male
female
```

轉換成類似：

```
Sex_female
Sex_male
```

---

## `handle_unknown='ignore'` 很重要

假設訓練資料有：

```
S
C
Q
```

但測試資料突然出現新的類別。

```
handle_unknown='ignore'
```

可以避免因為未知類別而直接報錯。

---

# ④ ColumnTransformer

```
preprocessor = ColumnTransformer(
    transformers=[
        ('num', numeric_transformer, numeric_features),
        ('cat', categorical_transformer, categorical_features)
    ]
)
```

它的功能就是：

> **不同欄位使用不同的前處理方法。**

可以想成：

```
                    ┌→ median → StandardScaler
Age ────────────────┤
Fare ───────────────┤
SibSp ──────────────┤
Parch ──────────────┘

                    ┌→ most_frequent → OneHotEncoder
Pclass ─────────────┤
Sex ────────────────┤
Embarked ───────────┘
```

---

# ⭐ Pipeline 和 ColumnTransformer 的差別

這個很容易考。

### Pipeline

> **把多個處理步驟串起來。**

例如：

```
numeric_transformer = Pipeline([
    ('imputer', ...),
    ('scaler', ...)
])
```

意思：

```
補值
 ↓
Scaling
```

---

### ColumnTransformer

> **不同欄位使用不同 Pipeline。**

例如：

```
數值欄位
→ numeric_transformer

類別欄位
→ categorical_transformer
```

---

# d. 建立模型與訓練

首先分：

```
X = train_df[numeric_features + categorical_features]
y = train_df['Survived']
```

這兩個是 Machine Learning 最重要的概念。

## X = 特徵

```
Age
Fare
SibSp
Parch
Pclass
Sex
Embarked
```

## y = 答案

```
Survived
```

所以：

```
X → 題目
y → 答案
```

---

# train_test_split

```
X_train, X_val, y_train, y_val = train_test_split(
    X,
    y,
    test_size=0.2,
    random_state=42
)
```

意思：

```
80%
↓
訓練資料

20%
↓
驗證資料
```

---

## `test_size=0.2`

表示：

> 20% 作為驗證集。

---

## `random_state=42`

固定隨機切割結果。

這樣每次執行比較容易得到相同的切分結果。

---

# 建立完整 Pipeline

```
clf = Pipeline(steps=[
    ('preprocessor', preprocessor),
    ('classifier', LogisticRegression(
        random_state=42,
        max_iter=1000
    ))
])
```

這裡非常重要。

整個模型：

```
原始資料
 ↓
preprocessor
 ↓
補缺失值
 ↓
Encoding
 ↓
Scaling
 ↓
LogisticRegression
 ↓
預測
```

---

# `clf.fit()`

```
clf.fit(X_train, y_train)
```

就是：

> **訓練模型。**

模型會使用：

```
X_train
+
y_train
```

學習。

---

# e. 模型評估

首先：

```
y_pred = clf.predict(X_val)
```

意思：

> 使用訓練好的模型，預測驗證資料。

---

# Accuracy

```
accuracy_score(y_val, y_pred)
```

準確率：

```
正確預測數
──────────
全部預測數
```

例如：

```
100 人
預測對 82 人

Accuracy = 82%
```

---

# Classification Report

```
classification_report(y_val, y_pred)
```

通常會看到：

```
precision
recall
f1-score
support
```

### Precision

> 模型預測成某類的人，有多少是真的。

### Recall

> 真正屬於某類的人，有多少被模型抓出來。

### F1-score

Precision 和 Recall 的綜合指標。

---

# Confusion Matrix

```
confusion_matrix(y_val, y_pred)
```

混淆矩陣主要看：

```
               預測
             0      1
實際  0     TN     FP
      1     FN     TP
```

四個重要名稱：

```
TP = True Positive
TN = True Negative
FP = False Positive
FN = False Negative
```

---

# f. GridSearchCV

這一段是在做：

> **參數調校（Hyperparameter Tuning）**

```
from sklearn.model_selection import GridSearchCV
```

---

## param_grid

```
param_grid = {
    'preprocessor__num__imputer__strategy': [
        'mean',
        'median'
    ],

    'classifier__C': [
        0.1,
        1.0,
        10.0
    ],

    'classifier__solver': [
        'lbfgs',
        'liblinear'
    ]
}
```

意思是：

> 把不同參數組合全部拿來試。

---

# ⭐ `__` 雙底線非常重要

例如：

```
'classifier__C'
```

拆開：

```
classifier
   ↓
C
```

因為 Pipeline 裡：

```
('classifier', LogisticRegression())
```

所以：

```
classifier__C
```

就是：

> LogisticRegression 的 `C` 參數。

---

更複雜：

```
'preprocessor__num__imputer__strategy'
```

拆開：

```
preprocessor
    ↓
num
    ↓
imputer
    ↓
strategy
```

也就是：

> ColumnTransformer → 數值 Pipeline → imputer → strategy

---

# GridSearchCV

```
grid_search = GridSearchCV(
    clf,
    param_grid,
    cv=5,
    scoring='accuracy'
)
```

### `cv=5`

代表：

> **5-Fold Cross Validation**

把資料分成 5 份：

```
① ② ③ ④ ⑤
```

輪流：

```
4份訓練
1份驗證
```

重複 5 次。

最後得到平均分數。

---

# `best_params_`

```
grid_search.best_params_
```

取得：

> 最佳參數組合。

---

# `best_score_`

```
grid_search.best_score_
```

取得：

> GridSearchCV 找到的最佳交叉驗證分數。

---

# ⭐ g. RandomForestClassifier

接下來換另一種模型：

```
from sklearn.ensemble import RandomForestClassifier
```

建立：

```
rf_clf = Pipeline(steps=[
    ('preprocessor', preprocessor),
    ('classifier', RandomForestClassifier(random_state=42))
])
```

結構：

```
資料
 ↓
Preprocessing
 ↓
Random Forest
 ↓
預測
```

---

# Random Forest 是什麼？

Random Forest：

> **由很多棵 Decision Tree 組成的模型。**

可以想成：

```
             Decision Tree 1
            /
資料 →      Decision Tree 2
            \
             Decision Tree 3
            ...
             Decision Tree 100
                    ↓
                 綜合結果
```

---

# Random Forest 重要參數

## `n_estimators`

```
'n_estimators': [100, 200, 300]
```

代表：

> 樹的數量。

例如：

```
100 棵
200 棵
300 棵
```

---

## `max_depth`

```
'max_depth': [None, 10, 20]
```

代表：

> 每棵樹最大的深度。

---

## `min_samples_leaf`

```
'min_samples_leaf': [1, 2, 4]
```

代表：

> 一個 Leaf 最少需要多少筆資料。

---

# Random Forest GridSearch

```
rf_grid_search = GridSearchCV(
    rf_clf,
    rf_param_grid,
    cv=5,
    scoring='accuracy',
    n_jobs=-1,
    verbose=1
)
```

### `n_jobs=-1`

非常重要：

> 使用所有可用的 CPU 核心進行運算。

因此 GridSearch 通常會比較快。

---

### `verbose=1`

控制輸出訊息的詳細程度。

```
verbose 越大
↓
顯示越多執行進度
```

---

# h. 最佳 Random Forest

```
best_rf_model = rf_grid_search.best_estimator_
```

意思：

> 取得 GridSearchCV 找到的最佳 Random Forest Pipeline。

然後：

```
test_rf_predictions = best_rf_model.predict(X_test)
```

對測試資料進行預測。

---

你貼的程式這一段順序有錯：

```
rf_submission = pd.DataFrame({
    'PassengerId': test_df['PassengerId'],
    'Survived': test_rf_predictions
})
```

但是 `test_rf_predictions` 在前面才出現。

正確順序應該是：

```
X_test = test_df[numeric_features + categorical_features]

test_rf_predictions = best_rf_model.predict(X_test)

rf_submission = pd.DataFrame({
    'PassengerId': test_df['PassengerId'],
    'Survived': test_rf_predictions
})

rf_submission.to_csv(
    'submission_rf.csv',
    index=False
)
```

---

# i. Kaggle Submission

最後：

```
best_model = grid_search.best_estimator_
```

取得 Logistic Regression 的最佳模型。

---

## 準備 Test

```
X_test = test_df[
    numeric_features + categorical_features
]
```

---

## 預測

```
test_predictions = best_model.predict(X_test)
```

---

## 建立 Submission

```
submission = pd.DataFrame({
    'PassengerId': test_df['PassengerId'],
    'Survived': test_predictions
})
```

形成：

```
PassengerId    Survived
1              0
2              1
3              1
4              1
...
```

---

## 匯出

```
submission.to_csv(
    'submission.csv',
    index=False
)
```

產生：

```
submission.csv
```

這個檔案就是拿去 Kaggle 提交的檔案。

---

# ⭐ 這一章最重要的觀念

你可以把整章濃縮成：

```
X = 題目
y = 答案

Pipeline
↓
把「前處理 + 模型」串起來

ColumnTransformer
↓
不同欄位使用不同前處理

SimpleImputer
↓
補缺失值

StandardScaler
↓
數值標準化

OneHotEncoder
↓
類別 → 0/1 特徵

LogisticRegression
↓
分類模型

RandomForestClassifier
↓
多棵決策樹組成的分類模型

GridSearchCV
↓
自動搜尋最佳參數

Cross Validation
↓
交叉驗證

best_params_
↓
最佳參數

best_score_
↓
最佳 CV 分數

best_estimator_
↓
最佳模型

predict()
↓
預測

to_csv()
↓
輸出 Kaggle Submission
```

---

# ⭐ 特別要記：兩層 Pipeline

這是這份程式最容易搞混的地方。

```
ColumnTransformer
│
├── num
│   └── Pipeline
│       ├── SimpleImputer
│       └── StandardScaler
│
└── cat
    └── Pipeline
        ├── SimpleImputer
        └── OneHotEncoder
```

最後再包一次：

```
完整 Pipeline
│
├── preprocessor
│   └── ColumnTransformer
│
└── classifier
    └── LogisticRegression
```

所以整體就是：

```
                 ┌─ 數值 → 補值 → Scaling ─┐
原始資料 → preprocessor                     ├→ classifier → 預測
                 └─ 類別 → 補值 → OneHot ──┘
```

這就是為什麼參數名稱會長成：

```
preprocessor__num__imputer__strategy
```

以及：

```
classifier__C
```

**雙底線 `__` 就是在 Pipeline / ColumnTransformer 裡面「往下一層找參數」。**

---

## 最後一張「考試速記表」

|程式|意思|
|---|---|
|`X`|特徵|
|`y`|目標/答案|
|`fit()`|學習/訓練|
|`predict()`|預測|
|`Pipeline`|把多個處理步驟串起來|
|`ColumnTransformer`|不同欄位使用不同處理|
|`SimpleImputer`|補缺失值|
|`median`|中位數|
|`most_frequent`|眾數|
|`StandardScaler`|標準化|
|`OneHotEncoder`|類別編碼|
|`LogisticRegression`|邏輯斯迴歸分類|
|`RandomForestClassifier`|隨機森林分類|
|`train_test_split`|切訓練/驗證資料|
|`GridSearchCV`|搜尋最佳參數|
|`cv=5`|5-fold 交叉驗證|
|`best_params_`|最佳參數|
|`best_score_`|最佳 CV 分數|
|`best_estimator_`|最佳模型|
|`accuracy`|準確率|
|`classification_report`|Precision / Recall / F1|
|`confusion_matrix`|混淆矩陣|
|`n_jobs=-1`|使用所有 CPU|
|`to_csv()`|輸出 CSV|

**一句話記憶：**

> **ColumnTransformer 負責「怎麼整理資料」，Pipeline 負責「把整理資料和模型串起來」，GridSearchCV 負責「找參數」，`predict()` 負責「做預測」，`to_csv()` 負責「產生提交檔」。**