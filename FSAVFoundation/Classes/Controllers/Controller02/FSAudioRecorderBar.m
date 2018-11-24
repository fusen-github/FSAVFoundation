//
//  FSAudioRecorderBar.m
//  FSAVFoundation
//
//  Created by 付森 on 2018/10/20.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSAudioRecorderBar.h"

@interface FSAudioRecorderBar ()

@property (nonatomic, strong) NSArray *buttonArray;

@end

@implementation FSAudioRecorderBar

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
    NSArray *array = @[@"record",@"pause",@"stop"];
    
    NSMutableArray *buttonArray = [NSMutableArray array];
    
    for (NSString *title in array)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setTitle:title forState:UIControlStateNormal];
        
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        
        button.backgroundColor = [UIColor greenColor];
        
        [button addTarget:self action:@selector(operateButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        
        [buttonArray addObject:button];
    }
    
    self.buttonArray = buttonArray;
}

- (void)operateButton:(UIButton *)button
{
    NSString *title = [button titleForState:UIControlStateNormal];
    
    if ([title isEqualToString:@"record"])
    {
        if ([self.delegate respondsToSelector:@selector(startRecord:)])
        {
            [self.delegate startRecord:button];
        }
    }
    else if ([title isEqualToString:@"pause"])
    {
        if ([self.delegate respondsToSelector:@selector(pauseRecord:)])
        {
            [self.delegate pauseRecord:button];
        }
    }
    else if ([title isEqualToString:@"stop"])
    {
        if ([self.delegate respondsToSelector:@selector(stopRecord:)])
        {
            [self.delegate stopRecord:button];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger count = self.buttonArray.count;
    
    CGFloat btnX = 0;
    
    CGFloat btnW = 60;
    
    CGFloat btnH = 35;
    
    CGFloat margin = (self.width - count * btnW) / (count + 1);
    
    CGFloat btnY = (self.height - btnH) * 0.5;
    
    for (int i = 0; i < count; i++)
    {
        UIButton *button = [self.buttonArray objectAtIndex:i];
        
        btnX = margin + (btnW + margin) * i;
        
        button.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
}

@end
