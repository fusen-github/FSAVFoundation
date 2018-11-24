//
//  FSPhotoViewCell.m
//  
//
//  Created by 付森 on 2018/9/6.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSPhotoViewCell.h"
#import "FSPhotoPickerUtil.h"


@interface FSPhotoViewCell ()

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, weak) UIButton *button;

@end

@implementation FSPhotoViewCell

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
    UIImageView *imageView = [[UIImageView alloc] init];
    
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    imageView.clipsToBounds = YES;
    
    self.imageView = imageView;
    
    imageView.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:imageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.button = button;
    
    UIImage *norImage = [FSPhotoPickerUtil bundleImageWithName:@"check_off_small"];
    
    [button setImage:norImage forState:UIControlStateNormal];
    
    UIImage *selImage = [FSPhotoPickerUtil bundleImageWithName:@"check_on_small"];
    
    [button setImage:selImage forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(touchDownButton:)
     forControlEvents:UIControlEventTouchDown];
    
    [self.contentView addSubview:button];
    
    self.contentView.layer.borderWidth = 0.5;
    
    self.contentView.layer.borderColor = [UIColor redColor].CGColor;
    
    self.contentView.backgroundColor = [UIColor blackColor];
}

- (void)touchDownButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(cell:didClickCheckButton:)])
    {
        [self.delegate cell:self didClickCheckButton:button];
    }
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = nil;
    
    _image = image;
    
    self.imageView.image = image;
    
    [self setNeedsLayout];
}

- (void)setChecked:(BOOL)checked
{
    _checked = checked;
    
    self.button.selected = checked;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imgW = self.contentView.bounds.size.width;
    
    CGFloat ratio = imgW / self.image.size.width;
    
    CGFloat imgH = self.image.size.height * ratio;
    
    imgH = MIN(imgH, self.contentView.bounds.size.height);
    
    CGRect tmpRect = CGRectMake(0, 0, imgW, imgH);
    
    self.imageView.frame = CGRectInset(tmpRect, 0.5, 0.5);
    
    self.imageView.centerY = self.contentView.bounds.size.height * 0.5;
    
    CGFloat btnWH = 35;
    
    CGFloat space = 10;
    
    CGFloat btnX = self.contentView.bounds.size.width - btnWH - space;
    
    self.button.frame = CGRectMake(btnX, space, btnWH, btnWH);
}

@end
