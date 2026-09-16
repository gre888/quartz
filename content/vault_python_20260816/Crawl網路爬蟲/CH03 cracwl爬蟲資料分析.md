你這一大段其實是在練 **Python 物件、字串不可變、List 去重、Pandas DataFrame、JSON 資料解析、DataFrame 合併**。我幫你把它整理成「上課重點＋容易考的觀念」。

---

# Python / Pandas 上課重點整理

## 1. Class 物件與「參考」概念

```
class Student:
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def set_age(self, age):
        self.age = age

    def get_age(self):
        return self.age
```

建立物件：

```
s1 = Student("Alice", 20)
print(s1.get_age())
```

結果：

```
20
```

### `s2 = s1` 不是複製物件

```
s2 = s1
s2.set_age(25)
```

此時：

```
print(s2.get_age())
print(s1.get_age())
print(s1 is s2)
```

結果：

```
25
25
True
```

### 為什麼？

因為：

```
s2 = s1
```

代表 **s1 和 s2 指向同一個 Student 物件**。

可以想成：

```
s1 ──┐
     ├──> Student("Alice", 25)
s2 ──┘
```

所以修改 `s2`，`s1` 看到的也是修改後的資料。

### 考試重點

|寫法|意思|
|---|---|
|`s2 = s1`|兩個變數指向同一個物件|
|`s1 is s2`|判斷是不是同一個物件|
|`s2.set_age(25)`|修改共同指向物件的資料|

---

# 2. Python 字串 Immutable 不可變

```
s = "$29,900"
```

字串是 **immutable（不可變）**。

例如：

```
print(s.replace("$", ""))
```

得到：

```
29,900
```

但是：

```
print(s)
```

仍然是：

```
$29,900
```

因為：

```
s.replace("$", "")
```

只是產生一個**新的字串**。

---

## 3. `replace()` 可以連續使用

```
s.replace("$", "").replace(",", "")
```

執行順序：

```
$29,900
 ↓ replace("$", "")
29,900
 ↓ replace(",", "")
29900
```

所以：

```
print(s.replace("$", "").replace(",", ""))
```

結果：

```
29900
```

但是原本的 `s` 還是：

```
$29,900
```

---

## 4. 如果要真的更新 `s`

必須重新指定：

```
s = s.replace("$", "").replace(",", "")
```

現在：

```
print(s)
```

結果：

```
29900
```

### 記這句

> **字串的方法通常不會直接修改原字串，而是回傳新的字串。**

這和你前面 Pandas 的概念很像。

---

# 5. Dictionary 裡面的字串也可以修改

例如：

```
raw_data = [
    {"item": "iPhone 15", "price": "$29,900"},
    {"item": "iPhone 15", "price": "$29,900"},
    {"item": "iPad Air", "price": "$19,500"},
    {"item": "MacBook", "price": "None"}
]
```

可以：

```
for item in raw_data:
    item["price"] = item["price"].replace("$", "").replace(",", "")
```

這裡的重點是：

```
item["price"] = 新字串
```

不是 `replace()` 改變原字串，而是把 `replace()` 產生的新字串重新存回 Dictionary。

---

# 6. List 去除重複：`set()`

例如：

```
raw_data = [10, 10, 20, 20, 20, 30, 30]
```

可以：

```
raw_data = list(set(raw_data))
```

得到類似：

```
[10, 20, 30]
```

流程：

```
List
 ↓
set()
 ↓
去除重複
 ↓
list()
 ↓
重新變成 List
```

### 注意

`set` 是**無序集合**。

所以不要依賴：

```
list(set(raw_data))
```

的排列順序。

---

# 7. `list.remove()` 的概念

你前面的程式：

```
for item in raw_data:
    count = raw_data.count(item)

    if count > 2:
        for i in range(count - 1):
            raw_data.remove(item)
```

這是在嘗試：

> 如果某個數字出現超過 2 次，就刪除多餘的。

例如：

```
[10, 10, 20, 20, 20, 30, 30]
```

希望變成：

```
[10, 10, 20, 20, 30, 30]
```

不過要注意：

> **一邊 `for` 迴圈遍歷 List，一邊修改 List，容易造成跳過元素或邏輯問題。**

這是很重要的實務觀念。

---

# 8. Pandas DataFrame

```
import pandas as pd
```

可以把：

```
[
    {"item": "iPhone 15", "price": "$29,900"},
    {"item": "iPad Air", "price": "$19,500"}
]
```

轉成：

```
df = pd.DataFrame(raw_data)
```

概念：

```
List
  ↓
Dictionary
  ↓
DataFrame
```

DataFrame 很適合做：

- 資料整理
- 篩選
- 統計
- 排序
- 去重
- 欄位處理

---

# 9. `drop_duplicates()`

```
df = df.drop_duplicates()
```

例如：

```
iPhone 15   29900
iPhone 15   29900
iPad Air    19500
```

變成：

```
iPhone 15   29900
iPad Air    19500
```

### 重要觀念

你程式中的：

```
df = df.drop_duplicates()
```

很重要。

因為 Pandas 很多操作會**回傳新的 DataFrame**。

所以通常寫：

```
df = df.drop_duplicates()
```

而不是只寫：

```
df.drop_duplicates()
```

---

# 10. `reset_index()`

去重之後可能變成：

```
0  iPhone 15
2  iPad Air
3  MacBook
```

可以：

```
df = df.reset_index(drop=True)
```

重新變成：

```
0  iPhone 15
1  iPad Air
2  MacBook
```

### `drop=True`

代表：

> 舊的 Index 不要保留下來。

---

# 11. Pandas `.str.replace()`

```
df["price"] = df["price"].str.replace("$", "").str.replace(",", "")
```

例如：

```
$29,900
$19,500
```

變成：

```
29900
19500
```

注意這裡：

```
.str
```

代表對 Series 中的每個字串進行字串操作。

---

# 12. `pd.to_numeric()`

清除 `$` 和 `,` 後：

```
29900
19500
None
```

但它們可能仍然是字串。

所以：

```
df["price"] = pd.to_numeric(
    df["price"],
    errors="coerce"
)
```

把它轉成數字。

例如：

```
29900 → 29900
19500 → 19500
None  → NaN
```

### `errors="coerce"`

非常重要。

意思是：

> 如果遇到不能轉成數字的資料，就轉成 `NaN`，不要直接報錯。

---

# 13. DataFrame 可以從不同資料建立

### Dictionary

```
df = pd.DataFrame({
    "title": ["新聞A"],
    "clicks": [100]
})
```

### List of Dictionary

```
df = pd.DataFrame([
    {"item": "iPhone", "price": 29900},
    {"item": "iPad", "price": 19500}
])
```

### 單純 List

```
df = pd.DataFrame([10, 30, 60, 50, 40])
```

也可以建立 DataFrame。

會類似：

```
    0
0  10
1  30
2  60
3  50
4  40
```

---

# 14. DataFrame 欄位平均值

```
df = pd.DataFrame(
    [
        {"城市": "台北", "溫度": 25},
        {"城市": "台中", "溫度": 28},
        {"城市": "高雄", "溫度": 30},
    ]
)
```

取得溫度：

```
df["溫度"]
```

計算平均：

```
df["溫度"].mean()
```

結果：

```
27.666666666666668
```

所以：

```
print("平均溫度=", df["溫度"].mean())
```

---

# 15. JSON + Pandas

你的程式：

```
with open("F-C0032-027.json", encoding="utf-8") as f:
    data27 = json.load(f)
```

流程：

```
JSON 檔案
   ↓
open()
   ↓
json.load()
   ↓
Python Dictionary / List
```

然後：

```
df27 = pd.DataFrame(data27)
```

才是：

```
Python 資料
   ↓
DataFrame
```

---

# 16. JSON 巢狀資料的取值

你的資料有很多層：

```
data27["cwaopendata"]
```

↓

```
["Dataset"]
```

↓

```
["Locations"]
```

↓

```
["Location"]
```

↓

```
["WeatherElement"]
```

↓

```
["ElementValue"]
```

↓

```
["WeatherDescription"]
```

所以：

```
data27["cwaopendata"]["Dataset"]["Locations"]["Location"]
```

就是一路往下取資料。

### 最重要觀念

這些：

```
["cwaopendata"]
["Dataset"]
["Locations"]
```

是在取 **Dictionary 的 Key**。

---

# 17. `index()` 找字串位置

例如：

```
s = "abcdefg"

print(s.index("d"))
```

結果：

```
3
```

因為：

```
a b c d e f g
0 1 2 3 4 5 6
```

所以：

```
"abcdefg".index("d")
```

就是 `3`。

---

# 18. 用 `index()` 擷取溫度

例如：

```
溫度：25至30度
```

可以：

```
start = temp_data.index("溫") + 1
end = temp_data.index("至")

min_temp = temp_data[start:end]
```

得到：

```
25
```

為什麼 `+1`？

因為：

```
temp_data.index("溫")
```

找到的是「溫」的位置。

我們不要「溫」，所以：

```
+ 1
```

從「溫」的下一個字開始。

---

# 19. `[start:end]` 切片

```
text[start:end]
```

規則：

> **包含 start，不包含 end**

例如：

```
s = "abcdefg"
print(s[1:4])
```

結果：

```
bcd
```

不是 `bcde`。

---

# 20. 多個 JSON 檔案批次處理

你後面使用：

```
file_list = [
    "F-C0032-027.json",
    "F-C0032-010.json",
    "F-C0032-013.json",
    "F-C0032-018.json",
    "F-C0032-026.json"
]
```

然後：

```
for file_name in file_list:
```

就可以一次處理多個 JSON。

這個寫法非常實用：

```
檔案清單
   ↓
for
   ↓
open()
   ↓
json.load()
   ↓
解析資料
   ↓
計算溫度
   ↓
下一個檔案
```

---

# 21. `pd.concat()`：合併 DataFrame

你最後的程式是這次很重要的重點：

```
df1 = pd.DataFrame({
    "title": ["新聞A"],
    "clicks": [100]
})

df2 = pd.DataFrame({
    "title": ["新聞B"],
    "clicks": [250]
})
```

兩個 DataFrame：

```
df1

title    clicks
新聞A      100
```

```
df2

title    clicks
新聞B      250
```

使用：

```
all_news = pd.concat(
    [df1, df2],
    ignore_index=True
)
```

結果：

```
  title  clicks
0   新聞A     100
1   新聞B     250
```

---

# 22. `ignore_index=True` 是什麼？

如果沒有：

```
pd.concat([df1, df2])
```

可能會：

```
  title  clicks
0   新聞A     100
0   新聞B     250
```

因為兩個 DataFrame 原本的 Index 都是 `0`。

加上：

```
ignore_index=True
```

就會重新編號：

```
0
1
```

### 考試直接記

```
pd.concat([df1, df2], ignore_index=True)
```

＝

> **把兩個 DataFrame 上下合併，並重新建立 Index。**

---

# ⭐ 這一章最重要的觀念

|語法|重點|
|---|---|
|`s2 = s1`|兩個變數指向同一物件|
|`is`|判斷是不是同一個物件|
|`str.replace()`|回傳新字串，不直接修改原字串|
|`list(set(x))`|去除重複值|
|`pd.DataFrame()`|建立 DataFrame|
|`drop_duplicates()`|去除重複資料|
|`reset_index(drop=True)`|重新建立 Index|
|`.str.replace()`|對 Series 裡的字串操作|
|`pd.to_numeric()`|轉換成數字|
|`errors="coerce"`|無法轉換 → `NaN`|
|`json.load()`|JSON → Python 資料|
|`index()`|找資料位置|
|`[start:end]`|切片，end 不包含|
|`pd.concat()`|合併 DataFrame|
|`ignore_index=True`|合併後重新編號|

### 最後把這幾個「不可變」觀念一起記

```
字串 String
   ↓
immutable
   ↓
replace() 不直接改原字串
```

```
DataFrame
   ↓
很多方法會回傳新的 DataFrame
   ↓
df = df.drop_duplicates()
```

而：

```
s2 = s1
```

則是另一個很重要的概念：

```
不是複製
而是兩個變數指向同一個物件
```

import pandas as pd # products = [ # {"name": "咖啡機", "price": 5000, "rating": 4.8}, # {"name": "磨豆機", "price": 1200, "rating": 4.2}, # {"name": "濾紙", "price": 150, "rating": 4.9}, # {"name": "保溫杯", "price": 800, "rating": 3.5} # ] # df1 = pd.DataFrame(products) # print(df1) # print() # print(df1[(df1['rating']>4.5)&(df1['price']<=2000)]) # print("----------------------------") df = pd.DataFrame({ "user": [" Alice ", "Bob\n", " Charlie "], "email": ["ALICE@gmail.com", "bob@Gmail.com", "CHARLIE@outlook.com"] }) df["user"] = df["user"].str.strip() print(df["user"]) print() df["email"] = df["email"].str.lower() print(df["email"]) print() print(df) # s="Bob\n" # print(s+"是一位醫生") # print(s.strip()+"是一位醫生") df1=pd.DataFram({"product":["iPhone","iPad"],"price":["5000","3000"]})

你這段是在練 **Pandas 的條件篩選 + 字串清洗**。整體觀念是對的，不過最後一行有一個拼字錯誤。

---

## 1. DataFrame 條件篩選

你的：

```
print(df1[(df1['rating'] > 4.5) & (df1['price'] <= 2000)])
```

意思是：

> 找出 **評分大於 4.5，而且價格小於等於 2000** 的商品。

原始資料：

|name|price|rating|
|---|---|---|
|咖啡機|5000|4.8|
|磨豆機|1200|4.2|
|濾紙|150|4.9|
|保溫杯|800|3.5|

判斷：

```
咖啡機
rating 4.8 > 4.5 ✓
price 5000 <= 2000 ✗
→ 不符合

磨豆機
rating 4.2 > 4.5 ✗
→ 不符合

濾紙
rating 4.9 > 4.5 ✓
price 150 <= 2000 ✓
→ 符合

保溫杯
rating 3.5 > 4.5 ✗
→ 不符合
```

所以結果只有：

```
  name  price  rating
2   濾紙    150     4.9
```

### ⭐ Pandas 條件篩選記法

```
df[(條件1) & (條件2)]
```

`&` = **而且（AND）**

例如：

```
df[(df["rating"] > 4.5) & (df["price"] <= 2000)]
```

注意 Pandas 通常要使用：

```
&
|
```

而不是 Python 常見的：

```
and
or
```

---

# 2. `.str.strip()`：清除前後空白

你的資料：

```
"user": [" Alice ", "Bob\n", "  Charlie  "]
```

原本：

```
" Alice "
"Bob\n"
"  Charlie  "
```

執行：

```
df["user"] = df["user"].str.strip()
```

變成：

```
Alice
Bob
Charlie
```

### `strip()` 做什麼？

> 清除字串「前面和後面」的空白字元。

例如：

```
s = "  Bob  "
print(s.strip())
```

結果：

```
Bob
```

你的：

```
"Bob\n"
```

其中 `\n` 是換行字元：

```
Bob\n
   ↑
換行
```

所以：

```
"Bob\n".strip()
```

會變成：

```
Bob
```

---

# 3. `.str.lower()`：全部轉小寫

你的：

```
df["email"] = df["email"].str.lower()
```

原本：

```
ALICE@gmail.com
bob@Gmail.com
CHARLIE@outlook.com
```

變成：

```
alice@gmail.com
bob@gmail.com
charlie@outlook.com
```

### 記法

```
.str.lower()
```

＝

> Series 裡面的字串全部轉成小寫。

相反地：

```
.str.upper()
```

＝

> 全部轉成大寫。

---

# 4. `.str` 是什麼？

這個觀念很重要。

一般 Python：

```
s = "ABC"
s.lower()
```

但是 Pandas：

```
df["email"].str.lower()
```

因為：

```
df["email"]
```

是一個 **Pandas Series**，不是單純的一個字串。

所以要透過：

```
.str
```

來對整個 Series 裡面的字串進行操作。

可以想成：

```
Python String

"ABC"
 ↓
.lower()


Pandas Series

["ABC", "DEF", "GHI"]
 ↓
.str.lower()
 ↓
["abc", "def", "ghi"]
```

---

# 5. 你最後一行有錯

你寫：

```
df1=pd.DataFram({"product":["iPhone","iPad"],"price":["5000","3000"]})
```

這裡：

```
pd.DataFram
```

少了一個 `e`。

正確：

```
df1 = pd.DataFrame({
    "product": ["iPhone", "iPad"],
    "price": ["5000", "3000"]
})
```

---

# 6. 這裡還有一個值得注意的地方

你的：

```
"price": ["5000", "3000"]
```

這兩個是 **字串 String**，不是數字。

所以：

```
print(df1.dtypes)
```

會看到：

```
product    object
price      object
dtype: object
```

如果價格之後要做數學運算，例如：

```
平均價格
最大價格
價格排序
價格比較
```

建議轉成數字：

```
df1["price"] = pd.to_numeric(df1["price"])
```

或者建立資料時直接使用數字：

```
df1 = pd.DataFrame({
    "product": ["iPhone", "iPad"],
    "price": [5000, 3000]
})
```

這樣 `price` 就是數字。

---

# ⭐ 這一段你要記住的 5 個重點

```
# ① 條件篩選
df[(df["rating"] > 4.5) & (df["price"] <= 2000)]

# ② 清除前後空白、換行
df["user"] = df["user"].str.strip()

# ③ 全部轉小寫
df["email"] = df["email"].str.lower()

# ④ Pandas 對字串操作要使用 .str
df["email"].str.lower()

# ⑤ 字串價格轉數字
df["price"] = pd.to_numeric(df["price"])
```

### 可以把 `.str` 這一組直接背起來

|語法|功能|
|---|---|
|`.str.strip()`|去除前後空白、換行|
|`.str.lower()`|轉小寫|
|`.str.upper()`|轉大寫|
|`.str.replace()`|字串取代|
|`.str.contains()`|判斷是否包含文字|

這一段其實已經開始進入 **「資料清洗 Data Cleaning」** 的核心了：先把髒資料（空白、大小寫、字串數字）整理乾淨，再進行篩選與分析。

import json import csv file="3-1-6.json" with open(file, "r", encoding="utf-8") as f:     data = json.load(f)     print(data) with open("3-1-6.csv", mode="w", encoding="utf-8-sig",newline="") as f:   fieldnames=["title","clicks"]   writer = csv.DictWriter(f, fieldnames=fieldnames)   writer.writeheader()   writer.writerows(data)   with open("3-1-6.csv", mode="r", encoding="utf-8-sig") as f:       reader = csv.DictReader(f)       for row in reader:           print(row["title"], row["clicks"])

你這段程式的目的很清楚：

> **JSON → Python List/Dictionary → CSV → 再從 CSV 讀回來**

不過你最後面的 `with open()` **縮排錯了**。它現在被放在第一個 CSV `with open()` 裡面，而且這樣的縮排會造成問題。

---

## ① 讀取 JSON

```
import json
import csv

file = "3-1-6.json"

with open(file, "r", encoding="utf-8") as f:
    data = json.load(f)
    print(data)
```

流程：

```
3-1-6.json
    ↓
open()
    ↓
json.load()
    ↓
data
```

假設 JSON 是：

```
[
    {"title": "新聞A", "clicks": 100},
    {"title": "新聞B", "clicks": 250}
]
```

那麼：

```
data
```

就是：

```
[
    {"title": "新聞A", "clicks": 100},
    {"title": "新聞B", "clicks": 250}
]
```

也就是：

> **List 裡面放 Dictionary**

---

# ② 建立 CSV

你這段：

```
with open("3-1-6.csv", mode="w", encoding="utf-8-sig", newline="") as f:
    fieldnames = ["title", "clicks"]

    writer = csv.DictWriter(
        f,
        fieldnames=fieldnames
    )

    writer.writeheader()
    writer.writerows(data)
```

### `fieldnames`

```
fieldnames = ["title", "clicks"]
```

代表 CSV 欄位：

```
title,clicks
```

---

### `writeheader()`

```
writer.writeheader()
```

寫入標題：

```
title,clicks
```

---

### `writerows(data)`

```
writer.writerows(data)
```

把 `data` 裡面的多筆 Dictionary 寫進 CSV。

例如：

```
title,clicks
新聞A,100
新聞B,250
```

---

# ③ 再讀取 CSV

這部分應該要和前面的 `with open()` **同一層縮排**：

```
with open("3-1-6.csv", mode="r", encoding="utf-8-sig") as f:
    reader = csv.DictReader(f)

    for row in reader:
        print(row["title"], row["clicks"])
```

這樣才是：

```
JSON
 ↓
讀取
 ↓
data
 ↓
寫入 CSV
 ↓
讀取 CSV
 ↓
DictReader
 ↓
逐筆印出
```

---

# ④ 你的完整正確版本

```
import json
import csv

file = "3-1-6.json"

# 讀取 JSON
with open(file, "r", encoding="utf-8") as f:
    data = json.load(f)
    print(data)


# 寫入 CSV
with open("3-1-6.csv", mode="w", encoding="utf-8-sig", newline="") as f:
    fieldnames = ["title", "clicks"]

    writer = csv.DictWriter(f, fieldnames=fieldnames)

    writer.writeheader()
    writer.writerows(data)


# 讀取 CSV
with open("3-1-6.csv", mode="r", encoding="utf-8-sig") as f:
    reader = csv.DictReader(f)

    for row in reader:
        print(row["title"], row["clicks"])
```

---

# ⭐ 最重要：`DictWriter` vs `DictReader`

這個很容易考。

### JSON → CSV

使用：

```
csv.DictWriter
```

```
writer = csv.DictWriter(f, fieldnames=fieldnames)
writer.writeheader()
writer.writerows(data)
```

意思：

> **把 Dictionary 寫進 CSV**

---

### CSV → Python

使用：

```
csv.DictReader
```

```
reader = csv.DictReader(f)

for row in reader:
    print(row["title"])
```

意思：

> **把 CSV 每一列讀成 Dictionary**

---

## ⭐ 直接背這個方向

```
Dictionary → CSV
      ↓
 DictWriter
```

```
CSV → Dictionary
      ↓
 DictReader
```

---

## 另外一個重點：`newline=""`

寫 CSV 時：

```
open(
    "3-1-6.csv",
    mode="w",
    encoding="utf-8-sig",
    newline=""
)
```

這個：

```
newline=""
```

可以避免 Windows 下 CSV 出現**多餘空白行**的問題。

而：

```
encoding="utf-8-sig"
```

主要是讓 Excel 開啟中文 CSV 時，比較不容易出現亂碼。

---

### 你這一題可以整理成一句考試口訣：

> **JSON 先 `json.load()`，Dictionary 寫 CSV 用 `DictWriter`，CSV 讀回 Dictionary 用 `DictReader`。**

另外，你原始程式最大的問題就是最後這段：

```
  with open("3-1-6.csv", mode="r", encoding="utf-8-sig") as f:
```

前面多縮排了，應該跟「寫 CSV 的 `with open()`」**對齊**。