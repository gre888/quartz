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
