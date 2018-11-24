//
//  FSPhotoPickerConfiguration.m
//  FSAVFoundation
//
//  Created by 付森 on 2018/11/22.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSPhotoPickerConfiguration.h"
#import "FSAlbumModel.h"
#import "FSPhotoPickerUtil.h"


@interface FSPhotoPickerConfiguration ()

@end

#define KIconSize CGSizeMake(30, 40)

#define kSelectImageSize [UIScreen mainScreen].bounds.size

@implementation FSPhotoPickerConfiguration

- (instancetype)initWithAlbumListIconSize:(CGSize)iconSize
                          selectImageSize:(CGSize)selectImageSize
                           maxSelectCount:(NSUInteger)maxCount
{
    if (self = [super init])
    {
        self->_albumListIconSize = iconSize;
        
        if (iconSize.width <= 0 || iconSize.height <= 0)
        {
            self->_albumListIconSize = KIconSize;
        }
        
        self->_selectImageSize = selectImageSize;
        
        if (selectImageSize.width <= 0 || selectImageSize.height <= 0)
        {
            self->_selectImageSize = kSelectImageSize;
        }
        
        self->_maxSelectCount = maxCount;
        
        if (maxCount <= 0)
        {
            self->_maxSelectCount = 9;
        }
    }
    return self;
}

- (instancetype)init
{
    NSAssert(NO, @"请使用-initWithAlbumListIconSize:selectImageSize:maxSelectCount方法来实例化FSPhotoPickerConfiguration对象");
    
    return nil;
}

- (NSArray <FSAlbumModel *> *)loadValideAlbumsWithError:(NSError **)error
{
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    
    PHFetchResult<PHAssetCollection *> *smartCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:options];
    
    NSArray *smarts = [self fetchAlbumModelWithCollections:smartCollections];
    
    PHFetchResult<PHAssetCollection *> *albumCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:options];
    
    NSArray *albums = [self fetchAlbumModelWithCollections:albumCollections];
    
    NSMutableArray *result = [NSMutableArray arrayWithArray:smarts];
    
    [result addObjectsFromArray:albums];
    
    return result;
}

- (NSArray *)fetchAlbumModelWithCollections:(PHFetchResult<PHAssetCollection *> *)collections
{
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    /*
     1、只用 *stop = YES; 跳出循环Block，但是本次循环需要执行完成。
     2、只用 return; 跳出本次循环Block，相当于for循环中continue的用法。
     3、*stop = YES; 和 return; 连用，跳出循环Block，不执行本次循环剩余的代码，相当于for循环中break的用法。
     */
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    
    /* 按asset创建日期排序 */
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES];
    
    options.sortDescriptors = @[sortDesc];
    
    /* 只加载照片类型的asset */
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    
    [collections enumerateObjectsUsingBlock:^(PHAssetCollection *obj, NSUInteger idx, BOOL *stop) {
        
        PHFetchResult<PHAsset *> *allAssets = [PHAsset fetchAssetsInAssetCollection:obj options:options];
        
        if (allAssets.count == 0)
        {
            /// 枚举遍历中的return， 相当于for循环中的continue
            return;
        }
        
        NSString *title = obj.localizedTitle;
        
        if (!title.length)
        {
            /// 枚举遍历中的return， 相当于for循环中的continue
            return;
        }
        
        FSAlbumModel *item = [[FSAlbumModel alloc] init];
        
        item.name = title;
        
        item.count = allAssets.count;
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, allAssets.count)];
        
        item.assetArray = [allAssets objectsAtIndexes:indexSet];
        
        PHAsset *last = [item.assetArray lastObject];
        
        CGSize targetSize = self.albumListIconSize;
        
        [FSPhotoPickerUtil imageWithAsset22:last size:targetSize completion:^(UIImage *image) {
           
            item.faceImage = image;
        }];
        
        if (obj.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary)
        {
            [tmpArray insertObject:item atIndex:0];
        }
        else
        {
            [tmpArray addObject:item];
        }
    }];
    
    return tmpArray;
}

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

- (void)fetchSmartTypeWithSubtypes:(NSSet<NSNumber *> *)subtypes options:(PHFetchOptions *)options
{
    
    /*
     PHAssetCollectionSubtypeSmartAlbumGeneric    = 200,
     PHAssetCollectionSubtypeSmartAlbumPanoramas  = 201,
     PHAssetCollectionSubtypeSmartAlbumVideos     = 202,
     PHAssetCollectionSubtypeSmartAlbumFavorites  = 203,
     PHAssetCollectionSubtypeSmartAlbumTimelapses = 204,
     PHAssetCollectionSubtypeSmartAlbumAllHidden  = 205,
     PHAssetCollectionSubtypeSmartAlbumRecentlyAdded = 206,
     PHAssetCollectionSubtypeSmartAlbumBursts     = 207,
     PHAssetCollectionSubtypeSmartAlbumSlomoVideos = 208,
     PHAssetCollectionSubtypeSmartAlbumUserLibrary = 209,
     */
    
//    PHAssetCollectionSubtype
    
//    NSArray *primarySubtypes = @[@(PHAssetCollectionSubtypeSmartAlbumGeneric),
//                                 @(PHAssetCollectionSubtypeSmartAlbumPanoramas),
//                                 @(PHAssetCollectionSubtypeSmartAlbumVideos),
//                                 @(PHAssetCollectionSubtypeSmartAlbumFavorites),
//                                 @(PHAssetCollectionSubtypeSmartAlbumTimelapses),
//                                 @(PHAssetCollectionSubtypeSmartAlbumAllHidden),
//                                 @(PHAssetCollectionSubtypeSmartAlbumRecentlyAdded),
//                                 @(PHAssetCollectionSubtypeSmartAlbumBursts),
//                                 @(PHAssetCollectionSubtypeSmartAlbumSlomoVideos),
//                                 @(PHAssetCollectionSubtypeSmartAlbumUserLibrary)];
//
//    NSMutableArray *subtypes = [NSMutableArray arrayWithArray:primarySubtypes];
//
//    [PHAssetCollection fetchAssetCollectionsWithType:<#(PHAssetCollectionType)#> subtype:<#(PHAssetCollectionSubtype)#> options:<#(nullable PHFetchOptions *)#>]
    
    
}

@end
