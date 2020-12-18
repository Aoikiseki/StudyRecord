# Animation

### 动画组

https://www.jianshu.com/p/1a2ad3711726

### 核心动画

https://www.jianshu.com/p/d05d19f70bac

https://juejin.im/post/6844903762364989448

https://www.jianshu.com/p/a079a9bb20f9

https://www.jianshu.com/p/f2def3da931f

### 动画之间设置延迟

https://www.coder.work/article/416046

### 关键帧动画

http://i-swift.ir/en/blog/2018/11/16/keyframe-animations/

### 基础知识

单一责任：UIView持有CALayer，UIView负责创建和管理CALayer、处理用户交互，CALayer负责显示内容

LayerTree？PresentationTree？RenderTree？

Hit test调用顺序：touch -> UIApplication -> UIWindow -> UIViewController -> UIView -> subview -> 合适的view

事件传递顺序刚好相反：如果当前view无法处理，则交给superview处理，到UIApplication都无法处理则丢弃

UIView什么时候不响应事件？

1. view.userInteractionEnabled = false
2. view.isHidden = true
3. view.alpha < 0.05
4. view.bounds超过superview

因此在自己写hittest的时候**必须**首先将上面1～3考虑到，然后递归subview判断，首先进行point的坐标转换，将point转换为每个subview的坐标系，然后调用subview的hittest，最后如果为nil说明当前point不在当前view下。

应用场景：事件穿透

子view的bounds超出了superview，但是还想触发点击事件

### 属性动画CAPropertyAnimation

CAPropertyAnimation、CATransition、CAAnimationGroup都是CAAnimation子类，其中CATransition是苹果封装好的动画，可以直接用

CAPropertyAnimation通过修改属性完成动画，常用的CABasicAnimation和CAKeyframeAnimation都是属性动画

通过修改属性

```swift
let animation = CABasicAnimation()
animation.kayPath = "position.y"
animation.toValue = 400
```

| 属性                | 含义                                                         |
| ------------------- | ------------------------------------------------------------ |
| keyPath             | 需要修改的属性值，字符串形式                                 |
| toValue             | 对于keyPath的值，在当前值基础上的偏移量                      |
| duration            | 持续时间                                                     |
| removedOnCompletion | 动画结束后是否移除，默认true                                 |
| fillMode            | `forwards`：动画结束后，layer保持动画最后的状态<br />`backwards`：动画开始前，就会进入动画第一帧的状态<br />`both`：`forwards` & `backwards`<br />`removed`：动画结束后对原始的layer没有影响，直接移除 |
|                     |                                                              |
|                     |                                                              |
|                     |                                                              |
|                     |                                                              |

对于一个View依据不同环境要进行不同动画，可以先创建出所有的animation，通过参数判断add哪一个animation

keyPath list: https://stackoverflow.com/questions/44230796/what-is-the-full-keypath-list-for-cabasicanimation

### 动画结束后复原问题

确保下面两个属性设置正确

```swift
animation.removedOnCompletion = false
animation.fillMode = .forwards
```

动画是在PresentationTree中进行移动，当移动完如果`removedOnCompletion = true`则动画消失，原始的Layer显示出来，因此动画结束后会回到原先的位置

### 隐式动画

`CATransaction`用来控制隐式动画，该类型只有类方法，使用方式类似数据库：

1. CATransaction.begin
2. 修改隐式动画的属性（比如持续时间）
3. 加入目标动画（比如改变颜色）
4. CATransaction.commit

```swift
CATransaction.begin
CATransaction.setAnimationDuration = 1.0
/*
在此处加入想要执行的动画
*/
CATransaction.commit
```

### CGAffineTransform

https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/83-%E5%88%A9%E7%94%A8-cgaffinetransform-%E7%B8%AE%E6%94%BE-%E4%BD%8D%E7%A7%BB%E5%92%8C%E6%97%8B%E8%BD%89-e061df9ed672

### 判断是什么设备

```swift
UIDevice.current.model == "iPad"
```

### 镜像翻转动画

```swift
let animationMirror = CABasicAnimation(keyPath: "transform.scale.x")
animationMirror.beginTime = 1.0
animationMirror.toValue = 1
animationMirror.duration = 0.1
animationMirror.fillMode = .forwards
animationMirror.isRemovedOnCompletion = false
animations.append(animationMirror)
```

### 小车动画重复的动画被覆盖了（比如两次RightDown）？

layer.add(​ : key:)key设置为nil即可，否则动画会被覆盖

### 增加动画后，无法触发点击事件，看options参数

```swift
UIView.animateKeyframes(withDuration: , delay: , options: , animations: , completion: )
```

PS：是否递归？