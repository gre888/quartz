
# Python 第 7 章：常用函式、模組與函式設計重點筆記

> 整理自原有 19 個與新增 17 個課堂 Python 範例，共 36 個範例。內容涵蓋數值轉換、進位表示、數學運算、字元編碼、日期時間、函式、亂數、參數傳遞、變數範圍與階乘。

## 一、內建數值函式

### 1. `abs()`：求絕對值

絕對值會移除正負號，結果一定是 0 或正數。

```python
temp_a = 15
temp_b = -3

temp_diff = abs(temp_a - temp_b)
print(f"兩地溫差為 {temp_diff} 度")
```

輸出：

```text
兩地溫差為 18 度
```

重點：

- `abs()` 是 Python 內建函式，不需要 `import math`。
- 可處理整數、浮點數，也可用於計算兩個數值的差距。

---

### 2. `int()`：轉換成整數

```python
exact_age = 25.85
age = int(exact_age)
print(f"使用者今年滿 {age} 歲")
```

輸出：

```text
使用者今年滿 25 歲
```

注意：`int()` 是直接去掉小數部分，並不是四捨五入。

```python
print(int(3.9))    # 3
print(int(-3.9))   # -3，朝 0 的方向截斷
```

---

### 3. `float()`：轉換成浮點數

表單輸入或 `input()` 取得的資料通常是字串，運算前要先轉成數值。

```python
price_input = "199"
discount = 0.85
final_price = float(price_input) * discount
print(f"折扣後的價格為 {final_price}")
```

輸出：

```text
折扣後的價格為 169.15
```

注意：課堂檔名 `ch7-2-flow.py` 應是在示範 `float()`。

---

### 4. `divmod()`：同時計算商與餘數

語法：

```python
商, 餘數 = divmod(被除數, 除數)
```

等同於：

```python
商 = 被除數 // 除數
餘數 = 被除數 % 除數
```

範例一：秒數換算成分鐘和秒

```python
total_seconds = 385
minutes, seconds = divmod(total_seconds, 60)
print(f"{minutes} 分 {seconds} 秒")
```

輸出：`6 分 25 秒`

範例二：平均分配班費

```python
money = 6359
person = 28
div, mod = divmod(money, person)
print(f"每人分到 {div} 元，剩餘 {mod} 元")
```

輸出：`每人分到 227 元，剩餘 3 元`

---

### 5. `pow()`：次方運算

```python
principal = 10000
rate = 1.05
years = 3
total = principal * pow(rate, years)
print(f"3 年後本利和 {round(total)}")
```

`pow(rate, years)` 等同於 `rate ** years`。

```python
pow(2, 3)  # 8
2 ** 3     # 8
```

---

### 6. `round()`：數值取近似值

語法：

```python
round(數值)          # 取到整數
round(數值, 位數)    # 保留指定的小數位數
```

Python 採用「取最接近值；正好在中間時取偶數」的規則，常稱為銀行家捨入法：

```python
scores = [12.5, 11.5, 13.5, 14.5, 14.51]
print([round(score) for score in scores])
# [12, 12, 14, 14, 15]
```

保留小數位數：

```python
print(round(12.367, 2))  # 12.37
print(round(12.364, 2))  # 12.36
```

重要提醒：電腦使用二進位浮點數，某些十進位小數無法被精確儲存，因此 `round(2.675, 2)` 等結果可能和直覺不同。金融金額若要求精確的十進位捨入，可使用 `decimal.Decimal`。

## 二、進位表示函式

### 1. `hex()`：轉成十六進位字串

```python
print(hex(254))  # '0xfe'
```

- 結果型別是 `str`。
- 前綴 `0x` 表示十六進位。
- `[2:]` 可以取出前綴之後的內容。

RGB 色碼範例：

```python
r, g, b = 255, 165, 0
hex_color = f"#{r:02x}{g:02x}{b:02x}"
print(hex_color)
```

輸出：`#ffa500`

使用 `:02x` 的好處是每個色彩值固定占兩位，不足時自動補 `0`。

---

### 2. `oct()`：轉成八進位字串

```python
chmod_val = 493
print(oct(chmod_val))
```

輸出：`0o755`

- 前綴 `0o` 表示八進位。
- Unix/Linux 檔案權限常使用八進位，例如 `755` 對應 `rwxr-xr-x`。

## 三、`math` 數學模組

使用前要先匯入：

```python
import math
```

### 1. `math.fabs()` 與 `abs()`

```python
import math

val = -15
print(math.fabs(val))  # 15.0
print(abs(val))        # 15
```

| 函式 | 是否要匯入 `math` | 常見回傳結果 |
| --- | --- | --- |
| `abs(x)` | 否 | 保留適當的數值型別 |
| `math.fabs(x)` | 是 | 浮點數 `float` |

一般用途使用 `abs()` 即可。

---

### 2. `math.ceil()` 與 `math.floor()`

| 函式 | 功能 | 範例結果 |
| --- | --- | --- |
| `math.ceil(x)` | 無條件向上取整數 | `ceil(2.3)` → `3` |
| `math.floor(x)` | 無條件向下取整數 | `floor(2.9)` → `2` |

```python
import math

items = 23
capacity_per_box = 10
boxes_needed = math.ceil(items / capacity_per_box)
print(f"需要 {boxes_needed} 個箱子")  # 3

rent_hours = 50
days = math.floor(rent_hours / 24)
print(f"滿天數 {days}")              # 2
```

注意負數：

```python
math.ceil(-2.7)   # -2
math.floor(-2.7)  # -3
```

---

### 3. `math.pi`、`math.sqrt()`

圓面積：

```python
radius = 5.0
circle_area = math.pi * radius ** 2
print(f"圓面積是 {circle_area:.2f}")
```

輸出：`圓面積是 78.54`

直角三角形斜邊：

```python
a, b = 3.0, 4.0
c = math.sqrt(a ** 2 + b ** 2)
print(c)  # 5.0
```

- `math.pi`：圓周率 π。
- `math.sqrt(x)`：求平方根，也可寫成 `x ** 0.5`。

---

### 4. 對數與指數：`math.log()`、`math.exp()`

計算 1000 種狀態至少需要多少位元：

```python
states = 1000
bits_needed = math.ceil(math.log(states, 2))
print(bits_needed)  # 10
```

因為 $2^9=512$ 不足，而 $2^{10}=1024$ 才能容納 1000 種狀態。

常見對數寫法：

```python
math.log(x)       # 自然對數，底數為 e
math.log(x, 2)    # 以 2 為底
math.log10(x)     # 以 10 為底
```

連續複利公式：

$$A=Pe^{rt}$$

```python
principal = 1000
rate = 0.05
years = 3
amount = principal * math.exp(rate * years)
print(f"連續複利後的總金額 = {amount:.2f}")
```

- `math.e`：自然常數 e。
- `math.exp(x)`：計算 $e^x$。

---

### 5. 三角函數與角度轉換

Python 的三角函數使用「弧度」，不是角度。

```python
angle_degrees = 30
hypotenuse = 10.0
radians = math.radians(angle_degrees)
height = hypotenuse * math.sin(radians)
print(f"高度 {height:.2f}")  # 5.00
```

反正切：

```python
tan_value = 1.0
rad_result = math.atan(tan_value)
deg_result = math.degrees(rad_result)
print(f"弧度 {rad_result:.2f}，角度 {deg_result:.2f}")
```

輸出：`弧度 0.79，角度 45.00`

建議使用：

```python
math.radians(角度)  # 角度轉弧度
math.degrees(弧度)  # 弧度轉角度
```

## 四、字元與 Unicode 編碼

### 1. `ord()`：字元轉成 Unicode 編碼

```python
print(ord("A"))   # 65
print(ord("a"))   # 97
print(ord("0"))   # 48
print(ord("台"))  # 21488
print(ord("😊"))  # 128522
```

`ord()` 的參數必須是「一個字元」。

---

### 2. `chr()`：Unicode 編碼轉成字元

```python
print(chr(65))      # A
print(chr(97))      # a
print(chr(48))      # 0
print(chr(21488))   # 台
print(chr(128522))  # 😊
```

建立 A～Z：

```python
alphabet = [chr(i) for i in range(65, 91)]
print(alphabet)
```

字母位移：

```python
char = "C"
shift = 3
new_char = chr(ord(char) + shift)
print(f"{char} 向後推 {shift} 位是 {new_char}")  # F
```

記憶方式：

- `ord("A")`：字元 → 整數編碼。
- `chr(65)`：整數編碼 → 字元。
- 兩者互為相反操作。

## 五、日期與時間 `datetime`

課堂範例使用別名匯入：

```python
import datetime as DT
```

### 1. 取得目前日期與時間

```python
import datetime as DT

t1 = DT.datetime.now()
print(t1)
print(f"現在日期：{t1.year} 年 {t1.month} 月 {t1.day} 日")
print(f"目前時間：{t1.hour} 時 {t1.minute} 分 {t1.second} 秒")
```

常用屬性：`year`、`month`、`day`、`hour`、`minute`、`second`。

---

### 2. 建立指定日期

```python
set_time = DT.datetime(1969, 7, 20)
print(set_time)
```

輸出：

```text
1969-07-20 00:00:00
```

沒有指定時間時，時、分、秒預設為 0。

完整語法可寫成：

```python
DT.datetime(年, 月, 日, 時, 分, 秒)
```

---

### 3. 日期時間格式化

三種常見寫法：

```python
now_time = DT.datetime.now()

print("{:%Y/%b/%d %A}".format(now_time))
print(f"{now_time:%Y/%b/%d %A}")
print(now_time.strftime("%Y/%b/%d %A"))
```

常用格式代碼：

| 代碼 | 意義 | 範例 |
| --- | --- | --- |
| `%Y` | 四位數年份 | `2026` |
| `%m` | 兩位數月份 | `08` |
| `%d` | 兩位數日期 | `30` |
| `%H` | 24 小時制小時 | `19` |
| `%M` | 分鐘 | `05` |
| `%S` | 秒 | `09` |
| `%b` | 月份縮寫 | `Aug` |
| `%A` | 星期完整名稱 | `Sunday` |

若要固定顯示純數字日期，建議：

```python
print(now_time.strftime("%Y/%m/%d %H:%M:%S"))
```

## 六、函式快速比較表

| 函式或屬性 | 用途 | 範例 |
| --- | --- | --- |
| `abs(x)` | 絕對值 | `abs(-3)` → `3` |
| `int(x)` | 轉整數、截去小數 | `int(3.9)` → `3` |
| `float(x)` | 轉浮點數 | `float("1.5")` → `1.5` |
| `divmod(a, b)` | 同時求商與餘數 | `divmod(7, 3)` → `(2, 1)` |
| `pow(a, b)` | a 的 b 次方 | `pow(2, 3)` → `8` |
| `round(x, n)` | 取近似值 | `round(3.14159, 2)` → `3.14` |
| `hex(x)` | 轉十六進位字串 | `hex(254)` → `'0xfe'` |
| `oct(x)` | 轉八進位字串 | `oct(493)` → `'0o755'` |
| `math.fabs(x)` | 浮點數絕對值 | `fabs(-3)` → `3.0` |
| `math.ceil(x)` | 無條件向上取整 | `ceil(2.1)` → `3` |
| `math.floor(x)` | 無條件向下取整 | `floor(2.9)` → `2` |
| `math.sqrt(x)` | 平方根 | `sqrt(25)` → `5.0` |
| `math.log(x, base)` | 對數 | `log(8, 2)` → `3.0` |
| `math.exp(x)` | e 的 x 次方 | `exp(1)` → `e` |
| `math.sin(x)` | 正弦，x 使用弧度 | `sin(pi/2)` → `1.0` |
| `math.atan(x)` | 反正切，結果為弧度 | `atan(1)` → 約 `0.785` |
| `ord(c)` | 字元轉 Unicode 編碼 | `ord("A")` → `65` |
| `chr(i)` | Unicode 編碼轉字元 | `chr(65)` → `'A'` |
| `datetime.now()` | 目前日期時間 | 回傳 `datetime` 物件 |
| `strftime()` | 格式化日期時間 | `"%Y/%m/%d"` |

## 七、考試與實作必記

1. `int(3.9)` 是 `3`，不是 `4`；要取近似值才使用 `round()`。
2. `abs()` 不用匯入模組；`math.fabs()` 必須先 `import math`。
3. `ceil()` 是向上、`floor()` 是向下，遇到負數時要特別小心。
4. `divmod(a, b)` 回傳 `(商, 餘數)`，可用兩個變數直接接收。
5. `hex()` 和 `oct()` 回傳的是字串，分別帶有 `0x` 和 `0o` 前綴。
6. `ord()` 與 `chr()` 互為反向轉換。
7. `range(65, 91)` 不包含 91，因此剛好可產生 A～Z。
8. `math.sin()`、`math.atan()` 等三角函數使用弧度。
9. `datetime.now()` 取得現在時間；`strftime()` 負責轉成指定格式的字串。
10. f-string 可同時格式化數值與日期，例如 `{area:.2f}`、`{now:%Y/%m/%d}`。

## 八、綜合練習

### 練習 1

將 `3671` 秒換算成「幾小時、幾分鐘、幾秒」。提示：可連續使用兩次 `divmod()`。

```python
total_seconds = 3671
hours, remainder = divmod(total_seconds, 3600)
minutes, seconds = divmod(remainder, 60)
print(f"{hours} 小時 {minutes} 分 {seconds} 秒")
```

答案：`1 小時 1 分 11 秒`

### 練習 2

輸入半徑後，計算圓面積並保留兩位小數。

```python
import math

radius = float(input("請輸入半徑："))
area = math.pi * radius ** 2
print(f"圓面積：{area:.2f}")
```

### 練習 3

輸出目前時間，格式為 `年-月-日 時:分:秒`。

```python
import datetime as DT

now_time = DT.datetime.now()
print(now_time.strftime("%Y-%m-%d %H:%M:%S"))
```

---

## 九、自訂函式與回傳值

### 1. 三角形面積函式

函式可以把重複使用的計算封裝起來。`return` 會將結果傳回呼叫處。

```python
def triangle(base, height):
    area = base * height / 2
    return area

base = 10
height = 5
area = triangle(base, height)
print(f"三角形的面積為：{area}")
```

輸出：

```text
三角形的面積為：25.0
```

重點：

- `base`、`height` 是形式參數。
- `10`、`5` 是呼叫函式時傳入的實際引數。
- 沒有寫 `return` 的函式會回傳 `None`。

### 2. 預設參數

```python
def triangle(base=6, height=6):
    return base * height / 2

print(triangle(10, 5))  # 25.0，使用傳入值
print(triangle())       # 18.0，使用預設值
```

原始 `ch7-3-triangle02(5).py` 只呼叫了 `triangle(base, height)`，因此沒有實際展示預設值。若要觀察預設參數，必須再呼叫一次 `triangle()`。

### 3. 一次回傳多個值：等差數列

```python
def progress(a1, d, n):
    an = a1 + (n - 1) * d
    sn = n * (a1 + an) / 2
    return an, sn

a1 = float(input("請輸入首項："))
d = float(input("請輸入公差："))
n = int(input("請輸入第 n 項："))

an, sn = progress(a1, d, n)
print(f"第 {n} 項為：{an}，前 {n} 項和為：{sn}")
```

`return an, sn` 實際上會回傳一個 tuple，再用 `an, sn` 拆包接收。

原始程式的輸出寫成 `第{an}項`、`前{an}項和`，應改成 `第{n}項`、`前{n}項和`，因為 `n` 才是項數。

> 安全提醒：不建議用 `eval(input())` 讀取數字。整數使用 `int(input())`，小數使用 `float(input())`，較安全也較容易除錯。

### 4. 只負責輸出的函式

```python
def print_char(ch, n):
    for _ in range(n):
        print(ch, end="")
    print()

print_char("A", 12)
print_char("$", 15)
print_char("B", 16)
```

此函式沒有 `return`，用途是直接印出字元。`end=""` 會讓每次輸出不自動換行，最後的 `print()` 才負責換行。

---

## 十、`random` 亂數模組

使用前先匯入：

```python
import random
```

### 1. 常用亂數函式比較

| 函式 | 用途 | 可能結果 |
| --- | --- | --- |
| `randint(a, b)` | 產生 a～b 的整數，包含兩端 | `randint(1, 6)` → 1～6 |
| `randrange(start, stop, step)` | 從指定序列抽一個值，不包含 stop | `randrange(0, 10, 2)` → 0、2、4、6、8 |
| `random()` | 產生 0.0～1.0 之間的小數，不包含 1.0 | `0.472...` |
| `uniform(a, b)` | 產生 a～b 間的浮點數 | `36.82` |
| `choice(seq)` | 從序列隨機選一個元素 | `'貓咪'` |
| `sample(seq, k)` | 隨機選 k 個不重複元素 | `[2, 8, 5]` |
| `shuffle(list)` | 原地打亂串列順序 | 無回傳新串列 |

綜合範例：

```python
import random

print(random.randint(1, 6))
print(random.randrange(0, 10, 2))
print(random.random())
print(f"{random.uniform(36.0, 37.5):.2f}")
print(random.choice(["貓咪", "狗狗", "兔子", "倉鼠"]))
print(random.sample(range(1, 11), 3))

cards = ["A", "J", "Q", "K", "10"]
random.shuffle(cards)
print(cards)
```

### 2. 使用別名與重複產生亂數

```python
import random as R

for i in range(5):
    rnd = R.randint(1, 10)
    print(f"第 {i + 1} 次亂數：{rnd}")
```

亂數每次執行通常不同，因此無法預先固定輸出。

### 3. 產生不重複亂數

課堂範例使用 `while`、布林旗標與迴圈自行排除重複值。較精簡的寫法是：

```python
import random as R

numbers = R.sample(range(18, 36), 6)
for i, value in enumerate(numbers, start=1):
    print(f"第 {i} 個亂數：{value}")
```

注意：

- `range(18, 36)` 代表 18～35。
- `sample()` 不會重複抽取。
- 抽取數量不能大於資料池的元素數量。
- 不建議使用 `min`、`max` 當變數名稱，因為會遮蔽 Python 內建函式。

---

## 十一、`time` 時間模組

課堂範例使用別名：

```python
import time as T
```

### 1. `time()`：Unix 時間戳記

```python
import time as T

num = T.time()
print(num)
```

它回傳自 1970-01-01 00:00:00 UTC 起累積的秒數，型別為 `float`。實際數字會隨執行時間改變。

### 2. `ctime()`：轉成人類可讀的時間字串

```python
import time as T

current_time = T.ctime()
print(current_time)
```

可能輸出：

```text
Sun Aug 30 14:37:19 2026
```

`ctime()` 會依執行電腦的本地時區顯示時間。

### 3. `localtime()`：拆解本地日期時間

```python
import time as T

timer = T.localtime()
print(
    f"{timer.tm_year}-{timer.tm_mon:02d}-{timer.tm_mday:02d} "
    f"{timer.tm_hour:02d}:{timer.tm_min:02d}:{timer.tm_sec:02d}"
)
```

常用屬性：`tm_year`、`tm_mon`、`tm_mday`、`tm_hour`、`tm_min`、`tm_sec`。

### 4. `sleep()`：暫停程式

```python
import time as T

t1 = T.time()
T.sleep(5)
t2 = T.time()
print(f"程式暫停約 {t2 - t1:.2f} 秒")
```

`sleep(5)` 是暫停目前程式約 5 秒，不是讓整台電腦暫停。實際經過時間可能略多於 5 秒。

### 5. `time` 與 `datetime` 的差異

| 模組 | 適合用途 |
| --- | --- |
| `time` | 時間戳記、程式暫停、簡單計時 |
| `datetime` | 日期計算、建立日期物件、格式化年月日時分秒 |

---

## 十二、Python 參數傳遞

Python 較精確的說法是「物件參照傳遞」（call by sharing）。函式收到的是同一個物件的參照；結果是否影響外部，取決於物件是否可變，以及函式是修改物件還是重新綁定變數。

### 1. 不可變物件：函式外通常不受影響

```python
def triple(x, y):
    x = x * 3
    y = y * 3
    print(f"函式內：x={x}, y={y}")

x = 10
values = [2, 4, 6, 8]
print(f"呼叫前：x={x}, values[1]={values[1]}")
triple(x, values[1])
print(f"呼叫後：x={x}, values[1]={values[1]}")
```

輸出：

```text
呼叫前：x=10, values[1]=4
函式內：x=30, y=12
呼叫後：x=10, values[1]=4
```

`int` 是不可變物件；函式中的 `x = x * 3` 只是讓區域變數改指向新物件。

原始 `ch7-5-callbyvalue(5).py` 有縮排和 `A=A[2,4,6,8]` 的錯誤。建立串列應寫成 `A = [2, 4, 6, 8]`，而主程式也必須移到函式外。

### 2. 可變物件：原串列可能被修改

```python
def triple(values):
    for i in range(len(values)):
        values[i] *= 3

numbers = [2, 4, 6, 8, 10]
triple(numbers)
print(numbers)
```

輸出：

```text
[6, 12, 18, 24, 30]
```

函式直接修改串列元素，因此外部的 `numbers` 也改變。若不想修改原串列，可建立並回傳新串列：

```python
def tripled(values):
    return [value * 3 for value in values]
```

---

## 十三、區域變數、全域變數與 `global`

### 1. 區域變數會遮蔽同名全域變數

```python
def subpro():
    v1 = 31
    v3 = 33
    print(v1, v2, v3)

v1 = 100
v2 = 200
subpro()            # 31 200 33
print(v1, v2)       # 100 200
```

- 函式內的 `v1`、`v3` 是區域變數。
- 函式內找不到 `v2`，Python 才向外讀取全域 `v2`。
- 函式結束後，外部不能直接使用區域變數 `v3`。

### 2. 使用 `global` 修改全域變數

```python
def subpro():
    global n
    n += 10
    m = 20
    print(f"函式內：n={n}, m={m}")

n = 100
m = 200
subpro()
print(f"主程式：n={n}, m={m}")
subpro()
print(f"主程式：n={n}, m={m}")
```

最後 `n` 會變成 `120`，但全域 `m` 仍是 `200`。

實作建議：能用參數與 `return` 完成時，優先避免 `global`，因為全域狀態較難追蹤與測試。

---

## 十四、階乘：迴圈與遞迴

階乘定義：

$$n! = 1 \times 2 \times 3 \times \cdots \times n$$

並且數學上定義 $0! = 1$。

### 1. 迴圈寫法

```python
def factorial(n):
    result = 1
    for i in range(1, n + 1):
        result *= i
    return result

print(factorial(5))  # 120
```

初始值必須是 `1`，因為這是連乘；若設成 `0`，結果永遠都是 0。

### 2. 遞迴寫法

```python
def factorial(n):
    if n <= 1:              # 終止條件
        return 1
    return n * factorial(n - 1)

print(factorial(5))  # 120
```

計算過程：

```text
factorial(5)
= 5 × factorial(4)
= 5 × 4 × factorial(3)
= 5 × 4 × 3 × 2 × 1
= 120
```

遞迴一定要有終止條件，否則會不斷呼叫自己，最後引發 `RecursionError`。大型數值通常較適合迴圈寫法。

### 3. 驗證輸入與主程式入口

```python
def main():
    while True:
        try:
            n = int(input("請輸入大於等於 0 的整數："))
            if n >= 0:
                break
            print("輸入值不可小於 0")
        except ValueError:
            print("請輸入有效整數")

    print(f"{n}! = {factorial(n)}")

if __name__ == "__main__":
    main()
```

`if __name__ == "__main__":` 表示只有直接執行此檔案時才呼叫 `main()`；若檔案被其他程式 `import`，不會自動啟動輸入流程。

---

## 十五、新增內容快速比較表

| 主題 | 關鍵語法 | 必記觀念 |
| --- | --- | --- |
| 自訂函式 | `def`、`return` | 函式可封裝工作並回傳結果 |
| 預設參數 | `def f(x=1)` | 未傳入引數時才使用預設值 |
| 多值回傳 | `return a, b` | 實際回傳 tuple，可拆包接收 |
| 亂數 | `random.randint()`、`sample()` | `sample()` 可抽出不重複元素 |
| 時間戳記 | `time.time()` | 回傳從 Unix epoch 起算的秒數 |
| 暫停 | `time.sleep(s)` | 暫停目前程式約 s 秒 |
| 參數傳遞 | 物件參照傳遞 | 修改可變物件可能影響函式外部 |
| 區域變數 | 函式內賦值 | 通常只在函式內有效 |
| 全域變數 | `global x` | 可在函式內修改外部同名變數 |
| 階乘 | `result *= i` | 連乘初始值設為 1 |
| 遞迴 | 函式呼叫自己 | 必須設定終止條件 |
| 主程式入口 | `if __name__ == "__main__":` | 被匯入時不自動執行主流程 |

## 十六、新增內容考試必記

1. `return a, b` 可一次回傳多個值，實際型別是 tuple。
2. 預設參數只有在呼叫時未提供對應引數才會使用。
3. `randint(a, b)` 包含 `a` 與 `b`；`range(a, b)` 不包含 `b`。
4. `random.sample()` 適合產生不重複亂數；`shuffle()` 直接修改原串列。
5. `time.time()` 是時間戳記；`time.sleep()` 是暫停程式。
6. Python 參數傳遞應理解為物件參照傳遞，不宜只背「傳值」或「傳址」。
7. 修改傳入串列的元素會影響原串列；重新指定整數變數不會改變外部整數。
8. 區域變數只在函式內有效；`global` 可修改全域變數，但不宜濫用。
9. 階乘的連乘初始值是 `1`，而且 `0! = 1`。
10. 遞迴必須有終止條件；迴圈通常較不受遞迴深度限制。
11. `eval(input())` 可能執行任意程式碼，應改用 `int(input())` 或 `float(input())`。
12. 不要用 `min`、`max`、`list` 等內建函式名稱作為一般變數名稱。
