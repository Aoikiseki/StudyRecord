> https://my.oschina.net/SwiftOldDriver/blog/4635805
>
> WWDC：https://developer.apple.com/videos/play/wwdc2020/10652/
>
> 百度**《WWDC20 内参》**系列文章

## 访问相册

- 权限增加`limited`，弹窗也有适配

- 相册访问方式分为`addOnly`和`readWrite`方式

- 对于`readOnly`，Apple推出`PHPicker`，比如`PHPickerViewController`

  优点如下：

  - PHPicker 是**独立进程**，不影响 APP 的性能表现
  - PHPicker **不需要用户授予权限**就可以选择用户所有的资源
  - PHPicker 支持多选