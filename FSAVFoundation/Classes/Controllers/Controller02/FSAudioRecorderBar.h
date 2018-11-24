//
//  FSAudioRecorderBar.h
//  FSAVFoundation
//
//  Created by 付森 on 2018/10/20.
//  Copyright © 2018年 付森. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FSAudioRecorderBarDelegate <NSObject>

@optional
- (void)startRecord:(UIButton *)button;

- (void)pauseRecord:(UIButton *)button;

- (void)stopRecord:(UIButton *)button;

@end

@interface FSAudioRecorderBar : UIView

@property (nonatomic, weak) id<FSAudioRecorderBarDelegate> delegate;

@end
