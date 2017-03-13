//
//  JMScanningQRCodeUtils.m
//  JMQRCodeDemo
//
//  Created by James.xiao on 2017/3/13.
//  Copyright © 2017年 James. All rights reserved.
//

#import "JMScanningQRCodeUtils.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@implementation JMScanningQRCodeUtils

/**
 *  @brief 获取图片包含的二维码信息
 *
 *  @param image       图片
 *
 *  @return NSString
 */
+ (NSString *)jm_scanQRCodeFromPhotosAlbum:(UIImage *)image {
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];

    NSString *result = @"";
    if (features != nil && features.count != 0) {
        CIQRCodeFeature *feature = features[0];
        result  = feature.messageString;
    }
    
    return result;
}

/**
 *  @brief 检查相机授权状态
 *
 *  @param success       授权成功
 *  @param failure       授权失败
 *
 */
+ (void)jm_cameraAuthStatusWithSuccess:(void (^)(void))success
                               failure:(void (^)(void))failure {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 第一次询问用户允许当前应用访问相机
                        if (success) {
                            success();
                        }
                    });
                } else {
                    // 第一次询问用户不允许当前应用访问相机
                    if (failure) {
                        failure();
                    }
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized) {
            // 用户允许当前应用访问相机
            if (success) {
                success();
            }
        } else if (status == AVAuthorizationStatusDenied) {
            // 用户拒绝当前应用访问相机
            if (failure) {
                failure();
            }
        } else if (status == AVAuthorizationStatusRestricted) {
            if (failure) {
                failure();
            }
        }
    }else {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"未检测到您的摄像头, 请在真机上测试" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alertVC animated:true completion:nil];
    }
}

/**
 *  @brief 检查相册授权状态
 *
 *  @param success       授权成功
 *  @param failure       授权失败
 *
 */
+ (void)jm_albumAuthStatusWithSuccess:(void (^)(void))success
                              failure:(void (^)(void))failure {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (device) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        
        if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {                     dispatch_async(dispatch_get_main_queue(), ^{
                    // 第一次询问用户允许当前应用访问相册
                        if (success) {
                            success();
                        }
                    });
                }else {
                    // 第一次询问用户不允许当前应用访问相册
                    if (failure) {
                        failure();
                    }
                }
            }];
        }else if (status == PHAuthorizationStatusAuthorized) {
            // 用户允许当前应用访问相册
            if (success) {
                success();
            }
        }else if (status == PHAuthorizationStatusDenied) {
            // 用户拒绝当前应用访问相册
            if (failure) {
                failure();
            }
        }else if (status == PHAuthorizationStatusRestricted) {
            if (failure) {
                failure();
            }
        }
    }else {
        if (failure) {
            failure();
        }
    }
}

@end
