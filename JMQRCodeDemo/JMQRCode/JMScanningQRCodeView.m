//
//  JMScanningQRCodeView.m
//  JMQRCodeDemo
//
//  Created by James.xiao on 2017/3/13.
//  Copyright © 2017年 James. All rights reserved.
//

#import "JMScanningQRCodeView.h"

const CGFloat jm_qr_cornerLineOffX = 0.7;
const CGFloat jm_qr_cornerLineOffY = 0.7;

const CGFloat jm_qr_scanLineOffY   = 2.0;

@interface JMScanningQRCodeView()
{
    UIImageView             *_qrLineImageView;
    CGFloat                 _qrLineY;
    CGFloat                 _scaMaxBorder;
    
    /* 扫描动画线条颜色 */
    CGFloat                 _qrLineColorRed;
    CGFloat                 _qrLineColorGreen;
    CGFloat                 _qrLineColorBlue;
    CGFloat                 _qrLineColorAlpha;

    JMScanningQRCodeConfig  *_qrConfig;
    NSTimer                 *_timer;
    BOOL                    _isScanResult;
}

@end

@implementation JMScanningQRCodeView

#pragma mark - Override
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        float width            = self.bounds.size.width - self.bounds.size.width * 0.15 * 2;
        self.transparentArea   = CGSizeMake(width, width);
        _transparentOriginY    = self.bounds.size.height / 2 - self.transparentArea.height / 2;

        _qrLineAnimateDuration = 0.01;
        _qrLineImageName       = @"";
        _qrLineSize            = CGSizeMake(width - 20, 2);
        _qrLineColorRed        = 9 / 255.0;
        _qrLineColorGreen      = 187 / 255.0;
        _qrLineColorBlue       = 7 / 255.0;
        _qrLineColorAlpha      = 1;
        _qrLineColor           = [UIColor clearColor];// 默认

        _cornerLineLength      = 15;
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!_qrLineImageView) {
        [self initQRLine];
    }
}

- (void)drawRect:(CGRect)rect {
    if (_transparentArea.width == 0 && _transparentArea.height == 0) {
        return ;
    }
    
    CGRect clearDrawRect = CGRectMake(self.bounds.size.width / 2 - self.transparentArea.width / 2,
                                      _transparentOriginY,
                                      self.transparentArea.width,
                                      self.transparentArea.height);
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    [self addScreenFillWithContext:contextRef
                              rect:self.bounds];
    
    [self addCenterClearWithContext:contextRef
                               rect:clearDrawRect];
    
    [self addWhiteWithContext:contextRef
                         rect:clearDrawRect];
    
    [self addCornerLineWithContext:contextRef
                              rect:clearDrawRect];
}

#pragma mark - init
- (void)initQRLine {
    CGRect viewBounds = self.bounds;
    
    _qrLineImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(viewBounds.size.width / 2 - _qrLineSize.width / 2, _transparentOriginY + jm_qr_scanLineOffY, _qrLineSize.width, _qrLineSize.height)];
    _qrLineImageView.backgroundColor = _qrLineColor;
    _qrLineImageView.image           = [UIImage imageNamed:_qrLineImageName];
    
    [self addSubview:_qrLineImageView];
    
    _qrLineY = _qrLineImageView.frame.origin.y;
}

#pragma mark - Private
- (void)animateQRLine {
    [UIView animateWithDuration:_qrLineAnimateDuration
                     animations:^{
                         CGRect rect            = _qrLineImageView.frame;
                         rect.origin.y          = _qrLineY;
                         _qrLineImageView.frame = rect;
                     } completion:^(BOOL finished) {
                         if (_qrLineY > _scaMaxBorder) {
                             _qrLineY = _transparentOriginY + jm_qr_scanLineOffY;
                         }
                         
                         _qrLineY++ ;
                     }];
}

- (void)initConfig {
    if (_qrConfig == nil) {
        _qrConfig                = [[JMScanningQRCodeConfig alloc] initWithQRCodeView:self delegate:self];
    }
}

- (void)handleScanResult:(NSString *)result
{
    if (_isScanResult) {
        return;
    }
    
    if (result != nil && ![result isEqualToString:@""]) {
        _isScanResult = YES;

        // 处理扫描结果
        [self stopRunning];
        
        if (_scanningQRCodeResult != nil) {
            _scanningQRCodeResult(result);
        }
    }else {
        _isScanResult = NO;
    }
}

#pragma mark - Public
- (void)qrCornerLineColorWithRed:(CGFloat)red
                           green:(CGFloat)green
                            blue:(CGFloat)blue
                           alpha:(CGFloat)alpha {
    _qrLineColorRed   = red;
    _qrLineColorGreen = green;
    _qrLineColorBlue  = blue;
    _qrLineColorAlpha = alpha;
    
    [self setNeedsDisplay];
}

- (void)startRunning {
    _qrLineImageView.hidden = NO;
    _isScanResult           = NO;
    
    [self initConfig];
    
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_qrLineAnimateDuration
                                                  target:self
                                                selector:@selector(animateQRLine)
                                                userInfo:nil
                                                 repeats:YES];
        [_timer fire];
    }
    
    [_qrConfig.session startRunning];
}

- (void)startRunningWithConfig:(JMScanningQRCodeConfig *)config {
    _qrConfig = config;
    [self startRunning];
}

- (void)stopRunning {
    _qrLineImageView.hidden = YES;
    
    CGRect frame            = _qrLineImageView.frame;
    frame.origin.y          = _transparentOriginY + jm_qr_scanLineOffY;
    _qrLineImageView.frame  = frame;
    
    [self removeTimer];
    [_qrConfig.session stopRunning];
}

- (void)removeTimer {
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - Draw
- (void)addScreenFillWithContext:(CGContextRef)ctx
                            rect:(CGRect)rect {
    CGContextSetRGBFillColor(ctx, 40 / 255.0, 40 / 255.0, 40 / 255.0, 0.5);
    CGContextFillRect(ctx, rect);
}

- (void)addCenterClearWithContext:(CGContextRef)ctx
                             rect:(CGRect)rect {
    CGContextClearRect(ctx, rect);
}

- (void)addWhiteWithContext:(CGContextRef)ctx
                       rect:(CGRect)rect {
    CGContextStrokeRect(ctx, rect);
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    CGContextSetLineWidth(ctx, 0.8);
    CGContextAddRect(ctx, rect);
    CGContextStrokePath(ctx);
}

- (void)addCornerLineWithContext:(CGContextRef)ctx
                            rect:(CGRect)rect{
    //画四个边角
    CGContextSetLineWidth(ctx, 2);
    CGContextSetRGBStrokeColor(ctx,
                               _qrLineColorRed,
                               _qrLineColorGreen,
                               _qrLineColorBlue,
                               _qrLineColorAlpha);
    
    //左上角
    CGPoint poinsTopLeftA[] = {
        CGPointMake(rect.origin.x + jm_qr_cornerLineOffX, rect.origin.y + jm_qr_cornerLineOffY),
        CGPointMake(rect.origin.x + jm_qr_cornerLineOffX, rect.origin.y + jm_qr_cornerLineOffY + _cornerLineLength)
    };
    
    CGPoint poinsTopLeftB[] = {
        CGPointMake(rect.origin.x + jm_qr_cornerLineOffX - 1, rect.origin.y + jm_qr_cornerLineOffY),
        CGPointMake(rect.origin.x + jm_qr_cornerLineOffX + _cornerLineLength, rect.origin.y + jm_qr_cornerLineOffY)
    };
    
    [self addLine:poinsTopLeftA
           pointB:poinsTopLeftB
              ctx:ctx];
    
    //左下角
    CGPoint poinsBottomLeftA[] = {
        CGPointMake(rect.origin.x + jm_qr_cornerLineOffX, rect.origin.y + rect.size.height - jm_qr_cornerLineOffY - _cornerLineLength),
        CGPointMake(rect.origin.x + jm_qr_cornerLineOffX, rect.origin.y + rect.size.height - jm_qr_cornerLineOffY)
    };
    
    CGPoint poinsBottomLeftB[] = {
        CGPointMake(rect.origin.x + jm_qr_cornerLineOffX - 1 ,rect.origin.y + rect.size.height - jm_qr_cornerLineOffY),
        CGPointMake(rect.origin.x + jm_qr_cornerLineOffX + _cornerLineLength, rect.origin.y + rect.size.height - jm_qr_cornerLineOffY)
    };
    
    [self addLine:poinsBottomLeftA
           pointB:poinsBottomLeftB
              ctx:ctx];
    
    //右上角
    CGPoint poinsTopRightA[] = {
        CGPointMake(rect.origin.x + rect.size.width - jm_qr_cornerLineOffX - _cornerLineLength, rect.origin.y + jm_qr_cornerLineOffY),
        CGPointMake(rect.origin.x + rect.size.width - jm_qr_cornerLineOffX + 1, rect.origin.y + jm_qr_cornerLineOffY)
    };
    
    CGPoint poinsTopRightB[] = {
        CGPointMake(rect.origin.x + rect.size.width - jm_qr_cornerLineOffX, rect.origin.y + jm_qr_cornerLineOffY),
        CGPointMake(rect.origin.x + rect.size.width - jm_qr_cornerLineOffX, rect.origin.y + _cornerLineLength + jm_qr_cornerLineOffY)
    };
    
    [self addLine:poinsTopRightA
           pointB:poinsTopRightB
              ctx:ctx];
    
    // 右下角
    CGPoint poinsBottomRightA[] = {
        CGPointMake(rect.origin.x + rect.size.width - jm_qr_cornerLineOffX, rect.origin.y + rect.size.height - jm_qr_cornerLineOffY - _cornerLineLength),
        CGPointMake(rect.origin.x + rect.size.width - jm_qr_cornerLineOffX,rect.origin.y + rect.size.height - jm_qr_cornerLineOffY)
    };
    
    CGPoint poinsBottomRightB[] = {
        CGPointMake(rect.origin.x + rect.size.width - jm_qr_cornerLineOffX - _cornerLineLength, rect.origin.y + rect.size.height - jm_qr_cornerLineOffY),
        CGPointMake(rect.origin.x + rect.size.width - jm_qr_cornerLineOffX + 1,rect.origin.y + rect.size.height - jm_qr_cornerLineOffY)
    };
    
    [self addLine:poinsBottomRightA
           pointB:poinsBottomRightB
              ctx:ctx];
    
    CGContextStrokePath(ctx);
}

- (void)addLine:(CGPoint[])pointA
         pointB:(CGPoint[])pointB
            ctx:(CGContextRef)ctx {
    CGContextAddLines(ctx, pointA, 2);
    CGContextAddLines(ctx, pointB, 2);
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        [self handleScanResult:metadataObj.stringValue ? : @""];
    }
}

#pragma mark - Properties
- (void)setTransparentArea:(CGSize)transparentArea {
    _transparentArea    = transparentArea;
    _scaMaxBorder = _transparentOriginY + (_transparentArea.height - jm_qr_scanLineOffY * 2);
}

- (void)setQrLineSize:(CGSize)qrLineSize {
    _qrLineSize = qrLineSize;
    if (_qrLineImageView != nil) {
        CGRect frame           = _qrLineImageView.frame;
        frame.size.height      = _qrLineSize.height;
        frame.origin.x         = (CGRectGetWidth(self.frame) - _qrLineSize.width) / 2;
        
        _qrLineImageView.frame = frame;
    }
}

- (void)setOpenSystemLight:(BOOL)openSystemLight {
    _openSystemLight = openSystemLight;
    
    if(_qrConfig != nil && _qrConfig.device != nil && [_qrConfig.device hasTorch]) {
        [_qrConfig.device lockForConfiguration:nil];
        
        if (_openSystemLight) {
            [_qrConfig.device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [_qrConfig.device setTorchMode:AVCaptureTorchModeOff];
        }
        
        [_qrConfig.device unlockForConfiguration];
    }
}

@end

@implementation JMScanningQRCodeConfig

- (instancetype)initWithQRCodeView:(JMScanningQRCodeView *)qrCodeView
                          delegate:(id)delegate {
    self = [super init];
    
    if (self) {
        [self qrConfig:qrCodeView
          withDelegate:delegate];
    }
    
    return self;
}

- (void)qrConfig:(JMScanningQRCodeView *)qrCodeView
    withDelegate:(id)delegate {
    // 1.获取摄像头设备
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 2.创建输入流
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // 3.创建输出流
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:delegate
                                      queue:dispatch_get_main_queue()];
    
    // 4.创建会话对象
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    
    if([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    
    // 5.设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    // 6.实例化预览图层
    self.preview                            = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    self.preview.videoGravity               = AVLayerVideoGravityResize;
    self.preview.frame                      = qrCodeView.bounds;
    
    qrCodeView.backgroundColor              = [UIColor clearColor];
    qrCodeView.superview.backgroundColor    = [UIColor clearColor];
    
    [qrCodeView.superview.layer insertSublayer:self.preview atIndex:0];
    
    self.preview.connection.videoOrientation = [self videoOrientationFromCurrentDeviceOrientation];
    
    // 7.修正扫描区域
    CGFloat viewHeight = CGRectGetHeight(qrCodeView.frame);
    CGFloat viewWidth  = CGRectGetWidth(qrCodeView.frame);
    CGRect cropRect    = CGRectMake((viewWidth - qrCodeView.transparentArea.width) / 2,
                                    qrCodeView.transparentOriginY,
                                    qrCodeView.transparentArea.width,
                                    qrCodeView.transparentArea.height);
    
    [_output setRectOfInterest:CGRectMake(cropRect.origin.y / viewHeight,
                                          cropRect.origin.x / viewWidth,
                                          cropRect.size.height / viewHeight,
                                          cropRect.size.width / viewWidth)];
}

- (AVCaptureVideoOrientation)videoOrientationFromCurrentDeviceOrientation {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];

    if (orientation == UIInterfaceOrientationPortrait) {
        // NSLog(@"UIInterfaceOrientationPortrait");
        return AVCaptureVideoOrientationPortrait;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft) {
        // NSLog(@"AVCaptureVideoOrientationLandscapeLeft");
        return AVCaptureVideoOrientationLandscapeLeft;
    } else if (orientation == UIInterfaceOrientationLandscapeRight){
        // NSLog(@"UIInterfaceOrientationLandscapeRight");
        return AVCaptureVideoOrientationLandscapeRight;
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        // NSLog(@"UIInterfaceOrientationPortraitUpsideDown");
        return AVCaptureVideoOrientationPortraitUpsideDown;
    }
    
    return AVCaptureVideoOrientationPortrait;
}

@end
