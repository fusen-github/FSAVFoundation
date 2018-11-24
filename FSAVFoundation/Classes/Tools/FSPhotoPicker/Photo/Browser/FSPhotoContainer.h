//
//  FSPhotoContainer.h
//  FSPhotoPicker
//
//  Created by 付森 on 2018/9/10.
//  Copyright © 2018年 付森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSPhotoPickerBaseController.h"

@class FSPhotoContainer;
@protocol FSPhotoContainerDelegate <NSObject>
@optional
- (void)container:(FSPhotoContainer *)container wantToCheckButton:(UIButton *)button;

@end

@class FSPhoto;
@interface FSPhotoContainer : FSPhotoPickerBaseController

@property (nonatomic, strong, readonly) FSPhoto *photo;

@property (nonatomic, weak) id<FSPhotoContainerDelegate> delegate;

- (instancetype)initWithPhoto:(FSPhoto *)photo;

@end
