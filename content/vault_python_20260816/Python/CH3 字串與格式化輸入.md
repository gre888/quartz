# Python 字串、輸入、轉型與格式化完整重點筆記

> 本筆記整合「Python 字串（String）函式重點整理」與「Python 字串、輸入與格式化重點筆記」。
>
> 核心觀念：Python 的字串 `str` 是**不可變（immutable）物件**。大部分字串方法不會直接修改原字串，而是回傳新的字串。

---

## 1. 字串索引（Index）

字串中的每一個字元都有位置編號，稱為「索引」。

```python
s = 'Python 基礎必修課'

print(s[3])    # h
print(s[-2])   # 修
```

- 正索引：從左邊開始，由 `0` 起算。
- 負索引：從右邊開始，由 `-1` 起算。
- `-1` 就是最後一個字元。

### 索引不可超出範圍

```python
print(s[16])
# IndexError: string index out of range
```

可以先使用：

```python
print(len(s))
```

有效正索引範圍：

```text
0 ~ len(s) - 1
```

---

## 2. 字串切片（Slice）

基本語法：

```python
字串[開始位置:結束位置:間隔]
```

重點：**結束位置不包含在結果中。**

```python
s = 'Python 基礎必修課'

print(s[:])       # 完整字串
print(s[7:])      # 索引 7 到最後
print(s[:6])      # 索引 0～5
print(s[5:8])     # 索引 5～7
print(s[::2])     # 每隔 2 個位置取一個字元
print(s[::-1])    # 字串反轉
print(s[::-2])    # 從右向左，每隔 2 個位置取一個
print(s[0:5:2])   # 索引 0、2、4
```

### 反向切片

間隔為負數時，代表由右向左：

```python
print(s[9:6:-1])
```

### 必記

```text
s[::-1] → 字串反轉
```

---

## 3. `len()`、`max()`、`min()`

### `len()`

取得字串字元數，空白也會計算。

```python
s = "hello world!"
print(len(s))       # 12
```

### `max()` / `min()`

依 Unicode 編碼順序比較字元。

```python
print(max("abcxyz"))   # z
print(min("abcxyz"))   # a
```

如果包含空白：

```python
s = "hello world!"
print(min(s))          # 空白字元
```

注意：

```text
max()、min() 是 Python 內建函式
```

所以寫：

```python
max(s)
min(s)
```

不是：

```python
s.max()
s.min()
```

---

## 4. `input()` 輸入資料

`input()` 取得的資料**一定是字串 `str`**。

```python
user_name = input('請輸入姓名：')
age = int(input('請輸入年齡：'))

print('姓名：%s\t年齡：%d歲' % (user_name, age))
```

- `%s`：字串
- `%d`：十進位整數
- `\t`：Tab
- 若需要數值運算，要使用 `int()` 或 `float()` 轉型。

### 輸入錯誤處理

```python
try:
    age = int(input('請輸入年齡：'))
except ValueError:
    print('年齡必須輸入整數')
```

---

## 5. 字串與數值轉型

### `int()`

```python
s1 = '123'
number = int(s1)

print(number)
print(type(number))
# 123
# <class 'int'>
```

### `float()`

```python
s2 = '12.34'

print(float(s2))   # 12.34
print(float('123')) # 123.0
```

### `str()`

將資料轉成字串：

```python
num = 123
s = str(num)

print(type(s))
# <class 'str'>
```

### `type()`

查看資料型別：

```python
print(type(123))      # int
print(type(12.34))    # float
print(type('123'))    # str
```

---

## 6. `eval()` 的作用與風險

`eval()` 會把字串內容當成 Python 運算式執行。

```python
print(eval('2 + 3'))    # 5
print(eval('123'))      # 123
print(eval('12.34'))    # 12.34
```

例如：

```python
s1, s2 = '123', '12.34'
print(eval('s1 + s2'))
# 12312.34
```

因為 `s1`、`s2` 本身仍是字串，所以 `+` 是字串連接。

### 安全提醒

不要直接對不可信任的使用者輸入使用 `eval()`。

一般資料轉型優先使用：

```python
int()
float()
str()
```

---

# 7. 字串大小寫轉換

| 方法 | 功能 | 範例 |
|---|---|---|
| `lower()` | 全部轉小寫 | `'ABC'.lower()` |
| `upper()` | 全部轉大寫 | `'abc'.upper()` |
| `swapcase()` | 大小寫互換 | `'Hello'.swapcase()` |
| `capitalize()` | 第一個字元大寫，其餘小寫 | `'hello WORLD'.capitalize()` |
| `title()` | 每個單字字首大寫 | `'hello world'.title()` |

```python
s = "Hello World!"

print(s.lower())       # hello world!
print(s.upper())       # HELLO WORLD!
print(s.swapcase())    # hELLO wORLD!
print(s.capitalize())  # Hello world!
print(s.title())       # Hello World!
```

### `capitalize()` vs `title()`

```python
"hello world".capitalize()
# Hello world

"hello world".title()
# Hello World
```

---

## 8. 判斷字串內容：`is...()`

這些方法通常回傳 `True` 或 `False`。

| 方法 | 功能 |
|---|---|
| `isalnum()` | 是否全部由文字或數字組成 |
| `isalpha()` | 是否全部為文字字元 |
| `isdigit()` | 是否全部為數字字元 |
| `isspace()` | 是否全部為空白字元 |
| `islower()` | 有大小寫的字母是否皆為小寫 |
| `isupper()` | 有大小寫的字母是否皆為大寫 |
| `istitle()` | 是否符合標題格式 |

```python
print("3M".isalnum())        # True
print("3M".isalpha())        # False
print("123".isdigit())       # True
print("   ".isspace())       # True
print("abc 公司".islower())  # True
print("U-LIONS 統一獅".isupper()) # True
print("Hello World".istitle())    # True
```

### 注意

Python 的 `isalpha()`、`isalnum()`、`isdigit()` 依 Unicode 字元規則判斷，不只限於 ASCII 英文字母與數字。

### 容易寫錯

```python
print('3M.isalpha()')
```

這只是印出文字。

正確：

```python
print('3M'.isalpha())
```

---

## 9. 搜尋字串

### `startswith()`

判斷是否以指定內容開頭：

```python
s = "Python String"

print(s.startswith("Python"))  # True
print(s.startswith("String"))  # False
```

語法：

```python
string.startswith(prefix[, start[, end]])
```

### `endswith()`

判斷是否以指定內容結尾：

```python
s = "Python String."
print(s.endswith("."))   # True
```

### `find()`

從左邊尋找，找不到回傳 `-1`。

```python
s = "Python"

print(s.find("th"))    # 2
print(s.find("Java"))  # -1
```

### `rfind()`

從右邊搜尋，找不到回傳 `-1`。

### `index()`

從左邊尋找，找不到會產生 `ValueError`。

```python
s = "Python String"

print(s.index("String"))  # 7
```

```python
s.index("Java")
# ValueError
```

### `rindex()`

從右邊搜尋，找不到會產生 `ValueError`。

```python
s = "abc abc abc"
print(s.rindex("abc"))   # 8
```

### 必考：`find()` vs `index()`

| 方法 | 搜尋方向 | 找不到 |
|---|---|---|
| `find()` | 左 → 右 | `-1` |
| `rfind()` | 右 → 左 | `-1` |
| `index()` | 左 → 右 | `ValueError` |
| `rindex()` | 右 → 左 | `ValueError` |

記法：

```text
find  → 找不到還能繼續，回傳 -1
index → 找不到直接報錯
```

---

## 10. `count()` 統計出現次數

```python
s = "abc abc abc"

print(s.count("abc"))     # 3
print(s.count("abc", 4))  # 2
```

語法：

```python
string.count(sub[, start[, end]])
```

---

## 11. `split()` / `rsplit()` 字串分割

### `split()`

從左邊開始分割，結果是 `list`。

```python
s = "Python,Java,C++"

print(s.split(","))
# ['Python', 'Java', 'C++']
```

限制分割次數：

```python
print(s.split(",", 1))
# ['Python', 'Java,C++']
```

### `rsplit()`

指定分割次數時，從右邊開始。

```python
print(s.rsplit(",", 1))
# ['Python,Java', 'C++']
```

### 必考

```text
split()  → 左邊開始分
rsplit() → 右邊開始分
```

---

## 12. `join()` 連接字串

使用指定字串作為分隔符號，連接可迭代物件中的字串元素。

```python
data = ["Python", "Java", "C++"]

print(",".join(data))
# Python,Java,C++
```

常與 `split()` 搭配：

```python
s = "Python Java C++"

words = s.split()
result = "-".join(words)

print(result)
# Python-Java-C++
```

### 必考

```text
split()：字串 → list
join() ：list 中的字串 → 字串
```

---

## 13. `replace()` 替換字串

語法：

```python
string.replace(old, new[, count])
```

```python
s = "I like Python. Python is easy."

print(s.replace("Python", "Java"))
# I like Java. Java is easy.
```

只替換一次：

```python
print(s.replace("Python", "Java", 1))
# I like Java. Python is easy.
```

注意：原字串不會被修改。

```python
new_s = s.replace("Python", "Java")
```

---

## 14. `strip()` / `lstrip()` / `rstrip()`

| 方法 | 處理位置 |
|---|---|
| `strip()` | 左右兩側 |
| `lstrip()` | 左側 |
| `rstrip()` | 右側 |

### `strip()`

```python
s = "\t Hello World! \n"

print(s.strip())
# Hello World!
```

### `rstrip()`

```python
s = "hello world!!!"

print(s.rstrip("!"))
# hello world
```

### `lstrip()`

```python
s = "hhhhello world!"

print(s.lstrip("h"))
# ello world!
```

### 注意

`strip(chars)` 的參數是「要移除的字元集合」，不是一定要完整匹配一段字串。

---

## 15. `expandtabs()`

將 `\t` Tab 字元依 Tab stop 規則展開成空白。

```python
print("Hello\tWorld!".expandtabs(4))
```

預設：

```python
print("Hello\tWorld!".expandtabs())
```

預設 `tabsize=8`。

實際補多少空白與目前字串位置有關，不一定剛好補 `tabsize` 個空白。

---

## 16. 字串對齊與補字元

| 方法 | 功能 |
|---|---|
| `center(width[, fillchar])` | 置中 |
| `ljust(width[, fillchar])` | 靠左 |
| `rjust(width[, fillchar])` | 靠右 |
| `zfill(width)` | 左側補 `0` |

### `center()`

```python
print("ABC".center(9, "-"))
# ---ABC---
```

### `rjust()`

```python
s = "hello world!"

print(s.rjust(16, ">"))
# >>>>hello world!
```

### `ljust()`

```python
print(s.ljust(16, "<"))
# hello world!<<<<
```

### `zfill()`

```python
print(s.zfill(16))
# 0000hello world!
```

`center()`、`ljust()`、`rjust()` 中的寬度表示**輸出結果總寬度**。

---

# 17. `%` 舊式格式化

```python
name = "Tom"
age = 20

print("姓名：%s，年齡：%d" % (name, age))
```

常見：

| 格式 | 功能 |
|---|---|
| `%s` | 字串 |
| `%d` | 十進位整數 |
| `%f` | 浮點數 |

---

# 18. `str.format()` 格式化

## 18.1 依位置放入資料

```python
s1 = '電車月票'
s2 = 1280

print('項目{0}，金額{1}'.format(s1, s2))
```

- `{0}`：第 1 個參數
- `{1}`：第 2 個參數
- 編號從 `0` 開始

---

## 18.2 小數、千分位、百分比

```python
p = 0.666666
i = 1000

print('{:.2f}'.format(p))     # 0.67
print('{:,}'.format(i * i))   # 1,000,000
print('{:.2%}'.format(p))     # 66.67%
print('{:.0f}'.format(p))     # 1
```

---

## 18.3 寬度與對齊

```python
s = '字串'
i = 1000

print('{:6}'.format(s))      # 字串預設靠左
print('{:6}'.format(i))      # 數字預設靠右
print('{:>6}'.format(s))     # 靠右
print('{:<6}'.format(i))     # 靠左
print('{:$^6}'.format(s))    # 置中，不足補 $
```

| 符號 | 功能 |
|---|---|
| `<` | 靠左 |
| `>` | 靠右 |
| `^` | 置中 |

可記成：

```text
{資料位置:補字元 對齊方式 寬度 .小數位數 類型}
```

---

## 18.4 顯示真正的大括號

```python
print('{}{{}}'.format('顯示'))
# 顯示{}
```

`{{` 與 `}}` 用來顯示真正的 `{`、`}`。

---

# 19. f-string 格式化

基本語法：

```python
name = "Tom"
age = 20

print(f"姓名：{name}，年齡：{age}")
```

## 常用型別格式

| 型別 | 用途 | 範例 |
|---|---|---|
| `s` | 字串 | `f"{name:s}"` |
| `d` | 十進位整數 | `f"{255:d}"` |
| `o` | 八進位 | `f"{255:o}"` |
| `x` | 十六進位小寫 | `f"{255:x}"` |
| `X` | 十六進位大寫 | `f"{255:X}"` |
| `f` | 固定小數格式 | `f"{3.14159:.2f}"` |
| `e` | 科學記號 | `f"{12345:e}"` |
| `E` | 大寫科學記號 | `f"{12345:E}"` |
| `g` | 一般或科學記號 | `f"{12345:g}"` |
| `!r` | `repr()` 形式 | `f"{value!r}"` |

```python
num = 255
pi = 3.1415926

print(f"{num:d}")       # 255
print(f"{num:o}")       # 377
print(f"{num:x}")       # ff
print(f"{num:X}")       # FF
print(f"{pi:.2f}")      # 3.14
print(f"{12345:e}")     # 1.234500e+04
```

---

# 20. 格式化方法比較

| 方法 | 範例 |
|---|---|
| `%` 格式化 | `"年齡：%d" % age` |
| `str.format()` | `"年齡：{}".format(age)` |
| f-string | `f"年齡：{age}"` |

---

# 21. `main()` 與程式進入點

```python
def main():
    pass


if __name__ == '__main__':
    main()
```

### `def main()`

建立 `main()` 函式，用來集中主要程式流程。

### `pass`

空敘述，代表暫時不執行任何動作。

### `if __name__ == '__main__':`

- 直接執行程式時，會呼叫 `main()`。
- 被其他程式 `import` 時，不會自動執行 `main()`。

---

# 22. 考試快速記憶表

| 類型 | 方法 / 函式 | 記憶方式 |
|---|---|---|
| 索引 | `s[0]` | 第一個字元 |
| 負索引 | `s[-1]` | 最後一個字元 |
| 切片 | `s[start:end:step]` | end 不包含 |
| 反轉 | `s[::-1]` | 字串倒過來 |
| 長度 | `len()` | 字元數 |
| 大小寫 | `lower()` | 全小寫 |
|  | `upper()` | 全大寫 |
|  | `swapcase()` | 大小寫互換 |
|  | `capitalize()` | 第一個字元大寫 |
|  | `title()` | 每個單字字首大寫 |
| 判斷 | `isalnum()` | 文字或數字 |
|  | `isalpha()` | 文字 |
|  | `isdigit()` | 數字 |
|  | `isspace()` | 空白 |
|  | `islower()` | 小寫判斷 |
|  | `isupper()` | 大寫判斷 |
|  | `istitle()` | 標題格式 |
| 搜尋 | `find()` | 找不到 `-1` |
|  | `index()` | 找不到報錯 |
|  | `rfind()` | 從右找，找不到 `-1` |
|  | `rindex()` | 從右找，找不到報錯 |
|  | `startswith()` | 開頭判斷 |
|  | `endswith()` | 結尾判斷 |
| 統計 | `count()` | 出現次數 |
| 分割 | `split()` | 字串 → list |
|  | `rsplit()` | 從右邊開始指定次數分割 |
| 合併 | `join()` | list 中的字串 → 字串 |
| 修改 | `replace()` | 替換 |
| 去除 | `strip()` | 左右 |
|  | `lstrip()` | 左 |
|  | `rstrip()` | 右 |
| 對齊 | `center()` | 置中 |
|  | `ljust()` | 靠左 |
|  | `rjust()` | 靠右 |
|  | `zfill()` | 左補 0 |
| 轉型 | `int()` | 字串 → 整數 |
|  | `float()` | 字串 → 浮點數 |
|  | `str()` | 轉字串 |
| 型別 | `type()` | 查看型別 |
| 格式化 | `.format()` | 格式化輸出 |
| 格式化 | `f"{}"` | f-string |

---

# 23. 最容易考的差異

## 23.1 `find()` vs `index()`

```text
find()  找不到 → -1
index() 找不到 → ValueError
```

## 23.2 `split()` vs `join()`

```text
split()：字串 → list
join() ：list 中的字串 → 字串
```

## 23.3 `split()` vs `rsplit()`

```text
split()  → 從左邊開始指定次數分割
rsplit() → 從右邊開始指定次數分割
```

## 23.4 `strip()` / `lstrip()` / `rstrip()`

```text
strip()  → 左右
lstrip() → 左
rstrip() → 右
```

## 23.5 `lower()` vs `islower()`

```python
"ABC".lower()      # 'abc'：轉換
"abc".islower()    # True：判斷
```

## 23.6 `upper()` vs `isupper()`

```python
"abc".upper()      # 'ABC'：轉換
"ABC".isupper()    # True：判斷
```

## 23.7 `capitalize()` vs `title()`

```python
"hello world".capitalize()
# Hello world

"hello world".title()
# Hello World
```

## 23.8 索引 vs 切片

```text
s[100]      → 超出範圍可能 IndexError
s[0:100]    → 切片超過範圍通常不會報錯
```

---

# 24. 本章必考重點總整理

1. 字串索引從 `0` 開始。
2. `-1` 是最後一個字元。
3. 切片 `[start:end:step]` 不包含 `end`。
4. `[::-1]` 可以反轉字串。
5. `input()` 回傳的一定是 `str`。
6. 數值輸入常搭配 `int(input())` 或 `float(input())`。
7. 字串是 immutable，方法通常回傳新字串。
8. `find()` 找不到回傳 `-1`。
9. `index()` 找不到產生 `ValueError`。
10. `split()` 將字串切成 list。
11. `join()` 將多個字串元素連接成字串。
12. `replace()` 回傳替換後的新字串。
13. `strip()` 只處理字串兩側。
14. `lower()` / `upper()` 是轉換；`islower()` / `isupper()` 是判斷。
15. `format()` 與 f-string 可以控制小數、千分位、百分比、寬度與對齊。
16. `eval()` 可以執行字串運算式，但不應直接處理不可信任的輸入。
17. `if __name__ == '__main__':` 用來控制程式直接執行時才啟動主要流程。

---

# 25. 一句話快速複習

```text
索引：0 從左開始，-1 從右開始
切片：[開始:結束:間隔]，結束不包含
反轉：[::-1]

轉換：lower / upper / swapcase / capitalize / title
判斷：is...
搜尋：find / index / startswith / endswith
統計：len / count / max / min
處理：replace / strip / split / join
排版：center / ljust / rjust / zfill

find 找不到 = -1
index 找不到 = ValueError

split = 字串 → list
join  = list 中的字串 → 字串

input = 一定回傳 str
int / float = 數值轉型

格式化：
% → 舊式格式化
.format() → 格式化方法
f-string → f"{變數}"
```

