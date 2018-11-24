//
//  FSPhotoPickerUtil.h
//  FSPhotoPicker
//
//  Created by 付森 on 2018/9/10.
//  Copyright © 2018年 付森. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHAsset;
@interface FSPhotoPickerUtil : NSObject

+ (UIImage *)bundleImageWithName:(NSString *)name;

+ (UIImage *)whiteImageWithSize:(CGSize)size;

+ (UIButton *)confirmButton;

+ (void)cachingImagesForAssets:(NSArray<PHAsset *> *)array size:(CGSize)size;

+ (void)imageWithAsset22:(PHAsset *)asset size:(CGSize)size completion:(void(^)(UIImage *image))completion;

+ (void)imageWithAsset11:(PHAsset *)asset
                    size:(CGSize)size
              completion:(void (^)(UIImage *, NSDictionary *info))completion;

+ (void)imageDataWithAsset:(PHAsset *)asset completion:(void(^)(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info))completion;

@end
