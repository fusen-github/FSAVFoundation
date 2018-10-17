//
//  FSSliderItem.m
//  FSAVFoundation
//
//  Created by 付森 on 2018/10/17.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSSliderItem.h"

@implementation FSSliderItem

+ (instancetype)itemWithTitle:(NSString *)title minValue:(NSNumber *)min maxValue:(NSNumber *)max idx:(NSString *)idx
{
    FSSliderItem *item = [[self alloc] init];
    
    item->_title = title;
    
    item->_minValue = min;
    
    item->_maxValue = max;
    
    item->_identifier = idx;
    
    return item;
}

@end
