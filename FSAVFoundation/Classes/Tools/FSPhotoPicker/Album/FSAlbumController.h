//
//  FSAlbumController.h
//  FSPhotoPicker
//
//  Created by 付森 on 2018/9/10.
//  Copyright © 2018年 付森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSPhotoPickerBaseController.h"

@class FSAlbumModel;
@interface FSAlbumController : FSPhotoPickerBaseController

- (instancetype)initWithAlbums:(NSArray <FSAlbumModel *>*)albums
                maxPickerCount:(NSInteger)count
           showGridimmediately:(BOOL)show;

@end
