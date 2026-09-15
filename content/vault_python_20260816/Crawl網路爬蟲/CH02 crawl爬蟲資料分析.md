
## ##2-1
這段程式是在做一個很標準的 **「Python 字典資料 → 寫入 CSV → 再讀取 CSV」** 範例。你的寫法基本上是正確的，只是目前主要程式碼前面都有 `##`，所以全部被註解掉，不會執行。

### 1. 原始資料

```
import csv
import os

data = [
    {"品名": "台積電", "股價": 800, "評等": "買進"},
    {"品名": "聯發科", "股價": 1000, "評等": "持有"},
    {"品名": "鴻海", "股價": 150, "評等": "買進"}
]

file_name = "stocks.csv"
```

`data` 是一個**串列 list**，裡面放了 3 個**字典 dict**。

可以想成：

```
data
 │
 ├─ {"品名":"台積電", "股價":800,  "評等":"買進"}
 ├─ {"品名":"聯發科", "股價":1000, "評等":"持有"}
 └─ {"品名":"鴻海",   "股價":150,  "評等":"買進"}
```

---

### 2. 寫入 CSV

把 `##` 拿掉：

```
with open(file_name, mode="w", encoding="utf-8-sig", newline="") as f:
    fieldnames = ["品名", "股價", "評等"]
    writer = csv.DictWriter(f, fieldnames=fieldnames)

    writer.writeheader()
    writer.writerows(data)
```

這裡最重要的是：

```
writer = csv.DictWriter(f, fieldnames=fieldnames)
```

意思是建立一個「專門寫字典資料」的 CSV writer。

`fieldnames`：

```
["品名", "股價", "評等"]
```

決定 CSV 的**欄位名稱與順序**。

接著：

```
writer.writeheader()
```

只寫標題：

```
品名,股價,評等
```

而：

```
writer.writerows(data)
```

是一次把 `data` 裡的**多筆字典**全部寫入。

最後 `stocks.csv` 會是：

```
品名,股價,評等
台積電,800,買進
聯發科,1000,持有
鴻海,150,買進
```

### 3. 讀取 CSV

```
with open(file_name, mode="r", encoding="utf-8-sig") as f:
    reader = csv.DictReader(f)

    for row in reader:
        print(row)
```

`DictReader` 會把每一列資料轉成類似字典的形式。

所以：

```
for row in reader:
    print(row)
```

會得到類似：

```
{'品名': '台積電', '股價': '800', '評等': '買進'}
{'品名': '聯發科', '股價': '1000', '評等': '持有'}
{'品名': '鴻海', '股價': '150', '評等': '買進'}
```

這裡有一個 **考試很容易考的地方**：

```
"股價": "800"
```

讀回來的 `800` 是 **字串 `str`**，不是原本的整數 `int`。

例如：

```
print(type(row["股價"]))
```

結果是：

```
<class 'str'>
```

如果要拿來數學運算：

```
price = int(row["股價"])
```

### 4. `with open()` 為什麼不用 `close()`？

你註解寫：

```
1. 開啟/建立文件
2. 讀取/寫入文件
3. 關閉文件
```

完全正確。

但使用：

```
with open(...) as f:
```

Python 會在離開 `with` 區塊後**自動關閉檔案**，所以不需要：

```
f.close()
```

### 考試可以這樣記

|指令|功能|
|---|---|
|`open(..., "w")`|寫入，原檔案內容會被覆蓋|
|`open(..., "r")`|讀取|
|`csv.DictWriter()`|用「字典」寫 CSV|
|`writeheader()`|寫入欄位名稱|
|`writerow(dict)`|寫入**一筆**字典|
|`writerows(list)`|寫入**多筆**資料|
|`csv.DictReader()`|把 CSV 每列當成類似字典讀取|
|`with open()`|結束後自動關閉檔案|
|`utf-8-sig`|中文 CSV 給 Excel 開啟時通常較不容易出現亂碼|
|`newline=""`|寫 CSV 時避免產生多餘空白列|

另外你有：

```
import os
```

但目前這個版本**還沒有使用 `os`**。如果下一步是要做你之前練過的「`stocks.csv` 不存在才寫入標題，已存在就追加資料」，這時 `os.path.exists(file_name)` 就會派上用場。
對，這段程式的邏輯是正確的，而且剛好把你之前學的 `os.path.exists()` 和 CSV 結合起來了。

核心目的就是：

> **檔案不存在 → 建立檔案＋寫標題＋寫資料**  
> **檔案已存在 → 不寫標題，只追加資料**

看你的程式：

```
new_data = {"品名": "新產品x", "股價": 500, "評等": "觀察"}        

not_exists = False

if not os.path.exists(file_name):
    not_exists = True
```

最重要的是這一段。

假設：

```
file_name = "stocks.csv"
```

### 情況 1：`stocks.csv` 不存在

```
os.path.exists(file_name)
```

得到：

```
False
```

加上 `not`：

```
not False
```

就變成：

```
True
```

所以：

```
if not os.path.exists(file_name):
    not_exists = True
```

會執行，最後：

```
not_exists == True
```

接著：

```
with open(file_name, mode="a", encoding="utf-8-sig", newline="") as f:
```

`a` 是 **append 追加模式**。

因為檔案不存在，所以 `"a"` 會順便建立新檔案。

接下來：

```
if not_exists:
    writer.writeheader()
```

因為：

```
not_exists == True
```

所以寫入標題。

最後：

```
writer.writerow(new_data)
```

寫入資料。

CSV 就會是：

```
品名,股價,評等
新產品x,500,觀察
```

---

### 情況 2：`stocks.csv` 已經存在

這時：

```
os.path.exists(file_name)
```

是：

```
True
```

因此：

```
not True
```

變成：

```
False
```

所以這個 `if` 不會執行：

```
if not os.path.exists(file_name):
    not_exists = True
```

`not_exists` 維持原本的：

```
False
```

接下來：

```
if not_exists:
    writer.writeheader()
```

也不會執行。

因此**不會重複寫標題**，只執行：

```
writer.writerow(new_data)
```

假設原本：

```
品名,股價,評等
台積電,800,買進
聯發科,1000,持有
鴻海,150,買進
```

就會變成：

```
品名,股價,評等
台積電,800,買進
聯發科,1000,持有
鴻海,150,買進
新產品x,500,觀察
```

### 這題最重要的流程

```
os.path.exists(file_name)
          ↓
      檔案存在嗎？
       ↙      ↘
     否          是
   False        True
     ↓            ↓
not False      not True
     ↓            ↓
   True         False
     ↓            ↓
寫 header      不寫 header
     ↘            ↙
       writerow()
           ↓
        寫入資料
```

而且你的：

```
not_exists = False

if not os.path.exists(file_name):
    not_exists = True
```

其實可以簡化成一行：

```
not_exists = not os.path.exists(file_name)
```

兩種寫法的效果相同。

如果是考試，我反而建議你先記你現在這個版本，因為比較容易理解：

```
not_exists = False

if not os.path.exists(file_name):
    not_exists = True
```

最後再記一個關鍵：

**`writerow()` 是一筆，`writerows()` 是多筆。**

你這裡的：

```
new_data = {"品名": "新產品x", "股價": 500, "評等": "觀察"}
```

是一個 `dict`，只有一筆，所以使用：

```
writer.writerow(new_data)
```

是正確的。


你這份程式的架構基本上是對的，已經把 CSV 的「寫入、讀取、輸入、追加」拆成不同函式了。不過有一個地方很容易搞混：你把**函式名稱 `input_data`** 和 `append_csv()` 的**參數名稱 `input_data`** 取成一樣。

### 先看你目前最重要的一行

```
def append_csv(file_name, input_data):
    ...
    writer.writerow(input_data())
```

你呼叫：

```
append_csv(file_name, input_data)
```

這時傳進去的 `input_data` 是「函式本身」，所以：

```
input_data()
```

才會執行這個函式，取得：

```
{
    "品名": ...,
    "股價": ...,
    "評等": ...
}
```

因此你的程式**可以執行**，但名稱很容易讓自己搞混。

---

## 建議改成更清楚的版本

例如把 `append_csv()` 的第二個參數改成 `input_func`：

```
def append_csv(file_name, input_func):
    not_exists = not os.path.exists(file_name)

    with open(file_name, mode='a',
              encoding='utf-8-sig', newline="") as f:

        fieldnames = ["品名", "股價", "評等"]
        writer = csv.DictWriter(f, fieldnames=fieldnames)

        if not_exists:
            writer.writeheader()

        writer.writerow(input_func())
```

呼叫：

```
append_csv(file_name, input_data)
```

注意這裡是：

```
input_data
```

不是：

```
input_data()
```

因為你現在是在把「函式」傳進 `append_csv()`。

流程就是：

```
append_csv(file_name, input_data)
              ↓
       input_func = input_data
              ↓
       input_func()
              ↓
       執行 input_data()
              ↓
       回傳一個 dictionary
              ↓
       writer.writerow(dictionary)
```

---

### 另外，你的多次輸入可以再簡化

你現在：

```
while True:
    read_csv(file_name)
    append_csv(file_name, input_data)
    read_csv(file_name)

    yes_or_no = input("是否繼續(y/n)")
    if yes_or_no == "n":
        break
```

每一輪會讀取 CSV **兩次**。

假設原本有：

```
台積電
聯發科
鴻海
```

第一輪：

```
read_csv()
↓
先顯示3筆

append_csv()
↓
輸入第4筆

read_csv()
↓
再顯示4筆
```

所以前三筆資料會重複顯示。

如果你的目的只是「持續新增資料」，比較適合：

```
while True:
    append_csv(file_name, input_data)

    yes_or_no = input("是否繼續(y/n)：")

    if yes_or_no == "n":
        break

read_csv(file_name)
```

這樣就是：

```
輸入股票
   ↓
寫入 CSV
   ↓
是否繼續？
 ┌─────┴─────┐
 y           n
 ↓           ↓
再輸入      break
             ↓
        顯示全部資料
```

### 考試特別要記

你這題其實包含一個很重要的「函式當作參數」觀念：

```
append_csv(file_name, input_data)
```

`input_data` → **把函式傳進去，沒有執行**

```
append_csv(file_name, input_data())
```

`input_data()` → **先執行函式，把 return 的字典傳進去**

而你的：

```
writer.writerow(input_func())
```

就是在 `append_csv()` 裡面才真正執行輸入函式。

另外：

```
writer.writerow(...)
```

要求的是一個 `dict`，例如：

```
{"品名": "台積電", "股價": 800, "評等": "買進"}
```

這也正是你之前遇到 `AttributeError: 'function' object has no attribute 'keys'` 時需要特別注意的地方：`writerow()` 最後拿到的必須是**字典資料**，而不是函式本身。
## ##2-2
這段寫得很好，這題其實同時在考 **巢狀 JSON 資料存取** 和 **多個 `except` 的順序**。你的程式會正常執行，結果是：

```
台中天氣: 晴
```

### 先看 JSON 的層級

你的資料可以簡化成：

```
data
│
├── "status" → "success"
│
└── "results" → list
                  │
                  ├── [0] → 台北
                  │
                  └── [1] → 台中
                              │
                              └── "info"
                                   │
                                   ├── "name" → "台中"
                                   └── "weather" → "晴"
```

所以這一行：

```
data["results"][1]["info"]["weather"]
```

可以由左到右一層一層拆：

```
data["results"]
```

取得 `results` 的串列。

再：

```
data["results"][1]
```

取得第 2 筆：

```
{
    "id": 2,
    "info": {
        "name": "台中",
        "weather": "晴"
    }
}
```

再：

```
data["results"][1]["info"]
```

取得：

```
{
    "name": "台中",
    "weather": "晴"
}
```

最後：

```
data["results"][1]["info"]["weather"]
```

取得：

```
晴
```

所以這種題目可以記成：

```
["results"] → 找 key
[1]         → 找 list 第 2 筆
["info"]    → 找 key
["weather"] → 找 key
```

### `try / except` 也寫對了

```
try:
    data = json.loads(raw_data)
    print("台中天氣:", data["results"][1]["info"]["weather"])

except json.decoder.JSONDecodeError as je:
    print(je)

except NameError as ne:
    print(ne)

except Exception as e:
    print(e)
```

這裡你的註解：

```
# 越上層的類別盡量放後面
```

非常重要。

`Exception` 是很多例外的父類別，可以簡單理解：

```
Exception
├── NameError
├── TypeError
├── ValueError
│    └── JSONDecodeError
├── KeyError
├── IndexError
└── ...
```

所以應該：

```
except JSONDecodeError:   # 特定
except NameError:         # 特定
except Exception:         # 廣泛 → 最後
```

如果把：

```
except Exception as e:
```

放最前面，很多錯誤都會先被它抓走，後面的特定 `except` 就失去作用。

### 你註解中的 `n` 可以這樣測試

例如：

```
try:
    data = json.loads(raw_data)
    print(n)
    print("台中天氣:", data["results"][1]["info"]["weather"])

except json.decoder.JSONDecodeError as je:
    print(je)

except NameError as ne:
    print("發生 NameError：", ne)

except Exception as e:
    print("其他錯誤：", e)
```

因為沒有定義：

```
n = ...
```

所以：

```
print(n)
```

會產生 `NameError`，然後被：

```
except NameError as ne:
```

抓到。

### 這題再多記 3 個常見陷阱

例如：

```
data["results"][1]["info"]["weather"]
```

不同地方寫錯，會產生不同例外：

|寫錯方式|可能的例外|
|---|---|
|`print(n)`，`n` 未定義|`NameError`|
|`data["abc"]`，沒有這個 key|`KeyError`|
|`data["results"][10]`，list 沒有第 11 筆|`IndexError`|
|JSON 格式本身寫錯|`JSONDecodeError`|

所以這題考試最值得記：

**字典用 `["key"]`，串列用 `[索引]`；巢狀 JSON 就按照資料結構一層一層往內找。**

你的這題就是：

```
dict → list → dict → dict

["results"] → [1] → ["info"] → ["weather"]
```

這個判斷方法比死背 `data["results"][1]["info"]["weather"]` 更重要。

## ##2-3

這段程式是正確的。它是在練習 **XML 字串 → XML 元素 → 找節點 → 取得屬性與文字內容**。

執行結果：

```
----新聞列表----
item id= 1
title= Python 爬蟲入門
author= 老師
item id= 2
title= AI 時代來臨
author= 小助手
```

### 先看 XML 結構

```
<news_list>
    <item id="1">
        <title>Python 爬蟲入門</title>
        <author>老師</author>
    </item>

    <item id="2">
        <title>AI 時代來臨</title>
        <author>小助手</author>
    </item>
</news_list>
```

可以把它想成：

```
news_list                 ← root
│
├── item                  ← id="1"
│   ├── title             ← Python 爬蟲入門
│   └── author            ← 老師
│
└── item                  ← id="2"
    ├── title             ← AI 時代來臨
    └── author            ← 小助手
```

### 1. `ET.fromstring()`

```
root = ET.fromstring(xml_string)
```

把 **XML 字串解析成 XML Element**。

所以：

```
print(root.tag)
```

會得到：

```
news_list
```

因為最外層標籤是：

```
<news_list>
```

---

### 2. `root.findall("item")`

```
for news in root.findall("item"):
```

`findall()` 是：

> 找出所有符合名稱的子元素。

這裡會找到兩個：

```
<item id="1">...</item>

<item id="2">...</item>
```

所以迴圈執行兩次。

第一次：

```
news → <item id="1">
```

第二次：

```
news → <item id="2">
```

---

### 3. `.tag`、`.get()`、`.find()`、`.text`

這四個非常重要。

```
news.tag
```

取得**標籤名稱**：

```
item
```

而：

```
news.get("id")
```

取得 XML 的**屬性 attribute**：

```
<item id="1">
      ↑
   attribute
```

所以：

```
news.get("id")
```

第一次得到：

```
1
```

---

接著：

```
news.find("title")
```

是找到：

```
<title>Python 爬蟲入門</title>
```

但是 `find()` 找到的是 **Element 元素本身**。

如果要裡面的文字，就要再加：

```
.text
```

所以：

```
news.find("title").text
```

得到：

```
Python 爬蟲入門
```

同理：

```
news.find("author").text
```

得到：

```
老師
```

### 考試最重要的整理

|寫法|功能|
|---|---|
|`ET.fromstring(xml_string)`|XML 字串 → Element|
|`root.tag`|取得標籤名稱|
|`root.findall("item")`|找到**所有** item|
|`news.find("title")`|找到一個 title 元素|
|`news.find("title").text`|取得 title 的**文字**|
|`news.get("id")`|取得 `id` **屬性**|

尤其要分清楚 **attribute 與 text**：

```
<item id="1">
      ↑
    .get("id")

    <title>Python 爬蟲入門</title>
           ↑
       .find("title").text
</item>
```

所以可以記成：

**屬性用 `.get()`，標籤裡面的文字用 `.find(...).text`。**

另外，你之前遇過的：

```
root.find("temp").text
```

出現：

```
AttributeError: 'NoneType' object has no attribute 'text'
```

原因通常就是 `find("temp")` **沒有找到 `<temp>`**，因此回傳 `None`，再對 `None` 使用 `.text` 就會出錯。這和現在這個例子可以一起記。

import xml.etree.ElementTree as ET tree = ET.parse("dental_clinics.xml") root = tree.getroot() for content in root.findall("Data"): print("機構名稱:", content.find("機構名稱").text) print("地址:", content.find("街道項弄號").text) print("負責人:", content.find("負責人").text) print("電話:", content.find("電話").text) print()

對，這段也是正確的。和上一題最大的差別是：**上一題用 `ET.fromstring()` 解析 XML 字串；這一題用 `ET.parse()` 直接讀取 XML 檔案。**

假設 `dental_clinics.xml` 結構像這樣：

```
<Datas>
    <Data>
        <機構名稱>森美牙醫診所</機構名稱>
        <街道項弄號>大同里中正路111號</街道項弄號>
        <負責人>李森孟</負責人>
        <電話>(03)5260203</電話>
    </Data>

    <Data>
        <機構名稱>黃啟祥牙醫診所</機構名稱>
        <街道項弄號>和福街105號</街道項弄號>
        <負責人>黃啟祥</負責人>
        <電話>(03)5269095</電話>
    </Data>
</Datas>
```

可以想成：

```
Datas                    ← root
│
├── Data                 ← content
│   ├── 機構名稱
│   ├── 街道項弄號
│   ├── 負責人
│   └── 電話
│
└── Data                 ← content
    ├── 機構名稱
    ├── 街道項弄號
    ├── 負責人
    └── 電話
```

程式第一步：

```
tree = ET.parse("dental_clinics.xml")
```

是直接讀取並解析 XML **檔案**。

接著：

```
root = tree.getroot()
```

取得最外層的根元素 `<Datas>`。

所以：

```
print(root.tag)
```

會得到：

```
Datas
```

接下來：

```
for content in root.findall("Data"):
```

`findall("Data")` 會找出 `<Datas>` 底下**所有 `<Data>`**。

因此每跑一次迴圈：

```
content
```

就代表其中一筆：

```
<Data>
    ...
</Data>
```

最後這些：

```
content.find("機構名稱").text
content.find("街道項弄號").text
content.find("負責人").text
content.find("電話").text
```

都是同一個結構：

```
content
   ↓
.find("標籤名稱")
   ↓
找到 Element
   ↓
.text
   ↓
取得裡面的文字
```

例如：

```
content.find("機構名稱")
```

找到：

```
<機構名稱>森美牙醫診所</機構名稱>
```

再加：

```
.text
```

才得到：

```
森美牙醫診所
```

所以最後可能輸出：

```
機構名稱: 森美牙醫診所
地址: 大同里中正路111號
負責人: 李森孟
電話: (03)5260203

機構名稱: 黃啟祥牙醫診所
地址: 和福街105號
負責人: 黃啟祥
電話: (03)5269095
```

你現在 XML 可以把兩種讀取方式一起記：

|資料來源|寫法|
|---|---|
|XML **字串**|`ET.fromstring(xml_string)`|
|XML **檔案**|`ET.parse("檔名.xml")`|
|取得檔案的 root|`tree.getroot()`|
|找所有子元素|`root.findall("Data")`|
|找一個子元素|`content.find("電話")`|
|取得元素文字|`content.find("電話").text`|
|取得 XML 屬性|`content.get("id")`|

最簡單的考試口訣就是：

**字串 → `fromstring()`；檔案 → `parse()`；找很多 → `findall()`；找一個 → `find()`；取內容 → `.text`；取屬性 → `.get()`。**
## ##2-4



## CH2-homework01--

這張圖的「實作題 2 題」主要是在考 **CSV 寫入、CSV 讀取、型態轉換、for 迴圈加總**。你前面那份 `stocks.csv` 程式其實已經涵蓋大部分觀念了。

## 第 1 題：產品清單匯出

題目要求建立 3 個產品的 `List of Dicts`，欄位是 `ID、Name、Price`，存成 `products.csv`，並使用 `utf-8-sig`。

```
import csv

products = [
    {"ID": 1, "Name": "蘋果", "Price": 50},
    {"ID": 2, "Name": "香蕉", "Price": 30},
    {"ID": 3, "Name": "鳳梨", "Price": 80}
]

with open("products.csv", "w",
          encoding="utf-8-sig", newline="") as f:

    fieldnames = ["ID", "Name", "Price"]

    writer = csv.DictWriter(f, fieldnames=fieldnames)

    writer.writeheader()
    writer.writerows(products)
```

產生的 CSV：

```
ID,Name,Price
1,蘋果,50
2,香蕉,30
3,鳳梨,80
```

這題要記三個東西：

```
writer = csv.DictWriter(f, fieldnames=fieldnames)
writer.writeheader()       # 寫欄位名稱
writer.writerows(products) # 一次寫很多筆
```

尤其：

```
encoding="utf-8-sig"
```

是為了讓 Windows Excel 開啟 CSV 時，中文比較不容易出現亂碼。

---

# 第 2 題：讀取並計算總額

接著讀取剛才的 `products.csv`：

```
import csv

total = 0

with open("products.csv", "r",
          encoding="utf-8-sig") as f:

    reader = csv.DictReader(f)

    for row in reader:
        print(row)
        total += float(row["Price"])

print("Price 總和：", total)
```

結果：

```
{'ID': '1', 'Name': '蘋果', 'Price': '50'}
{'ID': '2', 'Name': '香蕉', 'Price': '30'}
{'ID': '3', 'Name': '鳳梨', 'Price': '80'}

Price 總和： 160.0
```

## ⚠️ 這題最大的考點

CSV 讀回來的：

```
row["Price"]
```

通常是**字串 `str`**。

也就是：

```
"50"
"30"
"80"
```

不能直接拿來做正常的數值加總，所以要：

```
float(row["Price"])
```

如果題目的 Price 全部都是整數，也可以：

```
int(row["Price"])
```

所以考試看到：

> 「從 CSV 讀回來的數字可能是字串格式，需轉換」

馬上想到：

```
int(row["Price"])
```

或：

```
float(row["Price"])
```

---

## 和你前面的 stocks.csv 對照

其實兩題幾乎就是你剛才寫過的：

```
data = [
    {"品名": "台積電", "股價": 800, "評等": "買進"},
    {"品名": "聯發科", "股價": 1000, "評等": "持有"},
    {"品名": "鴻海", "股價": 150, "評等": "買進"}
]
```

換成：

```
products = [
    {"ID": 1, "Name": "蘋果", "Price": 50},
    {"ID": 2, "Name": "香蕉", "Price": 30},
    {"ID": 3, "Name": "鳳梨", "Price": 80}
]
```

### 考前記憶版

```
寫 CSV
List of Dicts
     ↓
csv.DictWriter
     ↓
writeheader()       ← 標題
     ↓
writerows(data)     ← 多筆資料


讀 CSV
csv.DictReader
     ↓
for row in reader
     ↓
row["Price"]
     ↓
float(row["Price"]) ← 字串轉數字
     ↓
total += ...
```

另外圖片下半部的 **`json.loads()` 與 `json.dumps()`** 也是很容易出題的地方，最簡單可以先背：

```
loads：JSON 字串 → Python
dumps：Python → JSON 字串
```

其中 `s` 可以幫你記成 **string**。


## CH2-homework02--

這張圖很重要，因為它把 JSON 最容易混淆的 **4 個函式**都帶到了：`loads()`、`dumps()`、`load()`、`dump()`。

## 最重要：先分成「字串」與「檔案」

|函式|方向|用途|
|---|---|---|
|`json.loads()`|JSON 字串 → Python|讀「字串」|
|`json.dumps()`|Python → JSON 字串|產生「字串」|
|`json.load()`|JSON 檔案 → Python|讀「檔案」|
|`json.dump()`|Python → JSON 檔案|寫「檔案」|

最好這樣記：

```
有 s → string（字串）

loads  ：字串 → Python
dumps  ：Python → 字串

沒 s → 檔案

load   ：檔案 → Python
dump   ：Python → 檔案
```

---

## ① `json.loads()`：JSON 字串 → Python 字典

圖片中的概念：

```
import json

raw_json_str = '{"name": "台北天氣", "temp": 25, "status": "晴天"}'

data = json.loads(raw_json_str)

print(type(data))
print(data["name"])
print(data["temp"])
```

轉換過程：

```
JSON 字串
'{"name":"台北天氣","temp":25}'
              ↓
        json.loads()
              ↓
Python dict
{"name":"台北天氣", "temp":25}
```

所以：

```
type(raw_json_str)
```

是：

```
str
```

但是：

```
type(data)
```

是：

```
dict
```

### 為什麼要轉成 dict？

因為轉成 Python 字典後，就可以：

```
data["name"]
data["temp"]
data["status"]
```

---

## ② `json.dumps()`：Python → JSON 字串

反過來：

```
import json

student_info = {
    "id": "A123",
    "courses": ["Python", "爬蟲", "AI"],
    "is_graduated": False
}

json_string = json.dumps(
    student_info,
    indent=4,
    ensure_ascii=False
)

print(json_string)
```

方向：

```
Python dict
     ↓
json.dumps()
     ↓
JSON 字串 str
```

因此：

```
type(json_string)
```

會是：

```
str
```

### 兩個參數也要知道

```
indent=4
```

代表漂亮縮排：

```
{
    "id": "A123",
    "courses": [
        "Python",
        "爬蟲",
        "AI"
    ],
    "is_graduated": false
}
```

而：

```
ensure_ascii=False
```

主要是讓中文字直接顯示，而不是變成 Unicode 跳脫形式。

---

# ③ `json.dump()`：Python → JSON 檔案

圖片中的：

```
import json

config = {
    "url": "https://example.com",
    "retry": 3
}

with open("config.json", "w") as f:
    json.dump(config, f)
```

這次沒有：

```
json.dumps()
```

而是：

```
json.dump()
```

因為我們不是要取得 JSON **字串**，而是要把資料**寫進檔案**。

```
Python dict
    ↓
json.dump()
    ↓
config.json
```

我會更建議中文資料時寫：

```
with open("config.json", "w", encoding="utf-8") as f:
    json.dump(config, f, ensure_ascii=False, indent=4)
```

---

# ④ `json.load()`：JSON 檔案 → Python

最後再把 `config.json` 讀回來：

```
with open("config.json", "r", encoding="utf-8") as f:
    loaded_config = json.load(f)

print(loaded_config["url"])
```

方向：

```
config.json
    ↓
json.load()
    ↓
Python dict
```

---

# ⭐ 考試最容易考的差異

直接背這張：

```
                JSON              Python
                 │                  │
JSON 字串 ── loads() ───────────→ dict
JSON 字串 ←─ dumps() ──────────── dict


JSON 檔案 ── load() ────────────→ dict
JSON 檔案 ←─ dump() ───────────── dict
```

更簡單：

```
load  = 讀進來
dump  = 倒出去

有 s = string
沒 s = file
```

所以看到：

```
json.loads('{"name":"Tom"}')
```

想到：

> **JSON 字串 → Python**

看到：

```
json.dumps({"name": "Tom"})
```

想到：

> **Python → JSON 字串**

看到：

```
json.load(f)
```

想到：

> **JSON 檔案 → Python**

看到：

```
json.dump(data, f)
```

想到：

> **Python → JSON 檔案**

### 一個考試陷阱

注意 JSON 和 Python 的布林值寫法不同：

```
Python          JSON
True      →     true
False     →     false
None      →     null
```

例如 Python：

```
{"is_graduated": False}
```

經過：

```
json.dumps(...)
```

JSON 會變成：

```
{"is_graduated": false}
```

這個差異很值得一起記。

## CH2-homework2-2--

對，這張是在補充 JSON 的「考試陷阱」。我幫你把每一點跟前面的 `load / loads / dump / dumps` 串起來。

### 1. `loads` vs `load`

最重要就是 **有沒有 `s`**：

```
loads → s = string → 處理 JSON 字串
load  → 沒有 s      → 讀取 JSON 檔案
```

例如字串：

```
import json

text = '{"name": "Tom"}'
data = json.loads(text)
```

檔案則是：

```
with open("data.json", "r", encoding="utf-8") as f:
    data = json.load(f)
```

同理，反方向也是：

```
dumps → Python → JSON 字串
dump  → Python → JSON 檔案
```

---

### 2. `ensure_ascii=False`

例如：

```
data = {"name": "台積電"}

print(json.dumps(data))
```

可能看到：

```
{"name": "\u53f0\u7a4d\u96fb"}
```

加入：

```
print(json.dumps(data, ensure_ascii=False))
```

就可以直接看到：

```
{"name": "台積電"}
```

所以考試看到：

> 如何讓 JSON 正常顯示中文？

答案就是：

```
ensure_ascii=False
```

---

### 3. `indent=4`

只是讓 JSON **排版比較漂亮、比較容易閱讀**：

```
data = {
    "name": "台積電",
    "price": 800
}

print(json.dumps(data, ensure_ascii=False, indent=4))
```

結果：

```
{
    "name": "台積電",
    "price": 800
}
```

`indent=4` = 每一層縮排 4 個空格。

---

## 4. JSON Key 一定要雙引號

合法 JSON：

```
{
    "name": "Tom",
    "age": 20
}
```

下面不是合法 JSON：

```
{'name': 'Tom'}
```

因為 JSON 的 key、字串必須使用：

```
"雙引號"
```

這點要注意：Python 字典可以寫單引號：

```
{"name": "Tom"}
{'name': 'Tom'}
```

但標準 JSON 要用雙引號。

---

## 5. `null / true / false` 的轉換

這是考試很容易考的：

|JSON|Python|
|---|---|
|`null`|`None`|
|`true`|`True`|
|`false`|`False`|

例如 JSON：

```
text = '''
{
    "name": "Tom",
    "passed": true,
    "deleted": false,
    "score": null
}
'''

data = json.loads(text)

print(data)
```

Python 得到：

```
{
    "name": "Tom",
    "passed": True,
    "deleted": False,
    "score": None
}
```

注意**大小寫也不同**：

```
JSON       Python
true   →   True
false  →   False
null   →   None
```

---

## 6. `s` 的意思可以記成 String

這個記法非常適合考試：

```
loads
     ↑
     s = String

dumps
     ↑
     s = String
```

所以：

```
loads：JSON String → Python
dumps：Python → JSON String

load ：JSON File → Python
dump ：Python → JSON File
```

---

## 7. 有些 Python 物件不能直接轉 JSON

例如：

```
import json
from datetime import datetime

data = {
    "time": datetime.now()
}

json.dumps(data)
```

會發生：

```
TypeError: Object of type datetime is not JSON serializable
```

因為 `datetime` 不能直接 JSON 序列化。

先轉成字串：

```
data = {
    "time": str(datetime.now())
}

print(json.dumps(data))
```

`set` 也是一樣：

```
data = {"skills": {"Python", "MySQL"}}
```

不能直接 `json.dumps()`。

可以先：

```
data = {
    "skills": list({"Python", "MySQL"})
}
```

再：

```
json.dumps(data)
```

### ⭐ 最後濃縮成一張考試記憶表

```
                JSON                     Python

字串 ───── json.loads() ─────────────→ Python
字串 ←──── json.dumps() ────────────── Python

檔案 ───── json.load() ──────────────→ Python
檔案 ←──── json.dump() ─────────────── Python


s = String
load = 讀進來
dump = 倒出去

ensure_ascii=False → 中文正常顯示
indent=4           → 漂亮縮排

JSON              Python
null      ↔        None
true      ↔        True
false     ↔        False
```

如果考題問 **「`json.load()` 和 `json.loads()` 最大差別？」**，最精簡答案就是：**`load()` 讀檔案，`loads()` 讀 JSON 字串。**


## CH2-2--
這兩題就是在考你剛才學的 **`json.dumps()` 與 `json.loads()`**，而且兩題剛好方向相反。

## 第 1 題：個人化設定檔轉換

題目要求：

> 建立 Python 字典 `my_config`，包含 `user_id`、`theme`、`auto_login`，再轉成「縮排 4 格、中文正常顯示」的 JSON 字串。

可以這樣寫：

```
import json

my_config = {
    "user_id": 1001,
    "theme": "深色主題",
    "auto_login": True
}

json_string = json.dumps(
    my_config,
    indent=4,
    ensure_ascii=False
)

print(json_string)
```

輸出：

```
{
    "user_id": 1001,
    "theme": "深色主題",
    "auto_login": true
}
```

### 為什麼用 `dumps()`？

因為現在是：

```
Python 字典
    ↓
JSON 字串
```

所以：

```
json.dumps()
```

其中題目的兩個關鍵要求：

```
indent=4
```

→ 縮排 4 格。

```
ensure_ascii=False
```

→ 中文正常顯示。

另外注意：

```
"auto_login": True
```

是 Python 的寫法，但是轉成 JSON 後會變：

```
"auto_login": true
```

---

## 第 2 題：API 資料提取

題目已經給你：

```
api_res = '{"count": 1, "data": [{"title": "今日新聞", "likes": 99}]}'
```

注意外面有引號，所以 `api_res` 現在是：

```
JSON 字串（str）
```

題目要求先轉成 Python 物件，再印出 `title` 和 `likes`。

答案：

```
import json

api_res = '{"count": 1, "data": [{"title": "今日新聞", "likes": 99}]}'

data = json.loads(api_res)

print("標題：", data["data"][0]["title"])
print("按讚數：", data["data"][0]["likes"])
```

輸出：

```
標題： 今日新聞
按讚數： 99
```

這一題最重要的是看懂：

```
data["data"][0]["title"]
```

我們拆開：

```
data
```

是整個字典：

```
{
    "count": 1,
    "data": [
        {
            "title": "今日新聞",
            "likes": 99
        }
    ]
}
```

第一步：

```
data["data"]
```

取得 List：

```
[
    {
        "title": "今日新聞",
        "likes": 99
    }
]
```

第二步：

```
data["data"][0]
```

取得 List 第 `0` 筆：

```
{
    "title": "今日新聞",
    "likes": 99
}
```

第三步：

```
data["data"][0]["title"]
```

得到：

```
今日新聞
```

同理：

```
data["data"][0]["likes"]
```

得到：

```
99
```

### 這兩題剛好可以成對記

```
第 1 題
Python 字典
   ↓
dumps()
   ↓
JSON 字串


第 2 題
JSON 字串
   ↓
loads()
   ↓
Python 字典
   ↓
["data"]
   ↓
[0]
   ↓
["title"] / ["likes"]
```

所以考試看到「**將 Python 字典轉成 JSON 字串**」→ `dumps()`；看到「**將 JSON 字串轉成 Python 物件**」→ `loads()`。

尤其第 2 題的 **`["data"][0]["title"]` 巢狀取值**，我認為是這題最需要會看懂的部分。



## CH2-3--
這一頁開始進入 **XML**。如果前面 JSON 已經懂了，XML 可以用「**樹狀結構**」來理解，考試會容易很多。

## 先看 XML 長什麼樣

圖片中的資料：

```
<weather_report>
    <city name="台北">
        <temp>25</temp>
        <status>多雲</status>
    </city>
</weather_report>
```

它可以想成一棵樹：

```
weather_report              ← 根節點 root
│
└── city                    ← 子節點
    │   name="台北"          ← 屬性 attribute
    │
    ├── temp
    │    └── 25             ← 文字 text
    │
    └── status
         └── 多雲            ← 文字 text
```

這個觀念非常重要。

---

## 1. XML 的標籤、屬性、文字

例如：

```
<city name="台北">
    <temp>25</temp>
</city>
```

這裡可以拆成：

```
city        → 標籤 tag
name        → 屬性名稱
台北         → 屬性值
temp        → 子標籤
25          → 文字內容 text
```

所以 Python 處理 XML 時，常看到三個東西：

```
element.tag
element.get("屬性")
element.text
```

可以直接背：

```
.tag       → 標籤名稱
.get()     → 取得屬性
.text      → 取得文字內容
```

---

# 2. `ET.fromstring()`：解析 XML 字串

圖片中的：

```
import xml.etree.ElementTree as ET

xml_data = """
<weather_report>
    <city name="台北">
        <temp>25</temp>
        <status>多雲</status>
    </city>
</weather_report>
"""

root = ET.fromstring(xml_data)

print(root.tag)
```

結果：

```
weather_report
```

因為：

```
root = ET.fromstring(xml_data)
```

會解析 XML **字串**，並取得根節點。

所以：

```
root.tag
```

就是：

```
weather_report
```

---

# 3. 如何找到 `<city>`

可以：

```
city = root.find("city")
```

現在 `city` 就代表：

```
<city name="台北">
    <temp>25</temp>
    <status>多雲</status>
</city>
```

---

# 4. `.get()` 取得「屬性」

`city` 有：

```
<city name="台北">
```

其中：

```
name="台北"
```

是屬性。

所以：

```
print(city.get("name"))
```

結果：

```
台北
```

記：

```
.get("name")
```

→ 找**屬性**。

---

# 5. `.find().text` 取得標籤裡的文字

例如：

```
<temp>25</temp>
```

可以：

```
print(city.find("temp").text)
```

結果：

```
25
```

而：

```
<status>多雲</status>
```

可以：

```
print(city.find("status").text)
```

結果：

```
多雲
```

所以完整程式：

```
import xml.etree.ElementTree as ET

xml_data = """
<weather_report>
    <city name="台北">
        <temp>25</temp>
        <status>多雲</status>
    </city>
</weather_report>
"""

root = ET.fromstring(xml_data)

city = root.find("city")

print("根節點：", root.tag)
print("城市：", city.get("name"))
print("溫度：", city.find("temp").text)
print("天氣：", city.find("status").text)
```

結果：

```
根節點： weather_report
城市： 台北
溫度： 25
天氣： 多雲
```

---

## 6. `.get()` 和 `.text` 特別容易搞混

考試可以這樣判斷：

```
<city name="台北">
    <temp>25</temp>
</city>
```

要拿「台北」：

```
city.get("name")
```

因為 `台北` 在：

```
name="台北"
```

是**屬性**。

要拿 `25`：

```
city.find("temp").text
```

因為 `25` 是：

```
<temp>25</temp>
```

標籤裡面的**文字**。

### 一句話記

```
<city name="台北">
      ↑
      get()

<temp>25</temp>
      ↑
      text
```

---

## 7. `find()` 與 `findall()`

這跟你之前寫牙醫診所 XML 的：

```
for content in root.findall("Data"):
```

是同一個觀念。

如果只有找第一個：

```
root.find("city")
```

如果有很多個：

```
<weather_report>

    <city name="台北">
        <temp>25</temp>
    </city>

    <city name="新竹">
        <temp>27</temp>
    </city>

    <city name="台中">
        <temp>29</temp>
    </city>

</weather_report>
```

就使用：

```
for city in root.findall("city"):
    print(city.get("name"))
    print(city.find("temp").text)
```

結果：

```
台北
25
新竹
27
台中
29
```

所以：

```
find()     → 找一個
findall()  → 找全部，可以搭配 for
```

---

## 8. `fromstring()` 與 `parse()` 也要分清楚

這跟前面的 JSON 很像。

XML 是**字串**：

```
root = ET.fromstring(xml_data)
```

XML 是**檔案**：

```
tree = ET.parse("data.xml")
root = tree.getroot()
```

你之前的牙醫診所就是：

```
tree = ET.parse("dental_clinics.xml")
root = tree.getroot()

for content in root.findall("Data"):
    print("機構名稱:", content.find("機構名稱").text)
```

### 考試濃縮版

```
XML 字串
   ↓
ET.fromstring()
   ↓
root


XML 檔案
   ↓
ET.parse()
   ↓
tree
   ↓
tree.getroot()
   ↓
root
```

最後把 XML 最常考的 6 個記住就夠用了：

```
ET.fromstring()  → 解析 XML 字串
ET.parse()       → 解析 XML 檔案
.getroot()       → 取得根節點

.tag             → 標籤名稱
.get("name")     → 取得屬性
.text            → 取得標籤文字

.find()          → 找一個
.findall()       → 找全部
```

其中最值得先熟的是 **`.get()` 取屬性、`.text` 取文字、`findall()` 搭配 `for` 處理多筆資料**，因為這三個組合起來就能處理你前面做過的牙醫診所 XML。
這一頁其實是在把前面 XML 的觀念組合起來，尤其要看懂 **`find()`、`findall()`、`.get()`、`.text`** 怎麼一起使用。

## 範例一：取得屬性與文字

XML 假設是：

```
<weather_report>
    <city name="台北">
        <temp>25</temp>
        <status>多雲</status>
    </city>
</weather_report>
```

程式：

```
city_node = root.find("city")
city_name = city_node.get("name")
temp = city_node.find("temp").text

print(f"城市：{city_name}, 溫度：{temp} 度")
```

一行一行拆：

```
city_node = root.find("city")
```

從 `root` 底下找 `<city>`：

```
weather_report
      │
      └── city  ← 找到這個
           │
           ├── temp
           └── status
```

接著：

```
city_name = city_node.get("name")
```

因為：

```
<city name="台北">
```

`name` 是**屬性 Attribute**，所以用：

```
.get("name")
```

得到：

```
台北
```

再來：

```
temp = city_node.find("temp").text
```

分兩個動作理解：

```
city_node.find("temp")
```

先找到：

```
<temp>25</temp>
```

再：

```
.text
```

取得裡面的：

```
25
```

所以：

```
city_node.find("temp").text
```

就是：

> 找 `<temp>` → 取得 `<temp>` 裡面的文字。

---

# 範例二：`findall()` 遍歷多筆資料

這個非常重要。

XML：

```
<news_list>

    <item id="1">
        <title>Python 爬蟲入門</title>
        <author>老師</author>
    </item>

    <item id="2">
        <title>AI 時代來臨</title>
        <author>小助手</author>
    </item>

</news_list>
```

結構：

```
news_list
│
├── item  id="1"
│   ├── title → Python 爬蟲入門
│   └── author → 老師
│
└── item  id="2"
    ├── title → AI 時代來臨
    └── author → 小助手
```

因為現在有**很多個 `<item>`**，所以不是：

```
root.find("item")
```

而是：

```
root.findall("item")
```

搭配 `for`：

```
for news in root.findall("item"):
```

意思就是：

```
把所有 <item> 找出來
        ↓
一個一個交給 news
        ↓
      for 迴圈
```

---

## 迴圈裡再取得資料

```
title = news.find("title").text
news_id = news.get("id")

print(f"ID: {news_id} | 標題: {title}")
```

第一輪：

```
<item id="1">
    <title>Python 爬蟲入門</title>
    <author>老師</author>
</item>
```

所以：

```
news.get("id")
```

→ `"1"`

而：

```
news.find("title").text
```

→ `"Python 爬蟲入門"`

第二輪：

```
<item id="2">
```

就得到：

```
2
AI 時代來臨
```

最後輸出：

```
--- 新聞列表 ---

ID: 1 | 標題: Python 爬蟲入門
ID: 2 | 標題: AI 時代來臨
```

這跟你之前寫的：

```
for news in root.findall("item"):
    print(news.tag, "id=", news.get("id"))
    print("title=", news.find("title").text)
    print("author=", news.find("author").text)
```

其實完全是同一題型。

---

# 範例三：讀取 XML 檔案

前面是 XML **字串**：

```
root = ET.fromstring(xml_string)
```

現在如果真的有：

```
data.xml
```

就使用：

```
import xml.etree.ElementTree as ET

tree = ET.parse("data.xml")
root = tree.getroot()

print(root.tag)
```

流程一定要看懂：

```
data.xml
   ↓
ET.parse("data.xml")
   ↓
tree
   ↓
tree.getroot()
   ↓
root
```

所以：

```
tree = ET.parse("data.xml")
```

是解析**整個 XML 檔案**。

```
root = tree.getroot()
```

才是取得 XML 的**根節點**。

---

## ⭐ 考試最重要的判斷方式

看到 XML，不要急著背程式，先問自己「我要拿的東西在哪裡？」

```
<item id="1">
    <title>Python 爬蟲入門</title>
</item>
```

如果老師問 **id**：

```
news.get("id")
```

因為：

```
id="1"
↑
屬性 → get()
```

如果老師問 **title**：

```
news.find("title").text
```

因為：

```
<title>Python 爬蟲入門</title>
       ↑
      文字 → .text
```

如果老師問 **所有 item**：

```
root.findall("item")
```

因為有很多筆，所以 `findall()` + `for`。

### 最後背這個就很好用了

```
XML 字串 → ET.fromstring()

XML 檔案 → ET.parse()
              ↓
          getroot()

找一個   → find()
找很多   → findall() + for

取屬性   → get("屬性名稱")
取文字   → .text
取標籤名 → .tag
```

你現在 XML 這一章的核心其實就是這幾個。後面如果出「牙醫診所有很多個 `<Data>`，列出每一家機構名稱、地址、電話」，本質上也是 **`findall()` + `for` + `find().text`**。

這兩題是在考 XML 最核心的兩種題型：**單筆資料用 `find()`，多筆資料用 `findall()` + `for`**。

## 任務一：簡單解析

題目：

```
xml_str = '<user><name>John</name><age>20</age></user>'
```

要求印出：

```
John is 20 years old
```

答案：

```
import xml.etree.ElementTree as ET

xml_str = '<user><name>John</name><age>20</age></user>'

root = ET.fromstring(xml_str)

name = root.find("name").text
age = root.find("age").text

print(f"{name} is {age} years old")
```

### 執行流程

XML 結構是：

```
user               ← root
│
├── name
│    └── John
│
└── age
     └── 20
```

所以：

```
root.find("name")
```

找到：

```
<name>John</name>
```

加上：

```
.text
```

才真正取得：

```
John
```

因此：

```
root.find("name").text
```

可以理解成：

> 從 `root` 找到 `name` → 取得裡面的文字。

---

# 任務二：多筆資料提取

題目要求建立 XML：

> 根節點是 `class`，裡面有兩個 `student`，每個學生都有 `name` 標籤與 `score` 屬性，再用 `for` 迴圈印出每位學生姓名與分數。

可以建立：

```
<class>
    <student score="90">
        <name>Alice</name>
    </student>

    <student score="85">
        <name>Bob</name>
    </student>
</class>
```

完整 Python：

```
import xml.etree.ElementTree as ET

xml_str = """
<class>
    <student score="90">
        <name>Alice</name>
    </student>

    <student score="85">
        <name>Bob</name>
    </student>
</class>
"""

root = ET.fromstring(xml_str)

for student in root.findall("student"):
    name = student.find("name").text
    score = student.get("score")

    print("姓名：", name)
    print("分數：", score)
```

輸出：

```
姓名： Alice
分數： 90
姓名： Bob
分數： 85
```

## 為什麼一個用 `.text`，一個用 `.get()`？

這是這題**最重要的考點**。

看 Alice：

```
<name>Alice</name>
```

`Alice` 是標籤裡面的**文字**，所以：

```
student.find("name").text
```

但是分數：

```
<student score="90">
```

`score="90"` 是 `student` 的**屬性**，所以：

```
student.get("score")
```

可以這樣記：

```
<student score="90">
         ↑
       屬性
   .get("score")


<name>Alice</name>
      ↑
     文字
    .text
```

## 再注意 `find()` 和 `findall()`

任務一只有一個：

```
<name>John</name>
```

所以：

```
root.find("name")
```

任務二有很多：

```
<student>...</student>
<student>...</student>
```

所以：

```
for student in root.findall("student"):
```

考試看到「**每一位、所有、多筆、逐筆**」這類字眼，通常就要想到：

```
for ... in root.findall(...):
```

這兩題濃縮起來就是：

```
XML 字串 → ET.fromstring()

找單筆 → find()
找多筆 → findall() + for

標籤文字 → .text
屬性資料 → .get()
```

這四個觀念掌握後，這類 XML 實作題基本上就能處理。
## CH2-4--
這兩題是在考 **例外處理 `try / except`**。第一題是「讀 JSON 時可能找不到檔案」，第二題是「除法時可能除以 0」。

## 第 1 題：安全讀取 JSON

題目要求建立：

```
safe_load_json(file_path)
```

三種情況：

1. 檔案正常 → 回傳解析後資料
2. 檔案不存在 → 印出「請確認檔案路徑」並回傳 `None`
3. JSON 格式錯誤 → 印出「檔案內容損壞」並回傳 `None`

答案：

```
import json

def safe_load_json(file_path):
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            data = json.load(f)
            return data

    except FileNotFoundError:
        print("請確認檔案路徑")
        return None

    except json.JSONDecodeError:
        print("檔案內容損壞")
        return None
```

例如：

```
data = safe_load_json("data.json")

print(data)
```

### 第一個錯誤：`FileNotFoundError`

這行：

```
open(file_path, "r")
```

如果檔案不存在：

```
data.json 找不到
        ↓
FileNotFoundError
        ↓
except FileNotFoundError
```

所以：

```
except FileNotFoundError:
    print("請確認檔案路徑")
    return None
```

---

### 第二個錯誤：`JSONDecodeError`

假設檔案存在，但是內容寫錯：

```
{"name": "Tom", "age": }
```

檔案找得到，所以 `open()` 沒問題。

但是：

```
json.load(f)
```

解析失敗，就會產生：

```
json.JSONDecodeError
```

因此：

```
except json.JSONDecodeError:
    print("檔案內容損壞")
    return None
```

### ⭐ 這題的判斷方式

```
open() 找不到檔案
       ↓
FileNotFoundError


json.load() 看不懂 JSON
       ↓
json.JSONDecodeError
```

---

# 第 2 題：批次除法器

題目：

```
nums = [10, 2, 0, 5]
```

要計算：

```
100 / 10
100 / 2
100 / 0
100 / 5
```

其中：

```
100 / 0
```

會產生：

```
ZeroDivisionError
```

題目要求遇到 `0` 時：

> 印出「不可除以零，跳過此筆」

但是**不能讓整個迴圈停止**。

答案：

```
nums = [10, 2, 0, 5]

for x in nums:
    try:
        result = 100 / x
        print(result)

    except ZeroDivisionError:
        print("不可除以零，跳過此筆")
```

輸出：

```
10.0
50.0
不可除以零，跳過此筆
20.0
```

## 為什麼遇到錯誤還能繼續？

因為 `try / except` 放在 `for` **裡面**：

```
for x in nums:
    try:
        ...
    except:
        ...
```

可以想成每一輪都有自己的保護：

```
x = 10
100 / 10 → 10.0
      ↓
下一輪

x = 2
100 / 2 → 50.0
      ↓
下一輪

x = 0
100 / 0 → 發生錯誤
      ↓
except ZeroDivisionError
      ↓
不可除以零，跳過此筆
      ↓
下一輪 ← ★ 程式沒有停止

x = 5
100 / 5 → 20.0
```

---

## ⭐ 這兩題真正要考的觀念

```
try:
    # 可能發生錯誤的程式

except 某種錯誤:
    # 發生這種錯誤時怎麼處理
```

這三個例外名稱建議直接背：

|情況|例外|
|---|---|
|找不到檔案|`FileNotFoundError`|
|JSON 格式錯誤|`json.JSONDecodeError`|
|除以 0|`ZeroDivisionError`|

尤其第一題不要混淆：

```
json.load(f)
```

是因為現在處理的是 **JSON 檔案**；如果題目給的是 JSON **字串**，才會使用：

```
json.loads(json_string)
```

所以這題其實把前面學的 JSON 和現在的例外處理結合在一起了。


## CH2--


這兩題是前面內容的綜合題。第一題把 **JSON + CSV** 串起來；第二題把 **CSV + 函式 + try/except** 串起來。

## 任務一：JSON 轉 CSV

題目給：

```
json_data = '[{"name": "小明", "score": 85},
              {"name": "小華", "score": 92},
              {"name": "小美", "score": 78}]'
```

注意：最外面有引號，所以 `json_data` 是 **JSON 字串**，不是 Python List。

完整答案：

```
import json
import csv

json_data = '''[
    {"name": "小明", "score": 85},
    {"name": "小華", "score": 92},
    {"name": "小美", "score": 78}
]'''

# JSON 字串 → Python List
data = json.loads(json_data)

# 寫入 CSV
with open("students.csv", "w",
          encoding="utf-8-sig", newline="") as f:

    fieldnames = ["name", "score"]

    writer = csv.DictWriter(f, fieldnames=fieldnames)

    writer.writeheader()
    writer.writerows(data)
```

產生的 `students.csv`：

```
name,score
小明,85
小華,92
小美,78
```

這題的流程一定要看懂：

```
JSON 字串
   ↓
json.loads()
   ↓
Python List of Dicts
   ↓
csv.DictWriter()
   ↓
writeheader()
   ↓
writerows()
   ↓
students.csv
```

為什麼使用：

```
json.loads(json_data)
```

因為 `json_data` 是**字串**。

為什麼使用：

```
writer.writerows(data)
```

因為 `data` 裡面有**多筆 dictionary**。

---

# 任務二：安全檔案讀取器

題目要求建立：

```
smart_reader(file_path)
```

規則是：

> CSV 存在 → 讀取全部資料  
> 不存在 → 印「找不到檔案」並回傳空串列  
> 其他讀取錯誤 → 印「檔案讀取失敗」並回傳空串列  
> 成功 → 印出 Row count

完整答案：

```
import csv

def smart_reader(file_path):
    try:
        with open(file_path, "r",
                  encoding="utf-8-sig") as f:

            reader = csv.DictReader(f)
            data = list(reader)

            print("Row count:", len(data))

            return data

    except FileNotFoundError:
        print("找不到檔案")
        return []

    except Exception:
        print("檔案讀取失敗")
        return []
```

呼叫：

```
result = smart_reader("students.csv")

print(result)
```

成功的話：

```
Row count: 3

[
 {'name': '小明', 'score': '85'},
 {'name': '小華', 'score': '92'},
 {'name': '小美', 'score': '78'}
]
```

---

## 為什麼要 `list(reader)`？

這一行很值得理解：

```
reader = csv.DictReader(f)
```

`reader` 是一個可以逐筆讀取的物件。

通常我們之前寫：

```
for row in reader:
    print(row)
```

但這一題需要：

1. 回傳所有資料
2. 計算總共有幾列

所以可以：

```
data = list(reader)
```

把所有資料轉成 List：

```
[
    {"name": "小明", "score": "85"},
    {"name": "小華", "score": "92"},
    {"name": "小美", "score": "78"}
]
```

接著就可以：

```
len(data)
```

得到：

```
3
```

因此：

```
print("Row count:", len(data))
```

---

## `return []` 是什麼意思？

題目要求失敗時「回傳空串列」。

所以：

```
except FileNotFoundError:
    print("找不到檔案")
    return []
```

這裡：

```
[]
```

就是一個沒有任何元素的 List。

例如：

```
result = smart_reader("不存在.csv")
```

結果：

```
找不到檔案
```

而：

```
print(result)
```

就是：

```
[]
```

---

## 為什麼兩個 `except` 有順序？

這個地方也是例外處理常考點：

```
except FileNotFoundError:
    print("找不到檔案")

except Exception:
    print("檔案讀取失敗")
```

`Exception` 的範圍很大，可以處理很多一般例外。

所以應該：

```
先寫具體錯誤
       ↓
FileNotFoundError

再寫一般錯誤
       ↓
Exception
```

記成：

```
小範圍 → 前面
大範圍 → 後面
```

---

### 這兩題的考試濃縮版

```
任務一：

JSON 字串
 ↓
json.loads()
 ↓
List of Dicts
 ↓
csv.DictWriter
 ↓
writeheader()
writerows()
 ↓
CSV


任務二：

smart_reader()
 ↓
try
 ↓
open CSV
 ↓
csv.DictReader
 ↓
list(reader)
 ↓
len(data) → Row count
 ↓
return data

錯誤：
FileNotFoundError → 找不到檔案 → return []
Exception         → 檔案讀取失敗 → return []
```

另外要注意一個前面也出現過的考點：**CSV 讀回來的 `score` 是字串**，所以你看到 `'85'` 而不是 `85` 是正常的。如果之後要計算平均：

```
total += int(row["score"])
```

就需要再轉成 `int`。