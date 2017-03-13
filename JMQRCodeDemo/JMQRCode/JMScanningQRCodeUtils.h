//
//  JMScanningQRCodeUtils.h
//  JMQRCodeDemo
//
//  Created by James.xiao on 2017/3/13.
//  Copyright © 2017年 James. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JMScanningQRCodeUtils : NSObject

/**
 *  @brief 获取图片包含的二维码信息
 *
 *  @param image       图片
 *
 *  @return NSString
 */
+ (NSString *)jm_scanQRCodeFromPhotosAlbum:(UIImage *)image;

/**
 *  @brief 检查相机授权状态
 *
 *  @param success       授权成功
 *  @param failure       授权失败
 *
 */
+ (void)jm_cameraAuthStatusWithSuccess:(void (^)(void))success
                               failure:(void (^)(void))failure;

/**
 *  @brief 检查相册授权状态
 *
 *  @param success       授权成功
 *  @param failure       授权失败
 *
 */
+ (void)jm_albumAuthStatusWithSuccess:(void (^)(void))success
                              failure:(void (^)(void))failure;

@end
