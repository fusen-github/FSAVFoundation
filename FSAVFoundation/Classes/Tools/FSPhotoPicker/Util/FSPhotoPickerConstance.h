//
//  FSPhotoPickerConstance.h
//  FSPhotoPicker
//
//  Created by 付森 on 2018/9/11.
//  Copyright © 2018年 付森. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 点击“确定按钮”后的通知id
extern NSString * const kFSPhotoPickerDidFinishSelectedAssetsEvent;

/// 当已经选择了最大选择值后，还继续选择照片时的通知id
extern NSString * const kFSPhotoPickerAlreadySelectedMaxCountEvent;

/// grid的最大宽高，实际宽高小于或等于这个值
extern CGFloat const kFSPhotoPickerGridItemMaxWH;

@interface FSPhotoPickerConstance : NSObject

@end
