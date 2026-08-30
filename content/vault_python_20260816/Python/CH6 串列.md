# Python 第 6 章：串列（List）重點筆記

> 整理自本次上課的 20 個 Python 程式範例。

## 1. 串列基本觀念

串列（list）可以在一個變數中存放多筆資料，使用中括號 `[]` 建立，元素之間以逗號分隔。

```python
numbers = [11, 22, 33, 44]
season = ['spring', 'summer', 'autumn', 'winter']
```

串列具有以下特性：

- 有順序，每個元素都有索引。
- 索引從 `0` 開始。
- 可以修改、新增或刪除元素。
- 可以存放數字、字串，甚至其他串列。

## 2. 索引與切片

### 2.1 索引

```python
data = [11, 22, 33, 44, 55]

print(data[0])   # 11：第一個元素
print(data[3])   # 44：第四個元素
print(data[-1])  # 55：最後一個元素
```

負索引從尾端開始計算：

| 索引 | 意義 |
| --- | --- |
| `0` | 第一個元素 |
| `1` | 第二個元素 |
| `-1` | 最後一個元素 |
| `-2` | 倒數第二個元素 |

超過範圍會發生 `IndexError`：

```python
data = [10, 20, 30]
print(data[10])  # IndexError: list index out of range
```

### 2.2 修改元素

串列是可變（mutable）物件，可以用索引修改內容。

```python
words = ['one', 'two', 'three', 'four']
words[3] = '四'
print(words)  # ['one', 'two', 'three', '四']
```

### 2.3 切片

基本格式：

```python
串列[起點:終點:步長]
```

- 包含起點。
- 不包含終點。
- 起點省略時，從頭開始。
- 終點省略時，取到最後。

```python
data = [11, 22, 33, 44, 55, 66, 77, 88, 99]

print(data[2:6])    # [33, 44, 55, 66]
print(data[:6])     # [11, 22, 33, 44, 55, 66]
print(data[1::2])   # [22, 44, 66, 88]
print(data[-6:-3])  # [44, 55, 66]
print(data[:-2])    # [11, 22, 33, 44, 55, 66, 77]
```

## 3. 串列長度與走訪

`len()` 可以取得串列元素數量。

```python
data = [23, 45, 51, 67, 89, 100]
print(len(data))  # 6
```

### 3.1 直接取得元素

不需要索引時，建議直接走訪元素：

```python
season = ['spring', 'summer', 'autumn', 'winter']

for item in season:
    print(item, end=' ')
```

### 3.2 使用索引走訪

需要元素位置或需要修改元素時，可搭配 `range()` 和 `len()`：

```python
data = [11, 22, 33, 44]

for i in range(len(data)):
    print(f'data[{i}] = {data[i]}')
```

### 3.3 反向與間隔走訪

```python
data = [11, 22, 33, 44, 55, 66, 77, 88, 99]

for i in range(len(data) - 1, -1, -1):
    print(data[i], end=' ')  # 由後往前

for i in range(0, len(data), 2):
    print(data[i], end=' ')  # 索引 0、2、4、6、8
```

## 4. 串列生成式

串列生成式（list comprehension）可用簡短語法建立串列。

```python
arr = [8 for x in range(6)]
print(arr)  # [8, 8, 8, 8, 8, 8]

numbers = [y for y in range(5)]
print(numbers)  # [0, 1, 2, 3, 4]
```

一般格式：

```python
[運算式 for 變數 in 可迭代物件]
```

例如建立平方數：

```python
squares = [x ** 2 for x in range(1, 6)]
print(squares)  # [1, 4, 9, 16, 25]
```

## 5. 動態輸入串列

先建立空串列，再用 `append()` 加入輸入值。

```python
numbers = []
count = int(input('請輸入元素個數：'))

for i in range(count):
    number = int(input(f'請輸入第 {i + 1} 個整數：'))
    numbers.append(number)

print(numbers)
```

> 教材使用 `eval(input())`，但 `eval()` 會執行使用者輸入的 Python 程式碼，可能造成安全風險。輸入整數時應優先使用 `int(input())`。

## 6. 常用串列方法

```python
data = [10, 20, 30, 40, 50]
```

| 方法 | 功能 | 範例 |
| --- | --- | --- |
| `append(value)` | 在尾端新增元素 | `data.append(66)` |
| `insert(index, value)` | 在指定索引插入元素 | `data.insert(2, 77)` |
| `count(value)` | 計算指定值出現次數 | `data.count(30)` |
| `index(value)` | 找出指定值第一次出現的索引 | `data.index(30)` |
| `remove(value)` | 刪除第一個指定值 | `data.remove(20)` |
| `pop(index)` | 刪除並傳回指定位置的元素 | `data.pop(3)` |
| `pop()` | 刪除並傳回最後一個元素 | `data.pop()` |
| `clear()` | 清空所有元素 | `data.clear()` |
| `reverse()` | 原地反轉串列 | `data.reverse()` |
| `sort()` | 原地排序串列 | `data.sort()` |

### `del` 刪除索引或切片

```python
data = [11, 22, 33, 44, 55, 66, 77]
del data[1:5:2]
print(data)  # [11, 33, 55, 66, 77]
```

`data[1:5:2]` 代表索引 `1`、`3`，因此刪除 `22` 和 `44`。

### 常見錯誤

- `remove(x)`：如果 `x` 不存在，會發生 `ValueError`。
- `index(x)`：如果 `x` 不存在，也會發生 `ValueError`。
- `pop(i)`：如果索引超過範圍，會發生 `IndexError`。

## 7. 串列運算與成員判斷

### 7.1 `in` 與 `not in`

```python
data = [10, 20, 30, 40]

print(40 in data)      # True
print(95 in data)      # False
print(40 not in data)  # False
```

### 7.2 串列相加與重複

```python
data1 = [10, 20]
data2 = [66, 77]

print(data1 + data2)  # [10, 20, 66, 77]
print(data1 * 2)      # [10, 20, 10, 20]
```

### 7.3 指派不是複製

```python
list1 = [10, 20, 30, 40]
list2 = list1
list2[2] = 33

print(list1)  # [10, 20, 33, 40]
```

`list2 = list1` 只會讓兩個變數指向同一個串列，因此修改其中一個，另一個也會看到變化。

若要建立獨立的淺層複製，可使用：

```python
list2 = list1.copy()
# 或
list2 = list1[:]
```

## 8. 統計函式

```python
data = [10, 20, 30, 40, 50]

print(len(data))  # 5：元素數量
print(sum(data))  # 150：總和
print(max(data))  # 50：最大值
print(min(data))  # 10：最小值
```

也可以用迴圈自行尋找最大值：

```python
data = [8, 23, 5, 41, 16]
largest = data[0]

for item in data:
    if item > largest:
        largest = item

print(f'最大值：{largest}')
```

> 不建議把變數命名為 `max`、`min`、`sum` 或 `list`，否則會暫時蓋掉 Python 的同名內建函式。

## 9. 排序：`sort()`、`sorted()` 與 `reverse()`

### 9.1 `list.sort()`

直接修改原串列，不會建立新串列。

```python
score = [72, 98, 86, 76, 63]
result = score.sort()

print(score)   # [63, 72, 76, 86, 98]
print(result)  # None
```

### 9.2 `sorted()`

傳回排序後的新串列，原串列保持不變。

```python
animals = ['dog', 'cat', 'monkey', 'fox', 'tiger']
result = sorted(animals)

print(animals)  # 原順序不變
print(result)   # ['cat', 'dog', 'fox', 'monkey', 'tiger']
```

### 9.3 由大到小排序

```python
data.sort(reverse=True)
new_data = sorted(data, reverse=True)
```

### 9.4 `reverse()` 只是反轉

```python
animals.reverse()
```

`reverse()` 只會顛倒目前順序，不會依大小排序。

| 寫法 | 是否修改原串列 | 回傳值／結果 |
| --- | --- | --- |
| `data.sort()` | 是 | 回傳 `None` |
| `sorted(data)` | 否 | 回傳新串列 |
| `data.reverse()` | 是 | 反轉原串列並回傳 `None` |

## 10. 氣泡排序（Bubble Sort）

氣泡排序會反覆比較相鄰元素。如果左邊大於右邊，就交換兩者；每完成一輪，當輪最大值會移到右端。

```python
data = [4, -15, 20, 13, -11]
n = len(data)

for loop in range(1, n):
    for index in range(0, n - loop):
        if data[index] > data[index + 1]:
            data[index], data[index + 1] = data[index + 1], data[index]

print(data)  # [-15, -11, 4, 13, 20]
```

重點：

- `n` 個元素最多需要 `n - 1` 輪。
- 每輪的比較次數逐漸減少。
- Python 可用 `a, b = b, a` 直接交換，不一定需要暫存變數。
- 實務上通常直接使用 `sort()` 或 `sorted()`；氣泡排序主要用來學習排序原理。

## 11. 二維串列

二維串列就是「串列中的元素仍然是串列」，可視為表格的列與欄。

```python
data = [
    [4, 8, 5, 9],
    [13, 16, 19, 15],
    [28, 25, 29, 24]
]

print(data[1])     # [13, 16, 19, 15]
print(data[1][2])  # 19
```

`data[1][2]` 的意思是：

1. `data[1]` 取得第 2 列。
2. `[2]` 再取得該列的第 3 個元素。

### 11.1 巢狀迴圈走訪

```python
for i in range(len(data)):
    for j in range(len(data[i])):
        print(f'data[{i}][{j}] = {data[i][j]}')
```

### 11.2 建立二維串列時的參照陷阱

教材範例：

```python
row = [0 for x in range(2)]
arr = [row for y in range(4)]
```

這四列其實指向同一個 `row`。修改一列，其他列會一起改變：

```python
arr[0][0] = 99
print(arr)  # [[99, 0], [99, 0], [99, 0], [99, 0]]
```

建立彼此獨立的列，應寫成：

```python
arr = [[0 for x in range(2)] for y in range(4)]
```

也可以簡化為：

```python
arr = [[0] * 2 for _ in range(4)]
```

## 12. 二維串列成績統計

```python
student_no = [1, 2, 3, 4]
scores = [
    [87, 64, 88],
    [93, 72, 86],
    [80, 88, 89],
    [79, 91, 90]
]
```

### 12.1 計算每位學生總分（橫向加總）

```python
for i in range(len(student_no)):
    total = 0
    for j in range(len(scores[i])):
        total += scores[i][j]
    print(f'{student_no[i]} 號總分：{total}')
```

也可簡化為：

```python
for i in range(len(student_no)):
    print(f'{student_no[i]} 號總分：{sum(scores[i])}')
```

### 12.2 計算每科平均（直向加總）

```python
subject_count = len(scores[0])

for j in range(subject_count):
    total = 0
    for i in range(len(scores)):
        total += scores[i][j]
    average = total / len(scores)
    print(f'第 {j + 1} 科平均：{average:.1f}')
```

## 13. 字串的 `split()` 與 `join()`

### 13.1 `split()`：字串切成串列

```python
text = '人之初,性本善,性相近,習相遠'
items = text.split(',')
print(items)
# ['人之初', '性本善', '性相近', '習相遠']
```

### 13.2 `join()`：串列合成字串

```python
items = ['苟不教', '性乃遷', '教之道', '貴以專']
text = ' '.join(items)
print(text)
# 苟不教 性乃遷 教之道 貴以專
```

記憶方式：

```text
字串 --split()--> 串列
串列 --join()---> 字串
```

`join()` 的元素必須是字串。如果串列內是數字，可先轉換：

```python
numbers = [10, 20, 30]
text = ','.join(map(str, numbers))
print(text)  # 10,20,30
```

## 14. 海象運算子 `:=`

海象運算子可以在運算式中指派變數。

```python
data = [10, 20, 30, 40, 50]
print(num := len(data))  # 指派 num = 5，同時輸出 5
```

一般情況下，分成兩行會更容易閱讀：

```python
num = len(data)
print(num)
```

## 15. 本章易錯重點

1. 索引從 `0` 開始，切片不包含終點。
2. `list2 = list1` 是共用同一個串列，不是複製。
3. `sort()` 修改原串列並回傳 `None`；`sorted()` 會建立新串列。
4. `reverse()` 是反轉，不等於排序。
5. 二維串列若重複使用同一個內層串列，可能產生參照共享問題。
6. 輸入數字時優先使用 `int(input())` 或 `float(input())`，避免任意使用 `eval()`。
7. 不要使用 `list`、`max`、`min`、`sum` 等內建名稱當作變數名稱。
8. `join()` 只能直接連接字串元素。

## 16. 快速複習表

| 需求 | 寫法 |
| --- | --- |
| 建立串列 | `data = [10, 20, 30]` |
| 取得第一個元素 | `data[0]` |
| 取得最後一個元素 | `data[-1]` |
| 取得元素數量 | `len(data)` |
| 新增到尾端 | `data.append(40)` |
| 插入指定位置 | `data.insert(1, 15)` |
| 修改元素 | `data[0] = 99` |
| 刪除指定值 | `data.remove(20)` |
| 刪除並取得元素 | `data.pop()` |
| 判斷元素是否存在 | `20 in data` |
| 由小到大原地排序 | `data.sort()` |
| 取得排序後新串列 | `sorted(data)` |
| 反轉原串列 | `data.reverse()` |
| 複製一層串列 | `new_data = data.copy()` |
| 計算總和 | `sum(data)` |
| 最大／最小值 | `max(data)`、`min(data)` |
| 字串切成串列 | `text.split(',')` |
| 串列組成字串 | `','.join(items)` |

## 17. 練習題

1. 輸入 5 個整數存入串列，輸出最大值、最小值、總和與平均。
2. 將 `[45, 12, 78, 30, 66]` 分別由小到大及由大到小排序。
3. 建立 3 × 4 的二維串列，使用巢狀迴圈逐一輸出元素。
4. 說明 `data2 = data1` 與 `data2 = data1.copy()` 的差異。
5. 將字串 `'red,green,blue'` 切成串列，再用 `' / '` 重新組合。

---

### 一句話總結

串列是 Python 中用來保存多筆有順序資料的重要容器；本章核心是熟悉「索引與切片、走訪、增刪改查、排序，以及二維串列」。
