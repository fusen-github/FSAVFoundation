//
//  FSPhoto.m
//  FSPhotoPicker
//
//  Created by 付森 on 2018/9/10.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSPhoto.h"

@implementation FSPhoto

+ (FSPhoto *)photoObjWithAsset:(PHAsset *)asset targetSize:(CGSize)size
{
    FSPhoto *obj = [[FSPhoto alloc] init];
    
    obj->_asset = asset;
    
    obj->_targetSize = size;
    
    return obj;
}

@end
