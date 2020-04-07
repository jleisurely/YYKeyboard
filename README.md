# YYKeyboard

[![CI Status](https://img.shields.io/travis/wangyu1001@live.cn/YYKeyboard.svg?style=flat)](https://travis-ci.org/wangyu1001@live.cn/YYKeyboard)
[![Version](https://img.shields.io/cocoapods/v/YYKeyboard.svg?style=flat)](https://cocoapods.org/pods/YYKeyboard)
[![License](https://img.shields.io/cocoapods/l/YYKeyboard.svg?style=flat)](https://cocoapods.org/pods/YYKeyboard)
[![Platform](https://img.shields.io/cocoapods/p/YYKeyboard.svg?style=flat)](https://cocoapods.org/pods/YYKeyboard)

## 视频示例

[视频跳转点击我](https://upload-images.jianshu.io/upload_images/3249308-61216ad67a983d92.gif?imageMogr2/auto-orient/strip)

## 感谢 [https://github.com/VernonVan/PPStickerKeyboard](https://github.com/VernonVan/PPStickerKeyboard))。解决了不少问题

## 实现思路
YYKit提供了自定义表情的类，实现方式是UIScrollView+YYLabel进行实现

键盘中的按钮实际上是YYlabel上面的图片，并给图片加入了点击事件，间距用原图经过Core Graphics处理出间距，实际上还是图片，可以生成图片时直接处理成这个样子

功能包含：

1、自定义表情键盘，TextView中能够展示自定义表情，能够进行所有TextView的相关操作

2、性能卓越

3、光标


欢迎提意见
[简书](https://www.jianshu.com/p/c8722f1d0e1c)“留言入口”


## Pod自动导入

1、在 Podfile 中添加 pod 'YYKeyboard'。

2、执行 pod install 或 pod update。

3、阅读代码，如有问题可以下载Demo或者给简书留言。

4、代码是花了2个小时实现的，代码会有一些问题，如您发现问题，可在简书留言给我

再次感谢YY大牛，写了如此强大的三方库，膜拜中！！！！


## Author

[Jade](wangyu1001@live.cn)

## License

YYKeyboard is available under the MIT license. See the LICENSE file for more info.
