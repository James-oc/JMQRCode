//
//  JMScanningQRCodeView.h
//  JMQRCodeDemo
//
//  Created by James.xiao on 2017/3/13.
//  Copyright © 2017年 James. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class JMScanningQRCodeConfig;

typedef void (^JMScanningQRCodeResult)  (NSString *result);

@interface JMScanningQRCodeView : UIView

/** 透明的区域 */
@property (nonatomic, assign) CGSize             transparentArea;
/** 透明的区域起始位置 */
@property (nonatomic, assign) float              transparentOriginY;
/** 是否打开照明，默认false */
@property (nonatomic, assign) BOOL               openSystemLight;
/** 扫描结果 */
@property (nonatomic, copy)   JMScanningQRCodeResult scanningQRCodeResult;

/** 扫描动画线条 */
@property (nonatomic,strong ) NSString           *qrLineImageName;// 默认@""
@property (nonatomic,strong ) UIColor            *qrLineColor;// 默认[UIColor clearColor]
@property (nonatomic, assign) CGSize             qrLineSize;// 默认宽度等于transparentArea宽度减去20，高度2
@property (nonatomic, assign) float              qrLineAnimateDuration;// 线条动画频率,默认0.01

/** 四个角 */
@property (nonatomic, assign) float              cornerLineLength;// 边角线条长度，默认15

/** 四个角线条颜色 */
- (void)qrCornerLineColorWithRed:(CGFloat)red
                           green:(CGFloat)green
                            blue:(CGFloat)blue
                           alpha:(CGFloat)alpha;

/* 开始扫描，默认配置 */
- (void)startRunning;

/* 开始扫描，自定义配置 */
- (void)startRunningWithConfig:(JMScanningQRCodeConfig *)config;

/* 停止扫描 */
- (void)stopRunning;

@end

@interface JMScanningQRCodeConfig : NSObject

@property (strong, nonatomic) AVCaptureDevice            *device;
@property (strong, nonatomic) AVCaptureDeviceInput       *input;
@property (strong, nonatomic) AVCaptureMetadataOutput    *output;
@property (strong, nonatomic) AVCaptureSession           *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;

- (instancetype)initWithQRCodeView:(JMScanningQRCodeView *)qrCodeView
                          delegate:(id)delegate;

- (void)qrConfig:(JMScanningQRCodeView *)qrCodeView
    withDelegate:(id)delegate;

- (AVCaptureVideoOrientation)videoOrientationFromCurrentDeviceOrientation;

@end
