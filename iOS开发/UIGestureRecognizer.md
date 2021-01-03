# UIGestureRecognizer

> 在gestureRecognizer出现之前，想要对手势进行跟踪，需要先在UIView中注册`touchesBegan`, `touchesMoved`、 `touchesEnded`通知，使用起来比较繁琐。从iOS3.0开始，Apple引入了更好用的gestureRecognizer来监测手势，比如tap、pinch、rotate、pan等。

## 基本使用方法

- 创建`UIGestureRecognizer`的**具体子类**对象，指定action function
- 将gesture添加到view
- 编写action function
  - 通过gesture.view来获取发生手势事件的view引用
  - 通过gesture获取手势信息
  - 编写响应算法
  - 每次action处理完，将gesture的偏移量清零，否则会进行累积

https://www.raywenderlich.com/6747815-uigesturerecognizer-tutorial-getting-started

```swift
let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler))
contentView.addGestureRecognizer(gestureRecognizer)

@objc
func panGestureHandler(_ gesture: UIPanGestureRecognizer) {
    // 1.得到gesture发生的view
  	guard let gestureView = gesture.view else {
        return
    }
  
  	// 2.从gestrue得到想要的信息
    let translation = gesture.translation(in: view)
    
  	// 3.使用gesture信息对view进行修改
    gestureView.center.y = gestureView.center.y + translation.y

    if gesture.state == .ended {
        self.animator.addAnimations {
            if gestureView.frame.minY < 100 {
                self.changeContentViewHeight(to: .Full)
            } else if gestureView.frame.minY < self.view.frame.height / 2 {
                self.changeContentViewHeight(to: .Half)
            } else {
                self.changeContentViewHeight(to: .Zero)
            }
            self.view.window?.layoutIfNeeded()
        }
        self.animator.startAnimation()
    }
  
  	// 4.重置gesture
    gesture.setTranslation(.zero, in: view)
}
```

