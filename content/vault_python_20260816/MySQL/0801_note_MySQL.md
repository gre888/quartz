# MySQL CH3：建表與資料表管理筆記

> 依據 `0803-CH3-00.sql`、`0803-ch3-01.sql` 與 `0803practice-00～03.sql` 整理。以下範例以 MySQL 8.x 為主，並已修正原始程式中的明顯錯誤。

## 1. 選擇資料庫

```sql
USE db1;
```

執行後，後續未指定資料庫名稱的 SQL 都會在 `db1` 中執行。

也可以直接使用完整名稱：

```sql
CREATE TABLE db1.department (...);
```

---

## 2. CREATE TABLE 基本語法

```sql
CREATE TABLE IF NOT EXISTS 資料表名稱 (
    欄位名稱 資料型別 欄位限制,
    欄位名稱 資料型別 欄位限制
);
```

- `IF NOT EXISTS`：資料表不存在時才建立，可避免重複建立所造成的錯誤。
- 最後一個欄位或限制後面不能多加逗號。
- 建議資料表與欄位命名保持一致，例如統一使用小寫加底線。

### 範例：建立部門資料表

```sql
CREATE TABLE IF NOT EXISTS db1.department (
    dept_no  INT PRIMARY KEY,
    dname    VARCHAR(16) NOT NULL,
    location VARCHAR(16) DEFAULT NULL
);
```

### 常見欄位限制

| 限制 | 說明 |
|---|---|
| `PRIMARY KEY` | 主鍵；值不可重複，也不可為 `NULL` |
| `NOT NULL` | 欄位不可留空 |
| `NULL` | 欄位可以留空，通常可省略 |
| `DEFAULT` | 沒有提供值時使用預設值 |
| `AUTO_INCREMENT` | 自動產生遞增編號 |
| `UNSIGNED` | 不允許負數 |
| `COMMENT` | 加入欄位或資料表說明 |
| `CHECK` | 限制欄位值必須符合條件 |

---

## 3. 主鍵 PRIMARY KEY

### 單一欄位主鍵

兩種寫法效果相同：

```sql
CREATE TABLE department1 (
    dept_no INT PRIMARY KEY,
    dname   VARCHAR(16) NOT NULL
);
```

```sql
CREATE TABLE department2 (
    dept_no INT,
    dname   VARCHAR(16) NOT NULL,
    PRIMARY KEY (dept_no)
);
```

### 複合主鍵

由兩個以上欄位共同組成主鍵：

```sql
CREATE TABLE department3 (
    dept_no  INT,
    dname    VARCHAR(16) NOT NULL,
    location VARCHAR(16),
    PRIMARY KEY (dept_no, dname)
);
```

這表示 `(dept_no, dname)` 的組合不可重複，但單獨的 `dept_no` 或 `dname` 可以重複。

---

## 4. 常用資料型別

### 數值型別

| 型別 | 用途 |
|---|---|
| `INT` | 一般整數 |
| `BIGINT` | 範圍較大的整數 |
| `INT UNSIGNED` | 只允許 0 與正整數，適合人口、數量等 |
| `DECIMAL(10,1)` | 精確小數，總共 10 位，其中小數 1 位；適合金額 |
| `DOUBLE` | 浮點數，可能有精度誤差 |
| `FLOAT(12,5)` | 浮點數；舊式顯示寬度寫法不建議用於新設計 |

金額通常優先使用 `DECIMAL`，避免浮點數的精度誤差。

### 字串與其他型別

| 型別 | 用途 |
|---|---|
| `CHAR(5)` | 固定長度字串，例如固定格式編號 |
| `VARCHAR(60)` | 可變長度字串，例如姓名、產品名稱 |
| `TEXT` | 較長文字 |
| `BLOB` | 二進位資料，例如圖片；實務上也常只存檔案路徑 |
| `DATE` | 日期，例如 `2026-08-16` |
| `TIMESTAMP` | 日期與時間，可自動記錄建立或更新時間 |
| `ENUM(...)` | 只能選擇列出的其中一個值 |

### 電話應使用 VARCHAR

原始程式把廠商電話寫成 `DECIMAL(20)`，較不適合。電話可能包含前導 `0`、`+`、分機或連字號，建議：

```sql
ven_tel VARCHAR(20)
```

---

## 5. DEFAULT、COMMENT 與 ENUM

```sql
CREATE TABLE db1.main_product (
    product_id        INT AUTO_INCREMENT PRIMARY KEY COMMENT '產品編號',
    product_name      VARCHAR(60) DEFAULT NULL COMMENT '產品名稱',
    product_list      DECIMAL(10,1) DEFAULT NULL COMMENT '產品定價',
    product_cost      DECIMAL(10,2) DEFAULT NULL COMMENT '產品成本',
    product_kind      ENUM('餅乾', '糖果', '米果') DEFAULT NULL
                      COMMENT '產品種類',
    product_remark01  TEXT,
    product_remark02  TEXT
);
```

注意：

- `product_id AUTO_INCREMENT` 必須是索引欄位，通常直接設為主鍵。
- 原始 `0803practice-01.sql` 最後一個欄位後有多餘逗號，會造成語法錯誤。
- 原始欄位 `produect_list` 疑似拼字錯誤，建議改成 `product_list`。
- `TEXT DEFAULT NULL` 中的 `DEFAULT NULL` 通常可以省略。

---

## 6. AUTO_INCREMENT 與 SERIAL

### 自動編號

```sql
CREATE TABLE IF NOT EXISTS auto_test1 (
    id   BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20)
) AUTO_INCREMENT = 1000;
```

第一筆未指定 `id` 的資料會從 1000 開始編號。

### SERIAL

在 MySQL 中：

```sql
id SERIAL
```

大致等同於：

```sql
id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
```

`SERIAL` 建立的是唯一鍵，但為了讓資料表結構更清楚，實務上常直接寫出 `PRIMARY KEY`。

### 查看自動編號相關變數

```sql
SHOW VARIABLES LIKE '%auto_inc%';
```

### 修改編號增量

`auto_increment_increment` 是系統或工作階段變數，不是資料庫屬性。正確寫法例如：

```sql
SET SESSION auto_increment_increment = 5;
```

若要修改全域設定，通常需要較高權限：

```sql
SET GLOBAL auto_increment_increment = 5;
```

原始寫法 `SET db2.auto_increment_increment = 5` 不正確。

### 設定下一個自動編號

```sql
ALTER TABLE db2.auto_test1 AUTO_INCREMENT = 300;
```

如果資料表中已存在更大的編號，MySQL 不會因此產生重複主鍵。

---

## 7. ZEROFILL 注意事項

原始程式使用：

```sql
price1 INT ZEROFILL
```

`ZEROFILL` 用來以 0 補足顯示寬度，但已在 MySQL 8.0.17 被標示為不建議使用。若只是顯示格式，建議由查詢或應用程式處理：

```sql
SELECT LPAD(price1, 8, '0') FROM auto_test3;
```

---

## 8. 日期與時間欄位

### 自動記錄建立時間

```sql
CREATE TABLE temp_record1 (
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    temp       INT NOT NULL
);
```

### 自動記錄更新時間

```sql
CREATE TABLE temp_record2 (
    updated_at TIMESTAMP NOT NULL
               DEFAULT CURRENT_TIMESTAMP
               ON UPDATE CURRENT_TIMESTAMP,
    temp       INT NOT NULL
);
```

### 同時記錄建立與更新時間

```sql
CREATE TABLE temp_record3 (
    id         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
               ON UPDATE CURRENT_TIMESTAMP,
    temp       INT NOT NULL
);
```

原始程式的 `updated TIMESTAMP ON UPDATE CURRENT_TIMESTAMP` 沒有預設值。雖然部分版本可能接受，但加上 `DEFAULT CURRENT_TIMESTAMP` 較完整、行為也更明確。

---

## 9. 字元集與排序規則

```sql
CREATE TABLE db1.department4 (
    dept_no  INT PRIMARY KEY,
    dname    VARCHAR(16) NOT NULL,
    location VARCHAR(16)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
```

- `ENGINE=InnoDB`：支援交易、外鍵與崩潰復原，是常用預設引擎。
- `utf8mb4`：可完整儲存 Unicode，包括繁體中文與 Emoji。
- 原始範例使用 `big5`；新資料庫通常建議使用 `utf8mb4`。

查看 MySQL 支援的字元集：

```sql
SHOW CHARACTER SET;
```

---

## 10. 查看資料表與欄位結構

```sql
SHOW TABLES FROM db1;
```

```sql
SELECT *
FROM information_schema.tables
WHERE table_schema = 'db1';
```

以下指令都可查看欄位結構：

```sql
DESCRIBE db1.customer;
DESC db1.customer;
SHOW COLUMNS FROM db1.customer;
SHOW FIELDS FROM db1.customer;
```

---

## 11. 使用查詢結果建立資料表

### 複製指定資料

```sql
USE world;

CREATE TABLE city_of_taiwan AS
SELECT name, population
FROM world.city
WHERE countrycode = 'TWN';
```

這會建立欄位並複製查詢結果，但索引、主鍵、`AUTO_INCREMENT` 等結構通常不會完整複製。

### 只複製結構，不複製資料

```sql
CREATE TABLE city_of_world AS
SELECT *
FROM world.city
WHERE 1 = 0;
```

`WHERE 1 = 0` 永遠不成立，因此只建立欄位，不會複製資料；但主鍵與索引不會完整保留。

### 完整複製資料表結構

```sql
CREATE TABLE city_of_new_world LIKE world.city;
```

`LIKE` 會複製欄位、索引等結構，但不複製資料。若也要複製資料：

```sql
INSERT INTO city_of_new_world
SELECT * FROM world.city;
```

### 先定義欄位，再放入查詢結果

```sql
CREATE TABLE db1.city_of_taiwan2 (
    id         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(35),
    population INT UNSIGNED
)
SELECT name, population
FROM world.city
WHERE countrycode = 'TWN';
```

注意新增的自動編號欄位 `id` 不需要出現在 `SELECT` 中。

---

## 12. CHECK 條件限制

### 未命名的 CHECK

```sql
CREATE TABLE persons (
    id    INT PRIMARY KEY,
    name  VARCHAR(200),
    score INT,
    CHECK (score >= 0 AND score <= 100)
);
```

### 命名 CHECK

```sql
CREATE TABLE persons2 (
    id    INT PRIMARY KEY,
    name  VARCHAR(200),
    score INT,
    CONSTRAINT chk_score CHECK (score BETWEEN 0 AND 100)
);
```

命名限制的好處是之後較容易辨識與刪除。

### 年齡至少 18 歲且地址為桃園市

原始程式少了 `CREATE` 關鍵字，正確寫法是：

```sql
CREATE TABLE db1.student (
    id      INT PRIMARY KEY,
    name    VARCHAR(30),
    age     INT,
    address VARCHAR(20),
    CONSTRAINT chk_student
        CHECK (age >= 18 AND address = '桃園市')
);
```

這個條件表示兩項都必須成立。如果需求只是各自限制，也可拆成兩個 `CHECK`，更容易維護。

---

## 13. 暫存資料表 TEMPORARY TABLE

```sql
CREATE TEMPORARY TABLE IF NOT EXISTS t1 (
    id   BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30)
);
```

- 暫存表只存在於目前的資料庫連線。
- 連線中斷後會自動刪除。
- 不同連線可以建立同名暫存表。
- 暫存表可與一般資料表同名，但容易混淆，因此不建議。

---

## 14. ALTER TABLE 修改資料表

### 新增欄位

```sql
ALTER TABLE address1 ADD newcol1 INT;
ALTER TABLE address1 ADD newcol2 INT FIRST;
ALTER TABLE address1 ADD newcol3 INT AFTER tel;
ALTER TABLE address1 ADD (col4 INT, col5 INT);
```

- `FIRST`：放在第一欄。
- `AFTER tel`：放在 `tel` 後面。

### 刪除欄位

```sql
ALTER TABLE address1 DROP COLUMN col5;
```

刪除欄位也會刪除其中資料，執行前應確認或備份。

### CHANGE：修改名稱及型別

```sql
ALTER TABLE address1
CHANGE col4 newcol4 CHAR(3) AFTER name;
```

`CHANGE 舊名稱 新名稱 完整型別與限制`，即使只改名稱，也必須重新寫出資料型別。

### MODIFY：修改型別或位置，不改名稱

```sql
ALTER TABLE address1
MODIFY newcol4 BIGINT AFTER birthdate;
```

### 重新命名資料表

```sql
ALTER TABLE customer RENAME TO new_customer;
```

或：

```sql
RENAME TABLE new_customer TO customer;
```

---

## 15. DELETE、TRUNCATE 與 DROP 的差別

| 指令 | 刪除內容 | 保留資料表結構 | 可使用 WHERE | 自動編號通常重置 |
|---|---:|---:|---:|---:|
| `DELETE FROM table` | 資料列 | 是 | 是 | 否 |
| `TRUNCATE TABLE table` | 全部資料列 | 是 | 否 | 是 |
| `DROP TABLE table` | 整張資料表 | 否 | 否 | 不適用 |

```sql
DELETE FROM auto_test1;
TRUNCATE TABLE auto_test1;
DROP TABLE IF EXISTS customer;
```

這三種操作都可能造成資料遺失，執行前要特別確認目標資料表。

---

## 16. 原始檔案中的重要問題整理

| 位置 | 問題 | 修正方式 |
|---|---|---|
| `0803practice-01.sql` | 最後一個欄位後多一個逗號 | 移除 `productRemark02 text default null,` 最後的逗號 |
| `0803practice-01.sql` | `AUTO_INCREMENT` 欄位沒有鍵 | 將 `product_id` 設為 `PRIMARY KEY` |
| `0803practice-01.sql` | `produect_list` 疑似拼錯 | 改成 `product_list` |
| `0803practice-02.sql` | 電話使用 `DECIMAL(20)` | 改成 `VARCHAR(20)` |
| `0803practice-03.sql` | 重複建立 `temp_record2` | 刪除重複區塊或加入 `IF NOT EXISTS` |
| `0803practice-03.sql` | `TABLE db1.student` 少了關鍵字 | 改成 `CREATE TABLE db1.student` |
| `0803practice-03.sql` | `SET db2.auto_increment_increment=5` 錯誤 | 改成 `SET SESSION auto_increment_increment = 5` |
| 多個檔案 | `DEPTARTMENT`、`DEPNO`、`cityofjanpan` 等拼字不一致 | 建議統一為 `department`、`dept_no`、`city_of_japan` |
| 多個檔案 | 使用 `BIG5`、`ZEROFILL` | 新設計建議改用 `utf8mb4`，格式補零交由查詢或程式處理 |

---

## 17. 綜合練習：建立較完整的產品與廠商表

```sql
USE db1;

CREATE TABLE IF NOT EXISTS vendor (
    vendor_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '廠商編號',
    ven_name  VARCHAR(36) NOT NULL COMMENT '廠商名稱',
    ven_tel   VARCHAR(20) DEFAULT NULL COMMENT '廠商電話',
    ven_area  ENUM('台北市', '桃園市', '新竹市') DEFAULT NULL
              COMMENT '廠商所在地'
) ENGINE = InnoDB
  DEFAULT CHARACTER SET = utf8mb4;

CREATE TABLE IF NOT EXISTS main_product (
    product_id       INT AUTO_INCREMENT PRIMARY KEY COMMENT '產品編號',
    product_name     VARCHAR(60) NOT NULL COMMENT '產品名稱',
    product_list     DECIMAL(10,1) DEFAULT NULL COMMENT '產品定價',
    product_cost     DECIMAL(10,2) DEFAULT NULL COMMENT '產品成本',
    product_kind     ENUM('餅乾', '糖果', '米果') DEFAULT NULL,
    product_remark01 TEXT,
    product_remark02 TEXT
) ENGINE = InnoDB
  DEFAULT CHARACTER SET = utf8mb4;
```

## 18. 快速複習口訣

- 建表：`CREATE TABLE`
- 看結構：`DESC 表名`
- 加欄位：`ALTER TABLE ... ADD`
- 改名稱及型別：`CHANGE`
- 只改型別或位置：`MODIFY`
- 刪欄位：`DROP COLUMN`
- 清空資料：`TRUNCATE TABLE`
- 刪整張表：`DROP TABLE`
- 複製完整結構：`CREATE TABLE 新表 LIKE 舊表`
- 依查詢建表：`CREATE TABLE 新表 AS SELECT ...`

