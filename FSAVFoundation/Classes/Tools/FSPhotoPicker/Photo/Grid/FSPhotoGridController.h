//
//  FSPhotoGridController.h
//  
//
//  Created by 付森 on 2018/9/5.
//  Copyright © 2018年 付森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSPhoto.h"
#import "FSPhotoPickerBaseController.h"

@class FSPhotoGridController;
@protocol FSPhotoGridControllerDelegate <NSObject>

@optional
- (void)gridController:(FSPhotoGridController *)controller selectedPhotosAlreadyIsMaxCount:(NSInteger)maxCount;

@end

@interface FSPhotoGridController : FSPhotoPickerBaseController

- (instancetype)initWithPhotos:(NSArray <FSPhoto *>*)photos;

@property (nonatomic, assign) NSInteger maxPickerCount;

@property (nonatomic, weak) id<FSPhotoGridControllerDelegate> delegate;

@end
