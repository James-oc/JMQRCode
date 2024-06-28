OC版：iOS原生方法实现二维码生成与扫描(需要iOS8或更高版本)
---

## 功能

* `生成普通或者彩色的二维码`<br>

* `生成普通或者彩色并且带logo的二维码`<br>

* `仿微信扫描二维码样式`<br>

* `可控制是否开启闪光灯`<br>

* `从相册中获取二维码`<br>

* `可设置扫描样式中四个边角颜色`<br>

* `可设置扫描样式中动画线条颜色和图片`<br>

## 代码

* 普通二维码生成
```
UIImage *image = [JMGenerateQRCodeUtils jm_generateQRCodeWithString:@"https://github.com/James-swift/JMSQRCode.git" imageSize:<＃Image_Size＃>];

/// 带logo
UIImage *image = [JMGenerateQRCodeUtils jm_generateQRCodeWithString:@"https://github.com/James-swift/JMSQRCode.git" imageSize:<＃Image_Size＃> logoImageName:<＃Logo_Name＃> logoImageSize:<＃Logo_Size＃>];
```

* 彩色二维码生成
```
UIImage *image = [JMGenerateQRCodeUtils jm_generateColorQRCodeWithString:@"https://github.com/James-swift/JMSQRCode.git" imageSize:<＃Image_Size＃> rgbColor:<＃QRCode_rgbColor＃> backgroundColor:<＃QRCode_bgColor＃>];

/// 带logo
UIImage *image = [JMGenerateQRCodeUtils jm_generateColorQRCodeWithString:@"https://github.com/James-swift/JMSQRCode.git" imageSize:<＃Image_Size＃> rgbColor:<＃QRCode_rgbColor＃> backgroundColor:<＃QRCode_bgColor＃> logoImageName:<＃Logo_Name＃> logoImageSize:<＃Logo_Size＃>];
```

* 二维码扫描视图
```
JMScanningQRCodeView *qrView  = [[JMScanningQRCodeView alloc] initWithFrame:self.view.bounds];
qrView.qrLineImageName        = <＃Line_Image_Name＃>;
qrView.backgroundColor        = [UIColor clearColor];
qrView.scanningQRCodeResult   = ^(NSString *result) {
    NSLog(@"扫描结果：%@",result);
};

// 修改四个边角颜色
[qrView qrCornerLineColorWithRed:<#red#>
                           green:<#green#>
                            blue:<#blue#>
                           alpha:<#alpha#>];

[self.view addSubview:_qrView];

```

## 安装
1. 将工程项目中的JMQRCode文件夹拉入自己的工程项目里面；
2. ```import 文件```并开始代码编写。

## 用CocoaPods安装
CocoaPods是OSX和iOS下的一个第三类库管理工具,如果你还未安装请先查看[**CocoaPods安装和使用教程**](http://code4app.com/article/cocoapods-install-usage)

## Podfile
```
pod 'JMQRCode', '~> 1.0.2'
```
执行命令
```OC
$ pod install
```

## 效果
<img src="https://github.com/James-oc/JMShareSource/raw/master/screenshots/OC/JMQRCode/1.PNG?raw=true"  height="480">  <img src="https://github.com/James-oc/JMShareSource/raw/master/screenshots/OC/JMQRCode/2.PNG?raw=true"  height="480">

## 联系方式

* 如在使用中, 遇到什么问题或有更好建议者, 请记得 [Issues me](https://github.com/James-oc/JMQRCode/issues) 或 1007785739@qq.com 邮箱联系我

## 作者
James.xiao
