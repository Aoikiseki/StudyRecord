[TOC]

## 扩展

### 扩展和访问修饰符

> 参考文章：https://www.cnblogs.com/tieria/p/4507261.html
> 文中将情况分为：同一文件下extension、不同文件下extesion、在当前类调用、在其他类调用四种情况

对于internal：

- 不论extension中的方法和类文件是否在同一文件中，均可调用

对于extension中的private方法：

- 同一文件下extension在本类中调用可以访问到
- 不同文件下extension在本类中无法访问到
- 同一文件下extension在其他类中调用可以访问到
- 不同文件下extension在其他类中无法访问到

对于extension中的public方法：

- 不论与本类是否在同一文件中，在本类和其他类中均可以访问

## 协议

### 关联类型

协议中通过`associatedtype`修饰的类型，被称为关联类型，可以为关联类型添加约束比如`Equatable`。关联类型可以提供一个类型占位符供协议使用，无需指定具体类型，从功能上感觉像是协议中的泛型。

```swift
protocol Container {
    associatedtype Item: Equatable
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}
```

关联的具体类型的推断方式：

- 实现协议中和Item相关的方法，编译器自动推断
- 使用`typealias Item = XXX`指定具体类型

### 协议where约束

一个协议需要有条件地继承另一个协议，比如要求内部的关联类型必须为某类型、或者必须遵循某协议时

```swift
protocol ComparableContainer: Container where Item: Comparable { }
```

where约束在协议和泛型中都比较常见，用来增加约束。

### 在关联类型的约束里使用当前协议

有一个协议对`Container`进行细化，协议中包含一个`suffix`方法，要求返回类型为实现了当前协议的类型，即返回自身类型。由于前面`Container`协议中包含关联类型`Item`，因此下面这种写法会报错。：

> Error: Protocol 'SuffixableContainer' can only be used as a generic constraint because it has Self or associated type requirements

Error表示`SuffixableContainer`只能用来作为泛约束，不能作为具体的返回值，因为其必须提供`Item`关联类型定义

```swift
protocol SuffixableContainer: Container {
    func suffix(_ size: Int) -> SuffixableContainer
}
```

可以通过在关联类型的约束中使用当前协议来实现这种需求，声明一个关联类型`Suffix`，让其遵循当前协议`SuffixableContainer`，将`func suffix`对返回值声明为`Suffix`类型，同时也可以使用`where`语句加额外约束。如此一来，关联类型`Suffix`作为占位类型，可以放在返回值位置。

```swift
protocol SuffixableContainer: Container {
    associatedtype Suffix: SuffixableContainer where Suffix.Item == Item
    func suffix(_ size: Int) -> Suffix
}
```

如此就可以对某个类进行扩展`SuffixableContainer`协议

```swift
extension Stack: SuffixableContainer {
    func suffix(_ size: Int) -> Stack {
        var result = Stack()
        for index in (count-size)..<count {
            result.append(self[index])
        }
        return result
    }
    // 推断 suffix 结果是Stack。
}
```

## 泛型

### 泛型where约束

`where`子句用来对**关联类型**添加约束，可以在**函数体**或者**类型大括号**之前添加约束。

下面的例子用来判断两个容器内的元素是否相等，不要求容器类型相同，但是要求元素类型相同，且`Equatable`

```swift
func allItemsMatch<C1: Container, C2: Container>
    (_ someContainer: C1, _ anotherContainer: C2) -> Bool
    where C1.Item == C2.Item, C1.Item: Equatable {

        // 检查两个容器含有相同数量的元素
        if someContainer.count != anotherContainer.count {
            return false
        }

        // 检查每一对元素是否相等
        for i in 0..<someContainer.count {
            if someContainer[i] != anotherContainer[i] {
                return false
            }
        }

        // 所有元素都匹配，返回 true
        return true
}
```

### 泛型where子句扩展（条件扩展泛型）

以下代码，当`Stack`中的泛型参数类型`Element`遵循协议`Equatable`时进行扩展：

```swift
extension Stack where Element: Equatable {
    func isTop(_ item: Element) -> Bool {
        guard let topItem = items.last else {
            return false
        }
        return topItem == item
    }
}
```

上面的代码通过增加一个扩展，在extension层面进行约束。也可以在extesion内部对方法进行约束，作用上有点类似`public extension`和`extension { public private }`的区别。

```swift
extension Container {
    func average() -> Double where Item == Int {
        var sum = 0.0
        for index in 0..<count {
            sum += Double(self[index])
        }
        return sum / Double(count)
    }
    func endsWith(_ item: Item) -> Bool where Item: Equatable {
        return count >= 1 && self[count-1] == item
    }
}
```

### 泛型下标

```swift
extension Container {
    subscript<Indices: Sequence>(indices: Indices) -> [Item]
        where Indices.Iterator.Element == Int {
            var result = [Item]()
            for index in indices {
                result.append(self[index])
            }
            return result
    }
}
```

- 在尖括号中的泛型参数 `Indices`，必须是符合标准库中的 `Sequence` 协议的类型。
- 下标使用的参数`indices`，必须是 `Indices` 的实例。
- 泛型 `where` 子句要求 `Sequence（Indices）`的迭代器，其所有的元素都是 `Int` 类型。这样就能确保在序列（`Sequence`）中的索引和容器（`Container`）里面的索引类型是一致的。