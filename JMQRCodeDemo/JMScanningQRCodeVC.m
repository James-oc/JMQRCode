//
//  JMScanningQRCodeVC.m
//  JMQRCodeDemo
//
//  Created by James.xiao on 2017/3/13.
//  Copyright © 2017年 James. All rights reserved.
//

#import "JMScanningQRCodeVC.h"
#import "JMScanningQRCodeView.h"
#import "JMScanningResultVC.h"
#import "JMScanningQRCodeUtils.h"
#import "JMQRCodeLoadView.h"

@interface JMScanningQRCodeVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    JMScanningQRCodeView        *_qrView;
    UIButton                    *_lightBtn;
    BOOL                        _isOpenLight;
    JMQRCodeLoadView            *_loadView;
    BOOL                        _firstLoad;
}
@end

@implementation JMScanningQRCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _firstLoad = true;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startRunning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopRunning];
}

- (void)setupViews {
    self.title                 = @"扫一扫";
    [self setupRightBarButtonItem];
    
    _qrView                    = [[JMScanningQRCodeView alloc] initWithFrame:self.view.bounds];
    _qrView.qrLineImageName    = @"jm_qr_line";
    
    _qrView.backgroundColor    = [UIColor clearColor];
    
    __weak JMScanningQRCodeVC *weakVC = self;
    _qrView.scanningQRCodeResult   = ^(NSString *result) {
        NSLog(@"扫描结果：%@",result);
        JMScanningResultType type = barCode;
        if ([result hasPrefix:@"http"]) {
            type = qrCode;
        }
        
        [weakVC pushVCWithType:type
                        result:result];
    };
    
    [self.view addSubview:_qrView];
    
    UILabel *infoLabel      = [[UILabel alloc] initWithFrame:CGRectMake(0, _qrView.transparentOriginY + _qrView.transparentArea.height + 10, self.view.bounds.size.width, 20)];
    infoLabel.text          = @"将二维码/条码放入框内，即可自动扫描";
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.textColor     = [UIColor whiteColor];
    infoLabel.font          = [UIFont systemFontOfSize:13.0f];
    
    [self.view addSubview:infoLabel];
    
    _lightBtn       = [UIButton buttonWithType:UIButtonTypeSystem];
    _lightBtn.frame = CGRectMake((CGRectGetWidth(self.view.frame) - 50) / 2,
                                 infoLabel.frame.origin.y + infoLabel.frame.size.height + 5,
                                 50,
                                 50);
    [_lightBtn setTitleColor:[UIColor greenColor]
                    forState:UIControlStateNormal];
    [_lightBtn setTitle:@"开灯"
               forState:UIControlStateNormal];
    [_lightBtn addTarget:self
                  action:@selector(changeLightSwitch)
        forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_lightBtn];
    
    [self setupLoadView];
}

- (void)setupLoadView {
    if (!_loadView) {
        _loadView                   = [[JMQRCodeLoadView alloc] initWithFrame:self.view.bounds];
        _loadView.backgroundColor   = [UIColor blackColor];
        
        [self.view addSubview:_loadView];
    }
}

- (void)setupRightBarButtonItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:(UIBarButtonItemStyleDone) target:self action:@selector(handleRightBarButtonAction)];
}

- (void)startRunning {
    if (_firstLoad) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _firstLoad       = false;
            _loadView.hidden = true;
            [_loadView.indicatorView stopAnimating];
            [_loadView removeFromSuperview];

            [_qrView startRunning];
        });
    }else {
        [_qrView startRunning];
    }
}

- (void)stopRunning {
    [_qrView stopRunning];
}

- (void)pushVCWithType:(JMScanningResultType)type
                result:(NSString *)result {
    JMScanningResultVC *resultVC    = [[JMScanningResultVC alloc] init];
    resultVC.resultType             = type;
    resultVC.resultInfo             = result;
    
    [self.navigationController pushViewController:resultVC animated:true];
}

#pragma mark - Event Response
- (void)changeLightSwitch {
    _isOpenLight = !_isOpenLight;
    if (_isOpenLight) {
        [_lightBtn setTitle:@"关灯"
                   forState:UIControlStateNormal];
    }else {
        [_lightBtn setTitle:@"开灯"
                   forState:UIControlStateNormal];
    }
    
    _qrView.openSystemLight = _isOpenLight;
}

#pragma mark - 相册
- (void)handleRightBarButtonAction {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:imagePicker
                                                              animated:YES
                                                            completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self dismissViewControllerAnimated:YES completion:^{
        NSString *result = [JMScanningQRCodeUtils jm_scanQRCodeFromPhotosAlbum:info[UIImagePickerControllerOriginalImage]];
        NSLog(@"扫描结果：%@",result);

        [self pushVCWithType:qrCode
                      result:result];
    }];
}

@end
