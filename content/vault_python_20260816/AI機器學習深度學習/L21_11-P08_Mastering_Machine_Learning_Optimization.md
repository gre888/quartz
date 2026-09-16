

def GD(x_start, df, epochs, lr): x = x_start for i in range(epochs): dx = df(x) v = -lr * dx x += v return x # 這裡以 f(x) = x^2 為例，其導函數 df(x) = 2x # 修改了參數使其與函數定義的 4 個參數相符 result = GD(5, lambda x: 2 * x, 15, 0.1) print("Gradient descent result:", result)

你這段程式就是圖片中「**梯度下降 Gradient Descent**」實作的基本版本。

### 1. 這段 `GD()` 在做什麼？

```
def GD(x_start, df, epochs, lr):
    x = x_start

    for i in range(epochs):
        dx = df(x)
        v = -lr * dx
        x += v

    return x
```

可以把它記成：

> **目前位置 → 算斜率 → 往斜率反方向走 → 重複很多次**

其中：

|參數|意思|
|---|---|
|`x_start`|起始的 x|
|`df`|函數的導數|
|`epochs`|要走幾次|
|`lr`|learning rate，學習率|
|`dx`|目前位置的斜率|
|`v`|這一次要移動的量|
|`x`|目前所在位置|

核心公式就是：

```
x = x - lr * df(x)
```

---

## 2. 你的範例

你設定：

```
result = GD(5, lambda x: 2 * x, 15, 0.1)
```

代表：

```
函數：f(x) = x²
導數：f'(x) = 2x

起點：x = 5
學習率：lr = 0.1
走 15 次
```

所以每次：

```
x = x - 0.1 * (2 * x)
```

也就是：

```
x = x - 0.2 * x
x = 0.8 * x
```

因此：

```
第 0 次：5
第 1 次：4
第 2 次：3.2
第 3 次：2.56
...
第 15 次：約 0.176
```

最後：

```
Gradient descent result: 0.17592186044416003
```

因為 `f(x)=x²` 的最小值在：

```
x = 0
```

所以梯度下降會慢慢靠近 `0`。

---

# 3. 對照你圖片裡的三個任務

你的圖片其實是在要求把同一個 `GD()` 程式，換不同函數來實驗。

### 任務一：多項式

圖片：

```
f(x) = x³ - 3x + 2
```

先求導：

```
f'(x) = 3x² - 3
```

所以可以寫：

```
def df(x):
    return 3 * x**2 - 3

result = GD(-0.5, df, 100, 0.1)
print(result)
```

以及測試：

```
result = GD(2, df, 100, 0.1)
print(result)
```

這個實驗的重點是：

> **不同起點可能會讓梯度下降走向不同的局部最小值。**

---

# 4. 任務二：三角函數

圖片：

```
f(x) = cos(x)
```

導數：

```
f'(x) = -sin(x)
```

所以：

```
import math

def df(x):
    return -math.sin(x)

result = GD(0, df, 100, 0.3)
print(result)
```

再改成：

```
result = GD(0, df, 100, 0.8)
print(result)
```

這是在觀察：

```
learning rate = 0.3
        vs
learning rate = 0.8
```

兩種學習率的**收斂軌跡差異**。

---

# 5. 任務三：魔王關卡

圖片：

```
f(x) = 0.1x² + sin(0.1x²)
```

這個就比較有趣。

令：

```
u = 0.1x²
```

原函數：

```
f(x) = u + sin(u)
```

求導：

```
f'(x)
= (1 + cos(u)) × du/dx
```

而：

```
du/dx = 0.2x
```

所以：

```
f'(x) = 0.2x × [1 + cos(0.1x²)]
```

Python：

```
import math

def df(x):
    return 0.2 * x * (1 + math.cos(0.1 * x**2))
```

然後測試圖片指定的：

```
x_start = 3.7
x_start = 9
```

例如：

```
result = GD(3.7, df, 100, 0.1)
print("x_start=3.7:", result)

result = GD(9, df, 100, 0.1)
print("x_start=9:", result)
```

---

## 6. 這張投影片真正要你理解的重點

不是單純「把程式跑出答案」。

而是觀察：

```
                 Gradient Descent
                        │
            ┌───────────┴───────────┐
            ↓                       ↓
       起始位置不同              Learning Rate不同
            ↓                       ↓
       x_start 改變                lr 改變
            ↓                       ↓
       可能走不同路徑          可能收斂/震盪
            │                       │
            └───────────┬───────────┘
                        ↓
                 最後到哪裡？
```

### 你目前這個 `GD()` 可以直接記成一條公式：

```
x += -lr * df(x)
```

等價於：

```
x = x - lr * df(x)
```

**看到 `df(x)` 就是在問「現在斜率是多少？」**

**看到 `-lr` 就是在問「我要往斜率的反方向走多遠？」**

這就是 Gradient Descent 最核心的概念。

![7a30ad75-68ba-4a45-84fb-07997927f96c.png](https://chatgpt.com/backend-api/estuary/content?id=file_00000000d45c8208a5fe321424750a17&ts=497098&p=fs&cid=1&sig=70e8881ce0ce1d149732cd7ddecb2056cb5305171c34d49488f647e93baf5ba3&v=0)

這張圖可以整理成你上課很容易記的 **「機器學習 4 步驟循環」**：

## 🤖 從資料到預測的機器學習閉環

```
① 輸入資料 Data
       ↓
② 建立模型 Model
       ↓
③ 計算誤差 Loss
       ↓
④ 優化模型 Gradient Descent
       ↓
   更新 w、b
       ↓
回到模型，再計算 Loss
       ↺
```

### ① 輸入資料 Data

例如：

```
房屋面積 → 房價
```

資料可能是：

```
100 坪 → 300 萬
150 坪 → 450 萬
200 坪 → 600 萬
```

這些是真實世界的**觀測資料**。

---

### ② 建立模型 Model

最簡單的線性模型：

```
y = w * x + b
```

其中：

|符號|意思|
|---|---|
|`x`|輸入資料，例如房屋坪數|
|`y`|預測結果，例如房價|
|`w`|權重、斜率|
|`b`|偏差、截距|

例如：

```
y = 2.5 * x + 10
```

就是目前模型認為：

```
房價 = 2.5 × 坪數 + 10
```

---

### ③ 計算 Loss

模型預測後，要跟真正答案比較。

例如：

```
真實房價：500 萬
預測房價：450 萬
```

代表模型有誤差。

`Loss` 就是用一個**損失函數**把這個錯誤量化。

> **Loss 越小 → 代表模型預測結果與真實資料越接近。**

所以機器學習的核心目標可以記成：

> 🎯 **找到最低的 Loss**

---

### ④ Gradient Descent

這就是你上一張圖的 `GD()`！

它負責：

> **計算梯度 → 調整 `w`、`b` → 讓 Loss 變小**

概念上：

```
Loss 很大
   ↓
計算梯度
   ↓
調整 w、b
   ↓
Loss 變小
   ↓
再計算梯度
   ↓
再調整 w、b
   ↓
……
   ↓
找到較低的 Loss
```

---

# ⭐ 把兩張投影片串起來

你上一題學的：

```
x = x - lr * df(x)
```

其實就是這張圖的 **第 ④ 步：Gradient Descent**。

可以把整套流程記成：

```
Data
 ↓
Model
 ↓
Prediction
 ↓
Loss
 ↓
Gradient
 ↓
更新參數 w、b
 ↓
重新 Prediction
 ↓
重新計算 Loss
 ↓
不斷重複
```

### 考試最重要的一句

> **機器學習就是利用資料建立模型，計算預測誤差（Loss），再透過 Gradient Descent 不斷更新模型參數，讓 Loss 越來越小。**

這句基本上就是這張投影片的核心。