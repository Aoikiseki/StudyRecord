[TOC]

# Cocoapods

> CocoaPods is a dependency manager for Swift and Objective-C Cocoa projects. 

CocoaPods是swift和oc的依赖管理工具，用来管理项目中依赖的第三方库和本地库的版本，也可以用来安装依赖。Cocoapods基于Ruby，而官方推荐使用MacOS自带的Ruby即可。

## 安装

`sudo gem install cocoapods`

## 使用

- `pod init`

  Cocoapods提供的初始化方法，init后在项目目录下生成`Podfile`，我们需要在`Podfile`中填写需要管理的依赖项

- `Podfile`

  `Podfile`书写例子如下
  可以用`'~> x.x'`指定从远端拉取的版本，有关`~>`符号代表的意思以及版本控制的更多细节可以查看**常用描述符**一节

  ```swift
  platform :ios, '8.0'
  use_frameworks!
  
  target 'MyApp' do
    pod 'AFNetworking', '~> 2.6'
    pod 'ORStackView', '~> 3.0'
    pod 'LocalDepdency', :path => './Vendor/LeoUI'
  end
  ```

- `pod install`

  安装依赖项，安装后目录下生成`.xcworkspace`的项目启动器，替代`.xcodeproj`

## 创建自己的Pod

有时候我们想要使用pod在远端管理我们自己开发的依赖项，但是CocoaPods尚未收录我们的依赖项，无法使用`pod install`完成自动安装，这就需要创建一个Pod

```swift
$ pod spec create Peanut
$ edit Peanut.podspec
$ pod spec lint Peanut.podspec
```

还可以向CocoaPods Trunk提交Pod，有关Trunk的细节见后面小节

## PodSpec（Specification）

> A specification describes a version of Pod library. It includes details about where the source should be fetched from, what files to use, the build settings to apply, and other general metadata such as its name, version, and description.

PodSpec用来管理Pod库的版本、Pod库从哪里获取、需要的配置等等，官方给出的一份简单的Spec文件内容如下：

```swift
Pod::Spec.new do |spec|
    spec.name         = 'Reachability'
    spec.version      = '3.1.0'
    spec.license      = { :type => 'BSD' }
    spec.homepage     = 'https://github.com/tonymillion/Reachability'
    spec.authors      = { 'Tony Million' => 'tonymillion@gmail.com' }
    spec.summary      = 'ARC and GCD Compatible Reachability Class for iOS and OS X.'
    spec.source       = { :git => 'https://github.com/tonymillion/Reachability.git', :tag => 'v3.1.0' }
    spec.source_files = 'Reachability.{h,m}'
    spec.framework    = 'SystemConfiguration'
end
```

上述Spec描述了我们的Pod库`Reachability`通过Git从`https://github.com/tonymillion/Reachability.git`获取，取`tag = v3.1.0`版本，我们使用上一节提到的`pod spec create Reachability`命令即可自动生成这样一份PodSpec文件。

## Pod Install vs Pod Update

`pod install`

- 对于`Podfile.lock`中已有的依赖项，`pod install`会下载指定版本的依赖项，而不去检查是否有新版本
- 对于`Podfile.lock`中没有的依赖项，`pod install`会根据`Podfile`下载匹配的版本，并添加进`Podfile.lock`

`pod update`

- `pod update XXX`会无视`Podfile.lock`中锁住的版本，将XXX升级至符合`Podfile`描述后的最新版
- `pod update`则会尝试更新所有依赖项

## 常用描述符

在`Podfile`中可以看到有`:path =>`和`~>`之类的描述符，下面会列出本人日常开发中常用的描述符

- 版本控制

  **logic operator**

  `> 0.1`、`>= 0.1`、`< 0.1`、`<= 0.1`

  **optimistic operator**

  `~> 0.1.2`：取0.1.2~0.2左闭右开

  `~> 0.1`：取0.1~1.0左闭右开

  `~> 0`：取0～1.0左闭右开

- 来源控制

  **Using Git**

  `:git => xxx.git`

  `:git => xxx.git, :branch => 'dev'`

  `:git => xxx.git, :tag => '1.3.0'`

  `:git => xxx.git, :commit => '0f506b1c45'`

  **Using Local**

  `:path => '~/Documents/Alamofire'`

  注：使用本地pod时，对该pod进行任何修改，在主工程执行`pod install`后都会看到此修改已生效

  **Others**

  `:podspec => './XXX/MMM.podspec'`

  `:modular_headers => false`

  `:configurations => ['Debug', 'DebugInHouse', 'InHouse']`

## Test Pod

## Trunk