//
//  FSPhotoPickerManager.m
//  FSPhotoPicker
//
//  Created by 付森 on 2018/9/10.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSPhotoPickerManager.h"
#import <Photos/Photos.h>
#import "FSAlbumModel.h"


@implementation FSPhotoPickerManager

+ (void)loadAlbumWithCompletion:(void (^) (NSArray <FSAlbumModel *>*arr))completion
{
    float system = [UIDevice currentDevice].systemVersion.floatValue;
    
    if (system >= 8.0)
    {
        // Check library permissions
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        
        if (status == PHAuthorizationStatusNotDetermined)
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                
                if (status == PHAuthorizationStatusAuthorized)
                {
                    [self performLoadAssetsWithCompletion:completion];
                }
            }];
        }
        else if (status == PHAuthorizationStatusAuthorized)
        {
            [self performLoadAssetsWithCompletion:completion];
        }
        else if (status == PHAuthorizationStatusDenied || PHAuthorizationStatusRestricted)
        {
            NSString *title = @"提示";
            
            NSString *message = @"App被禁止使用系统相册，是否跳转到系统设置，以打开权限?";
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                    if (system >= 10.0)
                    {
                        NSURL *url = [NSURL URLWithString:@"App-Prefs:root=Privacy&path=PHOTOS"];

                        if ([[UIApplication sharedApplication] canOpenURL:url])
                        {
                            [[UIApplication sharedApplication] openURL:url];
                        }
                    }
                    else
                    {
                        /// 没有ios 10以下系统的设备，暂时没法测试，不知道这样是否可行。
                        NSURL *url = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];

                        if ([[UIApplication sharedApplication] canOpenURL:url])
                        {
                            [[UIApplication sharedApplication] openURL:url];
                        }
                    }
            }];
        
        
            [alertController addAction:confirm];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertController addAction:cancel];
            
            UIViewController *rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
            
            [rootController presentViewController:alertController animated:YES completion:nil];
        }
    }
    else
    {
        NSString *title = @"提示";
        
        NSString *message = @"当前系统版本小于iOS 8.0,暂不支持！！！";
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        
        [alertController addAction:confirm];
        
        UIViewController *rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
        
        [rootController presentViewController:alertController animated:YES completion:nil];
    }
}

+ (void)performLoadAssetsWithCompletion:(void (^) (NSArray <FSAlbumModel *>*arr))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self loadAllAlbumsCompletion:completion];
    });
}

+ (void)loadAllAlbumsCompletion:(void (^) (NSArray <FSAlbumModel *>*arr))completion
{
    NSMutableArray *albumArr = [NSMutableArray array];
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    
    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    
    PHFetchResult *myPhotoStreamAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream options:nil];
    
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    PHFetchResult *syncedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
    
    PHFetchResult *sharedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumCloudShared options:nil];
    
    NSArray *allAlbums = @[myPhotoStreamAlbum,smartAlbums,topLevelUserCollections,syncedAlbums,sharedAlbums];
    
    for (PHFetchResult *tmpFetchResult in allAlbums)
    {
        for (PHAssetCollection *collection in tmpFetchResult)
        {
            if (![collection isKindOfClass:[PHAssetCollection class]]) continue;
            
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            
            if (fetchResult.count < 1) continue;
            
            if ([collection.localizedTitle containsString:@"Deleted"] ||
                [collection.localizedTitle isEqualToString:@"最近删除"])
            {
                continue;
            }
            
            id model = [self modelWithResult:fetchResult name:collection.localizedTitle];
            
            if ([self isCameraRollAlbum:collection.localizedTitle])
            {
                [albumArr insertObject:model atIndex:0];
                
            } else
            {
                [albumArr addObject:model];
            }
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (completion)
        {
            completion(albumArr);
        }
    });
}

+ (BOOL)isCameraRollAlbum:(NSString *)albumName
{
    NSString *versionStr = [[UIDevice currentDevice].systemVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    if (versionStr.length <= 1)
    {
        versionStr = [versionStr stringByAppendingString:@"00"];
    }
    else if (versionStr.length <= 2)
    {
        versionStr = [versionStr stringByAppendingString:@"0"];
    }
    
    CGFloat version = versionStr.floatValue;
    
    // 目前已知8.0.0 - 8.0.2系统，拍照后的图片会保存在最近添加中
    if (version >= 800 && version <= 802)
    {
        return [albumName isEqualToString:@"最近添加"] || [albumName isEqualToString:@"Recently Added"];
        
    } else
    {
        return [albumName isEqualToString:@"Camera Roll"] || [albumName isEqualToString:@"相机胶卷"] || [albumName isEqualToString:@"所有照片"] || [albumName isEqualToString:@"All Photos"];
    }
}

+ (FSAlbumModel *)modelWithResult:(PHFetchResult *)result name:(NSString *)name
{
    FSAlbumModel *model = [[FSAlbumModel alloc] init];
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    [result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        [tmpArray addObject:obj];
    }];
    
    model.assetArray = tmpArray;
    
    model.name = name;
    
    if ([result isKindOfClass:[PHFetchResult class]])
    {
        PHFetchResult *fetchResult = (PHFetchResult *)result;
        
        model.count = fetchResult.count;
    }
    
    id asset = [result firstObject];
    
    if ([asset isKindOfClass:[PHAsset class]])
    {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        
        options.synchronous = YES;
        
        CGSize size = CGSizeMake(100, 120);
        
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * result, NSDictionary *info) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                if (result)
                {
                    model.faceImage = result;
                }
            });
        }];
    }
    
    return model;
}





@end
