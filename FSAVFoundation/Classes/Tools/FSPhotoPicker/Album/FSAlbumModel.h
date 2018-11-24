//
//  FSAlbumModel.h
//  FSPhotoPicker
//
//  Created by 付森 on 2018/9/10.
//  Copyright © 2018年 付森. All rights reserved.
//  相册模型类

#import <UIKit/UIKit.h>

/*
 照片APP结构“相簿”->“相册”->“资源”
 */

@class PHAsset;
@interface FSAlbumModel : NSObject

/// 最后一张照片
@property (nonatomic, strong) UIImage *faceImage;

/// 照片数量
@property (nonatomic, assign) NSInteger count;

/// 照片数组
@property (nonatomic, strong) NSArray<PHAsset *> *assetArray;

/// 相册名
@property (nonatomic, strong) NSString *name;

@end
