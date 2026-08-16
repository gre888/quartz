# Python ITS 考試通過重點筆記

依據你提供的《2024 ITS PYTHON 出85趴》61 頁題庫整理。題庫主要分成 8 類：資料型別與輸入輸出、運算子、條件判斷、字串與集合、迴圈、函式、檔案／例外、物件導向。

> 沒有任何筆記能保證 100% 通過；但如果你能熟記本文的規則、完成最後的自我測驗，並照 7 天計畫練習，通過機率會大幅提高。

## 一、考試做題方法

每一題依序做 5 件事：

1. 圈出題目問的是「輸出、型別、語法錯誤、執行錯誤、正確／錯誤敘述」中的哪一種。
2. 看到 `input()`，立刻在旁邊寫 `str`。
3. 依序計算：括號 → `**` → 正負號 → `* / // %` → `+ -` → 比較 → `not` → `and` → `or`。
4. 迴圈題畫表格，逐行更新變數，不要只用心算。
5. 最後檢查冒號、縮排、大小寫、引號與索引範圍。

## 二、資料型別與輸入輸出

| 型別 | 例子 | 重點 |
|---|---|---|
| `int` | `10`, `-3` | 整數 |
| `float` | `5.0`, `1e10` | 小數或科學記號 |
| `str` | `'True'`, `"90"` | 引號內一定是字串 |
| `bool` | `True`, `False` | 首字母大寫，不能加引號 |
| `list` | `[1, 2]` | 有順序、可修改 |
| `tuple` | `(1, 2)` | 有順序、不可修改 |
| `dict` | `{'a': 1}` | 鍵值配對 |
| `set` | `{1, 2}` | 元素不重複、不能用索引 |

### `input()` 必考

```python
age = input('Age: ')  # 結果一定是 str
age = int(age)        # 轉成整數
price = float('12.5') # 12.5
text = str(90)        # '90'
```

- `int('3.5')` 會發生 `ValueError`。
- `'False'` 是非空字串，不是布林值 `False`。
- `eval(input())` 會依輸入內容判斷型別，但實務上有安全風險；考試只需理解結果。

### `print()`

```python
print('A', 'B', sep='-')  # A-B
print('A', end='')
print('B')                # AB
print(f'{12.5:.2f}')      # 12.50
print(f'{7:03d}')         # 007
```

## 三、運算子

| 符號 | 意義 | 結果 |
|---|---|---|
| `/` | 真除法 | `7 / 2 == 3.5` |
| `//` | 向下取整 | `7 // 2 == 3`；`-7 // 2 == -4` |
| `%` | 餘數 | `7 % 2 == 1` |
| `**` | 次方 | `2 ** 3 == 8` |
| `=` | 指定值 | `x = 5` |
| `==` | 比較相等 | `x == 5` 得到布林值 |
| `!=` | 不相等 | `x != 5` |

### 題庫型運算範例

```python
a = 24
b = 7
ans = (a % b * 100) // 2.0 ** 3.0 - b
```

逐步計算：

1. `24 % 7 = 3`
2. `3 * 100 = 300`
3. `2.0 ** 3.0 = 8.0`
4. `300 // 8.0 = 37.0`
5. `37.0 - 7 = 30.0`

### 超高頻陷阱

- `-2 ** 2` 等於 `-(2 ** 2)`，答案是 `-4`。
- `(-2) ** 2` 才是 `4`。
- `//` 在負數時是向負無限方向取整，不只是刪掉小數。
- `x += 2` 等同於 `x = x + 2`。

## 四、布林值與條件判斷

```python
score = 78

if score >= 90:
    grade = 'A'
elif score >= 80:
    grade = 'B'
elif score >= 70:
    grade = 'C'
else:
    grade = 'D'
```

Python 由上往下判斷，只執行第一個成立的分支。因此範圍較嚴格的條件通常放前面。

| 運算 | 成立條件 |
|---|---|
| `A and B` | A、B 都是 True |
| `A or B` | 至少一個是 True |
| `not A` | 把 A 的真假反轉 |

通常視為 False 的值：

```python
False, None, 0, 0.0, '', [], (), {}
```

### `==` 與 `is`

- `==`：比較兩者的「值」。
- `is`：比較是否為「同一個物件」。
- 字串、數字內容比較通常用 `==`，不要用 `is`。

## 五、字串與集合型別

### 索引與切片

```python
s = 'Python'
s[0]     # 'P'
s[-1]    # 'n'
s[1:4]   # 'yth'，不包含索引 4
s[:3]    # 'Pyt'
s[::2]   # 'Pto'
s[::-1]  # 'nohtyP'
```

公式：`sequence[start:stop:step]`，`stop` 永遠不包含。

### 字串常用方法

| 方法 | 功能 |
|---|---|
| `lower()` / `upper()` | 轉小寫／大寫 |
| `strip()` | 去除頭尾空白 |
| `find(x)` | 找到回傳索引；找不到回傳 `-1` |
| `replace(a, b)` | 取代並回傳新字串 |
| `split(',')` | 切成 list |
| `','.join(items)` | 將字串序列連接 |
| `startswith()` / `endswith()` | 檢查開頭／結尾 |

字串不可修改，方法通常會回傳新字串。

### list 常用方法

| 方法 | 功能 |
|---|---|
| `append(x)` | 尾端加入「一個」元素 |
| `extend(seq)` | 逐一加入多個元素 |
| `insert(i, x)` | 在索引 i 插入 x |
| `remove(x)` | 刪除第一個值 x |
| `pop(i)` | 依索引刪除並回傳元素；預設最後一個 |
| `sort()` | 原地排序，回傳 `None` |
| `reverse()` | 原地反轉 |
| `index(x)` | 第一個 x 的索引 |
| `count(x)` | x 出現次數 |

```python
a = [1, 2]
b = a
b.append(3)
print(a)  # [1, 2, 3]，a、b 指向同一串列

c = a.copy()  # 建立淺複製
```

必考差異：

- `a.append([2, 3])`：加入一個串列元素。
- `a.extend([2, 3])`：加入數字 `2`、`3` 兩個元素。
- `a.sort()`：修改 `a`，回傳 `None`。
- `sorted(a)`：不修改原本資料，回傳新串列。

### `format()` 索引

```python
x, y, z = 'Tiger', 'Lion', 'Jaguar'
animals = '{1} and {0} and {2}'
print(animals.format(x, y, z))
# Lion and Tiger and Jaguar
```

## 六、迴圈與 `range()`

| 程式 | 產生內容 |
|---|---|
| `range(5)` | `0, 1, 2, 3, 4` |
| `range(2, 6)` | `2, 3, 4, 5` |
| `range(2, 10, 2)` | `2, 4, 6, 8` |
| `range(5, 0, -1)` | `5, 4, 3, 2, 1` |

`range(start, stop, step)` 不包含 `stop`。

```python
total = 0
for i in range(1, 6):
    total += i
print(total)  # 15
```

```python
i = 1
total = 0
while i <= 5:
    total += i
    i += 1  # 忘記更新可能形成無限迴圈
```

| 關鍵字 | 功能 |
|---|---|
| `break` | 立刻離開最內層迴圈 |
| `continue` | 跳過本輪剩餘程式，進入下一輪 |
| `pass` | 什麼都不做，只作語法占位 |

巢狀迴圈執行次數通常是「外層次數 × 內層次數」。

## 七、函式與作用域

```python
def area(width, height=1):
    result = width * height
    return result

a = area(5, 2)               # 位置引數
b = area(height=3, width=4)  # 關鍵字引數
c = area(7)                  # height 使用預設值 1
```

### `return` 與 `print()`

- `return` 把值交回呼叫端，而且會立即結束函式。
- `print()` 只顯示內容。
- 函式未寫 `return`，預設回傳 `None`。

### 參數規則

- 一般參數在前，預設參數在後：`def f(a, b=0)`。
- 位置引數通常在前，關鍵字引數在後。
- `*args` 收集額外位置引數成 tuple。
- `**kwargs` 收集額外關鍵字引數成 dict。
- 避免 `def f(items=[])`；應改用 `items=None`。

名稱查找順序：Local → Enclosing → Global → Built-in（LEGB）。

## 八、檔案處理

| 模式 | 用途 | 注意 |
|---|---|---|
| `r` | 讀取 | 不存在會錯 |
| `w` | 寫入 | 會清空原內容 |
| `a` | 附加 | 寫在檔尾 |
| `x` | 獨占建立 | 已存在會錯 |
| `b` | 二進位 | 如 `rb`、`wb` |
| `+` | 讀寫 | 如 `r+` |

```python
with open('data.txt', 'r', encoding='utf-8') as f:
    text = f.read()
# 離開 with 後自動關閉檔案
```

| 方法 | 回傳／功能 |
|---|---|
| `read()` | 全部內容，一個 str |
| `readline()` | 一行，一個 str |
| `readlines()` | 所有行，一個 list |
| `write(s)` | 寫入字串，回傳寫入字元數 |
| `writelines(seq)` | 寫多個字串，不會自動補換行 |

## 九、模組與例外處理

```python
import math
math.sqrt(16)

from random import randint
randint(1, 6)  # 1 與 6 都可能出現

import datetime
today = datetime.date.today()
```

例外流程：

```python
try:
    n = int(input('Number: '))
    result = 10 / n
except ValueError:
    print('不是整數')
except ZeroDivisionError:
    print('不能除以零')
else:
    print(result)       # 沒有例外才執行
finally:
    print('完成')       # 一定執行
```

順序：

1. 先執行 `try`。
2. 發生例外時，尋找相符的 `except`。
3. 沒發生例外才執行 `else`。
4. 不論有沒有例外，`finally` 通常都會執行。

## 十、物件導向

```python
class Student:
    school = 'ITS'  # 類別屬性

    def __init__(self, name, score):
        self.name = name      # 實例屬性
        self.score = score

    def passed(self):
        return self.score >= 60

s = Student('Amy', 85)
print(s.name)      # Amy
print(s.passed())  # True
```

- `self` 代表目前這個物件。
- `__init__` 在建立物件時初始化資料。
- 子類別可以繼承父類別的屬性與方法。
- 子類別重新定義同名方法叫「覆寫」。
- `pass` 可建立暫時沒有新內容的類別。

```python
class Person:
    def speak(self):
        return 'hello'

class Student(Person):
    def speak(self):  # 覆寫
        return 'hi'
```

三大概念：封裝、繼承、多型。

## 十一、考前必背 25 個陷阱

1. `input()` 回傳 `str`。
2. `True` 是 bool；`'True'` 是 str。
3. `/` 是真除法，通常得到 float。
4. `//` 是向下取整，負數尤其要小心。
5. `**` 比一元負號優先。
6. `=` 是指定；`==` 是比較。
7. `not` → `and` → `or`。
8. 字串比較大小依 Unicode 順序，大小寫有別。
9. `if/for/while/def/class` 後要有冒號。
10. 縮排決定程式區塊。
11. `range()` 不包含 stop。
12. 索引從 0 開始，`-1` 是最後一個。
13. 字串與 tuple 不可修改。
14. `sort()` 原地排序且回傳 `None`。
15. `append()` 加一個元素；`extend()` 加多個元素。
16. `remove(x)` 依值刪；`pop(i)` 依索引刪。
17. `b = a` 不會複製串列。
18. `while` 要更新控制變數。
19. `break` 只離開最內層迴圈。
20. `return` 立即結束函式。
21. 沒寫 `return` 就回傳 `None`。
22. 有預設值參數應放在一般參數後。
23. `w` 會清空檔案；`a` 才是附加。
24. `read()` 得 str；`readlines()` 得 list。
25. 具體的 `except` 通常放在一般 `Exception` 前面。

## 十二、自我測驗

先不要看答案：

1. `type('False')` 是什麼？
2. `7 / 2`、`7 // 2`、`7 % 2` 各是多少？
3. `-2 ** 2` 是多少？
4. `range(2, 8, 2)` 產生哪些數？
5. `'Python'[1:4]` 是什麼？
6. `[1,2].append(3)` 後串列為何？`append()` 回傳什麼？
7. `x=[]; y=x; y.append(1)` 後，`x` 是什麼？
8. `sort()` 與 `sorted()` 差在哪裡？
9. `break`、`continue`、`pass` 各做什麼？
10. 沒寫 `return` 的函式回傳什麼？
11. `open(..., 'w')` 對原內容做什麼？
12. `try` 沒發生例外時，`except`、`else`、`finally` 哪些執行？
13. `self` 代表什麼？
14. `==` 與 `is` 差在哪裡？
15. 以下輸出為何？

```python
x = 0
while x < 4:
    if x % 2 == 0:
        print(x, end=' ')
    x += 1
```

### 答案

1. `str`
2. `3.5`、`3`、`1`
3. `-4`
4. `2, 4, 6`
5. `'yth'`
6. `[1, 2, 3]`；回傳 `None`
7. `[1]`
8. `sort()` 修改原 list 且回傳 `None`；`sorted()` 回傳新 list
9. 離開迴圈／跳下一輪／占位不做事
10. `None`
11. 清空後寫入
12. `else`、`finally`
13. 目前實例
14. 比較值／比較是否同一物件
15. `0 2 `

## 十三、7 天衝刺計畫

| 天數 | 主題 | 完成標準 |
|---|---|---|
| Day 1 | 型別、input、轉型、print | 能立刻判斷型別與輸出 |
| Day 2 | 運算子、優先順序、布林 | 20 題至少答對 18 題 |
| Day 3 | if / elif / else | 能解釋每個分支是否執行 |
| Day 4 | 字串、list、tuple、dict、set | 熟記索引、切片與方法回傳值 |
| Day 5 | for、while、range | 每題能畫逐行追蹤表 |
| Day 6 | 函式、檔案、例外、模組、類別 | 能辨認標準結構與關鍵字 |
| Day 7 | 整份限時模擬與錯題重做 | 錯題能說出「錯誤規則」 |

每天 90 分鐘：

- 15 分鐘：背本章規則。
- 40 分鐘：不看答案做題。
- 20 分鐘：逐題訂正並寫錯因。
- 15 分鐘：重做錯題，口頭說出正確規則。

錯題本只寫三件事：我選了什麼、正確規則、下次看到哪個關鍵字要警覺。

> 你不是要把 61 頁全部背起來；你要把同一批規則練到看到題目就能判斷。
