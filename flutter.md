# flutter 笔记

## 环境设置 
### 安装 flutter SDK 

> android 需要先设置好 Android 的编译打包环境（java 和 Android的sdk）
> Ios 需要设置 ios的编译打包环境 Xcode  
>  接着设置 环境变量 PUB_HOSTED_URL  FLUTTER_STORAGE_BASE_URL
* 设置 环境变量 `export PUB_HOSTED_URL=https://pub.flutter-io.cn`
* 设置 环境变量 `export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn`
* SDK 下载 `git clone -b dev https://github.com/flutter/flutter.git`  如果网速较慢，使用下面的
* [MAC 下载 ](https://storage.flutter-io.cn/flutter_infra/releases/stable/macos/flutter_macos_v1.5.4-hotfix.2-stable.zip) 下载解押，再更新
* [WIN 下载 ](https://storage.flutter-io.cn/flutter_infra/releases/stable/macos/flutter_macos_v1.5.4-hotfix.2-stable.zip)
* 设置 环境变量 `export PATH="$PWD/flutter/bin:$PATH"`
* `cd ./flutter`
* 检查打包编译环境 `flutter doctor`
* Android 打包 `flutter build apk  --target-platform=android-arm `
* Ios 打包 `flutter build ios`
* `flutter build apk --target-platform android-arm,android-arm64 --split-per-abi`

>  目前 flutter 版本已经升级到 1.7x了 
> * [flutter_windows_v1.7.8](https://storage.flutter-io.cn/flutter_infra/releases/stable/windows/flutter_windows_v1.7.8+hotfix.4-stable.zip)
> * [flutter_macos_v1.7.8](https://storage.flutter-io.cn/flutter_infra/releases/stable/macos/flutter_macos_v1.7.8+hotfix.4-stable.zip)
> 
```
flutter doctor
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel unknown, v1.5.4-hotfix.2, on Mac OS X 10.14.5 18F203, locale en-CN)
[✓] Android toolchain - develop for Android devices (Android SDK version 28.0.3)
[✓] iOS toolchain - develop for iOS devices (Xcode 10.3)
[✓] Android Studio (version 3.2)
[✓] VS Code (version 1.36.1)
[✓] Connected device (1 available)
```

```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel v1.7.8-hotfixes, v1.7.8+hotfix.4, on Mac OS X 10.14.5 18F203, locale en-CN)
 
[✓] Android toolchain - develop for Android devices (Android SDK version 28.0.3)
[✓] Xcode - develop for iOS and macOS (Xcode 10.3)
[✓] iOS tools - develop for iOS devices
[✓] Chrome - develop for the web
[✓] Android Studio (version 3.2)
[✓] VS Code (version 1.36.1)
[✓] Connected device (3 available)

• No issues found!
```
参考文档 [win 安装文档](https://flutterchina.club/setup-windows/) [mac安装文档](https://flutterchina.club/setup-macos/)

## tips
* 获取当前commit 到commit id `git rev-parse HEA`
## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.


## TODO
阅读 关于 provide 的文字 https://juejin.im/post/5d00a84fe51d455a2f22023f 

## 单元测试
`flutter test test/audit_api_test.dart ` 


## flutter 与 native 互调

### flutter 调 native 
* Method Channel 
  1. 第一步先在flutter端声明 channel 
  ``` dart
  static const String _channel = 'com.zjex.equity.json/face';
  static const BasicMessageChannel<dynamic> jsonPlatformChannel =
      BasicMessageChannel<dynamic>(_channel, JSONMessageCodec());
  static const MethodChannel methodChannel =
      MethodChannel('com.zjex.equity/faceAll');
  static const EventChannel eventChannel =
      EventChannel('com.zjex.equity/faceEvt');

  ```
  
  2. 然后调  methodChannel 调 invokeMethod 方法
  
  ``` dart
    Future<T> invokeMethod<T>(String method, [dynamic arguments])
    // 
    String res;
    try {
      final String result = await methodChannel.invokeMethod(
        'doEncrypt',
        <String, String>{
          'password': password,
          'username': username,
        },
      );
      res = result;
      return res;
    } on PlatformException {
      res = 'Failed to doFullAuth.';
    }
  ```
    3. native 端初始化同杨的channel 然后，接收参数
    ```java
        // adnroid 
        private static String CHANNEL_FACE_ALL="com.zjex.equity/faceAll";
        private static String CHANNEL_FACE_EVT="com.zjex.equity/faceEvt";
        private static final String CHANNEL = "com.zjex.equity.json/face";
        private BasicMessageChannel<String> messageChannel;
        
        ...

         messageChannel = new BasicMessageChannel(getFlutterView(), CHANNEL, JSONMessageCodec.INSTANCE);
        messageChannel.
                setMessageHandler(new BasicMessageChannel.MessageHandler<String>() {
                    @Override
                    public void onMessage(String json, BasicMessageChannel.Reply<String> reply) {
                        Log.d(" [JSONMessageCodec] "," json = "+json);
                        doFaceAuthJson();
                        reply.reply(EMPTY_MESSAGE);
                    }
                });


        new EventChannel(getFlutterView(), CHANNEL_FACE_EVT).setStreamHandler(
                new StreamHandler() {
                    ...
        ...

        String username = call.argument("username");
        String password = call.argument("password");
        String strEnc = Des.strEnc(password,username);
        result.success(strEnc);
        ...    
    ```
    IOS 端例子
    ``` Objective-C
    
    @implementation FlutterMainViewController
    @property (nonatomic, strong) FlutterViewController* flutterViewController;

    @property (nonatomic, strong) FlutterEventSink eventSink;

    - (void)viewDidLoad {
        
    [super viewDidLoad];
    
    _flutterViewController = [[FlutterViewController alloc] init];
    
    [GeneratedPluginRegistrant registerWithRegistry:_flutterViewController];
    
    FlutterMethodChannel* faceAuthChannel = [FlutterMethodChannel methodChannelWithName:@"com.zjex.equity/faceAll" binaryMessenger:_flutterViewController];
    
    [faceAuthChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
       if([@"doEncrypt" isEqualToString:call.method]) {
            
            NSDictionary *dic = call.arguments;
            NSString * username = dic[@"username"];
            NSString * password = dic[@"password"];
            NSString* encStr = [DESUtil encryptUseDES:password withSalt:username];
            result(encStr);
            

    ```
    4. 然后做相应端业务逻辑，返回从调用结果
    5. flutter 接到结果后处理响应。
* native 端调用需要使用 EventChannel
native 可以主动向flutter发消息，flutter监听收到消息后处理后续业务。
