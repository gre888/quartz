

## ##1-3--

這份程式其實已經把 Python 很重要的 **List、二維 List、Dictionary、List + Dictionary、for 迴圈** 都練到了。我幫你按照考試容易出的方式整理，順便指出一個比較容易混淆的地方。

### 1. 一維 List

```
list1 = [10, 30, 60, 20, 50, 40]

print(list1)
print(list1[0])   # 10
print(list1[2])   # 60
```

List 索引從 **0 開始**：

```
資料：  10   30   60   20   50   40
索引：   0    1    2    3    4    5
```

所以 `list1[2]` 是第三個元素 `60`。

---

### 2. 二維 List

你的：

```
list2 = [
    ["1","2","3","4","5","6","7","8","9","10"],
    ["11","12","13","14","15","16","17","18","19","20"],
    ["21","22","23","24","25","26","27","28","29","30"],
]

print(list2[0][0])   # 1
print(list2[0][1])   # 2
print(list2[2][6])   # 27
```

記法：

```
list2[第幾列][第幾個]
```

兩個索引都從 `0` 開始。

例如：

```
list2[2][6]
```

先找：

```
list2[2]
```

得到第三列：

```
["21","22","23","24","25","26","27","28","29","30"]
```

再 `[6]`，就是第 7 個：

```
27
```

所以答案是：

```
27
```

---

### 3. 二維 List 儲存新聞

```
news_data = [
    ["台積電股價新高", 15000],
    ["AI概念股轉強", 800],
    ["美股四大指數收紅", 1200]
]

print(news_data[2][0])
```

`[2]` → 第三則新聞  
`[0]` → 新聞標題

所以：

```
美股四大指數收紅
```

而：

```
click_count = news_data[2][1]
```

就是：

```
1200
```

---

### 4. Dictionary 字典

```
single_news = {
    "title": "台積電股價新高",
    "clicks": 1500,
    "source": "財經日報"
}
```

Dictionary 不使用數字索引找資料，而是使用 **key**：

```
single_news["title"]
single_news["source"]
```

也可以：

```
single_news.get("source")
```

兩個都可以取得：

```
財經日報
```

考試要特別記：

```
dict["key"]
```

key 不存在 → `KeyError`

而：

```
dict.get("key")
```

key 不存在 → 預設得到 `None`，通常不會發生 `KeyError`。

---

### 5. List 裡面放 Dictionary ⭐

這是你這份程式非常重要的結構：

```
all_news = [
    {"title":"台積電", "price":800, "rank":1},
    {"title":"聯發科", "price":1000, "rank":2},
    {"title":"鴻海", "price":150, "rank":3}
]
```

外面：

```
[ ... ]
```

是 List。

裡面：

```
{ ... }
```

每一筆是 Dictionary。

所以：

```
all_news[1]["price"]
```

拆開看：

```
all_news[1]
```

得到：

```
{"title":"聯發科", "price":1000, "rank":2}
```

再：

```
["price"]
```

得到：

```
1000
```

因此可以記成：

```
List          Dictionary
 ↓                ↓
[第幾筆]       ["哪個欄位"]

all_news[1]["price"]
```

---

### 6. 搭配 for 迴圈

```
for item in all_news:
    print(item["title"], item["price"], item["rank"])
```

每跑一次：

```
item
```

就是其中一個 Dictionary。

第一次：

```
{"title":"台積電","price":800,"rank":1}
```

第二次：

```
{"title":"聯發科","price":1000,"rank":2}
```

第三次：

```
{"title":"鴻海","price":150,"rank":3}
```

所以才能：

```
item["title"]
item["price"]
item["rank"]
```

---

### 7. 購物車計算是很典型的考題

```
cart = [
    {"name":"Python書籍","price":450,"count":1},
    {"name":"無線滑鼠","price":890,"count":2},
    {"name":"螢幕支架","price":120,"count":1},
]

total = 0

for item in cart:
    price = item["price"]
    count = item["count"]

    cost = price * count

    print("小計", cost)

    total = total + cost

print(total)
```

逐筆計算：

```
Python書籍：450 × 1 = 450
無線滑鼠：890 × 2 = 1780
螢幕支架：120 × 1 = 120

總計 = 450 + 1780 + 120
     = 2350
```

所以最後：

```
print(total)
```

輸出：

```
2350
```

這裡的核心結構一定要會：

```
total = 0

for item in 資料:
    cost = ...
    total = total + cost
```

也可以寫：

```
total += cost
```

---

### 8. 你的 `site_data` 有一個容易混淆的地方

你現在寫：

```
site_data = {
    "city":"Taipei",
    "weather":[
        {"time":"morning"},
        {"temp":"night"},
        {"temp":18}
    ]
}

print(f'{site_data["city"]}晚上的氣溫{site_data["weather"][2]["temp"]}度')
```

程式可以得到：

```
Taipei晚上的氣溫18度
```

但資料結構不太合理，因為：

```
{"temp":"night"}
```

意思變成「溫度是 night」。

比較合理應該寫：

```
site_data = {
    "city": "Taipei",
    "weather": [
        {"time": "morning", "temp": 25},
        {"time": "night", "temp": 18}
    ]
}

print(f'{site_data["city"]}晚上的氣溫{site_data["weather"][1]["temp"]}度')
```

這時：

```
site_data["weather"][1]["temp"]
```

可以拆成：

```
site_data
   ↓
["weather"]     找 weather
   ↓
[1]             找第二筆
   ↓
["temp"]        找 temp
   ↓
18
```

### 考試最重要的 4 種取值方式

|資料結構|寫法|意思|
|---|---|---|
|List|`a[2]`|第 3 個|
|二維 List|`a[2][1]`|第 3 列第 2 個|
|Dictionary|`a["name"]`|找 `name`|
|List + Dictionary|`a[2]["name"]`|第 3 筆的 `name`|

最後這個可以當成口訣：

**看到 `[]` 裡面是數字 → List 索引；看到 `[]` 裡面是 `"文字"` → 通常是在用 Dictionary 的 key。**


## ##1-4--

你這一組程式很適合整理成 Python 檔案處理考試重點。其實主要就是 **備份、搬移、批次搬移、批次改名** 4 種題型。

### 1. 備份檔案：`shutil.copy2()`

你的第一題：

```
import os
import shutil
from datetime import datetime

def backup_file(source_file, target_folder):
    if not os.path.exists(source_file):
        print(f"找不到 {source_file}")
        return

    if not os.path.exists(target_folder):
        os.makedirs(target_folder)
        print(f"建立新資料夾 {target_folder}")

    try:
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        file_name = os.path.basename(source_file)
        new_file_name = f"{timestamp}_{file_name}"

        destination = os.path.join(target_folder, new_file_name)

        shutil.copy2(source_file, destination)

        print(f"備份成功，檔案存至 {destination}")

    except Exception as e:
        print(f"備份過程發生錯誤：{e}")

backup_file("data.txt", ".")
```

整個流程記成：

```
檢查來源檔案
     ↓
檢查目標資料夾
     ↓
不存在 → os.makedirs()
     ↓
取得時間 timestamp
     ↓
取得檔名 basename()
     ↓
組合新檔名
     ↓
組合完整路徑 join()
     ↓
copy2() 複製
```

這幾行特別重要：

```
timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
```

例如產生：

```
20260915_224500
```

而：

```
file_name = os.path.basename(source_file)
```

假設：

```
source_file = "C:/test/data.txt"
```

會得到：

```
data.txt
```

最後：

```
shutil.copy2(source_file, destination)
```

是**複製**，所以原始 `data.txt` 還會存在。

---

### 2. 歸檔檔案：`shutil.move()`

第二題：

```
target_dir = "old_notes"
sourcefile = "notes.txt"

if not os.path.exists(target_dir):
    os.makedirs(target_dir)

if os.path.exists(sourcefile):
    destination = os.path.join(target_dir, "backup_" + sourcefile)

    if os.path.exists(destination):
        print("檔案存在")
    else:
        shutil.move(sourcefile, destination)
        print(f"{sourcefile} 已經歸檔")
```

假設原本：

```
notes.txt
```

執行之後：

```
old_notes/
    backup_notes.txt
```

這裡要注意：

```
shutil.move()
```

是**移動**。

所以：

```
copy2()
原本檔案：✓
新檔案：  ✓

move()
原本檔案：✗
新檔案：  ✓
```

這是考試非常容易問的差異。

---

### 3. 批次搬移 `.txt`

第三題：

```
target_dir = "history_logs"

def move_files(sourcefile):

    if not os.path.exists(target_dir):
        os.makedirs(target_dir)

    if os.path.exists(sourcefile):
        shutil.move(
            sourcefile,
            os.path.join(target_dir, "old_" + sourcefile)
        )

        print(f"{sourcefile} 已經歸檔")

print(os.listdir("."))

for f in os.listdir("."):
    if os.path.isfile(f):
        if "txt" in f:
            move_files(f)
            print(f)
```

這裡最重要的是三層篩選：

```
for f in os.listdir("."):
```

第一層：目前資料夾所有東西。

接著：

```
if os.path.isfile(f):
```

第二層：只留下「檔案」，排除資料夾。

再：

```
if "txt" in f:
```

第三層：檔名有 `txt` 的檔案。

最後：

```
move_files(f)
```

搬進：

```
history_logs/
```

例如：

```
a.txt
b.txt
image.jpg
test.py
```

執行後：

```
history_logs/
    old_a.txt
    old_b.txt
```

不過這裡建議考試寫：

```
if f.endswith(".txt"):
```

比：

```
if "txt" in f:
```

更精確。

因為：

```
abc.txt.bak
mytxt.jpg
```

裡面也有 `"txt"`，但它們不一定是真正的 `.txt` 檔案。

---

### 4. `enumerate()` 批次重新命名

最後這題很重要：

```
import os

folder = "scraped_images"
files = os.listdir(folder)

for index, filename in enumerate(files):
    new_name = f"pet_{index}.jpg"

    old_path = os.path.join(folder, filename)
    new_path = os.path.join(folder, new_name)

    os.rename(old_path, new_path)

    print(f"更名成功{filename}->{new_name}")
```

假設：

```
scraped_images/
    dog.jpg
    cat.jpg
    bird.jpg
```

`enumerate(files)` 每次會給你兩個東西：

```
index    filename
  0      dog.jpg
  1      cat.jpg
  2      bird.jpg
```

所以：

```
new_name = f"pet_{index}.jpg"
```

產生：

```
pet_0.jpg
pet_1.jpg
pet_2.jpg
```

如果題目要求從 `pet_1.jpg` 開始，可以直接：

```
for index, filename in enumerate(files, start=1):
```

結果：

```
pet_1.jpg
pet_2.jpg
pet_3.jpg
```

---

### 這組題目考試最需要背的指令

|指令|功能|口訣|
|---|---|---|
|`os.path.exists(path)`|是否存在|存不存在|
|`os.makedirs(folder)`|建立資料夾|建資料夾|
|`os.listdir(folder)`|列出內容|有哪些東西|
|`os.path.isfile(path)`|是否為檔案|是不是檔案|
|`os.path.basename(path)`|取得檔名|路徑拿掉|
|`os.path.join(a, b)`|組合路徑|路徑接起來|
|`shutil.copy2(src, dst)`|複製|**原檔保留**|
|`shutil.move(src, dst)`|搬移|**原檔消失**|
|`os.rename(old, new)`|更名|改名字|
|`enumerate()`|索引＋內容|編號＋資料|
|`strftime()`|格式化時間|時間轉字串|

尤其把這四個分清楚：

```
shutil.copy2(source, destination)  # 複製
shutil.move(source, destination)   # 移動
os.rename(old, new)                # 更名
os.makedirs(folder)                # 建資料夾
```

你的四個範例剛好可以記成 **「備份 → 歸檔 → 批次歸檔 → 批次改名」**，這樣考試看到題目會比較容易立刻判斷該用哪一個函式。


## ##1-4-homework01--


students = [

    {"id": "A01", "name": "Alice", "score": 85},

    {"id": "A02", "name": "Bob", "score": 92},

    {"id": "A03", "name": "Charlie", "score": 78}

]

  

total = 0

for student in students:

    total = total + student["score"]

average = total / len(students)

print("平均分數：", average)

  

search_name = input("請輸入學生姓名：")

found = False

for student in students:

    if student["name"] == search_name:

        print("學生 ID：", student["id"])

        print("學生分數：", student["score"])

        found = True

        break

if not found:

    print("查無此人")


## ##1-4-homework02--


這一題和你上一題「學生平均分數」的結構非常像，都是 **List 裡面放 Dictionary，再用 `for` 逐筆計算**。差別是這次要算「單價 × 數量」。

### 先看資料結構

```
cart = [
    {"name": "Python 書籍", "price": 450, "count": 1},
    {"name": "無線滑鼠", "price": 890, "count": 2},
    {"name": "螢幕支架", "price": 1200, "count": 1}
]
```

外面的：

```
[ ... ]
```

是 **List**。

裡面的：

```
{"name": ..., "price": ..., "count": ...}
```

每一筆是 **Dictionary**。

所以可以這樣取資料：

```
cart[0]["name"]     # Python 書籍
cart[0]["price"]    # 450
cart[1]["price"]    # 890
cart[1]["count"]    # 2
```

可以記成：

```
cart[第幾筆商品]["欄位名稱"]
```

---

### `total_cost = 0` 是累加器

```
total_cost = 0
```

一開始總金額是 `0`。

接著：

```
for item in cart:
```

`item` 每次會取得一個 Dictionary：

```
第1次 → {"name":"Python 書籍", "price":450,  "count":1}
第2次 → {"name":"無線滑鼠",   "price":890,  "count":2}
第3次 → {"name":"螢幕支架",   "price":1200, "count":1}
```

---

### 最重要的計算

```
subtotal = item["price"] * item["count"]
```

就是：

> 小計 = 單價 × 數量

逐次執行：

```
Python 書籍
450 × 1 = 450

無線滑鼠
890 × 2 = 1780

螢幕支架
1200 × 1 = 1200
```

---

### `total_cost += subtotal`

```
total_cost += subtotal
```

等同：

```
total_cost = total_cost + subtotal
```

所以 `total_cost` 的變化：

```
一開始
total_cost = 0

第1次
0 + 450
= 450

第2次
450 + 1780
= 2230

第3次
2230 + 1200
= 3430
```

最後總金額：

```
3430
```

---

### `print()` 裡的 f-string

圖片中的：

```
print(f"商品:{item['name']}, 小計:{subtotal}")
```

假設第一次執行：

```
item["name"]   # Python 書籍
subtotal       # 450
```

所以輸出：

```
商品:Python 書籍, 小計:450
```

整個程式最後會輸出：

```
商品:Python 書籍, 小計:450
商品:無線滑鼠, 小計:1780
商品:螢幕支架, 小計:1200
總結帳金額:3430
```

### 這題考試最重要的結構

把它濃縮成這幾行：

```
total_cost = 0

for item in cart:
    subtotal = item["price"] * item["count"]
    total_cost += subtotal

print(total_cost)
```

可以用一句話記：

> **先設總計為 0 → for 逐筆取商品 → 單價 × 數量算小計 → 小計累加到總計。**

而且它跟你剛才的學生題幾乎是同一個觀念：

```
# 學生成績
total += student["score"]

# 購物車
subtotal = item["price"] * item["count"]
total_cost += subtotal
```

所以考試只要看到「**總分、總價、總數量、總金額**」，通常就要想到：**先設 `total = 0`，再用 `for` 搭配 `+=` 累加。**