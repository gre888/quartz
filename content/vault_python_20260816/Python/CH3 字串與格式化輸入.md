# Python 字串、輸入與格式化重點筆記

> 整理範圍：`index1.py`、`index2.py`、`input.py`、`str_fun.py`、`str2num.py`、`format1.py`、`format3.py`、`test.py`

## 一、字串索引（Index）

字串中的每一個字元都有位置編號，稱為「索引」。

```python
s = 'Python 基礎必修課'
```

- 正索引從左邊開始，由 `0` 起算。
- 負索引從右邊開始，由 `-1` 起算。

```python
print(s[3])    # h
print(s[-2])   # 修
```

### 注意：索引不可超出範圍

如果指定的位置不存在，會發生 `IndexError`：

```python
print(s[16])
# IndexError: string index out of range
```

可先使用 `len()` 查看字串長度：

```python
print(len(s))
```

有效的正索引範圍是 `0` 到 `len(s) - 1`。

---

## 二、字串切片（Slice）

基本語法：

```python
字串[開始位置:結束位置:間隔]
```

切片的「結束位置不包含在結果中」。省略開始或結束位置時，Python 會自動從字串開頭或取到結尾。

```python
s = 'Python 基礎必修課'

print(s[:])       # 複製完整字串
print(s[7:])      # 從索引 7 取到最後
print(s[:6])      # 索引 0～5，結果為 Python
print(s[5:8])     # 索引 5～7
print(s[::2])     # 每隔 2 個位置取一個字元
print(s[::-1])    # 字串反轉
print(s[::-2])    # 由右向左，每隔 2 個位置取一個字元
print(s[0:5:2])   # 索引 0、2、4
```

### 反向切片

間隔為負數時，代表從右向左取值：

```python
print(s[9:6:-1])
```

此例從索引 `9` 開始，反向取到索引 `7`，不包含索引 `6`。

---

## 三、使用 `input()` 輸入資料

`input()` 會等待使用者輸入，而且傳回值一定是字串 `str`。

```python
user_name = input('請輸入姓名：')
age = int(input('請輸入年齡：'))
print('姓名：%s\t年齡：%d歲' % (user_name, age))
```

- `%s`：格式化字串。
- `%d`：格式化整數。
- `\t`：插入定位字元（Tab）。
- 年齡需要用 `int()` 轉成整數。

### 輸入錯誤處理

如果使用者輸入的不是整數，`int()` 會產生 `ValueError`。可使用 `try...except`：

```python
try:
    age = int(input('請輸入年齡：'))
except ValueError:
    print('年齡必須輸入整數')
```

### 原始程式的小錯誤

```python
# coding uft-8
```

`uft-8` 拼字錯誤，應改成：

```python
# coding: utf-8
```

Python 3 的程式檔通常預設採用 UTF-8，因此大多數情況可以省略此行。

---

## 四、字串轉成數值

### `int()`：轉成整數

```python
s1 = '123'
number = int(s1)
print(number, type(number))
# 123 <class 'int'>
```

### `float()`：轉成浮點數

```python
s2 = '12.34'
print(float(s2), type(float(s2)))
print(float(s1), type(float(s1)))
```

結果分別為 `12.34` 和 `123.0`，型別都是 `float`。

### `type()`：查看資料型別

```python
print(type(123))      # <class 'int'>
print(type(12.34))    # <class 'float'>
print(type('123'))    # <class 'str'>
```

---

## 五、`eval()` 的作用與風險

`eval()` 會把字串內容當成 Python 運算式執行：

```python
print(eval('2 + 3'))       # 5
print(eval('123'))         # 123
print(eval('12.34'))       # 12.34
```

變數也可以出現在運算式中：

```python
s1, s2 = '123', '12.34'
print(eval('s1 + s2'))     # 12312.34
```

這裡的 `s1` 和 `s2` 都是字串，所以 `+` 代表字串連接，不是數值相加。

### 安全提醒

不要對不可信任的使用者輸入直接使用 `eval()`，因為它可能執行任意 Python 程式碼。一般型別轉換應優先使用：

- `int()`
- `float()`
- `str()`

---

## 六、字串搜尋方法

假設：

```python
s1 = 'python內建函式可以對字串做字串轉換、字串搜尋、字串分割。'
```

| 方法 | 功能 | 找不到時 |
|---|---|---|
| `find(text)` | 從左邊搜尋，傳回第一個位置 | 傳回 `-1` |
| `rfind(text)` | 從右邊搜尋 | 傳回 `-1` |
| `index(text)` | 從左邊搜尋 | 發生 `ValueError` |
| `rindex(text)` | 從右邊搜尋 | 發生 `ValueError` |
| `count(text)` | 計算出現次數 | 傳回 `0` |
| `startswith(text)` | 判斷是否以指定內容開頭 | 傳回布林值 |

```python
print(s1.find('字串'))
print(s1.find('字串', 14, 20))
print(s1.rfind('字串'))
print(s1.index('字串', 17))
print(s1.rindex('字串', 0, 20))
print(s1.count('字串'))
print(s1.startswith('字串'))
print(s1.startswith('字串', 13))
```

搜尋範圍也遵守 `[開始:結束]` 的觀念，不包含結束位置。

---

## 七、字串分割、連接與取代

### `split()` 與 `rsplit()`

```python
print(s1.split('、', 1))   # 從左邊最多分割 1 次
print(s1.split('、'))      # 分割所有符合位置
print(s1.rsplit('、', 1))  # 從右邊最多分割 1 次
```

分割結果是串列 `list`。

### `join()`

使用指定字串連接可迭代物件中的每個字串：

```python
parts = s1.split('、')
result = '@'.join(parts)
```

### `replace()`

```python
print(s1.replace('串', '元'))
```

字串是不可變物件，這些方法會傳回新字串，不會直接修改原字串。

---

## 八、大小寫轉換與文字排版

```python
s2 = 'Hello World'
```

| 方法 | 功能 |
|---|---|
| `capitalize()` | 第一個字元大寫，其餘轉成小寫 |
| `title()` | 每個單字的第一個字母大寫 |
| `upper()` | 全部轉成大寫 |
| `lower()` | 全部轉成小寫 |
| `swapcase()` | 大小寫互換 |
| `expandtabs(n)` | 將 Tab 展開到指定定位寬度 |

```python
print(s2.capitalize())
print('hello world!'.title())
print(s2.upper())
print(s2.lower())
print(s2.title().swapcase())
print('Hello\tWorld!'.expandtabs(10))
```

---

## 九、移除字串兩側內容

| 方法 | 功能 |
|---|---|
| `strip()` | 移除左右兩側的空白或指定字元 |
| `lstrip()` | 只移除左側 |
| `rstrip()` | 只移除右側 |

```python
print('\tHello World!\n'.strip())
print('Hello World!'.rstrip('!'))
print('Hello World'.lstrip('H'))
```

注意：參數代表要移除的「字元集合」，不是完整前綴或後綴字串。

---

## 十、字串對齊與補字元

```python
s2 = 'Hello World'

print(s2.center(18))       # 置中
print(s2.rjust(16, '<'))   # 靠右，左邊補 <
print(s2.ljust(16, '>'))   # 靠左，右邊補 >
print(s2.zfill(16))        # 左邊補 0
```

`center()`、`rjust()` 和 `ljust()` 的數字代表結果的總寬度。

---

## 十一、判斷字串內容

這些方法都會傳回 `True` 或 `False`：

| 方法 | 判斷內容 |
|---|---|
| `isalnum()` | 是否全部由字母或數字組成 |
| `isalpha()` | 是否全部為字母文字 |
| `isdigit()` | 是否全部為數字字元 |
| `isspace()` | 是否全部為空白字元 |
| `islower()` | 其中的英文字母是否皆為小寫 |
| `isupper()` | 其中的英文字母是否皆為大寫 |
| `istitle()` | 是否符合標題大小寫格式 |

```python
print('3M'.isalnum())
print('3M'.isalpha())
print('3M'.isdigit())
print('A or B'.isspace())
print('abc公司'.islower())
print('U-LIONS統一獅'.isupper())
print('Hello World'.istitle())
```

原始程式中的：

```python
print('3M.isalpha()')
```

只會印出文字 `3M.isalpha()`，不會呼叫方法。正確寫法是：

```python
print('3M'.isalpha())
```

---

## 十二、字串的 `max()`、`min()` 與 `len()`

```python
s2 = 'Hello World'

print(max(s2))   # Unicode 編碼值最大的字元
print(min(s2))   # Unicode 編碼值最小的字元
print(len(s2))   # 字串長度，包含空白
```

`max()` 和 `min()` 比較的是字元的 Unicode 編碼順序，不是英文單字的字典順序。

原始程式的 `min(min(s2))` 雖然可以執行，但內層 `min(s2)` 已經只剩一個字元，外層 `min()` 沒有必要。

---

## 十三、使用 `str.format()` 格式化輸出

### 依位置放入資料

```python
s1 = '電車月票'
s2 = 1280
print('項目{0}，金額{1}'.format(s1, s2))
```

- `{0}` 代表第 1 個參數。
- `{1}` 代表第 2 個參數。
- 位置編號從 `0` 開始。

### 數值格式

```python
p = 0.666666
i = 1000

print('{:.2f}'.format(p))   # 0.67，保留兩位小數
print('{:,}'.format(i * i)) # 1,000,000，加入千分位
print('{:.2%}'.format(p))   # 66.67%，百分比格式
print('{:.0f}'.format(p))   # 1，保留零位小數
```

### 寬度與對齊

```python
s = '字串'
i = 1000

print('{:6}'.format(s))     # 總寬度 6；字串預設靠左
print('{:6}'.format(i))     # 總寬度 6；數字預設靠右
print('{:>6}'.format(s))    # 靠右
print('{:<6}'.format(i))    # 靠左
print('{:$^6}'.format(s))   # 置中，不足位置補 $
```

常用對齊符號：

| 符號 | 功能 |
|---|---|
| `<` | 靠左 |
| `>` | 靠右 |
| `^` | 置中 |

格式結構可記成：

```text
{資料位置:補字元 對齊方式 寬度 .小數位數 類型}
```

### 顯示大括號

在格式字串中，`{{` 和 `}}` 代表要顯示真正的大括號：

```python
print('{}{{}}'.format('顯示'))
# 顯示{}
```

---

## 十四、`main()` 與程式進入點

```python
def main():
    pass


if __name__ == '__main__':
    main()
```

### `def main()`

建立名為 `main` 的函式，通常用來集中放置主要程式流程。

### `pass`

`pass` 是空敘述，表示目前不執行任何動作，常用來先保留函式或類別結構。

### `if __name__ == '__main__'`

- 直接執行此檔案時，`__name__` 的值是 `'__main__'`，因此會呼叫 `main()`。
- 此檔案被其他程式 `import` 時，不會自動執行 `main()`。

---

## 十五、本課重點速查

1. 字串索引從 `0` 開始，`-1` 代表最後一個字元。
2. 切片寫法為 `[開始:結束:間隔]`，不包含結束位置。
3. `[::-1]` 可以反轉字串。
4. `input()` 的結果一定是字串，需要時使用 `int()` 或 `float()` 轉型。
5. `find()` 找不到會傳回 `-1`；`index()` 找不到會發生錯誤。
6. `split()` 負責分割；`join()` 負責連接；`replace()` 負責取代。
7. Python 字串不可變，字串方法通常會傳回新字串。
8. `format()` 可控制小數位數、百分比、千分位、寬度及對齊。
9. `eval()` 能執行字串運算式，但不可直接處理不可信任的輸入。
10. `if __name__ == '__main__':` 可控制程式只在直接執行時啟動。

