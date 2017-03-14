//
//  JMScanningResultVC.m
//  JMQRCodeDemo
//
//  Created by James.xiao on 2017/3/13.
//  Copyright © 2017年 James. All rights reserved.
//

#import "JMScanningResultVC.h"
#import <WebKit/WebKit.h>

@interface JMScanningResultVC ()

@end

@implementation JMScanningResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
- (void)setupViews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.resultType == qrCode) {
        [self setupWebView];
    }else {
        [self setupLabel];
    }
}

- (void)setupLabel {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0,
                                  200,
                                  self.view.frame.size.width,
                                  30);
    titleLabel.text          = @"您扫描的条形码结果如下： ";
    titleLabel.textColor     = [UIColor redColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:titleLabel];
    
    // 扫描结果
    UILabel *contentLabel   = [[UILabel alloc] init];
    contentLabel.frame      = CGRectMake(0, CGRectGetMaxY(titleLabel.frame), self.view.frame.size.width, 30);
    contentLabel.text       = self.resultInfo;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:contentLabel];
}

- (void)setupWebView {
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.resultInfo]];
    
    [webView loadRequest:request];
    [self.view addSubview:webView];
}

@end
