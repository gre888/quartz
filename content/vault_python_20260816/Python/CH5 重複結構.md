# Python Chapter 5：迴圈控制重點

本章主要介紹 `while` 迴圈、`for` 迴圈、巢狀迴圈，以及 `break`、`continue` 的使用方式。

---

## 1. `while` 迴圈

### 基本語法

```python
while 條件:
    重複執行的程式
```

- 條件為 `True` 時，持續執行迴圈內容。
- 條件為 `False` 時，結束迴圈。
- 必須適時修改控制變數，否則可能形成無限迴圈。

### 範例：計算 1 到 10 的總和

來源：`ch5-while_1.py`

```python
i = 0
total = 0

while i < 10:
    i = i + 1
    total = total + i
    print(i)

print(total)
```

執行流程：

1. `i` 從 0 開始。
2. 每次進入迴圈先將 `i` 加 1。
3. 把新的 `i` 加入 `total`。
4. 最後結果為 `1 + 2 + ... + 10 = 55`。

> 建議不要使用 `sum` 當變數名稱，因為 `sum()` 是 Python 內建函式。改用 `total` 較適合。

---

## 2. `while...else`

來源：`ch5-while02.py`

```python
i = 11

while i > 0:
    i = i - 1
    print(i)
else:
    print('時間到了')
```

執行結果會依序輸出 `10` 到 `0`，最後顯示：

```text
時間到了
```

### 重點

- 當 `while` 的條件正常變成 `False` 時，會執行 `else`。
- 如果迴圈是被 `break` 強制中止，則不會執行 `else`。

```python
i = 3

while i > 0:
    if i == 2:
        break
    print(i)
    i -= 1
else:
    print('正常結束')  # 不會執行
```

---

## 3. 無限迴圈與縮排錯誤

來源：`ch5-while_3.py`

原程式的重要問題：

```python
i = 1
total = 0

while i <= 10:
    total += i

i += 1
print(total)
```

`i += 1` 沒有縮排在 `while` 裡面，因此 `i` 會一直等於 1，條件 `i <= 10` 永遠成立，形成無限迴圈。

### 正確寫法

```python
i = 1
total = 0

while i <= 10:
    total += i
    i += 1

print(total)  # 55
```

### 檢查無限迴圈的方法

看到 `while` 時，確認以下三件事：

1. 控制變數有設定初始值。
2. 條件式有明確的停止條件。
3. 控制變數有在迴圈內更新。

---

## 4. `break`：立即結束迴圈

來源：`ch5-break.py`

```python
while True:
    account = input('請輸入帳號：')

    if account == 'gotop':
        break

    print('帳號錯誤')

print('帳號正確')
```

### 重點

- `while True` 會建立無限迴圈。
- 當輸入內容是 `gotop` 時，執行 `break`，立刻離開迴圈。
- `break` 只會結束它所在的最內層迴圈。

### 流程

```text
輸入帳號 → 是否為 gotop？
          ├─ 是：break → 顯示「帳號正確」
          └─ 否：顯示「帳號錯誤」→ 再次輸入
```

---

## 5. `continue`：跳過本次迴圈

來源：`ch5-continue.py`

```python
text = input('請輸入字串：')

for ch in text:
    if ch > '9' or ch < '0':
        continue
    print(ch, end='')
```

若輸入：

```text
gotop168
```

輸出：

```text
168
```

### 判斷原理

```python
if ch > '9' or ch < '0':
```

表示字元不在 `'0'` 到 `'9'` 之間。如果不是數字，就使用 `continue` 跳過本次處理。

也可以使用較容易閱讀的寫法：

```python
for ch in text:
    if not ch.isdigit():
        continue
    print(ch, end='')
```

### `break` 與 `continue` 比較

| 指令 | 功能 | 迴圈是否繼續 |
| --- | --- | --- |
| `break` | 立刻結束整個迴圈 | 否 |
| `continue` | 跳過本次剩餘程式 | 是，進入下一次迴圈 |

---

## 6. 巢狀迴圈

巢狀迴圈是指「迴圈裡面還有另一個迴圈」。

```python
for 外層變數 in 範圍:
    for 內層變數 in 範圍:
        執行程式
```

- 外層迴圈每執行一次，內層迴圈會完整執行一輪。
- 常用於九九乘法表、星號圖形、二維資料等。

---

## 7. 巢狀迴圈：星號三角形

來源：`ch5-n_loop.py`

```python
for x in range(1, 6):
    for y in range(1, 6 - x):
        print(' ', end='')

    for y in range(1, x + 1):
        print('*', end='')

    print()

print()
```

輸出：

```text
    *
   **
  ***
 ****
*****
```

### 三層工作分工

| 程式 | 功能 |
| --- | --- |
| `for x in range(1, 6)` | 控制總共輸出 5 列 |
| `range(1, 6 - x)` | 控制每列前方空白數量 |
| `range(1, x + 1)` | 控制每列星號數量 |
| `print()` | 完成一列後換行 |

### 每列的變化

| `x` | 空白數 | 星號數 |
| ---: | ---: | ---: |
| 1 | 4 | 1 |
| 2 | 3 | 2 |
| 3 | 2 | 3 |
| 4 | 1 | 4 |
| 5 | 0 | 5 |

> `print(..., end='')` 表示輸出後不換行；單獨使用 `print()` 才會換到下一行。

---

## 8. 九九乘法表：混合使用 `for` 與 `while`

來源：`ch5-loop.py`

整理後的原理如下：

```python
for i in range(1, 10):
    j = 1

    while True:
        print(i, '*', j, '=', i * j, end='\t')
        j += 1

        if j > 9:
            break

    print()
```

### 執行方式

- 外層 `for`：控制被乘數 `i`，範圍是 1～9。
- 內層 `while`：控制乘數 `j`，範圍是 1～9。
- `\t`：插入 Tab，讓結果分欄排列。
- 當 `j > 9` 時，使用 `break` 結束內層迴圈。
- 每完成一列後，以 `print()` 換行。

原檔案使用：

```python
for i in range(10):
    if i <= 0:
        continue
```

這是先產生 `0～9`，再使用 `continue` 跳過 0。若不需要特別練習 `continue`，直接寫成 `range(1, 10)` 更簡潔。

### 更常見的雙層 `for` 寫法

```python
for i in range(1, 10):
    for j in range(1, 10):
        print(f'{i} * {j} = {i * j}', end='\t')
    print()
```

---

## 9. `range()` 重點複習

| 寫法 | 產生的整數 |
| --- | --- |
| `range(5)` | 0、1、2、3、4 |
| `range(1, 5)` | 1、2、3、4 |
| `range(1, 10)` | 1～9 |
| `range(10, 0, -1)` | 10～1 |

語法：

```python
range(起始值, 結束值, 間隔值)
```

> `range()` 不包含結束值。

---

## 10. 本章常見錯誤

### 錯誤 1：忘記更新控制變數

```python
i = 1
while i <= 10:
    print(i)
```

`i` 永遠是 1，會形成無限迴圈。

### 錯誤 2：更新變數的縮排位置錯誤

```python
while i <= 10:
    total += i
i += 1
```

`i += 1` 不在迴圈內，仍會形成無限迴圈。

### 錯誤 3：混淆 `break` 與 `continue`

- 想完全離開迴圈：使用 `break`。
- 只想略過某一次：使用 `continue`。

### 錯誤 4：不理解 `range()` 不包含結束值

```python
range(1, 10)
```

只會產生 1～9，不會產生 10。

### 錯誤 5：巢狀迴圈忘記在每列結束後換行

如果沒有外層迴圈尾端的 `print()`，所有結果可能會顯示在同一行。

---

## 11. 考試必記速查表

| 主題 | 必記重點 |
| --- | --- |
| `while` | 條件為真就重複執行 |
| `while...else` | 迴圈正常結束時執行 `else` |
| `break` | 立即結束最內層迴圈 |
| `continue` | 跳過本次，進入下一次迴圈 |
| 巢狀迴圈 | 外層一次，內層完整執行一輪 |
| `range(1, 10)` | 產生 1～9，不包含 10 |
| `end=''` | 輸出後不換行 |
| `end='\t'` | 輸出後加入 Tab 間距 |
| 無限迴圈 | 常因條件永遠成立或控制變數未更新 |

---

## 12. 練習題

1. 使用 `while` 計算 1～100 的總和。
2. 使用 `while` 顯示 10～1 的倒數，最後輸出「時間到了」。
3. 輸入一個字串，只輸出其中的英文字母。
4. 使用雙層 `for` 輸出九九乘法表。
5. 使用巢狀迴圈輸出以下圖形：

```text
*
**
***
****
*****
```

6. 說明 `break` 與 `continue` 的差別。

---

## 本章一句話總結

`while` 適合「不知道要重複幾次、由條件決定停止」的情況；`for` 適合「已知範圍或逐一處理資料」的情況，而 `break` 與 `continue` 可進一步控制迴圈流程。
