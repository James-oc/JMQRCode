//
//  JMScanningQRCodeViewController.m
//  JMQRCodeDemo
//
//  Created by James.xiao on 2017/3/13.
//  Copyright © 2017年 James. All rights reserved.
//

#import "JMScanningQRCodeViewController.h"
#import "JMScanningQRCodeView.h"
#import "JMScanningResultViewController.h"
#import "JMScanningQRCodeUtils.h"

@interface JMScanningQRCodeViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    JMScanningQRCodeView *_qrView;
    UIButton             *_lightbtn;
    BOOL                 _isOpenLight;
}
@end

@implementation JMScanningQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_qrView startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_qrView stopRunning];
}

- (void)setupViews {
    self.title                 = @"扫一扫";
    [self setupRightBarButtonItem];
    
    _qrView                    = [[JMScanningQRCodeView alloc] initWithFrame:self.view.bounds];
    _qrView.qrLineImageName    = @"jm_qr_line";
    
    _qrView.backgroundColor    = [UIColor clearColor];
    
    __weak JMScanningQRCodeViewController *weakVC = self;
    _qrView.scanningQRCodeResult   = ^(NSString *result) {
        NSLog(@"扫描结果：%@",result);
        [weakVC pushVCWithType:qrCode
                        result:result];
    };
    
    [self.view addSubview:_qrView];
    
    UILabel *infoLabel      = [[UILabel alloc] initWithFrame:CGRectMake(0, _qrView.transparentOriginY + _qrView.transparentArea.height + 10, self.view.bounds.size.width, 20)];
    infoLabel.text          = @"将二维码/条码放入框内，即可自动扫描";
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.textColor     = [UIColor whiteColor];
    infoLabel.font          = [UIFont systemFontOfSize:13.0f];
    
    [self.view addSubview:infoLabel];
    
    _lightbtn       = [UIButton buttonWithType:UIButtonTypeSystem];
    _lightbtn.frame = CGRectMake((CGRectGetWidth(self.view.frame) - 50) / 2,
                                 infoLabel.frame.origin.y + infoLabel.frame.size.height + 5,
                                 50,
                                 50);
    [_lightbtn setTitleColor:[UIColor greenColor]
                    forState:UIControlStateNormal];
    [_lightbtn setTitle:@"开灯"
               forState:UIControlStateNormal];
    [_lightbtn addTarget:self
                  action:@selector(changeLightSwitch)
        forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_lightbtn];
}

- (void)setupRightBarButtonItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:(UIBarButtonItemStyleDone) target:self action:@selector(handleRightBarButtonAction)];
}

- (void)pushVCWithType:(JMScanningResultType)type
                result:(NSString *)result {
    JMScanningResultViewController *resultVC = [[JMScanningResultViewController alloc] init];
    if ([result hasPrefix:@"http"]) {
        resultVC.resultType = qrCode;
    }else {
        resultVC.resultType = barCode;
    }
    resultVC.resultInfo = result;
    [self.navigationController pushViewController:resultVC animated:true];
}

#pragma mark - Event Response
- (void)changeLightSwitch {
    _isOpenLight = !_isOpenLight;
    if (_isOpenLight) {
        [_lightbtn setTitle:@"关灯"
                   forState:UIControlStateNormal];
    }else {
        [_lightbtn setTitle:@"开灯"
                   forState:UIControlStateNormal];
    }
    
    _qrView.openSystemLight = _isOpenLight;
}

#pragma mark - 相册
- (void)handleRightBarButtonAction {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker
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
