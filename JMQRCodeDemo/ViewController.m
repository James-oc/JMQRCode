//
//  ViewController.m
//  JMQRCodeDemo
//
//  Created by James on 2017/3/12.
//  Copyright © 2017年 James. All rights reserved.
//

#import "ViewController.h"
#import "JMGenerateQRCodeVC.h"
#import "JMScanningQRCodeVC.h"
#import "JMScanningQRCodeUtils.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
- (void)setupViews {
    
}

- (IBAction)generateQRCode:(id)sender {
    [self.navigationController pushViewController:[[JMGenerateQRCodeVC alloc] init] animated:true];
}

- (IBAction)scanQRCode:(id)sender {
    [JMScanningQRCodeUtils jm_cameraAuthStatusWithSuccess:^{
        [self.navigationController pushViewController:[[JMScanningQRCodeVC alloc] init] animated:true];
    } failure:^{
        
    }];
}

@end
