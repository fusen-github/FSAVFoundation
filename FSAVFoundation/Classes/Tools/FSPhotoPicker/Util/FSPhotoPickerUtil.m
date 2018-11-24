//
//  FSPhotoPickerUtil.m
//  FSPhotoPicker
//
//  Created by 付森 on 2018/9/10.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSPhotoPickerUtil.h"
#import <Photos/Photos.h>


@implementation FSPhotoPickerUtil

+ (UIImage *)bundleImageWithName:(NSString *)name
{
    if (!name.length)
    {
        return nil;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"FSPhotoPicker" ofType:@"bundle"];
    
    path = [path stringByAppendingPathComponent:name];
    
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    return image;
}

+ (UIImage *)whiteImageWithSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    
    [[UIColor whiteColor] setFill];
    
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}

+ (UIButton *)confirmButton
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightBtn.frame = CGRectMake(0, 0, 55, 35);
    
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    
    [rightBtn setTitle:@"确定" forState:UIControlStateDisabled];
    
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
    return rightBtn;
}

+ (void)cachingImagesForAssets:(NSArray<PHAsset *> *)array size:(CGSize)size
{
    PHCachingImageManager *manager = [[PHCachingImageManager alloc] init];
    
    [manager startCachingImagesForAssets:array targetSize:size contentMode:PHImageContentModeAspectFill options:[self imageRequestOptions]];
}

+ (void)imageWithAsset22:(PHAsset *)asset size:(CGSize)size completion:(void(^)(UIImage *image))completion;
{
    PHImageManager *manager = [PHImageManager defaultManager];
    
    CGSize targetSize = [self sizeWithScale:size];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    
    options.synchronous = YES;
    
    /// PHImageRequestOptionsResizeModeExact 设置size和targetSize严格一致
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    [manager requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage *result, NSDictionary *info) {
        
        if (completion)
        {
            completion(result);
        }
    }];
}

+ (void)imageWithAsset11:(PHAsset *)asset
                    size:(CGSize)size completion:(void (^)(UIImage *, NSDictionary *info))completion
{
    [[PHImageManager defaultManager]
     requestImageForAsset:asset
     targetSize:[self sizeWithScale:size]
     contentMode:PHImageContentModeAspectFill
     options:[self imageRequestOptions]
     resultHandler:^(UIImage *result, NSDictionary *info) {
         
         if (completion)
         {
             completion(result, info);
         }
     }];
}


+ (void)imageDataWithAsset:(PHAsset *)asset completion:(void(^)(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info))completion
{
    PHImageManager *manager = [PHImageManager defaultManager];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];

    options.synchronous = YES;
    
    /// PHImageRequestOptionsResizeModeExact 设置size和targetSize严格一致
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;

    [manager requestImageDataForAsset:asset
                              options:options
                        resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                           
                            if (completion)
                            {
                                completion(imageData, dataUTI, orientation, info);
                            }
                        }];
}

+ (CGSize)sizeWithScale:(CGSize)size
{
    CGFloat scale = [UIScreen mainScreen].scale;
    
    return CGSizeMake(size.width * scale, size.height * scale);
}

/*
 let options = PHImageRequestOptions()
 options.deliveryMode = .highQualityFormat
 options.resizeMode = .exact
 options.isSynchronous = true
 
 PHImageManager.default().requestImageData(for: asset, options: options, resultHandler: { (data, dataUTI, orientation, info) in
 */

// PHImageRequestOptionsResizeModeExact


///// 图像请求选项
//+ (PHImageRequestOptions *)imageRequestOptions
//{
//    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
//
//    // 设置 resizeMode 可以按照指定大小缩放图像
//    options.resizeMode = PHImageRequestOptionsResizeModeExact;
//
//    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
//
//    options.synchronous = YES;
//
//    return options;
//}


/// 图像请求选项
+ (PHImageRequestOptions *)imageRequestOptions
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    
    options.synchronous = YES;
    
    // 设置 resizeMode 可以按照指定大小缩放图像
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    // 只回调一次缩放之后的照片，否则会调用多次
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    return options;
}

@end
