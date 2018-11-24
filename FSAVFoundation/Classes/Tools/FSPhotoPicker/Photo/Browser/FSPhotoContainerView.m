//
//  FSPhotoContainerView.m
//  FSPhotoPicker
//
//  Created by 付森 on 2018/9/10.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSPhotoContainerView.h"
#import "FSPhotoPickerUtil.h"


@interface FSPhotoContainerView ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, copy) void (^block)(void);

@end

@implementation FSPhotoContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    self.backgroundColor = [UIColor blackColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.imageView = imageView;
    
    [self addSubview:imageView];
    
    self.maximumZoomScale = 2.5;
    
    self.minimumZoomScale = 1;
    
    self.delegate = self;
    
    imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView)];
    
    [imageView addGestureRecognizer:tap];
}



- (void)setupClickImageBlock:(void (^)(void))block
{
    self.block = block;
}

- (void)clickImageView
{
    if (self.block)
    {
        self.block();
    }
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    self.imageView.image = image;
    
    CGFloat ratio = CGRectGetWidth(self.bounds) / image.size.width;
    
    CGSize size = CGSizeMake(CGRectGetWidth(self.bounds), ceil(ratio * image.size.height));
    
    self.imageView.frame = CGRectMake(0, 0, size.width, size.height);
    
    self.contentSize = size;
    
    if (size.height <= self.bounds.size.height)
    {
        self.imageView.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end
