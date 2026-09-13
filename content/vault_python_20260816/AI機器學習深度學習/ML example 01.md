


###################################################
Part 1：分類預測購買與否  (分類目標是標籤：會 / 不會)
###################################################
import pandas as pd    #pandas 用來處理表格資料，像 Excel / CSV
import numpy as np		#numpy 用來做數值運算
from sklearn.model_selection import train_test_split	#	這個函式用來把資料切成：訓練資料 測試資料	
from sklearn.preprocessing import OneHotEncoder, StandardScaler	#StandardScaler：把數值欄位做標準化 OneHotEncoder：把類別資料轉成數字
from sklearn.compose import ColumnTransformer #這個是把不同類型的欄位分開處理
from sklearn.pipeline import Pipeline	#可以把「資料前處理 + 模型訓練」串起來
from sklearn.linear_model import LogisticRegression	#匯入邏輯回歸模型 因為目標是「會買 / 不會買」，這屬於分類問題
from sklearn.metrics import accuracy_score	#這是計算模型正確率的函式

np.random.seed(42)	#固定亂數種子 讓每次生成的隨機資料都一樣 這樣結果比較穩定，方便重現
n = 200	#設定資料筆數為 200 也就是我們會生成 200 個顧客資料
data = pd.DataFrame({
    "age": np.random.randint(18, 70, n),
    "income": np.random.randint(20000, 150000, n),
    "visit_count": np.random.randint(1, 15, n),
    "device": np.random.choice(["mobile", "desktop", "tablet"], n),
    "total_spend": np.random.randint(100, 2500, n)
})											#建立一個表格資料結構 產生 200 個隨機年齡#產生 200 個隨機收入#產生 200 個造訪次數#隨機分配裝置類型#產生每位顧客的總消費金額#
data["will_buy"] = (
    (data["income"] > 75000) &
    (data["visit_count"] >= 4) |
    (data["total_spend"] > 1200)
).astype(int)								#建立目標欄位 will_buy。如果收入>75000且造訪次數>=4或總花費>1200就判定為1表示「會買」否則是0表示「不會買」#把True/False轉成1/0
X = data[["age", "income", "visit_count", "device", "total_spend"]]		#X 是特徵（features）也就是模型用來預測的輸入資料
y = data["will_buy"]						#y 是目標值 也就是要預測的答案
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.3, random_state=42
)											#這一行是把資料切成訓練集與測試集。X_train：訓練特徵 X_test：測試特徵 y_train：訓練目標 y_test：測試目標
test_size=0.3								#30% 的資料拿來測試70% 的資料拿來訓練
random_state=42								#固定隨機拆分結果，方便重現
numeric_features = ["age", "income", "visit_count", "total_spend"]		#數值型欄位 這些欄位本來就可以直接當數字使用
categorical_features = ["device"]			#類別型欄位例如 mobile, desktop, tablet 這些不能直接給模型用，所以要做編碼
preprocessor = ColumnTransformer(
    transformers=[
        ("num", StandardScaler(), numeric_features),
        ("cat", OneHotEncoder(handle_unknown="ignore"), categorical_features)
    ]
)											##這一段是前處理器。數值欄位用 StandardScaler把它們縮放到平均值為0、標準差為1類別欄位用 OneHotEncoder把 mobile 轉成 [1,0,0]desktop 轉成 [0,1,0]tablet 轉成 [0,0,1]
model = Pipeline([
    ("preprocess", preprocessor),
    ("classifier", LogisticRegression(max_iter=2000))
])				
###先做前處理 再用邏輯回歸做分類 Pipeline 的好處是：你不必手動先處理資料再訓練模型 它會自動依序執行
###Pipeline 的架構寫得非常標準且規範！它將預處理步驟（preprocessor，如前述包含 StandardScaler 與 OneHotEncoder 的 ColumnTransformer）與分類模型（LogisticRegression）打包成一個單一物件，這是避免 資料洩漏（Data Leakage） 與簡化部署的最佳實踐
model.fit(X_train, y_train)					#用訓練資料訓練模型 模型會學習「哪種顧客比較可能購買」
y_pred = model.predict(X_test)				#用測試資料做預測 例如模型猜某顧客會買/不會買
accuracy = accuracy_score(y_test, y_pred)	#計算正確率 也就是預測結果和實際值比對，看看有多少正確
print("分類正確率:", round(accuracy, 3))		#代表  正確率
print("實際值:", y_test.head().tolist())		#印出前幾筆測試資料的實際答案 方便你看到真實標籤
print("預測值:", y_pred[:5].tolist())		#印出前 5 筆預測結果 跟實際值對照看看模型有沒有猜對




Part 1 的重點
一句話總結
這段程式的核心流程是：

建資料
定義目標 will_buy
切訓練/測試資料
做前處理
用邏輯回歸訓練模型
預測
計算正確率


你現在最重要的概念
這段程式屬於：
分類問題
因為答案是「會 / 不會」
用 LogisticRegression 做分類器
用 accuracy_score 看模型是否準

##########################################################
Part 2：回歸預測花費  回歸目標是數字：花多少
##########################################################

#這一段的目標是：
#預測每位顧客會花多少錢
#這是「回歸問題」
#因為答案不是 0 / 1，而是數字，例如 500、1200、2500

import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import OneHotEncoder, StandardScaler
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error

# 1. 建立資料
np.random.seed(42)

n = 200
data = pd.DataFrame({
    "age": np.random.randint(18, 70, n),
    "income": np.random.randint(20000, 150000, n),
    "visit_count": np.random.randint(1, 15, n),
    "device": np.random.choice(["mobile", "desktop", "tablet"], n),
})

# 2. 建立目標：每位顧客的花費
# 這裡用一個簡單邏輯來模擬花費
data["total_spend"] = (
    100
    + data["income"] * 0.01
    + data["visit_count"] * 80
    + data["age"] * 2
)

# 3. 避免純數字太大，讓模型更穩定
# 這只是為了示範，不是必要
data["income_scaled"] = data["income"] / 1000
data["age_scaled"] = data["age"] / 10

# 4. 選擇特徵和目標
X = data[["age_scaled", "income_scaled", "visit_count", "device"]]
y = data["total_spend"]

# 5. 切分訓練 / 測試資料
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.3, random_state=42
)

# 6. 特徵處理
numeric_features = ["age_scaled", "income_scaled", "visit_count"]
categorical_features = ["device"]

preprocessor = ColumnTransformer(
    transformers=[
        ("num", StandardScaler(), numeric_features),
        ("cat", OneHotEncoder(handle_unknown="ignore"), categorical_features)
    ]
)

# 7. 建模：線性回歸
model = Pipeline([
    ("preprocess", preprocessor),
    ("regressor", LinearRegression())
])

# 8. 訓練
model.fit(X_train, y_train)

# 9. 預測
y_pred = model.predict(X_test)

# 10. 評估
rmse = mean_squared_error(y_test, y_pred, squared=False)
print("回歸 RMSE:", round(rmse, 2))
print("實際花費:", y_test.head().tolist())
print("預測花費:", y_pred[:5].round(2).tolist())



#############################################################
Part 3 把顧客自動分成幾個相似群體 
#############################################################
#沒有明確目標標籤
#目標是「找出自然相似的群體」
#不是預測答案，
#而是發現潛在客群
#用 KMeans 來做這件事


import pandas as pd
import numpy as np
from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler

# 1. 建立顧客資料
np.random.seed(42)
n = 200
data = pd.DataFrame({
    "age": np.random.randint(18, 70, n),
    "income": np.random.randint(20000, 150000, n),
    "visit_count": np.random.randint(1, 15, n),
    "device": np.random.choice(["mobile", "desktop", "tablet"], n),
})
# 2. 建立花費欄位
data["total_spend"] = (
    100
    + data["income"] * 0.01
    + data["visit_count"] * 80
    + data["age"] * 2
)

# 3. 選擇要做分群的特徵
X = data[["age", "income", "visit_count", "total_spend"]]
# 4. 做標準化
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)
# 5. 建立 KMeans 模型
kmeans = KMeans(n_clusters=3, random_state=42, n_init=10)
# 6. 訓練模型：幫顧客分群
clusters = kmeans.fit_predict(X_scaled)
# 7. 加回資料表
data["cluster"] = clusters
# 8. 查看分群結果
print(data[["age", "income", "visit_count", "total_spend", "cluster"]].head(10))
# 9. 查看每群平均特徵
print("\n每群平均特徵:")
print(data.groupby("cluster").agg({
    "age": "mean",
    "income": "mean",
    "visit_count": "mean",
    "total_spend": "mean"
}).round(2))



################################################
Part 4：最後用評估指標看模型表現
#################################################
#分類問題用什麼指標
#回歸問題用什麼指標
#分群問題如何看表現
#最後怎麼整理成完整結論
import numpy as np
from sklearn.metrics import accuracy_score, mean_squared_error, r2_score, silhouette_score

# ----- 分類評估 -----
acc = accuracy_score(y_test, y_pred_class)
print("分類正確率:", round(acc, 3))

# ----- 回歸評估 -----
rmse = np.sqrt(mean_squared_error(y_test, y_pred_reg))
r2 = r2_score(y_test, y_pred_reg)

print("回歸 RMSE:", round(rmse, 2))
print("回歸 R²:", round(r2, 3))

# ----- 分群評估（如果有做分群） -----
sil_score = silhouette_score(X_scaled, clusters)
print("分群輪廓係數 Silhouette Score:", round(sil_score, 3))

#Silhouette Score（輪廓係數）
#這個值會在 -1 到 1 之間
sil_score = silhouette_score(X_scaled, clusters)
#X_scaled 是分群前的標準化資料
#clusters 是每個樣本被分到哪個群
#判斷標準：
#越接近 1：分群越好
#接近 0：群間分界不清楚
#負值：分群很差
#########################
##########分類###########
#常用：
#Accuracy
#Precision
#Recall
#F1-score
#例子：
#判斷顧客會不會買
#看「對的比例」有多少
######回歸################
#常用：
#RMSE
#MAE
#R²
#例子：
#預測顧客花多少錢
#看誤差有多大
########分群#########
#常用：
#Silhouette Score
#Inertia
#Davies-Bouldin Index
#例子：
#把顧客分成高消費/低消費群
#看這些群是否真的明顯分開
#5. 最後怎麼總結？
#你可以這樣寫結論：
#分類模型：使用 Accuracy 評估，結果是 0.883，表示約 88.3% 正確
#回歸模型：使用 RMSE 和 R² 評估，若 RMSE 很小且 R² 很接近 1，表示預測很準
#分群模型：使用 Silhouette Score 看群體是否清楚分開
#6. 一句話總結
#評估指標就是用來回答：「模型表現好不好？」
#分類看正確率
#回歸看誤差和解釋力
#分群看群體是否清晰
#7. 你現在最重要要懂的概念
#分類：看正確率
#回歸：看 RMSE / R²
#分群：看 Silhouette Score



######################################
#################final code############
#######################################
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import OneHotEncoder, StandardScaler
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.linear_model import LogisticRegression, LinearRegression
from sklearn.cluster import KMeans
from sklearn.metrics import accuracy_score, mean_squared_error, silhouette_score

# =========================
# 1. 建立資料
# =========================
np.random.seed(42)

n = 200
data = pd.DataFrame({
    "age": np.random.randint(18, 70, n),
    "income": np.random.randint(20000, 150000, n),
    "visit_count": np.random.randint(1, 15, n),
    "device": np.random.choice(["mobile", "desktop", "tablet"], n),
})

# =========================
# 2. 建立目標變數
# =========================
# 分類目標：會不會購買
# 規則：收入高、造訪多、花費高，較可能購買
data["will_buy"] = (
    (data["income"] > 75000) &
    (data["visit_count"] >= 4) |
    (data["income"] > 90000)
).astype(int)

# 回歸目標：每位顧客的花費
data["total_spend"] = (
    100
    + data["income"] * 0.01
    + data["visit_count"] * 80
    + data["age"] * 2
)

# =========================
# 3. Part 1：分類預測購買與否
# =========================
X_class = data[["age", "income", "visit_count", "device"]]
y_class = data["will_buy"]

X_class_train, X_class_test, y_class_train, y_class_test = train_test_split(
    X_class, y_class, test_size=0.3, random_state=42
)

numeric_features = ["age", "income", "visit_count"]
categorical_features = ["device"]

preprocessor = ColumnTransformer(
    transformers=[
        ("num", StandardScaler(), numeric_features),
        ("cat", OneHotEncoder(handle_unknown="ignore"), categorical_features)
    ]
)

class_model = Pipeline([
    ("preprocess", preprocessor),
    ("classifier", LogisticRegression(max_iter=2000))
])

class_model.fit(X_class_train, y_class_train)
y_class_pred = class_model.predict(X_class_test)
class_accuracy = accuracy_score(y_class_test, y_class_pred)

print("分類正確率:", round(class_accuracy, 3))

# =========================
# 4. Part 2：回歸預測花費
# =========================
X_reg = data[["age", "income", "visit_count", "device"]]
y_reg = data["total_spend"]

X_reg_train, X_reg_test, y_reg_train, y_reg_test = train_test_split(
    X_reg, y_reg, test_size=0.3, random_state=42
)

reg_model = Pipeline([
    ("preprocess", preprocessor),
    ("regressor", LinearRegression())
])

reg_model.fit(X_reg_train, y_reg_train)
y_reg_pred = reg_model.predict(X_reg_test)
reg_rmse = np.sqrt(mean_squared_error(y_reg_test, y_reg_pred))

print("回歸 RMSE:", round(reg_rmse, 2))

# =========================
# 5. Part 3：分群找出客群
# =========================
X_cluster = data[["age", "income", "visit_count", "total_spend"]]
X_cluster_scaled = StandardScaler().fit_transform(X_cluster)

kmeans = KMeans(n_clusters=3, random_state=42, n_init=10)
clusters = kmeans.fit_predict(X_cluster_scaled)

data["cluster"] = clusters
print("\n每群平均特徵:")
print(data.groupby("cluster").agg({
    "age": "mean",
    "income": "mean",
    "visit_count": "mean",
    "total_spend": "mean"
}).round(2))

# =========================
# 6. Part 4：評估指標總結
# =========================
print("\n模型評估總結:")
print("- 分類：Accuracy =", round(class_accuracy, 3))
print("- 回歸：RMSE =", round(reg_rmse, 2))
print("- 分群：Silhouette Score =", round(silhouette_score(X_cluster_scaled, clusters), 3))










