[TOC]

# AVPlayer

HLS：HTTP Live Streaming

## 常用类

### CMTime

> 参考资料：https://www.jianshu.com/p/f02aad2e7ff5

AVPlayer使用CMTime结构存储与时间有关的信息，CMTime的结构如下：

```swift
struct CMTime
{
    let value: CMTimeValue   // Int64
    let timescale: CMTimeScale // Int32
    let flags: CMTimeFlags           
    let epoch: CMTimeEpoch       
} 

typealias CMTimeValue = Int64
typealias CMTimeScale = Int32
```

关键成员有`value`、`timescale`，目的是解决由浮点数带来的误差累计，使用`Int32`来存储时间切片单位`timescale`，而value则是在当前时间分片下的时间值。举个例子timescale = 1000则将1s分成1000份，此时若value = 1，则该CMTime代表了精确的1ms；timescale = 600，value = 36000，则该CMTime代表了60s。

### AVAsset

声明播放资源的抽象接口，只存储媒体资源的静态信息，比如时长和创建时间，可以使用AVAsset的init创建不同的子类，比如传入URL创建`AVURLAsset`。

### AVPlayerItem

持有`AVAsset`对象，用于管理`AVAsset`的状态和播放时间，可以观察其**加载状态**（非播放状态）属性`status`，资源未加载为`AVPlayerItem.Status.unknown`，`AVPlayer`需要等待`AVPlayerItem.status`切换为`AVPlayerItem.Status.readyToPlay`才会将该资源加入队列等待播放。

AVPlayerItem的很多属性都可以通过KVO的方式进行监听。

#### 常用方法和属性

- presentationSize可以得到视频播放的resolution

- `status`：用来代表当前媒体资源的加载状态，如果状态为`AVPlayerItem.Status.failed`则可以通过`error`属性获取`Error`对象。

- `duration`：用来获取视频的总时长

- `var loadedTimeRanges: [NSValue]`：用来表明视频中缓冲完成的部分，可能为多个碎片。通过KVO的方式可以获取到`CMTimeRange`类型的对象。

  ```swift
  struct CMTimeRange {
    	let start: CMTime
     	let duration: CMTime
  }
  ```

  当进行seek后，获取到CMTimeRange.start会发生变化，因此即使当缓冲碎片数量为1时也不能仅仅通过range.duration获取缓冲范围，而是应该获取start+duration的方式来得到缓冲区域。

### AVPlayer

用来管理媒体资源的播放和时序，通过`currentItem`获取当前正在播放的Item，可以通过`replaceCurrentItem`方法切换播放对象，同一时刻播放一个`AVPlayerItem`。`AVPlayer`的子类`AVQueuePlayer`可以持有多个Items，从而管理视频序列的播放。

#### 常用方法和属性

- 播放控制方法：`play()`、`pause()`

- 播放器状态：`var timeControlStatus: AVPlayer.TimeControlStatus { get }`

  ```swift
  enum TimeControlStatus {
    case playing
    case paused
    case waitingToPlayAtSpecifiedRate
  }
  ```

  当想要获取播放状态而非加载状态，需要对该变量进行监听，而不是下面的`status`。当播放状态为`waitingToPlayAtSpecifiedRate`时，可以通过`var reasonForWaitingToPlay`获取等待原因。

- `status`：和`AVPlayerItem.Status`内容相同，用来代表当前媒体资源的加载状态，如果状态为`AVPlayerItem.Status.failed`则可以通过`error`属性获取`Error`对象。

- `rate`：播放视频的速度，0.0暂停视频，1.0正常速率
  其他正值有效性需要依赖`AVPlayerItem`的`canPlaySlowForward`、`canPlayFastForward`
  负数有效性依赖`canPlayReverse`、`canPlaySlowReverse`、`canPlayFastReverse`

- `func seek`

  该方法用来改变播放进度，视频进度控制的必备方法，Apple提供了3种实现，每种实现都有其带和不带completionHandler两种。

  - `func seek(to time: CMTime)`

    出于性能考虑，该实现的实际拖动位置可能会有出入，如果对精度要求不高，可以使用。

  - `func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime)`

    该实现增加了`toleranceBefore`参数，表示可以接受的精度损失，实际的拖动范围会在`[time-beforeTolerance, time+afterTolerance]`范围内。该方法**最常用于进度条控制**。

  - `func seek(to date: Date)`

    以Date类型作为seek的目标

- 时间控制

  - `func currentTime() -> CMTime`，获取当前时间

  - 添加周期性监听

    ```swift
    func addPeriodicTimeObserver(forInterval interval: CMTime, 
                           queue: DispatchQueue?, 
                           using block: @escaping (CMTime) -> Void) -> Any
    ```

    参数block为闭包类型，闭包会在`currentItem`的时间发生变化、或者`AVPlayer`播放状态发生变化时被调用，闭包包含一个CMTime参数用来代表当前播放进度。可以用于**改变播放器进度条**，对`AVPlayer`进行每隔1s的监听获取，`interval`可以传递`CMTime(value: 1, timeScale: 1)`

    > 重要：每个`addPeriodicTimeObserver`都需要对应一个`removeTimeObserver`，否则会产生无法预期的结果

- 播放结束后的动作

  ```swift
  enum ActionAtItemEnd {
  	case advance // 播放下一个视频
  	case pause // 在最后一帧暂停
  	case none //黑屏结束
  }
  ```

- `var preventsDisplaySleepDuringVideoPlayback`：播放时是否阻止自动锁屏，默认true

`AVPlayer`是非可视的对象，无法对资源进行呈现，需要依赖`AVPlayerLayer`或者`AVKit`，如果需要添加与`AVPlayerItem`时间同步的动画等，可以使用`AVSynchronizedLayer`

`AVKit`：可以创建`AVPlayerViewController`（iOS、tvOS）、`AVPlayerView`（macOS），这些内置类自带播放控制控件

### AVPlayerLayer

本身继承自CALayer，由单一职责可知，该类只作为展示视频内容的back Layer，不提供任何内置的播放控制控件。

#### 常用方法和属性

- `var videoGravity: AVLayerVideoGravity`，视频在该Layer上的展示方式
  - resizeAspect
  - resizeAspectFill
  - resize
- `var videoRect: CGRect`，视频在当前Layer上的显示区域，通过KVO该属性可以获取视频实际展示的区域，进而在视频区域处**添加水印**。

## 其他

- AVPlayer可以通过URL播放视频和音频，AVAudioPlayer只能播放本地音频



