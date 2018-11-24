//
//  FSPhoto.h
//  FSPhotoPicker
//
//  Created by 付森 on 2018/9/10.
//  Copyright © 2018年 付森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>


@interface FSPhoto : NSObject

@property (nonatomic, strong, readonly) PHAsset *asset;

@property (nonatomic, assign, readonly) CGSize targetSize;

@property (nonatomic, assign) BOOL selected;

+ (FSPhoto *)photoObjWithAsset:(PHAsset *)asset targetSize:(CGSize)size;

@end
