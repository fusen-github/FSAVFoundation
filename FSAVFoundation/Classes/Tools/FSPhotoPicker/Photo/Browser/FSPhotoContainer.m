//
//  FSPhotoContainer.m
//  FSPhotoPicker
//
//  Created by 付森 on 2018/9/10.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSPhotoContainer.h"
#import "FSPhoto.h"
#import "FSPhotoContainerView.h"
#import "FSPhotoPickerUtil.h"


@interface FSPhotoContainer ()<UIScrollViewDelegate>

@property (nonatomic, strong) FSPhoto *photo;

@end

@implementation FSPhotoContainer

- (instancetype)initWithPhoto:(FSPhoto *)photo
{
    if (self = [super init])
    {
        self.photo = photo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FSPhotoContainerView *scrollView = [[FSPhotoContainerView alloc] initWithFrame:self.view.bounds];
    
    __weak typeof(self) wSelf = self;
    
    [scrollView setupClickImageBlock:^{
        
        [wSelf clickImageView];
    }];
    
    [self.view addSubview:scrollView];
    
    if (@available(iOS 11, *))
    {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGFloat btnWH = 44;
    
    CGFloat space = 100;
    
    CGFloat btnX = self.view.bounds.size.width - btnWH - space;
    
    button.frame = CGRectMake(btnX, space, btnWH, btnWH);
    
    UIImage *norImage = [FSPhotoPickerUtil bundleImageWithName:@"check_off_big"];
    
    [button setImage:norImage forState:UIControlStateNormal];
    
    UIImage *selImage = [FSPhotoPickerUtil bundleImageWithName:@"check_on_big"];
    
    [button setImage:selImage forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(touchDownButton:)
     forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:button];
    
    if (self.photo)
    {
        CGSize targetSize = CGSizeMake(self.photo.asset.pixelWidth, self.photo.asset.pixelHeight);
        
        [FSPhotoPickerUtil imageWithAsset11:self.photo.asset
                                       size:targetSize
                                 completion:^(UIImage *image, NSDictionary *infro) {
                                   
            [scrollView setImage:image];
        }];
        
        button.selected = self.photo.selected;
    }
}

- (void)clickImageView
{
    BOOL hidden = self.navigationController.navigationBarHidden;
    
    NSTimeInterval time = 0.25;
    
    if (!hidden)
    {
        [UIView animateWithDuration:time animations:^{
           
            self.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(0, -100);
            
        } completion:^(BOOL finished) {

            self.navigationController.navigationBarHidden = YES;
        }];
    }
    else
    {
        self.navigationController.navigationBarHidden = NO;
        
        [UIView animateWithDuration:time animations:^{
           
            self.navigationController.navigationBar.transform = CGAffineTransformIdentity;
        }];
    }
}


- (void)touchDownButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(container:wantToCheckButton:)])
    {
        [self.delegate container:self wantToCheckButton:button];
    }
}

@end
