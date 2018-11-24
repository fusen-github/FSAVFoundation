//
//  FSPhotoPickerConfiguration.h
//  FSAVFoundation
//
//  Created by 付森 on 2018/11/22.
//  Copyright © 2018年 付森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

//@class FSAlbumModel;
@interface FSPhotoPickerConfiguration : NSObject

- (instancetype)initWithAlbumListIconSize:(CGSize)iconSize selectImageSize:(CGSize)selectImageSize maxSelectCount:(NSUInteger)maxCount;

@property (nonatomic, assign, readonly) CGSize albumListIconSize;

@property (nonatomic, assign, readonly) CGSize selectImageSize;

@property (nonatomic, assign, readonly) NSUInteger maxSelectCount;

/**
 是否直接跳转到grid界面
 */
@property (nonatomic, assign) BOOL showGridDirectly;

@end
