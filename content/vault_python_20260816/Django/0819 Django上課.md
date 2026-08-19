# MySQL 與 Django ORM 比較筆記

> 根據上課檔案 `0819-ORM01.sql` 與 `views.py` 整理。
>
> 本課重點：將 MySQL 的 `SELECT` 查詢轉換成 Django ORM 寫法。

## 一、MySQL 與 Django ORM 查詢比較

| 查詢目的 | MySQL | Django ORM |
|---|---|---|
| 取得全部資料 | `SELECT * FROM myapp_student;` | `Student.objects.all()` |
| 取得指定欄位 | `SELECT cID, cName, cEmail FROM myapp_student;` | `Student.objects.values('cID', 'cName', 'cEmail')` |
| 取得不重複資料 | `SELECT DISTINCT cSex FROM myapp_student;` | `Student.objects.values('cSex').distinct()` |
| 取得單筆資料 | `SELECT * FROM myapp_student WHERE cID=3;` | `Student.objects.get(cID=3)` |
| 等於 | `WHERE cSex='M'` | `.filter(cSex='M')` |
| 大於 | `WHERE cID > 5` | `.filter(cID__gt=5)` |
| 大於等於 | `WHERE cID >= 5` | `.filter(cID__gte=5)` |
| 小於 | `WHERE cID < 5` | `.filter(cID__lt=5)` |
| 小於等於 | `WHERE cID <= 5` | `.filter(cID__lte=5)` |
| 多條件 AND | `WHERE cID>5 AND cSex='M'` | `.filter(cID__gt=5, cSex='M')` |
| 使用 `Q` 表示 AND | `WHERE cID>5 AND cSex='M'` | `.filter(Q(cID__gt=5) & Q(cSex='M'))` |
| 多條件 OR | `WHERE cID=1 OR cID>=9` | `.filter(Q(cID=1) \| Q(cID__gte=9))` |
| 指定範圍 | `WHERE cID BETWEEN 4 AND 6` | `.filter(cID__range=[4, 6])` |
| 範圍的另一種寫法 | `WHERE cID>=4 AND cID<=6` | `.filter(cID__gte=4, cID__lte=6)` |
| 符合其中一個值 | `WHERE cID IN (1,3,5,7,9)` | `.filter(cID__in=[1,3,5,7,9])` |
| 字串開頭符合 | `WHERE cPhone LIKE '0918%'` | `.filter(cPhone__startswith='0918')` |
| 字串包含內容 | `WHERE cAddr LIKE '%建國%'` | `.filter(cAddr__contains='建國')` |
| 遞增排序 | `ORDER BY cBirthday ASC` | `.order_by('cBirthday')` |
| 遞減排序 | `ORDER BY cBirthday DESC` | `.order_by('-cBirthday')` |
| 多欄位排序 | `ORDER BY cSex ASC, cBirthday DESC` | `.order_by('cSex', '-cBirthday')` |
| 取前兩筆 | `LIMIT 2` | `.all()[0:2]` |
| 從第 5 筆取 2 筆 | `LIMIT 4,2` | `.all()[4:6]` |
| 不符合條件 | `WHERE cSex != 'M'` | `.exclude(cSex='M')` |

## 二、ORM 查詢條件速查表

| Django ORM 語法 | 意思 | MySQL 對應 |
|---|---|---|
| `欄位__gt` | 大於 | `>` |
| `欄位__gte` | 大於等於 | `>=` |
| `欄位__lt` | 小於 | `<` |
| `欄位__lte` | 小於等於 | `<=` |
| `欄位__range` | 指定範圍 | `BETWEEN` |
| `欄位__in` | 符合其中一個值 | `IN` |
| `欄位__startswith` | 以指定文字開頭 | `LIKE '文字%'` |
| `欄位__contains` | 包含指定文字 | `LIKE '%文字%'` |
| `exclude()` | 排除符合條件的資料 | `!=` 或 `NOT` |
| `distinct()` | 去除重複資料 | `DISTINCT` |
| `order_by()` | 排序 | `ORDER BY` |

## 三、MySQL 與 ORM 的基本差異

| 比較項目 | MySQL SQL | Django ORM |
|---|---|---|
| 操作對象 | 資料表及欄位 | Python 模型及屬性 |
| 基本語法 | `SELECT...FROM...WHERE` | `Model.objects.filter()` |
| 多筆查詢結果 | 多筆資料列 | `QuerySet` |
| 單筆查詢結果 | 一筆資料列 | 模型物件 |
| AND | 使用 `AND` | `filter()` 中使用逗號，或用 `Q()` 搭配 `&` |
| OR | 使用 `OR` | 使用 `Q()` 搭配 `\|` |
| 遞減排序 | 欄位後加 `DESC` | 欄位名稱前加 `-` |
| 限制筆數 | `LIMIT` | Python 切片 `[開始:結束]` |
| 主要優點 | 可以直接、精確控制資料庫 | 使用 Python 操作，容易和 Django 整合 |
| 注意事項 | 需要熟悉 SQL 語法 | 模型名稱和欄位名稱必須正確 |

## 四、QuerySet、模型物件與字典

### 1. `all()` 取得 QuerySet

```python
# 取得多筆資料，結果是 QuerySet
datas = Student.objects.all()

# QuerySet 中的每一筆資料是 Student 模型物件
for data in datas:
    print(data)
```

### 2. 使用 `model_to_dict()` 轉成字典

```python
from django.forms.models import model_to_dict

datas = Student.objects.all()

for data in datas:
    print(model_to_dict(data))
```

### 3. `values()` 直接取得字典形式資料

```python
datas = Student.objects.values('cID', 'cName', 'cEmail')

for data in datas:
    print(data)
```

可能輸出：

```python
{
    'cID': 1,
    'cName': '王小明',
    'cEmail': 'ming@example.com'
}
```

## 五、`get()` 與 `filter()` 的差異

| 方法 | 查詢結果 | 查不到資料 | 查到多筆 |
|---|---|---|---|
| `get()` | 單一模型物件 | 產生例外 | 產生例外 |
| `filter()` | `QuerySet` 集合 | 回傳空的 `QuerySet` | 正常回傳多筆 |

```python
# 適合查詢主鍵或唯一資料
data = Student.objects.get(cID=3)

# 適合查詢零筆、一筆或多筆資料
datas = Student.objects.filter(cSex='M')
```

> `get()` 必須剛好找到一筆資料；如果不確定資料筆數，通常先使用 `filter()` 比較安全。

## 六、使用 `Q()` 組合查詢條件

使用 `Q()` 前必須先匯入：

```python
from django.db.models import Q
```

### AND 查詢

```python
datas = Student.objects.filter(
    Q(cID__gt=5) & Q(cSex='M')
)
```

相當於：

```sql
SELECT *
FROM myapp_student
WHERE cID > 5 AND cSex = 'M';
```

### OR 查詢

```python
datas = Student.objects.filter(
    Q(cID=1) | Q(cID__gte=9)
)
```

相當於：

```sql
SELECT *
FROM myapp_student
WHERE cID = 1 OR cID >= 9;
```

## 七、排序與切片

### 遞增與遞減排序

```python
# 生日遞增排序
datas = Student.objects.all().order_by('cBirthday')

# 生日遞減排序
datas = Student.objects.all().order_by('-cBirthday')

# 先按性別遞增，再按生日遞減
datas = Student.objects.all().order_by('cSex', '-cBirthday')
```

### 限制查詢筆數

```python
# 取得前兩筆，索引為 0、1
datas = Student.objects.all()[0:2]

# 取得第 5～6 筆，索引為 4、5
datas = Student.objects.all()[4:6]
```

切片語法的結束索引不包含在結果中，因此 `[4:6]` 會取得索引 `4` 與 `5`。

## 八、上課檔案注意事項

### 1. 模型名稱大小寫

`views.py` 前面的部分範例使用：

```python
student.objects.all()
```

最後的程式使用：

```python
Student.objects.all()
```

Python 會區分大小寫，模型名稱必須和 `models.py` 中定義的類別名稱完全相同。Django 模型通常使用大寫開頭：

```python
class Student(models.Model):
    pass
```

因此查詢通常應統一寫成：

```python
Student.objects.all()
```

### 2. 變數內容被下一行覆蓋

原始檔案最後連續執行：

```python
datas = Student.objects.all()[0:2]
datas = Student.objects.all()[4:6]
```

第二行會覆蓋第一行，因此最後只會取得第 5～6 筆資料。如果要測試前兩筆，應先註解第二行：

```python
datas = Student.objects.all()[0:2]
# datas = Student.objects.all()[4:6]
```

## 九、重點整理

1. `all()`：取得全部資料。
2. `values()`：取得指定欄位，資料以字典形式呈現。
3. `get()`：取得唯一的一筆資料。
4. `filter()`：依條件取得零筆、一筆或多筆資料。
5. `exclude()`：排除符合條件的資料。
6. `Q()`：處理 AND、OR 等複合條件。
7. `order_by('-欄位')`：以指定欄位遞減排序。
8. `[開始:結束]`：限制取得的資料範圍，結束索引不包含在內。
9. ORM 查詢回傳的多筆結果通常是 `QuerySet`。
10. 模型名稱與欄位名稱必須和 `models.py` 的定義完全一致。



