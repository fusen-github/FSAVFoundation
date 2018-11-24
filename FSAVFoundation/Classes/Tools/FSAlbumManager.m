//
//  FSAlbumManager.m
//  FSAVFoundation
//
//  Created by 付森 on 2018/11/22.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSAlbumManager.h"
#import <Photos/Photos.h>
#import "FSAlbumItem.h"


@implementation FSAlbumManager

/*相簿： iOS系统照片app中的“相簿”tab页 */

+ (void)requestAuthorization:(void (^)(BOOL))complection
{
    if ([PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusAuthorized)
    {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            if (complection)
            {
                BOOL result = status == PHAuthorizationStatusAuthorized;
                
                complection(result);
            }
        }];
    }
    else
    {
        if (complection)
        {
            complection(YES);
        }
    }
}

/*
 typedef NS_ENUM(NSInteger, PHAssetCollectionType) {
 
    /// 获取iOS系统“照片app”中“相簿”tab里的“用户(或者其它app， 比如QQ，微信)自定义相册”
    PHAssetCollectionTypeAlbum      = 1,
    /// 获取iOS系统“照片app”中“相簿”tab里的“系统自定义的自定义相册(比如"相机胶卷"、”动图“、”最近添加“)”
    PHAssetCollectionTypeSmartAlbum = 2,
    /// 获取iOS系统“照片app”中“照片(第一个)”tab里的“相册(时刻、精选、年度)”
    PHAssetCollectionTypeMoment     = 3,
 } PHOTOS_ENUM_AVAILABLE_IOS_TVOS(8_0, 10_0);
 */



/**
 获取iOS系统Photo app中的“相簿”tab里的“Smart”分组中的资源(PHAsset)
 */
+ (NSArray <FSAlbumItem *> *)fetchSmartAssetCollections
{
    /*
     PHAssetCollectionSubtypeSmartAlbumGeneric              = 200,  // 未知
     PHAssetCollectionSubtypeSmartAlbumPanoramas            = 201,  // 全景照片
     PHAssetCollectionSubtypeSmartAlbumVideos               = 202,  // 视频
     PHAssetCollectionSubtypeSmartAlbumFavorites            = 203,  // 个人收藏
     PHAssetCollectionSubtypeSmartAlbumTimelapses           = 204,  // 延时摄影
     PHAssetCollectionSubtypeSmartAlbumAllHidden            = 205,  // 已隐藏
     PHAssetCollectionSubtypeSmartAlbumRecentlyAdded        = 206,  // 最近添加
     PHAssetCollectionSubtypeSmartAlbumBursts               = 207,  // 连拍快照
     PHAssetCollectionSubtypeSmartAlbumSlomoVideos          = 208,  // 慢动作
     PHAssetCollectionSubtypeSmartAlbumUserLibrary          = 209,  // 相机胶卷
     PHAssetCollectionSubtypeSmartAlbumSelfPortraits        = 210,  // 自拍
     PHAssetCollectionSubtypeSmartAlbumScreenshots          = 211,  // 屏幕快照
     PHAssetCollectionSubtypeSmartAlbumDepthEffect          = 212,  // 人像
     PHAssetCollectionSubtypeSmartAlbumLivePhotos           = 213,  // 实况照片
     PHAssetCollectionSubtypeSmartAlbumAnimated             = 214,  // 动图
     PHAssetCollectionSubtypeSmartAlbumLongExposures        = 215,  // 长曝光
     */
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    
    NSMutableArray *sortDescriptors = [NSMutableArray array];
    
    /*
     key: key or keyPath
     ascending:是否是升序
     */
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:NO];
    
    [sortDescriptors addObject:sortDesc];
    
    options.sortDescriptors = sortDescriptors;
    
    PHFetchResult<PHAssetCollection *> *systemDefineAssetCollectionResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:options];
    
    NSArray *array = [self album_handleAssetColletion:systemDefineAssetCollectionResult];
    
    return array;
}


/**
 获取iOS系统Photo app中的“相簿”tab里的“我的相簿”分组中的资源(PHAsset)
 */
+ (void)album_fetchUserOrOtherAppDefineAssetCollections
{
    PHFetchOptions *collcetOptions = [[PHFetchOptions alloc] init];
    
    NSMutableArray *sortDescriptors = [NSMutableArray array];
    
    /*
     key: key or keyPath
     ascending:是否是升序
     */
    
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:NO];
    
    [sortDescriptors addObject:sortDesc];
    
    collcetOptions.sortDescriptors = sortDescriptors;
    
    PHFetchResult<PHAssetCollection *> *customAssetCollectionResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:collcetOptions];
    
    NSArray *array = [self album_handleAssetColletion:customAssetCollectionResult];
    
    NSLog(@"%@",array);
}

/**
 公共方法
 @return 相簿中的资源集合名字
 */
+ (NSArray *)album_handleAssetColletion:(PHFetchResult<PHAssetCollection *> *)assetCollectionResult
{
    NSMutableArray *infoArray = [NSMutableArray array];
    
    /* 遍历一个相簿分组中的所有的资源集合 */
    for (PHAssetCollection *assetCollection in assetCollectionResult)
    {
        PHFetchOptions *assetOption = [[PHFetchOptions alloc] init];
        
        NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES];
        
        assetOption.sortDescriptors = @[sortDesc];
        
        PHFetchResult<PHAsset *> *allAssets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:assetOption];
        
        NSString *title = assetCollection.localizedTitle;
        
        if (!title.length)
        {
            title = @"<未知名称>";
        }
        
        FSAlbumItem *item = [[FSAlbumItem alloc] init];
        
        item.title = title;
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, allAssets.count)];
        
        item.assets = [allAssets objectsAtIndexes:indexSet];
        
        [infoArray addObject:item];
    }
    
    return infoArray;
}

@end
