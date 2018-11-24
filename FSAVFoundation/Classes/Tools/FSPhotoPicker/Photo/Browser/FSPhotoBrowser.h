//
//  FSPhotoBrowser.h
//  FSPhotoPicker
//
//  Created by 付森 on 2018/9/10.
//  Copyright © 2018年 付森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSPhotoPickerBaseController.h"

@class FSPhoto;
@interface FSPhotoBrowser : FSPhotoPickerBaseController

@property (nonatomic, assign) NSInteger maxPickerCount;

- (instancetype)initWithPhotos:(NSArray <FSPhoto *> *)photos currentIndex:(NSInteger)index;

- (void)setupPopBlock:(void(^)(void))block;

@end
