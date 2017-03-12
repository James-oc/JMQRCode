//
//  JMQRCodeUtils.m
//  JMQRCodeDemo
//
//  Created by James on 2017/3/12.
//  Copyright © 2017年 James. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMGenerateQRCodeUtils.h"

@implementation JMGenerateQRCodeUtils

/**
 *  @brief 生成一张普通的二维码
 *
 *  @param string       传入你要生成二维码的数据
 *  @param imageSize    生成的二维码图片尺寸
 *
 *  @return UIImage
 */
+ (UIImage *)jm_generateQRCodeWithString:(NSString *)string
                               imageSize:(CGSize)imageSize {
    return [self jm_generateQRCodeWithString:string
                                   imageSize:imageSize
                               logoImageName:@""
                               logoImageSize:CGSizeZero];
}

/**
 *  @brief 生成一张带有logo的二维码
 *
 *  @param string               传入你要生成二维码的数据
 *  @param imageSize            生成的二维码图片尺寸
 *  @param logoImageName        logo图片名称
 *  @param logoImageSize        logo图片尺寸（注意尺寸不要太大（最大不超过二维码图片的%30），太大会造成扫不出来）
 *
 *  @return UIImage
 */
+ (UIImage *)jm_generateQRCodeWithString:(NSString *)string
                               imageSize:(CGSize)imageSize
                           logoImageName:(NSString *)logoImageName
                           logoImageSize:(CGSize)logoImageSize {
    return [self createLogoImageWithOriginImage:[self createNonInterpolatedUIImageFormCIImage:[self outputNormalImageWithString:string imageSize:imageSize] withImageSize:imageSize] originImageSize:imageSize logoImageSize:logoImageSize logoImageName:logoImageName];
}

/**
 *  @brief 生成一张带有彩色的二维码
 *
 *  @param string           传入你要生成二维码的数据
 *  @param imageSize        生成的二维码图片尺寸
 *  @param rgbColor         主题色
 *  @param backgroundColor  背景题色
 *
 *  @return UIImage
 */
+ (UIImage *)jm_generateColorQRCodeWithString:(NSString *)string
                                    imageSize:(CGSize)imageSize
                                     rgbColor:(CIColor *)rgbColor
                              backgroundColor:(CIColor *)backgroundColor {
    return [UIImage imageWithCIImage:[self outputColorImageWithString:string imageSize:imageSize rgbColor:rgbColor backgroundColor:backgroundColor]];
}

/**
 *  @brief 生成一张带有彩色和logo的二维码
 *
 *  @param string           传入你要生成二维码的数据
 *  @param imageSize        生成的二维码图片尺寸
 *  @param rgbColor         主题色
 *  @param backgroundColor  背景题色
 *  @param logoImageName    logo图片名称
 *  @param logoImageSize    logo图片尺寸（注意尺寸不要太大（最大不超过二维码图片的%30），太大会造成扫不出来）
 *
 *  @return UIImage
 */
+ (UIImage *)jm_generateColorQRCodeWithString:(NSString *)string
                                    imageSize:(CGSize)imageSize
                                     rgbColor:(CIColor *)rgbColor
                              backgroundColor:(CIColor *)backgroundColor
                                logoImageName:(NSString *)logoImageName
                                logoImageSize:(CGSize)logoImageSize {
    return [self createLogoImageWithOriginImage:[UIImage imageWithCIImage:[self outputColorImageWithString:string imageSize:imageSize rgbColor:rgbColor backgroundColor:backgroundColor]] originImageSize:imageSize logoImageSize:logoImageSize logoImageName:logoImageName];
}

#pragma mark - Private
/**
 *  @brief 获得滤镜输出的图像
 *
 *  @param string       传入你要生成二维码的数据
 *  @param imageSize    生成的二维码图片尺寸
 *
 *  @return CIImage
 */
+ (CIImage *)outputNormalImageWithString:(NSString *)string
                               imageSize:(CGSize)imageSize {
    // 1.设置数据
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    // 2.创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    [filter setValue:data forKey:@"inputMessage"]; // 通过kvo方式给一个字符串，生成二维码
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];// 设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
    
    // 3.获得滤镜输出对象
    return [filter outputImage];
}

/**
 *  @brief 获得彩色滤镜输出的图像
 *
 *  @param string           传入你要生成二维码的数据
 *  @param imageSize        生成的二维码图片尺寸
 *  @param rgbColor         主题色
 *  @param backgroundColor  背景题色
 *
 *  @return CIImage
 */
+ (CIImage *)outputColorImageWithString:(NSString *)string
                              imageSize:(CGSize)imageSize
                               rgbColor:(CIColor *)rgbColor
                        backgroundColor:(CIColor *)backgroundColor {
    CIImage *outputNormalImage = [self outputNormalImageWithString:string imageSize:imageSize];
    
    // 创建颜色滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIFalseColor"];
    [filter setDefaults];
    [filter setValue:outputNormalImage forKey:@"inputImage"];
    // 替换颜色
    [filter setValue:rgbColor forKey:@"inputColor0"];
    // 替换背景颜色
    [filter setValue:backgroundColor forKey:@"inputColor1"];
    
    // 获得滤镜输出对象
    return [filter outputImage];
}

/**
 *  @brief 根据CIImage生成指定大小的UIImage
 *
 *  @param image            CIImage对象
 *  @param imageSize        生成的二维码图片尺寸
 *
 *  @return UIImage
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image
                                       withImageSize:(CGSize)imageSize {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(imageSize.width / CGRectGetWidth(extent), imageSize.height / CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width  = CGRectGetWidth(extent)  * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray(); // 创建一个DeviceGray颜色空间
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image
                                           fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    // 3.生成原图
    return [UIImage imageWithCGImage:scaledImage];;
}

/**
 *  @brief 生成带有logo二维码图片
 *
 *  @param originImage      UIImage对象
 *  @param imageSize        UIImage对象尺寸
 *  @param logoImageName    logo图片名称
 *  @param logoImageSize    logo图片尺寸（注意尺寸不要太大（最大不超过二维码图片的%30），太大会造成扫不出来）
 *
 *  @return UIImage
 */
+ (UIImage *)createLogoImageWithOriginImage:(UIImage *)originImage
                            originImageSize:(CGSize)imageSize
                              logoImageSize:(CGSize)logoImageSize
                              logoImageName:(NSString *)logoImageName {
    if (!CGSizeEqualToSize(logoImageSize, CGSizeZero) && logoImageName != nil && ![logoImageName isEqualToString:@""]) {
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, [[UIScreen mainScreen] scale]);
        [originImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
        
        UIImage *waterimage = [UIImage imageNamed:logoImageName];
        
        [waterimage drawInRect:CGRectMake((imageSize.width - logoImageSize.width) / 2.0, (imageSize.height - logoImageSize.height) / 2.0, logoImageSize.width, logoImageSize.height)];
        
        UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newPic;
    }
    
    return originImage;
}

@end
