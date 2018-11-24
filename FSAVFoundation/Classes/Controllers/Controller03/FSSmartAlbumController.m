//
//  FSSmartAlbumController.m
//  FSAVFoundation
//
//  Created by 付森 on 2018/11/22.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSSmartAlbumController.h"
#import "FSAlbumManager.h"
#import "FSAlbumItem.h"
#import "FSPhotoPickerController.h"
#import <AVFoundation/AVFoundation.h>


@interface FSSmartAlbumController ()<FSPhotoPickerControllerDelegate>

@end

@implementation FSSmartAlbumController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGSize iconSize = CGSizeMake(110, 130);
    
    CGSize imageSize = CGSizeMake(200, 300);
    
    FSPhotoPickerConfiguration *configuration = [[FSPhotoPickerConfiguration alloc] initWithAlbumListIconSize:iconSize selectImageSize:imageSize maxSelectCount:9];
    
    configuration.showGridDirectly = YES;
    
    NSError *error = nil;
    
    FSPhotoPickerController *controller = [[FSPhotoPickerController alloc] initWithConfiguration:configuration error:&error];
    
    controller.pickerDelegate = self;
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)picker:(FSPhotoPickerController *)picker didFetchImage:(UIImage *)image
{
    
}

- (void)endFetchImagePicker:(FSPhotoPickerController *)picker resultArray:(NSArray *)array
{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//
//    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSLog(@"%@",array);
    
    NSLog(@"结束了.............");
    
}

@end
