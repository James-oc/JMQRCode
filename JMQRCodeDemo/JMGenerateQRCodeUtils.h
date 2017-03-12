//
//  JMGenerateQRCodeUtils.h
//  JMQRCodeDemo
//
//  Created by James on 2017/3/12.
//  Copyright © 2017年 James. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMGenerateQRCodeUtils : NSObject

#pragma mark - 生成二维码
/**
 *  @brief 生成一张普通的二维码
 *
 *  @param string       传入你要生成二维码的数据
 *  @param imageSize    生成的二维码图片尺寸
 *
 *  @return UIImage
 */
+ (UIImage *)jm_generateQRCodeWithString:(NSString *)string
                               imageSize:(CGSize)imageSize;

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
                           logoImageSize:(CGSize)logoImageSize;

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
                              backgroundColor:(CIColor *)backgroundColor ;

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
                                logoImageSize:(CGSize)logoImageSize;

@end
