> https://www.raywenderlich.com/16126261-instruments-tutorial-with-swift-getting-started

Call Tree

- Separate by State
- Separate by Thread：常用选项
- Invert Call Tree：常用选项
- Hide System Libraries：常用选项
- Flatten Recursion：显示递归function
- Top Functions：计算一个function耗时，包括该function以及其调用的其他functions

## 符号表设置

- 打开Xcode，确保设置正确build settings-build option-Debug Information Format：设置为`DWARF with dSYM File`

- 找到符号表路径，一般为如下地址

  `/Users/YourUserName/Library/Developer/Xcode/DerivedData/YourProjectName/Build/Products/<mode>-iOS/YourProjectName.app.dSYM`

- 打开instruments-File-Symbols，选中工程，点击`Locate`手动指定符号表

- 过程中可以先clean再build一下项目

## Time Profiler

## Allocations

内存相关的问题主要有两个：

- Memory Leak
- 无限制的内存增长：比如对资源进行缓存，但是忘记释放

关注`All Heap & Anonymous VM`，使用`Mark Generation`在时间轴做标记

### 无限制的内存增长

处理内存增长问题，主要使用generation analysis，以及使用Mark Generation获取瞬时的Generations信息。使用Growth进行排序可以找到内存增长大户，然后进行处理。

#### 模拟内存警告（Memory Warning）

两种方式：

- Instruments：`Document->Simulate Memory Warning`
- Simulator：`Debug->Simulate Memory Warning`

Memory Warning告知app内存紧缺，需要进行一些释放

### Memory Leak

处理Memory Leak问题，主要关注内存中存在的对象个数，将栏目调到statistics，然后可以根据项目名称加一些过滤字段获取感兴趣内容。
内容包含`#Persistent`和`#Transient`，前者是对象个数，后者是已经被释放掉的对象个数。通过这两个值可以大致确定哪些对象引起的Memory Leak。

然后使用Xcode工具`Debug Memory Graph`查看每个对象被引用的信息。比较常见的比如`Swift closure context`然后点击箭头在右侧面板中发现`Type = strong`即被闭包强引用。