# Python 第 9 章：檔案與例外處理重點

> 整理範圍：路徑判斷、建立資料夾、開啟檔案、讀寫與附加、檔案指標、例外處理。

## 1. 路徑與檔案判斷

使用 `os.path` 可以判斷路徑、資料夾或檔案是否存在。

```python
import os

path = "c:/data/"
file = "c:/Windows/system.ini"

print(os.path.exists(path))   # 路徑是否存在
print(os.path.isdir(path))    # 是否為資料夾
print(os.path.isfile(file))   # 是否為檔案
```

| 函式 | 功能 |
| --- | --- |
| `os.path.exists(path)` | 判斷路徑是否存在 |
| `os.path.isdir(path)` | 判斷路徑是否為資料夾 |
| `os.path.isfile(path)` | 判斷路徑是否為檔案 |

### `exists()` 與 `isdir()`、`isfile()` 的差別

```python
import os

path = "c:/data/"
file_name = "c:/Windows/system.ini"

if os.path.exists(path):
    print("路徑存在")

if os.path.isdir(path):
    print("這是一個資料夾")

if os.path.isfile(file_name):
    print("這是一個檔案")
```

- `exists()` 只判斷路徑是否存在，無法分辨它是檔案還是資料夾。
- `isdir()` 專門確認資料夾。
- `isfile()` 專門確認一般檔案。
- 課堂的 `ch9-2-path02.py` 使用 `exists()` 後直接顯示「資料夾／檔案」；實務上若要確認類型，應使用 `isdir()` 或 `isfile()`。

### Windows 路徑寫法

```python
"c:/data/file01.txt"       # 推薦，簡單清楚
"c:\\data\\file01.txt"    # 反斜線必須寫成 \\
r"c:\data\file01.txt"     # 原始字串
```

## 2. 建立資料夾

```python
import os

path = "c:/data/"
if not os.path.exists(path):
    os.makedirs(path)
```

| 函式 | 說明 |
| --- | --- |
| `os.mkdir(path)` | 建立一層資料夾；上層路徑必須已存在 |
| `os.makedirs(path)` | 可一次建立多層資料夾 |

### 存在時不重複建立

```python
import os

path = "c:/data/"

if os.path.exists(path):
    print(f"{path} 路徑已存在，不必再建立")
else:
    os.mkdir(path)
    print(f"{path} 路徑已建立")
```

也可以使用 `exist_ok=True` 簡化：

```python
os.makedirs("c:/data/", exist_ok=True)
```

## 3. 刪除資料夾

### `os.rmdir()`：刪除空資料夾

```python
import os

path = "c:/data/"

if os.path.exists(path):
    os.rmdir(path)
    print(f"{path} 路徑已刪除")
```

`os.rmdir()` 只能刪除空資料夾；資料夾內有檔案或子資料夾時會發生 `OSError`。

### `shutil.rmtree()`：刪除整個資料夾樹

```python
import shutil

shutil.rmtree("c:/test/")
```

> `shutil.rmtree()` 會連同資料夾內的所有檔案與子資料夾一起刪除，通常無法從資源回收筒復原。執行前必須再次確認路徑。

## 4. 目前工作目錄與系統指令

### `os.getcwd()`

```python
import os

print(os.getcwd())
```

`os.getcwd()` 會回傳程式目前的工作目錄。相對路徑會以此目錄為起點。

### `os.system()`

```python
import os

os.system("cls")
os.system("mkdir dir2")
os.system(r"copy ossystem.py dir2\copyfile.py")
```

在 Windows 中：

| 指令 | 功能 |
| --- | --- |
| `cls` | 清除命令提示字元畫面 |
| `mkdir dir2` | 建立 `dir2` 資料夾 |
| `copy 來源 目的` | 複製檔案 |

注意事項：

- `os.system()` 交由作業系統命令列執行，因此不同作業系統的指令不一定相同。
- 指令含有外部輸入時可能產生命令注入風險，不可直接拼接不可信任的字串。
- 一般檔案操作優先使用 Python 函式，例如 `os.makedirs()`、`shutil.copy()`，較容易跨平台。

```python
import shutil

shutil.copy("ossystem.py", "dir2/copyfile.py")
```

## 5. 使用 `open()` 開啟檔案

基本語法：

```python
檔案物件 = open("檔案路徑", "模式", encoding="utf-8")
```

### 常用檔案模式

| 模式 | 功能 | 檔案不存在 | 檔案已存在 |
| --- | --- | --- | --- |
| `r` | 唯讀 | 發生錯誤 | 從頭讀取 |
| `w` | 寫入 | 建立檔案 | **清空原內容後寫入** |
| `a` | 附加 | 建立檔案 | 從檔尾加入內容 |
| `r+` | 讀寫 | 發生錯誤 | 不會自動清空 |
| `w+` | 讀寫 | 建立檔案 | 清空原內容 |
| `a+` | 附加與讀取 | 建立檔案 | 寫入位置固定在檔尾 |

> 中文文字檔建議固定加入 `encoding="utf-8"`，避免 Windows 預設編碼造成 `UnicodeDecodeError`。

## 6. 寫入檔案

### `w` 模式

```python
with open("c:/data/stu.txt", "w", encoding="utf-8") as file:
    file.write("王一心,85,90\n")
    file.write("陳二心,75,80\n")
    file.write("林三心,65,70\n")
```

- `write()` 寫入字串，並回傳寫入的字元數。
- `\n` 表示換行。
- 每次以 `w` 模式開啟，都會先清除舊內容。

### `a` 模式

```python
with open("c:/data/stu.txt", "a", encoding="utf-8") as file:
    file.write("趙七海,85,90\n")
    file.write("陳九東,75,80\n")
```

`a` 不會刪除舊資料，而是在檔案最後面繼續加入。

## 7. 關閉檔案與 `with`

傳統寫法需要自己關閉：

```python
file = open("c:/data/stu.txt", "r", encoding="utf-8")
content = file.read()
file.close()
```

推薦使用 `with`：

```python
with open("c:/data/stu.txt", "r", encoding="utf-8") as file:
    content = file.read()
```

離開 `with` 區塊後，Python 會自動關閉檔案；即使發生例外也能正確處理。

### 建立空白檔案後關閉

```python
file = open("c:/data/file02.txt", "w", encoding="utf-8")
file.close()
```

以 `w` 模式開啟不存在的檔案時會建立檔案；即使沒有呼叫 `write()`，關閉後仍會留下空白檔案。如果檔案原本已存在，內容會被清空。

### 檢查是否已關閉

```python
file = open("c:/data/file02.txt", "w", encoding="utf-8")
print(file.closed)  # False
file.close()
print(file.closed)  # True
```

推薦版本：

```python
with open("c:/data/file02.txt", "r", encoding="utf-8") as file:
    print(file.read())

print(file.closed)  # True
```

### `flush()`

```python
file.flush()
```

`flush()` 會立刻把緩衝區中的資料送去寫入檔案，但不會關閉檔案。正常執行 `close()` 或離開 `with` 時，也會自動完成寫入。

## 8. 讀取檔案

### `read()`：讀取全部或指定字元數

```python
with open("c:/data/stu.txt", "r", encoding="utf-8") as file:
    first = file.read(7)  # 從目前位置讀取 7 個字元
    rest = file.read()    # 從目前位置讀到檔尾
```

### `readline()`：讀取一行

```python
line = file.readline()
```

`readline(7)` 最多讀取 7 個字元；若先遇到換行，會提早停止。

### `readlines()`：一次讀取所有行

```python
lines = file.readlines()
print(lines)  # 每一行成為串列中的一個字串
```

例如：

```python
["王一心,85,90\n", "陳二心,75,80\n"]
```

### 逐行讀取

```python
with open("c:/data/stu.txt", "r", encoding="utf-8") as file:
    for line in file:
        print(line.strip())
```

`strip()` 會移除字串頭尾的空白與換行符號。

> 呼叫 `read()`、`readline()` 或 `readlines()` 後，檔案指標會向後移動。若 `readlines()` 已讀到檔尾，接著再呼叫 `readline()` 通常會得到空字串 `""`。

## 9. 檔案指標與 `seek()`

檔案物件會記錄目前讀寫位置，稱為「檔案指標」。

```python
with open("c:/data/stu.txt", "r", encoding="utf-8") as file:
    file.seek(0)       # 回到檔案開頭
    line = file.readline()
    print(line)
```

| 方法 | 功能 |
| --- | --- |
| `file.seek(0)` | 將指標移回檔案開頭 |
| `file.tell()` | 取得目前指標位置 |

注意事項：

- `seek()` 的位置是依底層資料位置計算，不宜把中文字簡單視為固定 1 個位元組。
- 文字模式最安全、最常見的做法是使用 `seek(0)` 回到開頭。
- 在 `a` 或 `a+` 模式中，即使移動指標，新的寫入內容仍會加在檔尾。
- 若要精確依位元組移動，應改用二進位模式，例如 `rb`、`wb`。

## 10. 例外處理 `try-except`

例外處理可以避免程式遇到錯誤時直接中止。

```python
try:
    result = 8 / 0
except ZeroDivisionError:
    print("除法錯誤：除數不能為零")
```

### 捕捉錯誤訊息

```python
try:
    result = 8 / 0
except Exception as error:
    print("發生錯誤：", error)
```

- `Exception` 可捕捉多數一般執行錯誤。
- `as error` 將錯誤物件存入變數，方便顯示原因。
- 已知錯誤類型時，優先捕捉具體例外，較容易找出問題。

## 11. 多組 `except`

```python
numbers = [0 for x in range(5)]

try:
    numbers[9] = 90
except ZeroDivisionError:
    print("除數不能為零")
except IndexError:
    print("串列索引超出範圍")
except Exception as error:
    print("其他錯誤：", error)
```

常見例外：

| 例外類型 | 發生原因 |
| --- | --- |
| `ZeroDivisionError` | 除數為 0 |
| `IndexError` | 串列索引超出範圍 |
| `FileNotFoundError` | 要讀取的檔案不存在 |
| `ValueError` | 資料內容或轉換值不合法 |
| `TypeError` | 資料型別不符合運算需求 |
| `UnicodeDecodeError` | 使用錯誤的文字編碼讀檔 |

例外判斷順序應從「具體」到「一般」：

```python
except IndexError:
    ...
except Exception as error:
    ...
```

如果先寫 `except Exception`，後面較具體的例外通常無法發揮作用。

## 12. `finally`：一定會執行

```python
try:
    result = 8 / 0
except ZeroDivisionError:
    print("除數不能為零")
finally:
    print("運算結束")
```

無論是否發生例外，`finally` 都會執行，常用於：

- 關閉檔案
- 關閉資料庫連線
- 釋放系統資源
- 顯示程式結束訊息

## 13. 完整安全讀檔範例

```python
file_name = "c:/data/stu.txt"

try:
    with open(file_name, "r", encoding="utf-8") as file:
        for line in file:
            print(line.strip())
except FileNotFoundError:
    print(f"找不到檔案：{file_name}")
except UnicodeDecodeError:
    print("檔案編碼不是 UTF-8")
except OSError as error:
    print("檔案處理失敗：", error)
```

## 14. 課堂範例易錯重點

1. `open(file, "w")` 會清空原檔，不適合用來保留舊資料。
2. 使用中文時，讀檔與寫檔的 `encoding` 必須一致。
3. `readlines()` 讀完後，指標通常已在檔尾；要重讀需先 `seek(0)`。
4. `a+` 可以讀取與附加，但寫入內容永遠放在檔尾。
5. 開啟檔案後必須關閉，建議一律使用 `with open(...)`。
6. `except Exception` 應放在所有具體例外的最後面。
7. `finally` 不論成功或失敗都會執行。
8. `exists()` 只能判斷存在與否；確認類型要使用 `isdir()` 或 `isfile()`。
9. `os.rmdir()` 只能刪除空資料夾；`shutil.rmtree()` 會遞迴刪除全部內容。
10. `open(file, "w")` 即使沒有寫入，也可能建立空檔或清空原檔。
11. `os.getcwd()` 顯示目前工作目錄，也是相對路徑的起點。

## 15. 考試速記

```text
r  = read，讀取；檔案必須存在
w  = write，寫入；舊內容會被清空
a  = append，附加；資料寫在檔尾
+  = 同時允許讀取與寫入

read(n)     讀取最多 n 個字元
readline()  讀取一行
readlines() 讀取全部行，回傳串列
seek(0)     回到檔案開頭
strip()     去除頭尾空白與換行

exists()    判斷路徑是否存在
isdir()     判斷是否為資料夾
isfile()    判斷是否為檔案
getcwd()    取得目前工作目錄
mkdir()     建立一層資料夾
rmdir()     刪除空資料夾
rmtree()    刪除資料夾及其全部內容

try         放可能出錯的程式
except      處理指定錯誤
finally     不論有無錯誤都會執行
```

## 16. 本章來源檔案

- `ch9-2-path01.py`：判斷資料夾與檔案
- `ch9-2-path02.py`：使用 `exists()` 判斷路徑是否存在
- `ch9-2-path03.py`：路徑不存在時使用 `mkdir()` 建立資料夾
- `ch9-2-path04.py`：使用 `rmdir()` 刪除空資料夾
- `ch9-2-path05.py`：取得工作目錄、`shutil` 與 `os.system()`
- `ch9-3-open01.py`：建立資料夾與開啟檔案
- `ch9-3-cloase01.py`：建立空白檔案並以 `close()` 關閉
- `ch9-3-cloe01.py`：Windows 路徑、`close()` 與 `with open()`
- `ch9-4-write01.py`：覆寫檔案
- `ch9-4-append01.py`：附加內容
- `ch9-4-read01.py`：使用 `read()`
- `ch9-4-read02.py`：使用 `readlines()`、`readline()`
- `ch9-4-read03.py`：逐行輸出與 `strip()`
- `ch9-4-seek01.py`：移動檔案指標
- `ch9-5-try01.py`：捕捉除以零錯誤
- `ch9-5-try02.py`：`Exception` 與 `finally`
- `ch9-5-try03.py`：多組 `except` 與索引錯誤
