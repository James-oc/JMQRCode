//
//  JMGenerateQRCodeViewController.m
//  JMQRCodeDemo
//
//  Created by James.xiao on 2017/3/13.
//  Copyright © 2017年 James. All rights reserved.
//

#import "JMGenerateQRCodeViewController.h"
#import "JMGenerateQRCodeUtils.h"

@interface JMGenerateQRCodeViewController ()

@end

@implementation JMGenerateQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"二维码";

    [self generateQRCode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)generateQRCode {
    CGSize size         = CGSizeMake(120, 120);
    float  off          = 30;
    NSString *string    = @"https://github.com/xiaobs/JMQRCode.git";
    NSString *logoName  = @"logo";
    CGSize logoSize     = CGSizeMake(30, 30);
    
    float tempX         = (self.view.bounds.size.width - size.width * 2 - off) / 2;
    for (int i = 0; i < 4; i++) {
        float originX  = tempX;
        float originY  = 80;
        UIImage *image = nil;
        
        switch (i) {
            case 0:
            {
                image = [JMGenerateQRCodeUtils jm_generateQRCodeWithString:string imageSize:size];
            }
                break;
            case 1:
            {
                image = [JMGenerateQRCodeUtils jm_generateQRCodeWithString:string imageSize:size logoImageName:logoName logoImageSize:logoSize];
                originX += size.width + off;
            }
                break;
            case 2:
            {
                image = [JMGenerateQRCodeUtils jm_generateColorQRCodeWithString:string imageSize:size rgbColor:[CIColor colorWithRed:200.0/255.0 green:70.0/255.0 blue:189.0/255.0] backgroundColor:[CIColor colorWithRed:1 green:1 blue:1]];
                originY += size.height + off;
            }
                break;
            case 3:
            {
                image = [JMGenerateQRCodeUtils jm_generateColorQRCodeWithString:string imageSize:size rgbColor:[CIColor colorWithRed:200.0/255.0 green:70.0/255.0 blue:189.0/255.0] backgroundColor:[CIColor colorWithRed:1 green:1 blue:1] logoImageName:logoName logoImageSize:logoSize];
                originX += size.width + off;
                originY += size.height + off;
            }
                break;
            default:
                break;
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, originY, size.width, size.height)];
        imageView.image = image;
        [self.view addSubview:imageView];
    }
}

@end
