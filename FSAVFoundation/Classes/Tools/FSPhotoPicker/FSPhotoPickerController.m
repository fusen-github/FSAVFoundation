//
//  FSPhotoPickerController.m
//  FSPhotoPicker
//
//  Created by 付森 on 2018/9/11.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSPhotoPickerController.h"
#import "FSAlbumController.h"
#import "FSPhotoPickerConstance.h"
#import "FSPhoto.h"
#import "FSPhotoPickerUtil.h"


@interface FSPhotoPickerConfiguration (Private)

/**
 加载有效的相册

 @param error 错误描述
 */
- (NSArray <FSAlbumModel *> *)loadValideAlbumsWithError:(NSError **)error;

@end

@interface FSPhotoPickerController ()

@end

static NSError * ErrorWithMessage(NSString *msg)
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    [userInfo setObject:msg forKey:NSLocalizedDescriptionKey];
    
    NSError *error = [NSError errorWithDomain:@"com.FSPhotoPickerController.error" code:-1 userInfo:userInfo];
    
    return error;
}

@implementation FSPhotoPickerController

- (instancetype)initWithConfiguration:(FSPhotoPickerConfiguration *)configuration
                                error:(NSError *__autoreleasing *)error
{
    if (self = [super init])
    {
        if (configuration == nil)
        {
            *error = ErrorWithMessage(@"FSPhotoPickerConfiguration 不能为nil");
            
            return nil;
        }
        
        self->_configuration = configuration;
        
        NSArray *array = [self.configuration loadValideAlbumsWithError:nil];
        
        FSAlbumController *root =
        [[FSAlbumController alloc] initWithAlbums:array
                                   maxPickerCount:configuration.maxSelectCount
                              showGridimmediately:configuration.showGridDirectly];
        
        [self pushViewController:root animated:NO];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self
                           selector:@selector(didFinishSelectedAssets:)
                               name:kFSPhotoPickerDidFinishSelectedAssetsEvent
                             object:nil];
    
    [notificationCenter addObserver:self
                           selector:@selector(alreadySelectedMaxCount:)
                               name:kFSPhotoPickerAlreadySelectedMaxCountEvent
                             object:nil];
}

/*
 {
 从相册获取图片返回的info字典
 PHImageFileOrientationKey = 0;
 PHImageFileSandboxExtensionTokenKey = "27b63b757d01b061fd128898c936e847175251d7;00000000;00000000;000000000000001a;com.apple.app-sandbox.read;01;01000004;00000000043b594b;/private/var/mobile/Media/DCIM/101APPLE/IMG_1813.JPG";
 PHImageFileURLKey = "file:///var/mobile/Media/DCIM/101APPLE/IMG_1813.JPG";
 PHImageFileUTIKey = "public.jpeg";
 PHImageResultDeliveredImageFormatKey = 9999;
 PHImageResultIsDegradedKey = 0;
 PHImageResultIsInCloudKey = 0;
 PHImageResultIsPlaceholderKey = 0;
 PHImageResultWantedImageFormatKey = 4035;
 }
 */

- (void)didFinishSelectedAssets:(NSNotification *)notification
{
    if ([self.pickerDelegate respondsToSelector:@selector(beginFetchImagePicker:)])
    {
        [self.pickerDelegate beginFetchImagePicker:self];
    }

    if ([self.pickerDelegate respondsToSelector:@selector(picker:didFetchImage:)])
    {
        /// 可以考虑用“信号量”，在for内控制并发数
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSArray *array = notification.object;
            
//            NSArray *resultArray = [self getImageWay:array];
            
            NSArray *resultArray = [self getDataWay:array];
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                if ([self.pickerDelegate respondsToSelector:@selector(endFetchImagePicker:resultArray:)])
                {
                    [self.pickerDelegate endFetchImagePicker:self resultArray:resultArray];
                }
            });
        });
    }
}



/**
 该方式不会出现内存暴涨
 较好的实现方式(推荐)
 */
- (NSArray *)getDataWay:(NSArray<FSPhoto *> *)array
{
    /*
     info字典的log
     {
     PHImageFileDataKey = <PLXPCShMemData: 0x1c043cd60> bufferLength=2031616 dataLength=2022150;
     PHImageFileOrientationKey = 3;
     PHImageFileSandboxExtensionTokenKey = "8573bcf09edcc369b0139b6660db610c44b53115;00000000;00000000;000000000000001a;com.apple.app-sandbox.read;01;01000004;0000000003e07ee0;/private/var/mobile/Media/DCIM/101APPLE/IMG_1772.JPG";
     PHImageFileURLKey = "file:///var/mobile/Media/DCIM/101APPLE/IMG_1772.JPG";
     PHImageFileUTIKey = "public.jpeg";
     PHImageResultDeliveredImageFormatKey = 9999;
     PHImageResultIsDegradedKey = 0;
     PHImageResultIsInCloudKey = 0;
     PHImageResultIsPlaceholderKey = 0;
     PHImageResultWantedImageFormatKey = 9999;
     }
     */
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    NSString *tmpDir = [self photoPickerTempPath];
    
    for (FSPhoto *obj in array)
    {
        @autoreleasepool
        {
            [FSPhotoPickerUtil imageDataWithAsset:obj.asset completion:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
            
                @autoreleasepool {
                    
                    /*
                     策略:
                     1、先将拿到的imageData保存到app的沙盒目录中
                     2、获取一张较小的缩略图，空展示使用
                     3、当需要的时候再从沙盒去除原图
                     */
                    NSURL *url = [info objectForKey:@"PHImageFileURLKey"];
                    
                    NSString *filePath = [tmpDir stringByAppendingPathComponent:url.lastPathComponent];
                    
                    BOOL rst = [imageData writeToFile:filePath atomically:YES];
                    
                    NSLog(@"rst = %d", rst);
                    
                    UIImage *image = [UIImage imageWithData:imageData];
                    
                    image = [self thumbnailWithImage:image size:CGSizeMake(200, 300)];
                    
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    
                    [dict setObject:image forKey:@"image"];
                    
                    [dict setObject:filePath forKey:@"location"];
                    
                    [resultArray addObject:dict];
                }
            }];
        }
    }
    
    return resultArray;
}

/**
 该方式会导致内存暴涨
 较差的实现方式
 */
- (NSArray *)getImageWay:(NSArray<FSPhoto *> *)array
{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    NSString *tmpDir = [self photoPickerTempPath];
    
    for (FSPhoto *obj in array)
    {
        @autoreleasepool
        {
            CGSize targetSize = CGSizeMake(obj.asset.pixelWidth, obj.asset.pixelHeight);
            
            [FSPhotoPickerUtil imageWithAsset11:obj.asset size:targetSize completion:^(UIImage *image, NSDictionary *info) {
                
                @autoreleasepool
                {
                    NSURL *url = [info objectForKey:@"PHImageFileURLKey"];
                    
                    NSData *data = UIImageJPEGRepresentation(image, 1);
                    
                    NSString *filePath = [tmpDir stringByAppendingPathComponent:url.lastPathComponent];
                    
                    [data writeToFile:filePath atomically:YES];
                    
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    
                    UIImage *thumbImg = [self thumbnailWithImage:image size:CGSizeMake(200, 300)];
                    
                    [dict setObject:thumbImg forKey:@"image"];
                    
                    [dict setObject:filePath forKey:@"location"];
                    
                    [resultArray addObject:dict];
                }
            }];
        }
    }
    
    return resultArray;
}

- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    
    UIImage *newimage;
    
    if (nil == image) {
        
        newimage = nil;
        
    }
    
    else{
        
        CGSize oldsize = image.size;
        
        CGRect rect;
        
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            
            rect.size.height = asize.height;
            
            rect.origin.x = (asize.width - rect.size.width)/2;
            
            rect.origin.y = 0;
            
        }
        
        else{
            
            rect.size.width = asize.width;
            
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            
            rect.origin.x = 0;
            
            rect.origin.y = (asize.height - rect.size.height)/2;
            
        }
        
        UIGraphicsBeginImageContext(asize);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        
        [image drawInRect:rect];
        
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
    }
    
    return newimage;
}

- (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    
    if (nil == image)
    {
        newimage = nil;
    }
    else
    {
        UIGraphicsBeginImageContext(asize);
        
        [image drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
        
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    
    return newimage;
    
}

- (NSString *)photoPickerTempPath
{
    NSString *tmp = NSTemporaryDirectory();
    
    tmp = [tmp stringByAppendingPathComponent:@"PhotoPicker"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:tmp])
    {
        NSError *error = nil;
        
        BOOL value = [manager createDirectoryAtPath:tmp withIntermediateDirectories:YES attributes:nil error:&error];
        
        if (!value || error)
        {
            return nil;
        }
    }
 
    return tmp;
}

- (void)alreadySelectedMaxCount:(NSNotification *)notification
{
    if ([self.pickerDelegate respondsToSelector:@selector(picker:alreadySelectedMaxCount:)])
    {
        [self.pickerDelegate picker:self alreadySelectedMaxCount:notification.object];
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"FSPhotoPickerController dealloc");
}

@end
