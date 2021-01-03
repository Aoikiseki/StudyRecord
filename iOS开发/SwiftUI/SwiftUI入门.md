# SwiftUI入门

> https://developer.apple.com/videos/play/wwdc2020/10119/

## List

List内可以只创建若干没有数据驱动的View，也可以通过数据驱动创建内容

- No Data Driven

  ```swift
  List(0 ..< 5) { item in
     VStack(alignment: .leading) {
         Text("Hello, world!")
         		.padding()
         HStack {
             Image(systemName: "photo")
             Text("test")
             .font(.headline)
             .foregroundColor(.secondary)
         }
     }
  }
  ```

- Data Driven

  data driven首先需要需要确保自己的数据结构实现了`Identifiable`协议，并在内部包含一个`var id = UUID()`，这等于告诉SwiftUI数据从哪里来，以及如何使用

  ```swift
  struct Gun: Identifiable {
      var id: UUID()
      let name: String
      let length: Int
      let bulletSize: Float
      let bulletVelocity: Float
      let imageName: String
  }
  ```



## View

swift中的View都继承自`View`协议，View的实现都是`struct`值传递，每个View中都有一个`var body {}`来表示这个View实体

## DataFlow

![image-20201216000414484](/Users/yuanhao/Library/Application Support/typora-user-images/image-20201216000414484.png)

- Source of Truth：view需要依赖的数据源
- Derived Value

### @State 

SwiftUI可以识别并观察被`@State`标记的变量，当该变量被读写时会引发对应View的重新绘制，by asking new body
被`@State`标记的变量称为Source of Truth，使用到该变量的对象被称为Derived Value

### @Binding

SwiftUI中都是`值传递`，通过@Binding可以达到`引用传递`的效果。

https://vmanot.com/data-flow-through-swiftui



忽略safearea：使用modifier`edegesIgnoringSafeArea`

在swiftUI中默认使用natural size，即intrinsic size初始化View的大小，在此基础之上设止backgroundColor就是对该片区域进行设置



NavigationView中关闭视图

```swift
/// 在View中先声明
@Environment(\.presentationMode) var presentationMode
///在合适的地方调用
presentationMode.wrappedValue.dismiss()
```





- 修bug：自定义输入
- build：列出build参数可填写+按钮
- custom：输入框+按钮
- history：拉取最近一个或多个历史URL，jekins拉取
- bug cell样式改成对勾