//
//  FSAlbumManager.h
//  FSAVFoundation
//
//  Created by 付森 on 2018/11/22.
//  Copyright © 2018年 付森. All rights reserved.
//

#import <Foundation/Foundation.h>


@class FSAlbumItem;
@interface FSAlbumManager : NSObject

+ (void)requestAuthorization:(void(^)(BOOL granted))complection;

+ (NSArray <FSAlbumItem *> *)fetchSmartAssetCollections;

@end
