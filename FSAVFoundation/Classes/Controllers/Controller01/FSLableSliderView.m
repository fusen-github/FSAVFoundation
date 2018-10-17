//
//  FSLableSliderView.m
//  FSAVFoundation
//
//  Created by 付森 on 2018/10/17.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSLableSliderView.h"

@interface FSLableSliderView ()

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UISlider *slider;

@property (nonatomic, weak) UILabel *valueLabel;

@end

@implementation FSLableSliderView

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
    UILabel *titleLabel = [self setupLabel];
    
    titleLabel.backgroundColor = [UIColor redColor];
    
    self.titleLabel = titleLabel;
    
    [self addSubview:titleLabel];
    
    UISlider *slider = [[UISlider alloc] init];
    
    self.slider = slider;
    
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:slider];
    
    UILabel *valueLabel = [self setupLabel];
    
    valueLabel.backgroundColor = [UIColor redColor];
    
    self.valueLabel = valueLabel;
    
    [self addSubview:valueLabel];
}

- (void)sliderValueChanged:(UISlider *)slider
{
    self.valueLabel.text = [NSString stringWithFormat:@"%.2f",slider.value];
    
    if ([self.delegate respondsToSelector:@selector(sliderViewDidChangedValue:)])
    {
        [self.delegate sliderViewDidChangedValue:self];
    }
}

- (UILabel *)setupLabel
{
    UILabel *label = [[UILabel alloc] init];

    label.font = [UIFont systemFontOfSize:14];
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.textColor = [UIColor darkTextColor];
    
    return label;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    self.titleLabel.text = title;
}

- (void)setCurrentValue:(NSNumber *)currentValue
{
    self.valueLabel.text = [NSString stringWithFormat:@"%@",currentValue];
    
    self.slider.value = currentValue.floatValue;
}

- (NSNumber *)currentValue
{
    return @(self.slider.value);
}

- (void)setMinValue:(NSNumber *)minValue
{
    _minValue = minValue;
    
    self.slider.minimumValue = minValue.floatValue;
}

- (void)setMaxValue:(NSNumber *)maxValue
{
    _maxValue = maxValue;
    
    self.slider.maximumValue = maxValue.floatValue;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat labelW = 80;
    
    self.titleLabel.frame = CGRectMake(0, 0, labelW, self.height);
    
    self.slider.frame = CGRectMake(self.titleLabel.maxX, 0, self.width - 2 * labelW, self.height);
    
    self.valueLabel.frame = CGRectMake(self.slider.maxX, 0, labelW, self.height);
}

@end
