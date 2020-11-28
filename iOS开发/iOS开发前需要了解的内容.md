[TOC]

在进行iOS开发前，需要对一些常见词汇有一些基本认知

## 原生框架Cocoa And CocoaTouch

> 简言之，Cocoa是macOS上原生的API集合，CocoaTouch则是iOS上的原生API集合

### Cocoa

Cocoa是macOS上的原生API集合。注意集合二字，Cocoa内部包含很多framework，每个framework都包含一系列的API，最常见的framework就是Foundation Kit、Application Kit以及Core Data。framework类似动态链接库，动态链接库能够在运行期被加载进程序的地址空间，而framework则是会添加关联的资源、头文件以及文档。Cocoa的主要framework如下：

- Foundation Kit：Foundation是一个通用库，提供类似字符串、值操作，容器和迭代，分布式计算，事件循环以及其他和**用户界面无关**的方法，Foundation中的类最大的特点就是全部以`NS`开头。
- Application Kit：Application Kit处于Foundation Kit的上游，用于提供编写用户界面的API，与Foundation一样也是以NS作为类名的开头。
- Core Data：可以用于数据的持久化，也可以用来缓存短期数据，也可以在设备上向app添加撤销功能，等等。
- ...

Cocoa专门用于macOS的程序开发，而iOS开发也有一套相似的API集合Cocoa Touch。

### Cocoa Touch

Cocoa Touch是iOS上的原生API集合。Cocoa Touch是基于Cocoa实现，增加了iOS设备的硬件和功能，包含Foundation Kit、UIKit以及Core Data三个主要框架。在iOS开发中比较常接触到的framework如下

- Foundation Kit
- UIKit
- EventKit UI
- Nitification Center
- Core Data
- ...

![Cocoa](/Users/yuanhao/Desktop/Cocoa.webp)

<center>Cocoa Touch</center>

### 参考文章

- https://en.wikipedia.org/wiki/Cocoa_(API)

- https://developer.apple.com/documentation/coredata

## 响应式编程RxSwift、RxCocoa

> 文章主要摘自https://cloud.tencent.com/developer/news/696683

原生框架的API很多时候开发效率并不尽人意，不光体现在API的可读性和易用性上，也体现在命令式编程和响应式编程的差异上，对于命令式编程和响应式编程，wiki上有一个生动的例子：

> 对于命令式编程，当a = b + c，a由b+c计算得到；但是之后，b和c发生了变化，这个变化对a并不生效，a还是保持原有的值；而当使用响应式编程时，当b和c发生变化，程序不需要再次执行a = b + c公式，a的值就会自动更新。

在实际的响应式开发中，我们并不需要手动存储和监听值是否被更新，而是将监听值变化的工作交给他人来做，甚至可以预先设定好当该值发生变化时要执行那些动作，这样当值发生了改变后就可以自动执行一系列动作，实现自动化，大大提升开发效率。

目前响应式编程库主要分为两派

- ReactiveX主导的rx系列库，语言支持如RxSwift, RxKotlin, 平台支持如RxAndroid, RxCocoa
- ReactiveCocoa(GitHub发起)库，语言仅支持swift，objective-c，平台仅支持iOS

本人在工作中，主要接触到的是前者，即RxSwift和RxCocoa。一个是Rx在Swift语言上的扩展，另一个是Rx在Cocoa平台的扩展：

- RxSwift：响应式编程在Swift语言上的实现库
- RxCocoa：针对Cocoa平台（iOS & Mac）的响应式编程库

