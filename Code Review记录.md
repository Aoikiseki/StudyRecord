### 较长函数的缩进

```swi
NotificationCenter.default.addObserver(
    self,
    selector: #selector(countInMainIncrement),
    name: LessonListViewController.countInMainIncrementNotification,
    object: nil
)
```

1. 每个参数单独成一行
2. 括号尾部和调用处的开头对齐

### 二维数组转一维数组

```swift
let ret = array.map({
    $0.reduce("") {
        if $1 == 0 {
            return $0 + "    "
        } else {
            return $0 + String(format: "%4d", $1)
        }
    }
})

let ret = array.map({ (subArray: [Int]) in
    subArray.map({ (element: Int) in
        if element == 0 {
            return "    "
        } else {
            return String(format: "%4d", element)
        }
        }).joined()
})
```

### delegate协议命名规范

1. 协议中指明Delegate的被代理类，例如UITableView的代理类应该声明为UITableViewDelegate

2. 方法的第一个参数应该为被代理对象，比如UITableView中的方法，第1个参数就是tableView传入被代理对象

   ```swift
   func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
   ```

3. 方法的命名需要符合动作要求，比如LessonReferenceViewControllerDelegate协议中描述了该ViewController will dismiss时要触发的事件，那么被代理的方法应该命名为

   ```swift
   func lessonReferenceViewWillDismiss(_ viewController: LessonReferenceViewController, type: String)
   ```

### 变量命名规范

1. 遵循驼峰
2. 缩写变量名部分要全大写，比如ID、API，如果缩写的位置在开头的话还是要id、api