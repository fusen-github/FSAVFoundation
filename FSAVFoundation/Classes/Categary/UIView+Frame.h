//
//  UIView+Frame.h
//  FSAVFoundation
//
//  Created by 付森 on 2018/10/17.
//  Copyright © 2018年 付森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

/**
 *  控件的x值
 */
@property (nonatomic) CGFloat x;
/**
 *  控件的y值
 */
@property (nonatomic) CGFloat y;
/**
 *  控件的宽度
 */
@property (nonatomic) CGFloat width;
/**
 *  控件的高度
 */
@property (nonatomic) CGFloat height;

/**
 *  中心点的x值
 */
@property (nonatomic) CGFloat centerX;
/**
 *  中心点的y值
 */
@property (nonatomic) CGFloat centerY;


@property (nonatomic,readwrite) CGSize size;

@property (nonatomic,readonly) CGFloat maxX;

@property (nonatomic,readonly) CGFloat maxY;

@end
