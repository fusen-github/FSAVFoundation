//
//  FSPhotoPickerManager.h
//  FSPhotoPicker
//
//  Created by 付森 on 2018/9/10.
//  Copyright © 2018年 付森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSAlbumModel.h"

@class FSAlbumModel;
@interface FSPhotoPickerManager : NSObject

//+ (void)loadAlbumWithCompletion:(void (^) (NSArray <FSAlbumModel *>*arr))completion;

+ (void)loadSmartAlbum:(void (^)(NSArray <FSAlbumModel *> *albums, NSError *error))completion;

+ (void)loadCustomAlbum:(void (^)(NSArray <FSAlbumModel *> *albums, NSError *error))completion;

+ (void)loadSmartAndCustomAlbum:(void (^)(NSArray <FSAlbumModel *> *smartAlbum, NSArray <FSAlbumModel *> *customAlbum, NSError *error))completion;

@end
