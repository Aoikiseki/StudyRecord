## 触发时机

> https://stackoverflow.com/questions/728372/when-is-layoutsubviews-called
>
> https://juejin.cn/post/6844903897073451022

- init不会触发layoutSubviews
- addSubview会触发以下layoutSubviews
  - addSubview的参数方，即subview
  - addSubview调用方，即superview
  - addSubview参数方的所有subviews
- bounds（包括frame中的size）变化
- UIScrollView滚动，造成bounds的变化，触发
  - superview的layoutSubviews
  - scrollView的layoutSubviews
- 旋转屏幕，触发superview.layoutSubviews
- 对view进行resize，触发superview.layoutSubviews

