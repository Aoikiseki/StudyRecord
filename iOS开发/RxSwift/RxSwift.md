[TOC]

# RxSwift

## 同步异步、阻塞非阻塞

RxSwift是简化异步编程的框架，因此首先需要了解同步异步、阻塞非阻塞

> 文章转载自：https://www.zhihu.com/question/19732473

出场人物：老张，水壶两把（普通水壶，简称水壶；会响的水壶，简称响水壶）。

1 老张把水壶放到火上，立等水开。（同步阻塞）

老张觉得自己有点傻

2 老张把水壶放到火上，去客厅看电视，时不时去厨房看看水开没有。（同步非阻塞）

老张还是觉得自己有点傻，于是变高端了，买了把会响笛的那种水壶。水开之后，能大声发出嘀~~~~的噪音。

3 老张把响水壶放到火上，立等水开。（异步阻塞）

老张觉得这样傻等意义不大

4 老张把响水壶放到火上，去客厅看电视，水壶响之前不再去看它了，响了再去拿壶。（异步非阻塞）

老张觉得自己聪明了。

### 所谓同步异步，只是对于水壶而言。（被调用方）

普通水壶，同步；响水壶，异步。

虽然都能干活，但响水壶可以在自己完工之后，提示老张水开了。这是普通水壶所不能及的。

同步只能让调用者去轮询自己（情况2中），造成老张效率的低下。

### 所谓阻塞非阻塞，仅仅对于老张而言。（调用方）

立等的老张，阻塞；看电视的老张，非阻塞。

情况1和情况3中老张就是阻塞的，媳妇喊他都不知道。虽然3中响水壶是异步的，可对于立等的老张没有太大的意义。所以一般异步是配合非阻塞使用的，这样才能发挥异步的效用。

## RxSwift基础

### Observable

> Observable的作用就是用来发出事件序列

创建Observable

```swift
let observable: Observable<Element> = Observable.create { (observer) -> Disposable in
		...
}
```

Observable.create需要传入observer，调用observer的onNext、onError、onCompleted产生Event事件序列：

### Event事件对象

```swift
public enum Event<Element> {
    case next(Element)
    case error(Swift.Error)
    case completed
}
```

### Observer

> Observer用来对Observable事件序列进行响应

创建Observer

1. subscribe

   最简单的方法就是在subscribe设置onNext、onError、onCompleted参数，自动生成Observer

2. AnyObserver

   AnyObserver表示任意观察者，init中接受一个EventHandler参数，即对Event的响应闭包

   ```swift
   let observer: AnyObserver<Int> = AnyObserver { (event) in
       switch event {
       case .next(let data):
       case .error(let error):
       case .completed:
       }
   }
   
   let observable = Observable<Int>.create { (observer) -> Disposable in
       observer.onNext(<#T##element: Int##Int#>)
       return Disposables.create()
   }
   
   observable
       .subscribe(observer)
       .disposed(by: bag)
   ```

3. Binder

   Binder是一个特殊的Observer，遵循两点规则

   - 不处理error事件

   - 默认在主线程bind

   例如UIView的isHidden属性，属于UI观察者，适用Binder


### Observable & Observer

> 还有一些类型，它们既是Observable又是Observer

1. PublishSubject: 只发出订阅后产生的元素
2. BehaviorSubject: 发出当前最新元素，如果没有则发出默认值
3. ControlProperty

```swift
//ControlProperty<CGPoint>
collectionView.rx.contentOffset
//return Observable<Element?>
collectionView.rx.observe(CGPoint.self, "contentOffset")
```



## 问题汇总

### Simultaneous accesses to 0x4c0a3f0f8, but modification requires exclusive access

在使用RxSwift时，对变量`A`进行观测，然后在`A`的订阅方法中调用某个方法`function`，在`function`中通过`self.A`的方式再度获取变量`A`，此时会报这个访问冲突。

解决方法：已经对变量A进行了观测，说明后面会用到这个变量，因此应该通过传参的方式将`A`传递出去。

### 内存泄漏

自己observe自己的属性产生引用循环，造成内存泄漏，例子如下：

```swift
// TestView无法被释放
class TestView: UIView {
    let bag = DisposeBag()
    init() {
        self.rx.observe(Bool.self, #keypath(TestView.isEnable))
            .subscribe(onNext: { [weak self] in
                  //...
             })
            .	disposed(by: bag)
    }
}
```

原因在于使用observe方法创建Observable时，有一个参数retainSelf默认为true

```swift
public func observe<Element>(_ type: Element.Type, _ keyPath: String, options: KeyValueObservingOptions = [.new, .initial], retainSelf: Bool = true) -> Observable<Element?> {
        return KVOObservable(
          object: self.base, 
          keyPath: keyPath, 
          options: options,
          retainTarget: retainSelf
        ).asObservable()
}
```

在创建KVOObservable中，凭借retainSelf变量决定是否持有base的强引用

```swift
private final class KVOObservable<Element>
    : ObservableType
    , KVOObservableProtocol {
    typealias Element = Element?

    unowned var target: AnyObject
    var strongTarget: AnyObject?

    var keyPath: String
    var options: KeyValueObservingOptions
    var retainTarget: Bool

    init(object: AnyObject, keyPath: String, options: KeyValueObservingOptions, retainTarget: Bool) {
        self.target = object
        self.keyPath = keyPath
        self.options = options
        self.retainTarget = retainTarget
      	// 对base的强引用
        if retainTarget {
            self.strongTarget = object
        }
    }
		// ...
}
```

可以看到如果retainSelf设置为false，则只会赋值给一个unowned变量，不影响base被释放

> unowned引用和weak一样，不会增加对象的引用计数，对象被释放后weak变量会标记为nil，而unowned变量由于不是可选类型，无法标记为nil，所以会变成悬挂指针。因此unowned安全的使用方式是确保被unowned标记的对象拥有更长的生命周期。在上面的代码中可以看到在TestView创建了KVOObservable，显然TestView拥有比KVOObservable更长的生命周期，因此被unowned标记是正确的。

该问题的两个解决方法

1. 使用observe，并将retainSelf参数改为false
2. 使用observeWeakly

