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