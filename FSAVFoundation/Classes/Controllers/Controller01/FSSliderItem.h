//
//  FSSliderItem.h
//  FSAVFoundation
//
//  Created by 付森 on 2018/10/17.
//  Copyright © 2018年 付森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSSliderItem : NSObject

@property (nonatomic, strong, readonly) NSString *title;

@property (nonatomic, strong) NSNumber *currentValue;

@property (nonatomic, strong, readonly) NSNumber *minValue;

@property (nonatomic, strong, readonly) NSNumber *maxValue;

@property (nonatomic, copy, readonly) NSString *identifier;

+ (instancetype)itemWithTitle:(NSString *)title
                     minValue:(NSNumber *)min
                     maxValue:(NSNumber *)max
                          idx:(NSString *)idx;

@end
