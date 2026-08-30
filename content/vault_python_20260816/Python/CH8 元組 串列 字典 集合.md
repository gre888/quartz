# Python 第 8 章重點筆記：Tuple、Dictionary、Set

> 整理自本次上課的 13 個 Python 範例。重點涵蓋元組、字典、集合，以及商品查詢、分組統計、猜數字與中文數字轉換等應用。

## 一、本章快速比較

| 資料型態 | 寫法範例 | 有順序 | 可重複 | 建立後可修改 | 取值方式 |
|---|---|---:|---:|---:|---|
| List 串列 | `[10, 20, 30]` | 是 | 是 | 是 | 索引 |
| Tuple 元組 | `(10, 20, 30)` | 是 | 是 | 否 | 索引 |
| Dictionary 字典 | `{'A001': '汽水'}` | 保留加入順序 | Key 不可重複 | 是 | Key |
| Set 集合 | `{10, 20, 30}` | 無固定順序 | 否 | 是 | 不支援索引 |

---

## 二、Tuple（元組）

### 2.1 建立 Tuple

```python
t1 = (10, 20, 30)
t2 = 10, 20, 30
```

Tuple 是有順序且不可變（immutable）的容器。建立後不能直接新增、刪除或改寫其中的元素。

### 2.2 單一元素 Tuple：逗號才是關鍵

```python
tuple1 = 25,      # tuple
tuple2 = (25,)    # tuple
tuple3 = (25)     # int
tuple4 = 25       # int
```

真正決定資料是不是 Tuple 的是逗號 `,`，不是括號。單一元素必須寫成 `(25,)`。

### 2.3 Tuple 常用函式與方法

```python
t = (10, 20, 30)

len(t)           # 3，元素數量
max(t)           # 30，最大值
sum(t)           # 60，總和
sum(t, 40)       # 100，總和再加起始值 40
t.count(20)      # 1，20 出現的次數
sorted(t)        # [10, 20, 30]，回傳 List
```

注意：`sorted()` 無論傳入 List 或 Tuple，回傳值都是新的 **List**。

### 2.4 List 與 Tuple 互相轉換

```python
list1 = [10, 20, 30]
tuple1 = tuple(list1)   # (10, 20, 30)

list2 = list(tuple1)    # [10, 20, 30]
```

Tuple 不能直接修改。若需要增加元素，可先轉成 List，修改後再轉回 Tuple：

```python
directions = ('東', '南', '西', '北')
temp = list(directions)
temp.append('東北')
directions = tuple(temp)
```

### 2.5 索引、成員判斷與走訪

```python
directions = ('東', '南', '西', '北')

print(directions[0])       # 東
print('東北' in directions) # False

for item in directions:
    print(item, end=' ')
```

### 2.6 Tuple 解構（Unpacking）

```python
direction = ('東', '南', '西')
east, south, west = direction
```

左側變數數量必須和 Tuple 元素數量一致，否則會發生 `ValueError`。

### 2.7 Tuple 串接與交換變數

```python
tuple1 = ('東',)
tuple2 = tuple1 + ('西',)
tuple3 = tuple2 + ('南', '北')

a, b = b, a
```

`+` 並不是修改原 Tuple，而是建立一個新的 Tuple。

### 2.8 Tuple 商品購物範例

```python
data = (
    ('香蕉', 34, 2),
    ('芭樂', 28, 3),
    ('水梨', 50, 2)
)

total = []

for product in data:
    name, quantity, price = product
    subtotal = quantity * price
    total.append(subtotal)

print(sum(total))
```

程式流程：

1. 外層 Tuple 儲存全部商品。
2. 每筆內層 Tuple 儲存「品名、數量、單價」。
3. 使用解構將三個欄位分別存入變數。
4. 計算小計後加入 `total`。
5. 使用 `sum(total)` 計算總金額。

格式化輸出：

```python
print(f'{name:>4}{quantity:8}{price:8}{subtotal:8}')
print(f'總  計:{sum(total):23}')
```

- `>4`：欄寬 4，靠右對齊。
- `:8`：欄寬 8；數值預設靠右對齊。
- `:23`：欄寬 23。

---

## 三、Dictionary（字典）

### 3.1 字典的結構

字典使用 `Key: Value` 儲存資料：

```python
months = {
    '一月': '正月',
    '二月': '二月',
    '三月': '梅月'
}
```

- Key 必須是不可變且可雜湊的資料，例如字串、數字、Tuple。
- Key 不可重複；若重複指定，新值會覆蓋舊值。
- Value 可以是任何資料型態，也可以重複。

### 3.2 查詢、新增、修改與刪除

```python
print(months['三月'])     # 查詢
months['一月'] = '端月'   # 修改
months['四月'] = '槐月'   # 新增
del months['一月']        # 刪除
```

`in` 預設檢查的是 Key：

```python
print('一月' in months)
```

### 3.3 使用 `dict()` 建立字典

```python
d1 = dict((('一月', '正月'), ('二月', '花月')))
d2 = dict([['一月', '正月'], ['二月', '花月']])
```

傳給 `dict()` 的外層是一個可走訪容器，每個內層元素必須剛好包含 Key 與 Value 兩項。

### 3.4 `dict.fromkeys()`

```python
d1 = dict.fromkeys(('四月', '五月'))
# {'四月': None, '五月': None}

d2 = dict.fromkeys(('一月', '四月'), '端月')
# {'一月': '端月', '四月': '端月'}
```

`fromkeys(keys, value)` 會讓所有 Key 共用相同的初始 Value。若省略 Value，預設為 `None`。

### 3.5 取得 Keys、Values、Items

```python
d = {'一月': '正月', '二月': '花月'}

d.keys()      # 所有 Key
d.values()    # 所有 Value
d.items()     # 所有 (Key, Value)

tuple(d.keys())
tuple(d.values())
list(d.items())
```

常見走訪方式：

```python
for key, value in d.items():
    print(key, value)
```

### 3.6 安全查詢：`get()`

```python
value = d.get('三月')            # 找不到回傳 None
value = d.get('三月', '查無資料') # 找不到回傳指定預設值
```

| 寫法 | Key 不存在時 |
|---|---|
| `d[key]` | 發生 `KeyError` |
| `d.get(key)` | 回傳 `None` |
| `d.get(key, default)` | 回傳指定的預設值 |

### 3.7 `setdefault()`

```python
d.setdefault('一月', '梅月')
d.setdefault('三月', '梅月')
```

- Key 已存在：回傳原有 Value，不會覆蓋。
- Key 不存在：新增 `Key: default`，並回傳 default。

### 3.8 `pop()`、`popitem()`、`update()`、`clear()`

```python
d.pop('二月', None)  # 刪除指定 Key，找不到則回傳 None
d.popitem()          # 刪除並回傳最後加入的鍵值對
d.update(other)      # 合併另一個字典；相同 Key 會被覆蓋
d.clear()            # 清空內容，字典變成 {}
del d                # 刪除整個變數，之後不能再使用 d
```

### 3.9 商品編號查詢與新增

```python
products = {
    'A001': ['汽水', 25],
    'A005': ['公主麵', 10]
}

number = input('請輸入商品編號: ')

if number not in products:
    name = input('請輸入商品名稱: ')
    price = int(input('請輸入商品金額: '))
    products[number] = [name, price]

print(number, products[number])
```

注意：`input()` 一律回傳字串。原始範例直接儲存 `money`，因此新增商品的金額會是 `str`，而原有金額是 `int`。若之後需要運算，應使用 `int(input(...))` 統一型別。

也應避免用 `id` 當變數名稱，因為 `id()` 是 Python 內建函式；可改用 `name`。

---

## 四、Set（集合）

### 4.1 Set 特性

- 元素不重複。
- 沒有固定順序。
- 可以新增或刪除元素。
- 不支援索引，例如 `s[0]` 會出錯。
- 元素必須是不可變且可雜湊的資料。

```python
s1 = {1, 2, 3, 1, 2}
print(s1)  # 重複項目會被移除
```

建立空集合必須使用 `set()`：

```python
empty_set = set()
empty_dict = {}      # 這是空字典，不是空集合
```

### 4.2 使用 `set()` 轉換資料

```python
set(range(1, 11))
set('Anastasia')
set('嘻嘻哈哈')
set({1: 'A', 2: 'B', 3: 'C'})
```

- 字串轉 Set：拆成單一字元並去除重複。
- 字典轉 Set：只取得字典的 Key。
- `set('Anastasia')` 的顯示順序不固定。

### 4.3 `add()` 與 `update()` 的差異

```python
s = set()
s.add('笑嘻嘻')     # 加入一個完整元素
s.update('笑嘻嘻')  # 逐一加入「笑」「嘻」「嘻」
```

| 方法 | 用途 | 傳入字串 `'笑嘻嘻'` 的結果 |
|---|---|---|
| `add(x)` | 加入單一元素 | `'笑嘻嘻'` 是一個元素 |
| `update(iterable)` | 加入可走訪物件中的每個元素 | 加入 `'笑'`、`'嘻'` |

### 4.4 刪除元素

```python
s.remove('笑嘻嘻')   # 不存在時發生 KeyError
s.discard('笑嘻嘻')  # 不存在時不會出錯
s.pop()              # 移除並回傳任意一個元素
```

不能依賴 `pop()` 移除特定位置的元素，因為 Set 沒有固定順序。

### 4.5 集合運算

```python
a = {'王一', '張三', '李四'}
b = {'王一', '張三', '趙六'}

a.intersection(b)  # 交集：兩邊都有
a.union(b)         # 聯集：合併後去重複
a.difference(b)    # 差集：只在 a
a.symmetric_difference(b)  # 對稱差集：只出現在其中一邊
```

亦可使用運算子：

| 運算 | 方法 | 運算子 |
|---|---|---|
| 交集 | `a.intersection(b)` | `a & b` |
| 聯集 | `a.union(b)` | `a \| b` |
| 差集 | `a.difference(b)` | `a - b` |
| 對稱差集 | `a.symmetric_difference(b)` | `a ^ b` |

### 4.6 分組名單去重與共同成員

```python
s1 = set(group1)
s2 = set(group2)

common = s1.intersection(s2)
all_people = s1.union(s2)
```

- `len(group1)`：原始名單筆數，包含重複姓名。
- `len(s1)`：實際不重複人數。
- 交集：兩組共同成員。
- 聯集：兩組合併後的總人數。

---

## 五、Set 猜數字遊戲

### 5.1 電腦產生兩個不重複數字

```python
from random import randint

pc = set()
while len(pc) < 2:
    pc.add(randint(1, 7))
```

即使 `randint()` 抽到相同數字，Set 也不會保存重複值，所以迴圈會持續到集合內有兩個數字。

### 5.2 玩家輸入兩個有效數字

```python
you = set()
while len(you) < 2:
    number = int(input('請輸入號碼: '))
    if 1 <= number <= 7:
        you.add(number)
```

重複輸入同一數字不會增加 Set 長度，因此玩家必須輸入兩個不同的有效數字。

### 5.3 比對答案與 `while...else`

```python
if you == pc:
    print('恭喜你猜中')
    break
```

Set 比較不考慮順序，例如 `{1, 2} == {2, 1}` 為 `True`。

```python
while count > 0:
    ...
    if guessed:
        break
else:
    print('沒有猜中')
```

`while` 的 `else` 只會在迴圈正常結束時執行；若因 `break` 離開，就不執行 `else`。

可改善之處：

- 用 `try...except ValueError` 處理非數字輸入。
- 對超出 1～7 的數字顯示錯誤提示。
- 正式遊戲不應在開始時 `print(pc)`，否則答案會直接顯示。

---

## 六、Tuple 綜合應用：數字轉中文大寫

### 6.1 對照表

```python
numerals = ('零', '壹', '貳', '叁', '肆', '伍', '陸', '柒', '捌', '玖')
units = ('', '拾', '佰', '仟', '萬')
```

Tuple 的索引可作為數字對照表：

- `numerals[1]` → `'壹'`
- `numerals[8]` → `'捌'`
- `units[3]` → `'仟'`

### 6.2 將數字拆成每一位

```python
digits = tuple(str(num))
```

例如 `1234`：

```python
('1', '2', '3', '4')
```

之後在迴圈中用 `int(digit)` 將每個字元轉回整數，作為 Tuple 索引。

### 6.3 位數計算

```python
unit_index = length - i - 1
result += numerals[digit] + units[unit_index]
```

若數字為四位數，第一個數字搭配 `仟`，第二個搭配 `佰`，依序往右處理。

### 6.4 `rstrip('零')`

```python
return result.rstrip('零')
```

它只會刪除字串尾端連續出現的「零」，不會刪除中間的零。

### 6.5 原始範例的限制與注意事項

- `units` 只定義到「萬」，因此只適用於五位數以下或最高萬位的正整數。
- 未檢查負數、超過五位數或非整數輸入。
- 原始程式判斷零的邏輯可能無法正確處理所有中間含零的數字，例如 `1001`、`1010`；完整中文數字轉換需額外處理「連續零只留一個」以及「後方仍有非零數字」的情況。
- 變數名稱 `tupNumberals` 應為 `tupNumerals`，屬拼字問題，不影響執行。

---

## 七、常見錯誤整理

| 情況 | 問題 | 建議 |
|---|---|---|
| `x = (25)` | 這是 `int`，不是 Tuple | 寫成 `x = (25,)` |
| 修改 `tuple1[0]` | Tuple 不可變 | 轉 List 修改，再轉回 Tuple |
| `sorted(tuple1)` | 誤以為回傳 Tuple | 實際回傳 List |
| `dict1[key]` 查不到 | 發生 `KeyError` | 使用 `get()` 或先用 `in` 判斷 |
| `input()` 金額直接存入 | 型別是 `str` | 使用 `int(input(...))` |
| 使用變數名稱 `id` | 遮蔽內建 `id()` | 改用 `product_name` 等名稱 |
| `s.remove(x)` 且 x 不存在 | 發生 `KeyError` | 不確定時使用 `discard()` |
| `s.update('abc')` | 逐字加入，不是加入完整字串 | 要加入完整字串請用 `add()` |
| 依賴 Set 顯示順序 | 每次順序可能不同 | 需要順序時使用 List 或 `sorted()` |
| `empty = {}` | 建立的是字典 | 空 Set 要用 `set()` |

---

## 八、考試前必背

1. 單一元素 Tuple 一定要有逗號：`(10,)`。
2. Tuple 有順序但不可修改；List 有順序且可修改。
3. `sorted(tuple)` 回傳 List。
4. Tuple 解構時，左右數量必須相同。
5. 字典以 Key 查 Value，Key 不可重複。
6. `in dictionary` 判斷的是 Key。
7. `get()` 查不到不會產生 `KeyError`。
8. `setdefault()` 只在 Key 不存在時新增資料。
9. Set 會自動去除重複元素，而且沒有固定順序。
10. `add()` 加一個元素；`update()` 加入可走訪物件中的多個元素。
11. `remove()` 找不到會出錯；`discard()` 找不到不會出錯。
12. 交集找共同元素，聯集合併並去重複。
13. Set 相等只比較元素，不比較順序。
14. `while...else` 在沒有遇到 `break`、正常結束迴圈時執行 `else`。
15. `input()` 的回傳型別永遠是字串，需要運算時要轉型。

## 九、練習題

### 題目 1

下列哪一個是單一元素 Tuple？

```python
A. (10)
B. (10,)
C. {10}
D. [10]
```

答案：B。

### 題目 2

```python
s = set('banana')
print(len(s))
```

答案：3，集合元素為 `b`、`a`、`n`。

### 題目 3

```python
d = {'A': 10}
print(d.get('B', 0))
```

答案：`0`。

### 題目 4

```python
a = {1, 2, 3}
b = {2, 3, 4}
print(a & b)
print(a | b)
```

答案：交集為 `{2, 3}`；聯集包含 `{1, 2, 3, 4}`，顯示順序不保證。

### 題目 5

`dict.clear()` 與 `del dict` 有何不同？

答案：`clear()` 只清空字典內容，變數仍存在；`del` 會刪除整個變數。

---

## 十、本次範例檔案對照

| 主題 | 檔案 |
|---|---|
| Tuple 建立、函式、型別轉換 | `ch8_1_tuple.py`、`ch8_1_tuple0.py` |
| Tuple 解構、串接、走訪 | `ch8_1_tuple1.py`、`tuple_1.py` |
| Tuple 商品計算 | `ch8_1_shop.py` |
| Dictionary 基本操作 | `ch8_2_dict1.py` |
| Dictionary 方法 | `ch8_2_dict2.py` |
| Dictionary 商品查詢 | `ch8_2_search.py` |
| Set 建立與轉換 | `ch8_3_set0.py` |
| Set 新增與刪除 | `ch8_3_set1.py` |
| Set 分組統計 | `ch8_3_group.py` |
| Set 猜數字遊戲 | `ch8_3_guess.py` |
| Tuple 中文數字轉換 | `chineseNumber.py` |
