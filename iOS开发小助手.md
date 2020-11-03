[TOC]

## 让View能够占满屏幕（消除顶部自动添加的空白部分）

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

