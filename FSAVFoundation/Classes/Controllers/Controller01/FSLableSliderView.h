//
//  FSLableSliderView.h
//  FSAVFoundation
//
//  Created by 付森 on 2018/10/17.
//  Copyright © 2018年 付森. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSLableSliderView;
@protocol FSLableSliderViewDelegate <NSObject>

@optional
- (void)sliderViewDidChangedValue:(FSLableSliderView *)view;

@end

@interface FSLableSliderView : UIView

@property (nonatomic, weak) id<FSLableSliderViewDelegate> delegate;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSNumber *currentValue;

@property (nonatomic, strong) NSNumber *minValue;

@property (nonatomic, strong) NSNumber *maxValue;

@property (nonatomic, copy) NSString *identifier;

@end
