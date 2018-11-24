//
//  FSPhotoGridFlowLayout.m
//  FSPhotoPicker
//
//  Created by 付森 on 2018/9/10.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSPhotoGridFlowLayout.h"
#import "FSPhotoPickerConstance.h"


@implementation FSPhotoGridFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    CGFloat margin = 3;
    
    /*
     count: 参数传几都行
     */
    CGFloat itemWH = [self itemWHWithMargin:margin];
    
    self.itemSize = CGSizeMake(itemWH, itemWH);
    
    self.minimumInteritemSpacing = margin;
    
    self.minimumLineSpacing = margin;
    
    self.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
}

- (CGFloat)itemWHWithMargin:(CGFloat)margin {
    
    CGFloat itemWH = 0;
    
    NSInteger count = 0;
    
    CGSize size = self.collectionView.bounds.size;
    
    do {
        
        itemWH = floor((size.width - (count + 1) * margin) / count);
        
        count++;
        
    } while (itemWH > kFSPhotoPickerGridItemMaxWH);
    
    
    return itemWH;
}

@end
