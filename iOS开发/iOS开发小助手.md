[TOC]

## CollectionView

### 让collectionView能够占满屏幕（消除顶部自动添加的空白部分）
```swift
if #available(iOS 11.0, *) {
    collectionView.contentInsetAdjustmentBehavior = .never
} else {
    automaticallyAdjustsScrollViewInsets = false
}
```

### collectionView滑动到指定cell（该cell置顶）

需要等待collectionView reload结束执行才有效果

https://stackoverflow.com/questions/45546087/scrolltoitem-does-not-work/45546357

```swift
DispatchQueue.main.async {
  	self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 1), at: .top, animated: true)
}
```

## 强制横竖屏

需要override VC中的三个属性，以强制横屏为例

```swift
public override var shouldAutorotate: Bool {
  	return true
}

public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
  	return .landscapeRight
}

// 声明当前VC支持的方向，以bit mask的形式进行设置（swift中数组形式即可）
public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
  	return .landscape
}
```

## Layer

### 添加圆角
```swift
layer.cornerRadius = 15.0
```

### 添加阴影
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

### 获取文本的外接矩形

```swift
labelSize = title.boundingRect(
  	with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 16),
  	options: NSStringDrawingOptions.usesLineFragmentOrigin,
  	attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)],
  	context: nil
).size
```

## 文本编辑UITextView

### 退出编辑状态

```swift
self.endEditing(true)
```

### 加入placeholder（UITextView默认没有placeholder）

> https://www.jianshu.com/p/9edb8be75e0b

### 设置文字范围（设置边距）

```swift
textView.textContainerInset = .init(top: 15, left: 11, bottom: 30, right: 11)
```

### 通用

#### 退出编辑状态

在编辑框的superview中调用endEditing方法

```swift
self.endEditing(true)
```

### 多行文本框UITextView

## ViewController切换

### present

当执行代码`A.present(B, animated: true)`后

属性presentingViewController：

- 如果A present B modally，则B.presentingViewController == A
- 如果B没有被A present modally，但是B的祖先C被present modally，则该属性被赋为present C modally的VC
- 否则为nil

属性presentedViewController：

- A.presentedViewController == B

利用两个属性可以判断某个VC是否被当前VC所present

```swift
func isPresentedViewController(viewController: UIViewController) {
  	return viewController.presentingViewController.presentedViewController == viewController
}
```

### 在NavigationController中跳转回指定ViewController

#### 场景一：根据条件决定pop回到哪个ViewController

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

#### 场景二：A->B->C，C->A

如果C固定跳转回A，则可以在B->C的push过程中将B自身从navigationController.viewControllers中删掉

```swift
if var viewControllers = self?.navigationController?.viewControllers {
    _ = viewControllers.popLast()
    viewControllers.append(ViewControllerC())
    self?.navigationController?.setViewControllers(viewControllers, animated: true)
}
```

## Audio & Video

### 播放音频

```swift
if let resourceURL = Bundle.main.url(forResource: "testMp3", withExtension: "mp3") {
    let audioPlayer = try? AVAudioPlayer(contentsOf: resourceURL)
    audioPlayer?.play()
}
```

> AVPlayer可以通过URL播放视频和音频，AVAudioPlayer只能播放本地音频

## View的仿射变换

### View镜像、缩放、旋转、平移

```swift
view.transform = CGAffineTransform(scaleX: -1, y: 1) // 水平镜像
view.transform = CGAffineTransform(scaleX: 2, y: 2) // 放大
view.transform = CGAffineTransform(rotationAngle: 1.5) // 旋转
view.transform = CGAffineTransform(translationX: 100, y: 50) // 平移
```

## Date

### 获取当前日期

```swift
let date = Date()
let dateSinceNow = date.timeIntervalSinceNow //创建date的时间与当前时间之差，单位s
let dateSince1970 = date.timeIntervalSince1970 //创建date的时间与1970标准时间之差，单位s
```

### 日期差格式化

```swift
// 得到dateNow与date的时间差
let difference = Calendar.current.dateComponents([.hour, .minute, .second], from: dateNow, to: date)
// 格式化
if 	let hour = difference.hour,
		let minute = difference.minute,
		let second = difference.second
{
    let formattedString = String(format: "%02ld:%02ld:%02ld", hour, minute, second)
    dateLabel.text = formattedString
}
```
## tintColor

tintColor，谷歌翻译为“着色颜色”，是可继承和传递的颜色值。

### 特点

- 如果当前view的tintColor属性为nil，则会自动使用superview的tintColor值
- 如果整个hierarchy中都没有找到非默认的tintColor，则会自动使用系统定义的色调颜色

### 不同控件下tintColor表达不同的含义

- navigation bar、tab bar：按钮上的文字和icon颜色
- text views：选择的指针和文字的高亮颜色
- progress bar：轨迹颜色

> https://www.hackingwithswift.com/example-code/uikit/how-to-set-the-tint-color-of-a-uiview

- **imageView**：UIImageView会将自身的`tintColor`应用到template images上。关于template image，需要了解UIImage的`renderingMode`属性：

  ```swift
  enum RenderingMode {
    	case automatic
    	case alwaysOriginal
    	case alwaysTemplate 
  }
  ```

  - automatic：使用上下文的默认设置

  - alwaysOriginal：使用原图片，不改变图片的颜色信息

  - alwaysTemplate：忽略图片原本的颜色信息，作为模板图片，此时hierarchy中的`tintColor`可以修改图片本身的颜色，但不会修改`backgroundColor`

    > 注：这一特性特别适合单色图片的颜色修改，无需增加额外切图，减少包体积

  > https://www.jianshu.com/p/8d91c59bb62d

