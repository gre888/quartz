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


# Python 15% 試卷必考項目

依據《PYTHON_202412_OK_15趴》28 頁試卷整理。這一份不是單純重複前一份 85% 題庫，而是補充許多容易失分的細節題。

## 一、先看結論：複習優先順序

### A 級：考前一定要會

1. `input()` 型別與 `int()`、`float()`、`str()` 轉型
2. 字串格式化：引號、`.format()`、f-string、`.2f`
3. `if / elif / else` 的條件順序與範圍
4. `is`、`==`、`in` 的差異
5. `range()`、`randint()`、`randrange()` 的邊界
6. 函式必要參數、預設參數、位置引數、關鍵字引數
7. 檔案模式 `r / w / a / w+` 與 `readline()`
8. `try / except / else / finally`
9. `unittest.TestCase` 與常用 assert
10. 常見錯誤類型：`SyntaxError`、`TypeError`、`NameError`、`ValueError`

### B 級：很可能出現

- 日期格式 `%B`、`%d`、`%y`
- `sys.argv` 命令列參數
- `math.floor()`、`math.fabs()`
- `os.path.isfile()`
- 字串大小寫方法與切片
- 註解 `#`、行內註解、字串中的 `#`
- 巢狀迴圈與質數判斷

### C 級：至少要認得

- `assertIsInstance()`
- docstring
- `None` 與 `is None`
- 函式沒有 `return` 時回傳 `None`
- 區域變數不一定會修改函式外的變數

---

## 二、輸入、轉型與輸出格式

### 1. `input()` 永遠回傳字串

```python
age = input('Enter age: ')       # str
age = int(input('Enter age: '))  # int
rating = float(input('Rating: '))
```

題型常問：程式在哪一行發生錯誤？

```python
base = input('Base: ')
exponent = input('Exponent: ')
result = base ** exponent
```

`base` 與 `exponent` 都是 `str`，字串不能使用 `**`，所以執行到第三行時產生 `TypeError`。

正確寫法：

```python
base = float(input('Base: '))
exponent = float(input('Exponent: '))
result = base ** exponent
```

### 2. CSV 類型輸出

需求：文字要有雙引號、數字不要有引號、兩者以逗號分隔。

```python
item = 'Book'
sales = 10

print('"{0}", {1}'.format(item, sales))
# "Book", 10

print('"' + item + '",', sales)
# print 的兩個參數預設以一個空格分隔
```

錯誤寫法：

```python
print(item + ',' + sales)
```

因為 `sales` 是 `int`，不能直接與 `str` 使用 `+`，會產生 `TypeError`。

### 3. 小數格式

```python
average = 4.2567
print(format(average, '.2f'))  # 4.26
print(f'{average:.2f}')        # 4.26
```

- `.2f`：固定顯示兩位小數，並四捨五入。
- `2d` 是整數寬度格式，不是兩位小數。

### 4. `.format()` 參數索引

```python
x = 'Tiger'
y = 'Lion'
z = 'Jaguar'

print('{1} and {0} and {2}'.format(x, y, z))
# Lion and Tiger and Jaguar
```

索引仍從 0 開始：`{0}` 是第一個參數。

---

## 三、日期格式化

```python
import datetime

d = datetime.datetime(2017, 4, 7)
print('{:%B-%d-%y}'.format(d))
```

| 格式碼 | 意義 | 範例 |
|---|---|---|
| `%B` | 完整月份名稱 | `April` |
| `%b` | 月份縮寫 | `Apr` |
| `%m` | 兩位數月份 | `04` |
| `%d` | 兩位數日期 | `07` |
| `%Y` | 四位數年份 | `2017` |
| `%y` | 兩位數年份 | `17` |

標準 Python 結果通常是 `April-07-17`；若試卷選項把英文全部顯示成大寫，仍應選擇月份名稱、日期、兩位數年份的那個選項。

---

## 四、字典鍵的型別

```python
rooms = {1: 'Foyer', 2: 'Conference Room'}
room = input('Room number: ')
```

如果輸入 `1`，`room` 是字串 `'1'`，但字典的 key 是整數 `1`：

```python
'1' != 1
```

因此 `room in rooms` 是 `False`。

正確修正：

```python
room = int(input('Room number: '))
```

必考觀念：字典查詢不只比較表面內容，也要匹配 key 的資料型別。

---

## 五、條件判斷與範圍

### 1. `=` 與 `==`

```python
x = 5       # 指派
x == 5      # 比較，結果為 bool
```

```python
if x = 5:
```

這是 `SyntaxError`，條件比較必須使用 `==`。

### 2. `<=` 包含相等

```python
if num1 <= num2:
```

條件在「小於」或「等於」時都成立，不能說只有 `num1 < num2` 時才執行。

### 3. 成績判斷要由高往低

```python
if grade >= 90:
    letter = 'A'
elif grade >= 80:
    letter = 'B'
elif grade >= 70:
    letter = 'C'
elif grade >= 65:
    letter = 'D'
else:
    letter = 'F'
```

如果先寫 `grade >= 65`，90 分也會先進入 D 的分支。

### 4. 位數判斷

```python
if -10 < num < 10:
    digits = '1'
elif -100 < num < 100:
    digits = '2'
else:
    digits = '>2'
```

因為 `elif` 只有在第一個條件不成立時才判斷，所以第二個範圍不用再次排除一位數。

### 5. `and` 與 `or`

```python
if numerator is None or denominator is None:
    print('缺少必要值')
elif denominator == 0:
    print('分母不能為零')
```

分子或分母只要有一個缺少就要報錯，所以使用 `or`。

---

## 六、`is`、`==`、`in`

| 運算子 | 比較內容 | 範例 |
|---|---|---|
| `==` | 值是否相等 | `a == b` |
| `is` | 是否為同一物件 | `a is b` |
| `in` | 是否包含 | `x in items` |

```python
num_list = [1, 2, 3]
alpha_list = ['a', 'b', 'c']

print(num_list is alpha_list)  # False
print(num_list == alpha_list)  # False

num_list = alpha_list
print(num_list is alpha_list)  # True
print(num_list == alpha_list)  # True
```

### `None` 建議使用 `is`

```python
if value is None:
    ...
```

不要寫 `value = None`，因為 `=` 是指派。

---

## 七、字串處理

### 1. 大小寫方法

```python
name.lower()       # 全小寫的新字串
name.upper()       # 全大寫的新字串
name.capitalize()  # 第一個字元大寫，其餘小寫
name.title()       # 每個單字首字母大寫
```

判斷輸入是否全小寫：

```python
if name.lower() == name:
    print('all lowercase')
elif name.upper() == name:
    print('all uppercase')
else:
    print('mixed case')
```

### 2. 切片

```python
text[start:stop:step]
```

- 包含 `start`。
- 不包含 `stop`。
- `step` 是間隔。
- `text[::-1]` 可反轉字串。

### 3. 使用 while 反轉字串

```python
def reverse_name(backward_name):
    forward_name = ''
    index = len(backward_name) - 1

    while index >= 0:
        forward_name += backward_name[index]
        index -= 1

    return forward_name
```

長度為 N 的序列，最後一個索引永遠是 `N - 1`。

---

## 八、運算子優先順序

順序：

1. 括號 `()`
2. 次方 `**`
3. 乘、除、整除、餘數 `* / // %`
4. 加減 `+ -`
5. 比較
6. `not`
7. `and`
8. `or`

試卷範例：

```python
value1 = 9
value2 = 4
answer = (value1 % value2 * 10) // 2.0 ** 3.0 + value2
```

計算：

```text
9 % 4 = 1
1 * 10 = 10
2.0 ** 3.0 = 8.0
10 // 8.0 = 1.0
1.0 + 4 = 5.0
```

只要 `//` 的其中一個運算元是 float，結果也可能是 float，例如 `10 // 8.0 == 1.0`。

---

## 九、迴圈必考題

### 1. 哨兵值（sentinel）

```python
total = 0
count = 0

while True:
    rating = float(input('Rating (-1 to stop): '))
    if rating == -1:
        break
    total += rating
    count += 1
```

`-1` 只負責結束迴圈，不應加入總和或計數。

### 2. 質數判斷

```python
for num in range(2, 101):
    is_prime = True

    for divisor in range(2, num):
        if num % divisor == 0:
            is_prime = False
            break

    if is_prime:
        print(num)
```

- 1 不是質數。
- 被整除的判斷：`num % divisor == 0`。
- 找到因數後可 `break`。

### 3. 巢狀迴圈

```python
for row in range(2, 13):
    for column in range(2, 13):
        print(row * column)
```

外層每執行一次，內層會完整執行一輪。

### 4. 逐字檢查

```python
count = 0

for word in word_list:
    for letter in word:
        if letter == target:
            count += 1
```

第一層取得單字，第二層取得單字中的字元。

---

## 十、函式參數

### 1. 從呼叫方式反推函式定義

```python
biker = get_name()
calories = calc_calories(distance, burn_rate)
```

合理定義：

```python
def get_name():
    ...

def calc_calories(miles, calories_per_mile):
    return miles * calories_per_mile
```

### 2. 預設參數

```python
def increment_score(score, bonus, points=1):
    if bonus:
        points *= 2
    return score + points
```

- 有預設值的參數可省略。
- 沒有預設值的參數是必要參數。
- 必要參數通常放在預設參數前面。

### 3. 位置引數與關鍵字引數

```python
def room_assignment(student, year):
    ...

room_assignment('Amy', 4)
room_assignment('Amy', year=4)
room_assignment(year=4, student='Amy')
```

以上都正確。

錯誤：

```python
room_assignment(year=4, name='Amy')
```

函式沒有名為 `name` 的參數，會產生 `TypeError`。

### 4. `pass` 不等於 `return`

```python
if salary > 0:
    pass
```

`pass` 只表示什麼都不做，程式仍會繼續執行後面的敘述。

### 5. 沒有 `return`

```python
def show_message():
    print('hello')
```

此函式會顯示文字，但回傳值是 `None`。

### 6. 區域變數

整數、字串等不可變物件傳入函式後，在函式內重新指定參數，通常不會修改外部同名變數：

```python
points = 5

def double(points):
    points = points * 2
    return points

result = double(points)
print(points)  # 5
print(result)  # 10
```

---

## 十一、隨機數邊界

### `randint()` 包含兩端

```python
random.randint(5, 11)
```

可能得到 5、6、7、8、9、10、11。

### `randrange()` 不包含 stop

```python
random.randrange(5, 12, 1)
```

同樣可能得到 5 到 11，但不包含 12。

### 產生 5 到 100 的 5 倍數

```python
random.randint(1, 20) * 5
random.randrange(5, 105, 5)
```

錯誤陷阱：

- `randrange(0, 100, 5)` 會包含 0，最大只到 95。
- `randint(0, 20) * 5` 可能得到 0。

---

## 十二、檔案處理

### 1. 模式比較

| 模式 | 讀取 | 寫入 | 檔案不存在 | 原內容 |
|---|---:|---:|---|---|
| `r` | ✓ |  | 產生錯誤 | 保留 |
| `w` |  | ✓ | 建立 | 清空 |
| `a` |  | ✓ | 建立 | 保留，寫到最後 |
| `w+` | ✓ | ✓ | 建立 | 清空 |

### 2. `readline()` 的兩種特殊結果

```python
line = file.readline()
```

- 到達 EOF：回傳空字串 `''`。
- 讀到空白行：通常回傳換行字串 `'\n'`。

因此：

```python
if line != '':       # 尚未到 EOF
    if line != '\n': # 不是空白行
        print(line)
else:
    print('End of file')
```

這是本份試卷非常值得背的細節。

### 3. `with open()`

```python
with open('data.txt', 'r', encoding='utf-8') as file:
    first_line = file.readline()
```

離開 `with` 區塊後自動關閉檔案。

### 4. 檢查檔案是否存在

```python
import os

def get_first_line(filename):
    if os.path.isfile(filename):
        with open(filename, 'r') as file:
            return file.readline()
    else:
        return None
```

---

## 十三、例外處理

```python
try:
    file = open('out.txt', 'w+')
except OSError:
    print('open failed')
else:
    print('open succeeded')
finally:
    print('finished')
```

| 區塊 | 執行時機 |
|---|---|
| `try` | 先執行可能出錯的程式 |
| `except` | 發生相符例外時執行 |
| `else` | 沒有發生例外時執行 |
| `finally` | 不論成功失敗通常都執行 |

規則：

- `try` 至少要搭配 `except` 或 `finally`。
- 可以有多個 `except`。
- `else` 不能單獨存在，必須接在 `try/except` 結構後。
- 具體例外應放在一般 `Exception` 前面。

---

## 十四、註解與 docstring

```python
# 這是單行註解
x = 5  # 這是行內註解

text = '# 這是字串，不是註解'
```

- Python 單行註解使用 `#`。
- `//` 在 Python 是整除，不是註解。
- 引號內的 `#` 是普通字元。

函式說明文件：

```python
def area(width, height):
    """Return the rectangle area."""
    return width * height
```

三引號放在函式第一個敘述時會成為 docstring。

---

## 十五、命令列參數 `sys.argv`

```python
import sys
print(sys.argv[2])
```

執行：

```text
python Script.py Cheese Bacon Bread
```

| 索引 | 內容 |
|---:|---|
| `sys.argv[0]` | `Script.py` |
| `sys.argv[1]` | `Cheese` |
| `sys.argv[2]` | `Bacon` |
| `sys.argv[3]` | `Bread` |

所以輸出是 `Bacon`。腳本名稱占索引 0。

---

## 十六、math 模組

```python
import math

math.fabs(-3.5)  # 3.5，回傳浮點數絕對值
math.floor(3.9)  # 3，向下取整
math.ceil(3.1)   # 4，向上取整
```

注意：

```python
math.floor(-3.1)  # -4
```

`floor` 是往負無限方向，不是單純刪掉小數。

---

## 十七、單元測試 `unittest`

標準結構：

```python
import unittest

class TestSomething(unittest.TestCase):
    def test_is_instance(self):
        self.assertIsInstance(obj, cls)

if __name__ == '__main__':
    unittest.main()
```

重點：

- 測試類別繼承 `unittest.TestCase`。
- 測試方法名稱必須以 `test` 開頭，測試執行器才會自動找到。
- Python 大小寫敏感：`assertIsInstance` 的 `I` 必須大寫。

| 方法 | 測試內容 |
|---|---|
| `assertEqual(a, b)` | `a == b`，值相等 |
| `assertIs(a, b)` | `a is b`，同一物件 |
| `assertIn(a, b)` | `a in b`，包含關係 |
| `assertTrue(x)` | x 是否為 True |
| `assertIsInstance(obj, cls)` | obj 是否為 cls 的實例 |

---

## 十八、常見錯誤類型

| 錯誤 | 典型原因 |
|---|---|
| `SyntaxError` | `if x = 5:`、漏冒號、語法結構錯誤 |
| `TypeError` | `'5' ** '2'`、字串直接加整數、參數數量錯誤 |
| `ValueError` | `int('abc')` |
| `NameError` | 使用尚未定義的變數 |
| `IndexError` | 索引超出 list／字串範圍 |
| `KeyError` | dict 中沒有該 key |
| `ZeroDivisionError` | 除數為 0 |
| `FileNotFoundError` | 以 `r` 開啟不存在的檔案 |

判斷錯誤發生位置時，先問：

1. 程式能不能被解析？不能 → `SyntaxError`。
2. 變數是否存在？不存在 → `NameError`。
3. 型別是否支援這個運算？不支援 → `TypeError`。
4. 型別正確但值不能轉換？→ `ValueError`。

---

## 十九、考前必背 20 句

1. `input()` 永遠回傳 `str`。
2. `format(x, '.2f')` 顯示兩位小數。
3. `%B` 完整月份，`%d` 日期，`%y` 兩位年份。
4. 字典 key 的值和型別都要相符。
5. `=` 指派；`==` 比較值；`is` 比較物件身分。
6. `in` 檢查包含關係。
7. `elif` 只有前面的條件不成立才判斷。
8. 成績區間通常由高分往低分判斷。
9. `range()` 與 `randrange()` 不包含 stop。
10. `randint(a, b)` 包含 a、b 兩端。
11. 長度 N 的序列最後索引是 `N - 1`。
12. 沒有 `return` 的函式回傳 `None`。
13. `pass` 只占位，不會結束函式。
14. 關鍵字引數名稱必須與參數名稱完全相同。
15. `readline()` 到 EOF 回傳 `''`，空白行通常是 `'\n'`。
16. `w`、`w+` 會清空原檔案。
17. `else` 在 try 沒有例外時執行；`finally` 通常一定執行。
18. `sys.argv[0]` 是腳本名稱。
19. unittest 測試方法要以 `test` 開頭。
20. `assertEqual` 比值，`assertIs` 比身分，`assertIn` 比包含。

---

## 二十、考前自我測驗

先遮住答案：

1. `input()` 回傳哪種型別？
2. `print('"{0}", {1}'.format('Book', 5))` 輸出為何？
3. `format(3.456, '.2f')` 結果為何？
4. `%B-%d-%y` 各代表什麼？
5. 為什麼字串 `'1'` 找不到字典中的整數 key `1`？
6. `a == b` 與 `a is b` 差在哪裡？
7. `random.randint(5, 11)` 是否可能得到 11？
8. `random.randrange(5, 11)` 是否可能得到 11？
9. `readline()` 到達 EOF 回傳什麼？
10. `readline()` 讀到空白行通常回傳什麼？
11. `w+` 在檔案不存在時會怎樣？存在時又會怎樣？
12. 函式只使用 `print()` 而沒有 `return`，回傳什麼？
13. `sys.argv[0]` 是什麼？
14. unittest 測試類別要繼承什麼？
15. 測試兩個物件是否為同一物件要用哪個 assert？
16. `math.floor(-3.1)` 是多少？
17. `if x = 5:` 是哪一類錯誤？
18. `'5' + 2` 是哪一類錯誤？
19. `int('abc')` 是哪一類錯誤？
20. `os.path.isfile(path)` 用來做什麼？

### 答案

1. `str`
2. `"Book", 5`
3. `'3.46'`
4. 完整月份、兩位日期、兩位年份
5. key 的資料型別不同，`'1' != 1`
6. 比較值／比較是否為同一物件
7. 會，`randint` 包含上限
8. 不會，`randrange` 不包含 stop
9. `''`
10. `'\n'`
11. 不存在會建立；存在會先清空再讀寫
12. `None`
13. 腳本檔名
14. `unittest.TestCase`
15. `assertIs(a, b)`
16. `-4`
17. `SyntaxError`
18. `TypeError`
19. `ValueError`
20. 檢查指定路徑是否為存在的檔案

## 最後複習建議

先把「考前必背 20 句」讀到能口頭回答，再做自我測驗。若只能再讀三個主題，依序選：

1. 檔案與 `readline()`
2. 函式參數與 `unittest`
3. 隨機數、日期與錯誤類型

這三部分正是本份 15% 試卷相對上一份 85% 題庫最有補充價值的內容。
