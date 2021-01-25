[TOC]

## 只允许类实现协议：AnyObject

## lazy

### lazy的应用场景

类中某个参数不希望类创建时就立即被赋值，或者说无法在创建时对其赋值

此前我常用的方法：

1. 初始化器或者在属性处赋予默认值，这样每个参数都要写在init中或者给予默认值，违背了初衷
2. 将类型声明为可选类型，缺点很明显，需要在每个用到该值的地方尝试解除可选类型

lazy可以解决上述问题，因为lazy中可以访问self
如果闭包中又调用了self的function，需要注意unowned

```swift
class Person {
    var age: Int

    init(age: Int) {
        self.age = age
    }
  
    lazy var fibonacciOfAge: Int = { [unowned self] in
        guard let self = self else { return 0 }
        return fibonacci(of: self.age)
    }()

    private func fibonacci(of num: Int) -> Int {
        if num < 2 {
            return num
        } else {
            return fibonacci(of: num - 1) + fibonacci(of: num - 2)
        }
    }
}

var a = Person(age: 10)
print(a.fibonacciOfAge)
```

### 其他

- immediately applied closure（立即执行闭包），会被隐式声明为`noescape`，不会持有`self`，因此闭包内可以使用self而无需`[unowned self]`。

  ```swift
  lazy var lazyVar: Int = { 
      return self.x * self.y
  }()
  ```

  但是如果闭包内调用了`self`的某个function，仍然需要`[unowned self]`

- lazy只能用于存储属性，且只能用var修饰

- lazy的initail是非atomic，非线程安全

参考

- https://abhimuralidharan.medium.com/lazy-var-in-ios-swift-96c75cb8a13a
- https://stackoverflow.com/questions/38141298/lazy-initialisation-and-retain-cycle

## KeyPath

编译期做类型检查

keyPath以`\Root.Value`作为出现形式

https://www.swiftbysundell.com/articles/the-power-of-key-paths-in-swift/

```swift
/*
 keyPath可以存储对属性的访问路径，而不持有属性的值
 */
struct BookInfo {
    let id: Int
    let content: String
}

let books = [BookInfo(id: 0, content: "math"), BookInfo(id: 1, content: "chinese"), BookInfo(id: 2, content: "english")]

let keyPathToID = \BookInfo.id
let keyPathToContent = \BookInfo.content

func printIDAndContent<T>(array: [T], keyPathToID: KeyPath<T, Int>, keyPathToContent: KeyPath<T, String>) {
    array.forEach {
        print($0[keyPath: keyPathToID])
        print($0[keyPath: keyPathToContent])
    }
}

printIDAndContent(array: books, keyPathToID: keyPathToID, keyPathToContent: keyPathToContent)

```

