> https://www.raywenderlich.com/5370-grand-central-dispatch-tutorial-for-swift-4-part-1-2

DispatchQueue

串行：顺序执行，顺序结束
并行：顺序执行，乱序结束

Main queue：主线程串行
Global queue：系统共用的并行队列
Custom queue：可以指定串行和并行

同步Queue：任务执行结束后，将控制权返回给调用者

```swift
DispatchQueue.sync(execute:)
```

异步Queue：立即返回，不会阻塞当前线程

```swift
DispatchQueue.async(execute:)
```

