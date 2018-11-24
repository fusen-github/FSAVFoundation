//
//  FSPhotoPickerBaseController.m
//  FSPhotoPicker
//
//  Created by 付森 on 2018/9/11.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSPhotoPickerBaseController.h"
#import "FSPhotoPickerUtil.h"


@interface FSPhotoPickerBaseController ()

@end

@implementation FSPhotoPickerBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setleftBarButtonItemWithAction:(SEL)action
{
    UIImage *image = [FSPhotoPickerUtil bundleImageWithName:@"blue_arrow"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:action];
}

@end
