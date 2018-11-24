//
//  FSPhotoPickerController.h
//  FSPhotoPicker
//
//  Created by 付森 on 2018/9/11.
//  Copyright © 2018年 付森. All rights reserved.
//

/*
 照片选择器类，创建对象后，要用presentViewController:animated:completion:方法
 */

#import <UIKit/UIKit.h>
#import "FSPhotoPickerConfiguration.h"


@class FSPhotoPickerController;
@protocol FSPhotoPickerControllerDelegate <NSObject>

@optional

/**
 照片选择器中已经勾选的照片等于最大可选照片数量(FSPhotoPickerController.maxPickerCount)时，
 再去选择照片时的回调。如果此时是反选，则不执行该代理方法

 @param picker 照片选择器
 @param count 最大允许选择的照片数量
 */
- (void)picker:(FSPhotoPickerController *)picker alreadySelectedMaxCount:(NSNumber *)count;


/**
 勾选好要选择的照片，点击确定时执行的代理
 此代理方法会在点击“确定”按钮后执行一次返回所有勾选的照片对象，占用内存过大
 当实现-picker:didSelectedPhoto:finished:代理方法时，该代理方法不会执行
 
 @param picker 照片选择器
 @param photos 勾选的所有照片
 */
//- (void)picker:(FSPhotoPickerController *)picker didFinishSelectedPhotos:(NSArray<UIImage *> *)photos;


/**
 开始取照片时的回调
 主线程
 
 @param picker 照片选择器
 */
- (void)beginFetchImagePicker:(FSPhotoPickerController *)picker;

/**
 勾选好要选择的照片，点击确定时执行的代理

 此代理方法会在在点击“确定”按钮后，将勾选的照片一张一张的返回。
 勾选多少张照片，就执行多少次该代理方法。
 占用内存小
 该代理方法是在子线程中执行的
 
 @param picker 照片选择器
 @param image 勾选照片
 */
- (void)picker:(FSPhotoPickerController *)picker didFetchImage:(UIImage *)image;


/**
 完成取照片操作的回调

 @param picker 主线程
 */
- (void)endFetchImagePicker:(FSPhotoPickerController *)picker resultArray:(NSArray *)array;


//- (void)picker:(FSPhotoPickerController *)picker didFinishSelectedPhotoDatas:(NSArray<NSData *> *)dataArray;

@end

@class FSAlbumModel;

@interface FSPhotoPickerController : UINavigationController


/**
 初始化方法

 @param configuration 配置对象，必须有值
 @param error 错误
 @return FSPhotoPickerController实例
 */
- (instancetype)initWithConfiguration:(FSPhotoPickerConfiguration *)configuration
                                error:(NSError *__autoreleasing *)error;


@property (nonatomic, strong, readonly) FSPhotoPickerConfiguration *configuration;

/**
 代理
 */
@property (nonatomic, weak) id<FSPhotoPickerControllerDelegate> pickerDelegate;


@end
