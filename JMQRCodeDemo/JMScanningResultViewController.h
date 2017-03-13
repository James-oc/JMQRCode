//
//  JMScanningResultViewController.h
//  JMQRCodeDemo
//
//  Created by James.xiao on 2017/3/13.
//  Copyright © 2017年 James. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,JMScanningResultType) {
    qrCode,
    barCode
};

@interface JMScanningResultViewController : UIViewController

@property (nonatomic, assign) JMScanningResultType  resultType;
@property (nonatomic, strong) NSString              *resultInfo;

@end
