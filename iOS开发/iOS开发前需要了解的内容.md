[TOC]

# iOS开发新手上路

> 在进行iOS开发前，需要对一些常见词汇有一些基本认知
>

## 原生框架Cocoa & CocoaTouch

> Cocoa是macOS上原生的API集合，CocoaTouch则是iOS上的原生API集合

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

## Cocoapods

> CocoaPods is a dependency manager for Swift and Objective-C Cocoa projects. 

CocoaPods是swift和oc的依赖管理工具，用来管理项目中依赖的第三方库和本地库的版本，也可以用来安装依赖。Cocoapods基于Ruby，而官方推荐使用MacOS自带的Ruby即可。

### 安装

`sudo gem install cocoapods`

### 使用

- `pod init`

  Cocoapods提供的初始化方法，init后在项目目录下生成`Podfile`，我们需要在`Podfile`中填写需要管理的依赖项

- `Podfile`

  `Podfile`书写例子如下
  可以用`'~> x.x'`指定从远端拉取的**最小**版本，一般不指定到第二个小数点，因为CocoaPods会忽略第二个小数点。
  也可以用`:path => './xxx/yyy'`指定使用本地版本

  ```swift
  platform :ios, '8.0'
  use_frameworks!
  
  target 'MyApp' do
    pod 'AFNetworking', '~> 2.6'
    pod 'ORStackView', '~> 3.0'
    pod 'LocalDepdency', :path => './Vendor/LeoUI'
  end
  ```

- `pod install`

  安装依赖项，安装后目录下生成`.xcworkspace`的项目启动器，替代`.xcodeproj`

## 观察者设计模式

> Observer pattern is used for one-to-many communication.Subject-object automatically notifies its observers about given state change or an event.

观察者设计模式监听被观察对象的状态，状态发生变化后通知观察者执行对应的action，是iOS开发中经常用于两个对象间数据通信的设计模式，举一个银行卡的例子如下：

> 我们办理的银行卡，如果没有与手机绑定，每次想查询余额都要到银行的ATM机操作一番，这就是轮询。如果与手机/微信绑定，每次账户余额发生变动，都会以短信/微信消息的方式通知我们，这就用到了观察者模式。

iOS原生框架中对于观察模式有两种实现，即KVO和NotificationCenter

### KVO（Key-value observing）与RxSwift

> Key-value observing is a mechanism that allows objects to be notified of changes to specified properties of other objects.

原生的KVO使用略显繁琐，这里不做介绍，而是要说一下提供了更好用的KVO的第三方库RxSwift。RxSwift可以非常简单地将一个变量包装为可被观察的对象即Observable，进而在需要监听变量变化的地方创建观察者即Observer，在Observer中提供针对变量变化时的actions。RxSwift中的KVO使用起来为如下两步：

- 将待观察变量声明为Observable
- 在监听的地方创建Observer

### NotificationCenter

NotificationCenter是以广播的方式发布一则通知，每则通知都会首先传递给Center，由Center进行派发给所有监听这一通知的对象，一同派发的还有这则通知附带的自定义内容。NotificationCenter的大致使用可以分为如下几步：

- 定义通知
- 监听通知
- 发布通知

### NotificationCenter vs KVO

NotificationCenter的缺点是必须显式定义通知、显式发布通知，优点是可以跨很多层进行数据通信，因此在本人日常开发中，经常在需要跨多个ViewController进行数据传输的场景使用NotificationCenter。

而KVO则需要在创建监听的地方能够访问到被监听的变量，因此难以完成跨越多层的数据通信，在iOS开发中经常被用在View-ViewModel之间的数据通信。

### 参考文献

- https://dmcyk.xyz/post/kvo-rx-nc-benchmarks/kvo-rx-nc-benchmarks/
- https://cloud.tencent.com/developer/news/696683
- https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/KeyValueObserving/KeyValueObserving.html

## iOS开发基础知识

每个UIView都有一个图层CALayer，CALayer负责渲染视图，UIView负责其他任务，比如对点击事件做出响应

`frame`：视图大小以及在父View中的位置

ViewController中的view是延时加载，只有需要用到的时候才会创建

使用`UIScreen.main.bounds`得到的屏幕尺寸不对?
应该是删除了plist中的`Launch screen interface file base name`，加回来就好了

LayoutGuide的snapkit用法

```swift
make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
```

