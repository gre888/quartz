# Python 物件導向程式設計（OOP）整理筆記

> 本筆記根據 19 個 Python 範例整理，並加入簡單中文註解與重點說明。

## 1. OOP 基本觀念

| 名稱 | 說明 |
|---|---|
| 類別（class） | 建立物件的設計圖，例如 `Animal` |
| 物件（object） | 根據類別建立的實體，例如 `bird` |
| 屬性（attribute） | 物件儲存的資料，例如 `name`、`age` |
| 方法（method） | 類別中的函式，例如 `sing()`、`fly()` |
| `self` | 代表目前正在操作的物件本身 |
| `__init__()` | 建立物件時自動執行的建構方法 |
| `__del__()` | 物件被回收時可能執行的解構方法 |

---

## 2. 建立類別與物件

來源：`class01.py`、`tclass01.py`

```python
class Animal:
    name = "小鳥"  # 類別屬性：所有物件預設共用

    def sing(self):
        # self 代表呼叫此方法的物件
        print("很會唱歌！")


# 根據 Animal 類別建立三個物件
bird = Animal()
dog = Animal()
cat = Animal()

print(bird.name)  # 小鳥
bird.sing()       # 很會唱歌！
```

重點：

- `class Animal:` 用來定義類別。
- `Animal()` 會建立一個新的物件。
- `bird.name` 讀取物件可使用的屬性。
- `bird.sing()` 呼叫物件的方法。
- `class Animal:` 與 `class Animal():` 在 Python 3 中效果相同，通常寫前者即可。

---

## 3. 建構方法 `__init__()`

來源：`class02.py`、`tclass02.py`

```python
class Animal:
    def __init__(self, name):
        # 建立物件時，把傳入的 name 儲存在物件內
        self.name = name
        print(f"【誕生】{self.name} 被建立好了！")

    def sing(self):
        print(self.name + "，很會唱歌！")

    def __del__(self):
        # 物件被回收時可能執行
        print(f"【銷毀】{self.name} 離開了。")


bird = Animal("鸚鵡")  # 自動呼叫 __init__()
print(bird.name)
bird.sing()

del bird  # 刪除 bird 這個參考
print("程式執行完畢。")
```

注意：`del bird` 是刪除變數對物件的參考；`__del__()` 的實際執行時間可能受 Python 記憶體管理影響，因此不建議用它處理一定要準時完成的重要工作。

---

## 4. 物件屬性與方法

來源：`class03.py`

```python
class Animal:
    def __init__(self, name, age):
        self.name = name  # 物件屬性
        self.age = age
        print(f"{self.name} is created.")

    def sing(self):
        print(self.name + str(self.age) + "歲，很會唱歌")

    def grow(self, years):
        # 修改目前物件的 age 屬性
        self.age += years
        print(f"{self.name} is now {self.age} years old.")


bird = Animal("鸚鵡", 1)
print(bird.name)
bird.grow(1)  # 年齡由 1 變成 2
bird.sing()
```

較清楚的字串寫法：

```python
def sing(self):
    print(f"{self.name}{self.age}歲，很會唱歌")
```

---

## 5. 匿名物件（沒有存入變數的物件）

來源：`anonymous.py`

```python
class Animal:
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def sing(self):
        print(f"{self.name}{self.age}歲，很會唱歌")

    def grow(self, years):
        self.age += years


Animal("鸚鵡", 1).grow(1)
Animal("鸚鵡", 1).sing()
```

這兩行各自建立了不同物件，所以第一個物件增加年齡後，不會影響第二個物件；輸出仍是「鸚鵡1歲」。

若希望同一隻鸚鵡先長大再唱歌，應寫成：

```python
bird = Animal("鸚鵡", 1)
bird.grow(1)
bird.sing()  # 鸚鵡2歲，很會唱歌
```

---

## 6. 封裝與私有成員

來源：`class4.py`

```python
class Animal:
    def __init__(self, name, age):
        self.__name = name  # 私有屬性
        self.__age = age    # 私有屬性

    def __sing(self):       # 私有方法
        print(f"{self.__name}{self.__age}歲，很會唱歌")

    def talk(self):         # 公開方法
        self.__sing()       # 類別內部可以呼叫私有方法
        print("也會模仿人類說話")


bird = Animal("灰鸚鵡", 2)
bird.talk()
```

原始程式的兩個重要現象：

```python
bird.__age = -1
```

這不是修改原本的私有屬性，而是另外建立一個名為 `__age` 的外部屬性，所以 `talk()` 讀到的年齡仍然是 2。

```python
bird.__sing()
```

這行會發生 `AttributeError`，因為雙底線成員不能用原名稱從類別外部直接存取。

建議透過公開方法安全地讀寫資料：

```python
class Animal:
    def __init__(self, name, age):
        self.__name = name
        self.__age = age

    def get_age(self):
        return self.__age

    def set_age(self, age):
        if age >= 0:              # 先驗證資料
            self.__age = age
        else:
            raise ValueError("年齡不可小於 0")
```

---

## 7. 單一繼承

來源：`myClass.py`、`class05.py`

### 7.1 繼承父類別的屬性與方法

```python
class Rectangle:
    def __init__(self, width, height):
        self.width = width
        self.height = height

    def area(self):
        return self.width * self.height


class Triangle(Rectangle):
    # Triangle 繼承 Rectangle 的 width、height 和 area()
    def area2(self):
        return self.width * self.height / 2


triangle = Triangle(5, 6)
print("矩形面積 =", triangle.area())    # 30
print("三角形面積 =", triangle.area2()) # 15.0
```

### 7.2 子類別新增自己的方法

```python
class Animal:
    def __init__(self, name):
        self.name = name

    def fly(self):
        print(self.name + "會飛")


class Bird(Animal):
    def __init__(self, name):
        self.name = "粉紅色" + name

    def sing(self):
        print(self.name + "也愛唱歌")


pigeon = Animal("鴿子")
pigeon.fly()

parrot = Bird("鸚鵡")
parrot.fly()   # 繼承自 Animal
parrot.sing()  # Bird 自己的方法
```

---

## 8. 使用 `super()` 呼叫父類別

來源：`class06.py`

```python
class Animal:
    def __init__(self, name):
        self.name = name

    def fly(self):
        print(self.name + "會飛")


class Bird(Animal):
    def __init__(self, name, age):
        super().__init__(name)  # 呼叫父類別的 __init__()
        self.age = age

    def fly(self):
        print(f"{self.age}歲的", end="")
        super().fly()           # 呼叫父類別的 fly()


if __name__ == "__main__":
    pigeon = Animal("鴿子")
    pigeon.fly()

    parrot = Bird("小鸚鵡", 2)
    parrot.fly()
```

輸出：

```text
鴿子會飛
2歲的小鸚鵡會飛
```

`if __name__ == "__main__":` 表示只有直接執行這個檔案時，區塊內程式才會執行；若此檔案被其他程式 `import`，區塊內程式不會自動執行。

---

## 9. 多層繼承

來源：`chainedInheritance.py`

```python
class A:
    x = 1


class B(A):
    y = 2


class C(B):
    z = 3


obj = C()
print(obj.x)  # 從 A 繼承
print(obj.y)  # 從 B 繼承
print(obj.z)  # C 自己的屬性
```

繼承關係：`A → B → C`。因此 C 的物件可以使用 A、B、C 中可繼承的成員。

---

## 10. 多重繼承

來源：`multipleInheritance.py`

```python
class Father:
    def drive(self):
        print("爸爸會開車")


class Mother:
    def cook(self):
        print("媽媽會做飯")


class Child(Father, Mother):
    # 同時繼承 Father 和 Mother
    def play(self):
        print("孩子會玩")


child = Child()
child.play()
child.drive()
child.cook()
```

如果多個父類別具有同名方法，Python 會依照 MRO（方法解析順序）決定先使用哪一個，可用以下指令查看：

```python
print(Child.mro())
```

---

## 11. 子類別取得父類別私有資料

來源：`getprivateattribute.py`

```python
class Father:
    def __init__(self, name):
        self.name = name
        self.__eye = "黑色"  # 父類別私有屬性

    def get_eye(self):
        # 提供公開方法，讓外部安全取得私有資料
        return self.__eye


class Child(Father):
    def __init__(self, name, eye):
        super().__init__(name)
        self.eye = eye
        self.father_eye = super().get_eye()


joe = Child("小華", "棕色")
print(joe.name)        # 小華
print(joe.eye)         # 棕色
print(joe.father_eye)  # 黑色
```

子類別不能直接使用 `self.__eye` 讀取父類別的私有屬性，因此父類別提供 `get_eye()` 公開方法。

---

## 12. 方法覆寫與多型

來源：`class07.py`

```python
class Animal:
    def fly(self):
        print("時速20公里")


class Bird(Animal):
    def fly(self):
        # 覆寫父類別的同名方法
        print("時速50公里")


class Plane:
    def fly(self):
        print("時速800公里")

    def fly_mile(self, speed):
        print(f"飛行{speed}英里")


animal = Animal()
bird = Bird()
plane = Plane()

animal.fly()  # 時速20公里
bird.fly()    # 時速50公里
plane.fly()   # 時速800公里
plane.fly_mile(5)
```

重點：

- `Bird.fly()` 覆寫了 `Animal.fly()`。
- 不同類別都可提供 `fly()` 方法，呼叫時會依物件類型執行對應版本，這是多型的概念。

---

## 13. 抽象類別與介面規格

來源：`interface.py`

```python
from abc import ABC, abstractmethod


class Animal(ABC):
    @abstractmethod
    def sound(self):
        """所有 Animal 子類別都必須實作 sound()。"""
        pass


class Dog(Animal):
    def sound(self):
        return "Woof!"


class Cat(Animal):
    def sound(self):
        return "Meow!"


dog = Dog()
cat = Cat()
print(dog.sound())
print(cat.sound())
```

重點：

- `ABC` 代表抽象基底類別。
- `@abstractmethod` 規定子類別必須實作該方法。
- 未完成 `sound()` 的子類別無法建立物件。
- Python 沒有與某些語言完全相同的 `interface` 關鍵字，通常可用抽象類別表達介面規格。

---

## 14. Python 中模擬方法多載

Python 不支援只靠參數數量或型別，重複定義多個同名方法。若連續定義同名方法，後面的定義會蓋掉前面的定義。常見替代方式如下。

### 14.1 使用預設參數

來源：`overloading_defaults_argus.py`

```python
class Calculator:
    def add(self, x, y=None):
        # 有傳入 y：處理兩個參數
        if y is not None:
            if isinstance(x, str) and isinstance(y, str):
                return f"{x}-{y}"
            return x + y

        # 沒有傳入 y：處理單一參數
        return f"單一數字處理結果：{x + 10}"


calc = Calculator()
print(calc.add(5))                 # 單一數字處理結果：15
print(calc.add(10, 20))            # 30
print(calc.add("Hello", "World")) # Hello-World
```

### 14.2 使用 `*args`

來源：`overloading_args.py`

```python
class Calculator:
    def add(self, *args):
        # args 是 tuple，存放所有位置參數
        if len(args) == 2:
            x, y = args
            if isinstance(x, str) and isinstance(y, str):
                return f"{x}-{y}"
            return x + y

        if len(args) == 1:
            x = args[0]
            return f"單一數字處理結果：{x + 10}"

        raise ValueError("參數數量錯誤")


calc = Calculator()
print(calc.add(5))
print(calc.add(10, 20))
print(calc.add("Hello", "World"))
```

### 14.3 使用 `@singledispatchmethod`

來源：`overloading_singledispatchmethod.py`

```python
from functools import singledispatchmethod


class Calculator:
    @singledispatchmethod
    def add(self, x, y=None):
        # 預設版本
        if y is not None:
            return x + y
        return f"單一數字處理結果：{x + 10}"

    @add.register
    def _(self, x: str, y: str):
        # 第一個參數 x 是 str 時使用此版本
        return f"字串串接：{x}-{y}"


calc = Calculator()
print(calc.add(5))
print(calc.add(10, 20))
print(calc.add("Hello", "World"))
```

注意：`singledispatchmethod` 主要根據第一個非 `self` 參數的型別選擇版本，不會同時根據所有參數型別做完整判斷。

---

## 15. 未完成的類別範例

來源：`oop1.py`

原始程式：

```python
class Animal():
    def a(self):

bird = Animal()
```

`def a(self):` 後面沒有任何方法內容，因此會出現 `IndentationError`。可以使用 `pass` 表示暫時不執行任何動作：

```python
class Animal:
    def a(self):
        pass  # 暫時保留空方法，避免語法錯誤


bird = Animal()
```

或補上真正的方法內容：

```python
class Animal:
    def a(self):
        print("Animal 的 a 方法被呼叫")


bird = Animal()
bird.a()
```

---

## 16. 本章快速總結

```python
class Parent:
    def __init__(self, value):
        self.value = value       # 公開屬性
        self.__secret = "秘密"   # 私有屬性

    def show(self):
        print(self.value)


class Child(Parent):
    def __init__(self, value, extra):
        super().__init__(value)  # 呼叫父類別建構方法
        self.extra = extra

    def show(self):
        # 覆寫父類別方法
        print(self.value, self.extra)


obj = Child("父類別資料", "子類別資料")
obj.show()
```

建議學習順序：

1. 類別、物件、`self`
2. `__init__()` 與物件屬性
3. 封裝與私有成員
4. 繼承與 `super()`
5. 方法覆寫與多型
6. 多層、多重繼承
7. 抽象類別
8. Python 模擬多載的方法

