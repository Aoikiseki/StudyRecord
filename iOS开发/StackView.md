## 基本使用

UIStackView可以根据属性以及内容生成自己的宽高，因此不需要手动设置宽高约束，只需要设置其位置约束即可。一些简单的单方向布局使用StackView会非常简单

```swift
// StackView：横向排列，等间距20，纵向为中心对齐
stackView.axis = .horizontal
stackView.distribution = .equalSpacing
stackView.spacing = 20
stackView.alignment = .center

button.snp.makeConstraints { (make) in
    make.height.equalTo(40)
}
stackView.addArrangedSubview(button)
button2.snp.makeConstraints { (make) in
    make.height.equalTo(60)
}
stackView.addArrangedSubview(button2)
button3.snp.makeConstraints { (make) in
    make.height.equalTo(80)
}
stackView.addArrangedSubview(button3)
button4.snp.makeConstraints { (make) in
    make.height.equalTo(100)
}
stackView.addArrangedSubview(button4)
```

