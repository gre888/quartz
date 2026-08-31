# Python Ch4：條件判斷與 `for` 迴圈重點

> 本筆記根據 `ch4-max.py`、`ch4-move.py`、`ch4-password.py`、`ch4-pytho_if.py`、`ch4-python_if_else.py`、`ch4-for_3.py`、`ch4-for_in.py` 整理。

## 1. `if` 單向條件判斷

當條件成立時，才會執行縮排區塊內的程式。

```python
score = 65

if score >= 60:
    print("及格")
```

基本語法：

```python
if 條件:
    條件成立時執行的程式
```

重點：

- 條件後面必須加冒號 `:`。
- Python 使用縮排表示程式區塊，通常使用 4 個空白。
- 如果條件不成立，會直接略過 `if` 區塊。

### 多個條件：`and`

`and` 表示左右兩個條件都必須成立。

```python
score = 58

if score >= 55 and score < 60:
    score = 60
    print("調整後的分數：", score)
```

也可以寫成 Python 的連續比較：

```python
if 55 <= score < 60:
    score = 60
```

## 2. `if...else` 雙向條件判斷

條件成立時執行 `if`，不成立時執行 `else`。

```python
score = 70

if score >= 60:
    print("及格")
    print("恭喜過關")
else:
    print("不及格")
    print("請再接再厲")
```

執行流程：

- `score >= 60` 為 `True`：執行 `if` 區塊。
- `score >= 60` 為 `False`：執行 `else` 區塊。
- `if` 與 `else` 只會執行其中一個區塊。

## 3. 比較運算子與邏輯運算子

### 比較運算子

| 運算子 | 意義 | 範例 |
| --- | --- | --- |
| `>` | 大於 | `age > 18` |
| `<` | 小於 | `age < 10` |
| `>=` | 大於或等於 | `score >= 60` |
| `<=` | 小於或等於 | `score <= 100` |
| `==` | 等於 | `pw == "gotop168"` |
| `!=` | 不等於 | `pw != "1234"` |

注意：

- `=` 是指定值，例如 `score = 70`。
- `==` 才是比較左右兩邊是否相等。

### 邏輯運算子

| 運算子 | 意義 | 成立條件 |
| --- | --- | --- |
| `and` | 而且 | 左右條件都為 `True` |
| `or` | 或者 | 至少一個條件為 `True` |
| `not` | 相反 | 將 `True`、`False` 反轉 |

## 4. `or` 的應用：票價判斷

兒童或年長者可以購買半價票：

```python
sell_price = 300
age = 70

if age < 10 or age >= 65:
    price = sell_price / 2
else:
    price = sell_price

print(age, price)
```

`age < 10 or age >= 65` 表示：

- 年齡小於 10 歲，或
- 年齡大於等於 65 歲。

只要其中一個條件成立，就以半價計算。

## 5. 使用 `input()` 驗證密碼

```python
password = input("請輸入密碼：")

if password == "gotop168":
    print("密碼正確，歡迎光臨")
else:
    print("密碼錯誤，拒絕進入")
```

重點：

- `input()` 取得的資料型別是字串 `str`。
- 比較密碼時使用 `==`，不是 `=`。
- 密碼的英文大小寫不同，會被視為不同字串。

## 6. `if...elif...else` 多向條件判斷

需要判斷多種互斥情況時，可以使用 `elif`。

```python
age = int(input("請輸入年齡："))

if age >= 18:
    rating = "限制級"
elif age >= 12:
    rating = "輔導級"
elif age >= 6:
    rating = "保護級"
else:
    rating = "普遍級"

print(f"年齡 {age} 可看 {rating} 電影")
```

### 判斷順序很重要

程式會由上往下檢查，遇到第一個成立的條件後，就不再檢查後面的條件。因此，本例要由年齡較大的條件開始判斷。

| 年齡 | 分級 |
| --- | --- |
| `age >= 18` | 限制級 |
| `12 <= age < 18` | 輔導級 |
| `6 <= age < 12` | 保護級 |
| `age < 6` | 普遍級 |

## 7. 巢狀 `if`：找出三個數的最大值

`if` 區塊裡面可以再放另一個 `if`，稱為巢狀條件判斷。

```python
n1 = 34
n2 = 100
n3 = -67

if n1 > n2:
    if n1 > n3:
        largest = n1
    else:
        largest = n3
else:
    if n2 > n3:
        largest = n2
    else:
        largest = n3

print(f"最大數為 {largest}")
```

判斷概念：

1. 先比較 `n1` 和 `n2`。
2. 再將較大的數與 `n3` 比較。
3. 最後把最大值指定給 `largest`。

實務上也可以直接使用內建函式：

```python
largest = max(n1, n2, n3)
```

## 8. `for...in` 迴圈

`for` 迴圈可以依序取得字串或其他可迭代物件中的每個元素。

```python
for char in "Python":
    print(char)
```

輸出：

```text
P
y
t
h
o
n
```

每次迴圈會將一個字元放入 `char`，直到所有字元都處理完畢。

### `print()` 的 `end` 參數

```python
for char in "Python":
    print(char, end="\n")
```

- `end="\n"`：每次輸出後換行，也是 `print()` 的預設值。
- `end=""`：輸出後不換行。
- `end=" "`：用空白分隔每次輸出。

## 9. `for...else`

Python 的 `for` 迴圈可以搭配 `else`：

```python
for char in "Python":
    print(char)
else:
    print("字串輸出結束")
```

當迴圈正常執行完畢後，會執行 `else` 區塊。若之後學到 `break`，則要注意：迴圈因 `break` 中途停止時，不會執行 `else`。

## 10. `range()` 與累加

`range(1, 11)` 會產生 1 到 10，不包含結束值 11。

```python
total = 0

for number in range(1, 11):
    total = total + number
    print("目前總和：", total)

print("最後總和：", total)
```

最後的計算結果是：

```text
1 + 2 + 3 + ... + 10 = 55
```

也可以簡寫為：

```python
total += number
```

### `range()` 常見寫法

| 寫法 | 產生的數字 |
| --- | --- |
| `range(5)` | `0, 1, 2, 3, 4` |
| `range(1, 5)` | `1, 2, 3, 4` |
| `range(1, 10, 2)` | `1, 3, 5, 7, 9` |
| `range(10, 0, -1)` | `10, 9, ..., 1` |

## 11. 海象運算子 `:=` 的注意事項

海象運算子可以在運算式中指定值，但必須留意運算子的優先順序。

原始程式中的寫法：

```python
if score := 65 >= 60:
    print("及格")
```

這實際上相當於：

```python
score = (65 >= 60)
```

因此 `score` 得到的是布林值 `True`，不是整數 `65`。

如果要先把 `65` 指定給 `score`，再判斷是否及格，應加上括號：

```python
if (score := 65) >= 60:
    print("及格")
```

一般初學階段，分開寫會更清楚：

```python
score = 65
if score >= 60:
    print("及格")
```

## 12. 程式命名與格式注意事項

### 不建議把內建函式名稱當作變數

原始範例使用了 `sum` 和 `max` 作為變數名稱，但 Python 本身已有同名的內建函式。

```python
# 不建議
sum = 0
max = n1

# 建議
total = 0
largest = n1
```

### `f-string` 加入適當間隔

```python
# 三個數字會連在一起
print(f"三個整數為 {n1}{n2}{n3}")

# 較清楚
print(f"三個整數為 {n1}、{n2}、{n3}")
```

## 13. 本章必背重點

1. `if` 用來判斷單一條件。
2. `if...else` 會從兩個區塊中選擇一個執行。
3. `if...elif...else` 適合多種互斥條件，而且判斷順序很重要。
4. `and` 要求全部成立；`or` 只要一個成立。
5. `=` 是指定值；`==` 是比較是否相等。
6. `input()` 回傳字串；需要數字時可使用 `int(input(...))`。
7. 巢狀 `if` 是在條件區塊中再進行判斷。
8. `for...in` 會依序取出字串或其他可迭代物件的元素。
9. `range()` 不包含結束值。
10. `for...else` 的 `else` 會在迴圈正常結束時執行。
11. `if score := 65 >= 60` 會把比較結果 `True` 指定給 `score`。
12. 避免使用 `sum`、`max` 等內建函式名稱當作變數名稱。

## 14. 綜合練習

### 練習一：判斷奇數或偶數

```python
number = int(input("請輸入整數："))

if number % 2 == 0:
    print("偶數")
else:
    print("奇數")
```

### 練習二：計算 1 到 100 的總和

```python
total = 0

for number in range(1, 101):
    total += number

print("總和：", total)
```

### 練習三：成績等級

```python
score = int(input("請輸入成績："))

if score >= 90:
    grade = "A"
elif score >= 80:
    grade = "B"
elif score >= 70:
    grade = "C"
elif score >= 60:
    grade = "D"
else:
    grade = "F"

print(f"成績等級：{grade}")
```
