//
//  FSAlbumItem.h
//  FSAVFoundation
//
//  Created by 付森 on 2018/11/22.
//  Copyright © 2018年 付森. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PHAsset;
@interface FSAlbumItem : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSArray<PHAsset *> *assets;

@end
