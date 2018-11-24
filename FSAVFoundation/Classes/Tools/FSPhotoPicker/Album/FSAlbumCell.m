//
//  FSAlbumCell.m
//  FSPhotoPicker
//
//  Created by 付森 on 2018/9/10.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSAlbumCell.h"
#import "FSAlbumModel.h"


@implementation FSAlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.imageView.layer.cornerRadius = 3;
        
        self.imageView.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setAlbum:(FSAlbumModel *)album
{
    _album = album;
    
    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:album.name attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor darkTextColor]}];
    
    NSAttributedString *countString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  (%zd)",album.count] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    
    [nameString appendAttributedString:countString];
    
    self.textLabel.attributedText = nameString;
    
    self.imageView.image = album.faceImage;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imageWH = self.contentView.bounds.size.height;
    
    CGFloat imageY = (self.contentView.bounds.size.height - imageWH) * 0.5;
    
    self.imageView.frame = CGRectMake(10, imageY, imageWH, imageWH);
    
    CGFloat textX = CGRectGetMaxX(self.imageView.frame) + 20;
    
    CGFloat textW = self.contentView.bounds.size.width - textX;
    
    self.textLabel.frame = CGRectMake(textX, 0, textW, self.contentView.bounds.size.height);
}



@end
