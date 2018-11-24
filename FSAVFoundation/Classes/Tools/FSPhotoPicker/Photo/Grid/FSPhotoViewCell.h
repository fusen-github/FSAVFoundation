//
//  FSPhotoViewCell.h
//  
//
//  Created by 付森 on 2018/9/6.
//  Copyright © 2018年 付森. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSPhotoViewCell;
@protocol FSPhotoViewCellDelegate <NSObject>

@optional
- (void)cell:(FSPhotoViewCell *)cell didClickCheckButton:(UIButton *)button;

@end

@interface FSPhotoViewCell : UICollectionViewCell

@property (nonatomic, weak) id<FSPhotoViewCellDelegate> delegate;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) BOOL checked;

@end
