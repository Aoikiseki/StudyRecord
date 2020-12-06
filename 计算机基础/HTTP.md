[TOC]

# HTTP

> HTTP是基于TCP协议实现的超文本传输协议

## HTTP的特点

- C/S模式：客户端主动发出请求，服务端给予回应
- 简单快速：只需要传输路径和请求方法
- 灵活：通过Content-Type标识，允许传输任意数据类型
- **无连接**：与UDP的无连接不同，这里的无连接的意思是每个HTTP连接只处理一个请求。
  随着网页越来越复杂，这种处理方式效率低下，开始使用`Connetcion: keep-alive`字段保持**TCP**连接不断开
- **无状态**：对事务的处理没有记忆能力，服务端不会记录客户端状态，这次请求依赖上次的请求仍然需要重传。
  目前有cookie和session两种方式提高传输效率

## URI、URL、URN

- URI：统一资源标识符。可以对网络中的资源进行标识，使得资源之间能够被区分。
- URL：统一资源定位符。对某一资源提供了具体的访问地址和访问方式。

显然URI >= URL，能够提供具体访问方式的资源都是URI，但是并不是所有URI都提供了访问方式 。HTTP请求中请求的是URI，但是由于绝大部分情况都是根据资源地址进行请求，所以大部分时候也是URL。

## HTTP的报文结构

### 请求报文

![image-20201115184052614](/Users/yuanhao/Library/Application Support/typora-user-images/image-20201115184052614.png)

上面图示的报文头包含了比较常用的报文头字段，只是所有报文头字段的一部分，报文头字段总体可以分为通用报文头、请求报文头、响应报文头和实体报文头四类，在HTTP/1.1中一共规范了47种报文头字段。

下面对比较常用的字段进行说明

- ACCEPT：浏览器端可以接受的媒体类型。比如text/html就是可以接受服务端返回的text/html类型，如果服务端没有对应类型，则返回406错误；而\*/\*代表浏览器可以接受所有类型。
- Connection：`keep-alive`代表TCP连接不关闭，`close`代表TCP连接在一次请求后就会关闭。
- Refer：告诉服务端，是从哪个页面链接过来的。
- User-Agent：客户端的操作系统和浏览器版本
- Content-Type：报文体内对象的媒体类型。在项目中比较常用的就是`application/json`。

### 响应报文

![image-20201115191453071](/Users/yuanhao/Library/Application Support/typora-user-images/image-20201115191453071.png)

## HTTP的请求方法

- GET：用来请求和访问已被URI识别的资源。GET也可以用来发送表单，提交数据，但提交信息直接拼在URI后面，一个是安全隐患，一个是有长度限制（不同的浏览器限制不同）

- POST：与GET功能类似，但是用来传输实体的主体。由于表单数据没有直接拼在URI后面，也没有大小限制，所以克服了GET请求的缺点。

  但是不论是GET还是POST请求，都不安全，比如抓包软件都拦截，只是POST相比GET提交数据，安全了一丢丢。

- PUT：从客户端向服务端传送的数据取代指定文档的内容，与POST的区别在于，PUT是幂等的而POST是非幂等的，比如创建对象用POST，更新对象用PUT。

- HEAD：类似GET请求，只是响应中没有具体内容。用于探测某个链接是否有效。

- DELETE：由于没有验证机制，几乎没人用。

- OPTIONS

- TRACE

- CONNECT：开启客户端与所请求资源之间的双向通道，可以用来创建隧道。目前只在代理中用的比较多。

## HTTP状态码

2XX成功

- 200：已接受并成功返回。
- 202：已接受但尚未处理完。
- 206：服务器成功处理了部分GET请求。断点续传、流媒体传输常用。

3XX重定向

- 301：请求的资源被永久移动到新的URI
- 302：临时移动

4XX服务端结果可能不尽人意

- 400：客户端请求语法错误
- 401：身份认证
- 403：服务端理解客户端请求，但拒绝执行
- 404：找不到资源

5XX服务器错误

- 500：服务器内部错误
- 502：网关或代理与远端服务器传输数据时发生了错误

## HTTP状态管理

HTTP通过Cookie和Session的方式来进行状态管理，其中Cookie是客户端的状态，Session是服务端的状态。

### Cookie

Cookie实际上是一小段文本信息，客户端请求服务器如果需要存储客户端的信息，则服务端会向客户端发送一段Cookie。客户端浏览器会将Cookie存储起来，当浏览器再请求该网站时，就会带上Cookie，服务器就可以凭借Cookie辨认用户。

### Session

Session是服务端存储用户状态的方式，服务端收到客户端发送的请求后，若用户此前未请求过，则为用户创建一个Session并生成SessionID，并将SessionID返回给客户端，以后客户端发送请求时携带SessionID即可。

保存SessionID的方式：

- Cookie
- URL重写
- 隐藏表单

由于Session一般都放到服务端的缓存中，所以为了减缓存储压力，所以会对不活跃的Session进行释放，所以Session的有效期相对较短，而Cookie可以永久存储。

## 字符集与编码

### 编码规范

编码规范（比如Unicode）包括三部分：

- 字库表
- 编码方式（比如UTF-8）
- 字符集

常见的编码规范：

- ASCII：最为人熟知的编码方式，字符只占一个字节，但是可表达的字符非常少
- GBK：所有字符都占两个字节
- ISO-8859-1：也是只占一个字节，但是表示的是ASCII以外的字符。最大的特点就是其他任何的编码规范都可以尝试用ISO-8859-1进行解码，虽然结果很可能不是你想要的，很多时候乱码就是这样产生的，一些数据库也利用了这个特点。该规范不支持中文。
- Unicode：ISO标准化组织定制的一种通用编码规范，该规范下包括utf-8（变长）、utf-16、utf-32编码方式

编码：文字->机器码

解码：机器码->文字

### 乱码是如何产生的？

有两种可能

1. 编码和解码使用的规范不一致
2. 编码和解码规范一致，但是字库表并没有这些字，比如使用iSO-8859-1对中文字符进行编码和解码，无法还原文本。

### URL的编码和解码

- URL使用ASCII字符集进行编码，因此如果URL含有非ASCII字符集的字符，则需要进行编码
- URL中的一些保留字符，比如参数分隔符"&"，如果想要使用保留字，也需要编码

URL中的"%"编码规范

- 对于URL中的ASCII字符集的非保留字不编码
- 对于保留字取其ASCII内码，然后加上%前缀进行编码
- 对于非ASCII字符取其Unicode内码，加上%前缀进行编码

## 身份认证

- Basic认证：简单的Base64加密传输。
- Digest摘要认证：HTTP/1.1起出现，服务端传送一个加密算法，客户端使用该加密算法进行加密传输。
- SSL认证：借由HTTPS的客户端证书完成认证，具备一定的成本。
- 基于表单的认证：该认证方法并不是在HTTP协议中定义的，而是有Web应用程序进行实现，通过Cookie和Session保存用户状态。

## 长连接和短连接

长连接和短连接的概念其实是来描述TCP，而非HTTP的。

- 短连接：建立连接、数据传输、关闭连接...建立连接、数据传输、关闭连接
- 长连接：建立连接、数据传输...数据传输、关闭连接

## HTTP缓存

HTTP的缓存对象更多是静态资源文件、比如css、js、图片等资源。

### 缓存头部字段：

- Cache-Control请求/响应头，缓存控制字段

  no-store：不缓存

  no-cache：缓存，但是使用缓存前需要询问服务器资源是否最新

  public：客户端和代理服务器都可以缓存

  private：客户端可以缓存

  max-age=x：请求缓存后的X秒内不再发起请求

  s-maxage=x：作用同上，用于代理服务器和源站

- Expires响应头，过期时间

- Last-Modified响应头，资源最新修改时o间

  if-Modified-Since请求头，资源最新修改时间

- Etag响应头，资源标识

  if-None-Match请求头，缓存资源标识

### 缓存的三种工作场景：

- 客户端向服务端请求资源，服务端返回资源+Expires，客户端再次请求前先去查看Expires

- 客户端向服务端请求资源，服务端返回资源+Expires+Last-Modified，客户端再次请求会带上if-Modified-Since，若服务端比对发现资源仍然未改动，则直接返回304

  两个问题：

  1. Expires在客户端可以被修改，因此不稳定
  2. Last-Modified只能精确到秒级，造成无法及时更新（可以抓包看一下）

- 客户端向服务端请求资源，服务端返回资源+Expires+Last-Modified+Etag+max-age，用max-age解决问题1，用Etag解决问题2，一旦比对Etag不匹配，则立即更新缓存

### 缓存改进方案

- md5/hash缓存
- CDN（目前最常用）

## 断点续传

下载使用的也是HTTP协议，可以在Range字段中指定要下载的范围

HTTP/1.1 200 OK 不使用断点续传

HTTP/1.1 206 Partial Content 使用断点续传

# HTTPS

http协议不对内容进行加密，容易被截获和修改

## 非对称加密

A与B进行通信，分三步

- A向B发送Public Key
- B收到Public Key后将准备进行通信的Core Key使用Public Key进行加密得到Secret Key，发送给A
- A收到Secret Key后使用Private Key解密得到Core Key

这样，即使Public Key在最开始被截获，但是真正用于加密通信的Core Key在网络上没有明文传输，所以是**相对**安全的。非对称加密并不是绝对安全的，因为中间人可能会在第一步截获Public Key，并偷梁换柱向B发送自己制造的Public Key2，从而影响后续的信息传输。

## 证书机制

考虑到非对称加密并非绝对安全，这里引入了证书机构，一般来说我们的浏览器中都设置好了各大证书机构的信息，所以浏览器可以直接进行解密。

还是A与B进行通信

- A通过向证书机构发送Public Key得到下发的证书，并向B发送证书而非Public Key
- B使用证书机构的公钥对证书进行解密得到Public Key，并将Core Key加密为Secret Key，发送给A
- A收到Secret Key后使用Private Key解密得到Core Key

整个流程后50%没有变化，只是前50%的流程引入了证书机构

# WebSocket

WebSocket是HTTP的长连接实现，并且兼容了现有的HTTP协议

## WebSocket的握手

WebSocket借用HTTP完成握手

客户端向服务端发送的WebSocket请求内容如下：

![image-20201125233156498](/Users/yuanhao/Library/Application Support/typora-user-images/image-20201125233156498.png)

Upgrade：websocket，告诉服务器当前使用websocket协议

Sec-WebSocket-Key：浏览器生成的base64加密串，用于验证服务器的websocket有效性

服务端返回的内容如下：

![image-20201125233503618](/Users/yuanhao/Library/Application Support/typora-user-images/image-20201125233503618.png)

传统的HTTP只能用于客户端向服务端发送请求，有两种解决方式

- AJAX轮询（固定时间轮询）
- Long Poll（阻塞轮询）

上面两种情况，对服务器要求都很高，前者要求有很快的处理速度，后者要求有很高的并发量。而WebSocket的出现就是为了解决这两个问题。

WebSocket在完成握手之后，连接并不会消失，而客户端会通过回调的方式从服务端获取数据。

同时WebSocket支持全双工通信，服务端不必等待请求可以直接向客户端发送数据

![image-20201125234528499](/Users/yuanhao/Library/Application Support/typora-user-images/image-20201125234528499.png)

- 全双工方式
- 减少通信量：不再频繁交换header信息
- 多路复用：多个URL可以使用同一个WebSocket连接
- 心跳包

### 典型应用：聊天室