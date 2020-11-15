[TOC]

## 让collectionView能够占满屏幕（消除顶部自动添加的空白部分）

```swift
if #available(iOS 11.0, *) {
    collectionView.contentInsetAdjustmentBehavior = .never
} else {
    automaticallyAdjustsScrollViewInsets = false
}
```

## 添加圆角

```swift
layer.cornerRadius = 15.0
```

## 添加阴影

```swift
layer.shadowColor = UIColor.black.cgColor
layer.shadowOpacity = 0.04
layer.shadowOffset = .init(width: 0.0, height: 5.0)
layer.shadowRadius = 10.0
```

### 阴影没有正常显示？

1. 由于阴影是加在view外面的，所以需要确保当前view的`layer.masksToBounds = false`（默认为false）
2. 如果当前view在superview的外面，为了保证view正常显示，还需要设置`superview.clipsToBounds = false`
3. 需要确保当前`view.backgroundColor != .clear`
4. 如果是UIImageView，没有手动设置过`backgroundColor`，则只有图片正常显示出来才会显示阴影

## 文本和字符串

### UILabel显示多行文本

```swift
label.lineBreakMode = .byWordWrapping
label.numberOfLines = 0
```

### 可读性更高的多行String

```swift
let multilineString = "first line\nsecond line\nthird line" 
let betterMultilineString = [
  "first line",
  "second line",
  "third line"
].joined(separator: "\n")
```

### 设置UILabel中部分文字的属性

```swift
if let fullTitleString = label.text {
    label.textColor = .white
    let rangeOfColoredString = (fullTitleString as NSString).range(of: keyString)
    let attributedString = NSMutableAttributedString(string: fullTitleString)
    attributedString.setAttributes([NSAttributedString.Key.foregroundColor: UIColor.yellow], range: rangeOfColoredString)
    label.attributedText = attributedString
}
```

## 页面切换

### 场景一：根据条件决定pop回到哪个页面

一般来说开发中不会对同一个ViewController类进行多次push，因此可以以类类型作为pop依据

```swift
if let viewControllers = self.navigationController?.viewControllers {
    for viewController in viewControllers {
        if viewController.isKind(of: isUnitFinalWord ? LiteracyHomeViewController.self : LiteracyWordMapViewController.self) {
          self.navigationController?.popToViewController(viewController, animated: true)
          break
        }
    }
}
```

### 场景二：A->B->C，C->A

如果C固定跳转回A，则可以在B->C的push过程中将B自身从navigationController.viewControllers中删掉

```swift
if var viewControllers = self?.navigationController?.viewControllers {
    _ = viewControllers.popLast()
    viewControllers.append(ViewControllerC())
    self?.navigationController?.setViewControllers(viewControllers, animated: true)
}
```

