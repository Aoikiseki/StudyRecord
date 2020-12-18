# AVPlayer

### 视频播放

HLS：HTTP Live Streaming

KVO：Key-value observing

`AVAsset`

声明播放资源的抽象接口，只存储媒体资源的静态信息，比如时长和创建时间，可以使用AVAsset的init创建不同的子类，比如传入URL创建`AVURLAsset`

`AVPlayerItem`

持有`AVAsset`对象，用于管理`AVAsset`的状态和播放时间，可以观察其加载状态属性`status`，资源未加载为`AVPlayerItem.Status.unknown`，`AVPlayer`需要等待`AVPlayerItem.status`切换为`AVPlayerItem.Status.readyToPlay`才会将该资源加入队列等待播放

`AVPlayer`

用来管理媒体资源的播放和时间，通过`currentItem`获取当前正在播放的Item，可以通过`replaceCurrentItem`方法切换播放对象，同一时刻播放一个`AVPlayerItem`。`AVPlayer`的子类`AVQueuePlayer`可以持有多个Items，从而管理视频序列的播放。

`rate`：播放视频的速度，0.0暂停视频，1.0正常速率

其他正值有效性需要依赖`AVPlayerItem`的`canPlaySlowForward`、`canPlayFastForward`

负数有效性依赖`canPlayReverse`、`canPlaySlowReverse`、`canPlayFastReverse`

`AVPlayer`是非可视的对象，无法对资源进行呈现，需要依赖`AVPlayerLayer`或者`AVKit`，如果需要添加与`AVPlayerItem`时间同步的动画等，可以使用`AVSynchronizedLayer`

`AVKit`：可以创建`AVPlayerViewController`（iOS、tvOS）、`AVPlayerView`（macOS），这些内置类自带播放控制控件

`AVPlayerLayer`

只提供对视频内容的展示，不提供任何内置的播放控制控件，可以用于创建自定义的播放界面

### AVPlayer可以通过URL播放视频和音频，AVAudioPlayer只能播放本地音频

### AVPlayerLayer

- 通过`videoRect`属性可以获取视频实际展示的区域

### AVPlayerItem

- 通过presentationSize可以得到视频播放的resolution

### CMTime

AVPlayer中使用的时间单位都是CMTime，CMTime构造方法包含两个值，value和timescale，可以简单理解二者：

- timeScale：将1s切分成多少个单位时间，比如timescale=600，则此时`单位时间`就是1/600
- value：`单位时间`个数，而不是帧数

假如读取了一个视频，得知其长度即`duration`属性为`CMTime(36000, 600)`，那么可知这里将1s切分为600个`单位时间`，而视频总长度为36000个`单位时间`，即总长度为60s。

timescale有何意义？为了减少浮点数产生的误差累计，更精确地表达时间

> https://www.jianshu.com/p/f02aad2e7ff5