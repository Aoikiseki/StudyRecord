# Bundle

> Bundle是硬盘中包目录下的代码和资源集合体

苹果使用`Bundle`来描述一个app、一个framework、一个plugin等等。

bundle使用子目录结构来管理内部的资源，实现方式因平台而异，但是开发者无需关注bundle的内部结构。

Bundle的使用大致分为如下三个步骤

1. 创建指定目标的Bundle objcet
2. 使用Bundle的方法定位资源
3. 使用系统API对资源进行交互（访问资源）

## 创建Bundle object

在定位资源文件前，需要指定一个Bundle，最常用的就是`main`。`main`为当前运行中的代码所在的Bundle，对于一个app，可以通过`main`访问app的所有资源。如果你的app和其他的framework、plugins有交集，那么可以使用Bundle的其他方法创建framework、plugins的Bundle实例去访问它们的资源。

```swift
// Get the app's main bundle
let mainBundle = Bundle.main

// Get the bundle containing the specified private class.
let myBundle = Bundle(for: NSClassFromString("MyPrivateClass")!)
```

## 使用Bundle的方法定位资源

```swift
// Get resource`s URL
Bundle.main.url(forResource: String?, withExtension: String?) 
// Get resource`s path String
Bundle.main.path(forResource: String?, ofType: String?) 
注：项目的Build Phases -> Copy Bundle Resources中必须包含要查找的文件 
```

## Bundle和Asset的关系？