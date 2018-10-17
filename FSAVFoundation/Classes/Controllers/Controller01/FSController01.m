//
//  FSController01.m
//  FSAVFoundation
//
//  Created by 付森 on 2018/10/17.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSController01.h"
#import "FSSpeechTool.h"
#import <AVFoundation/AVFoundation.h>
#import "FSLableSliderView.h"
#import "FSSliderItem.h"

static NSString * const kVolumeId = @"volume";

static NSString * const kRateId = @"rate";

static NSString * const kProgressId = @"progress";

@interface FSController01 (Extention)

- (void)demo02;

@end

@interface FSController01 ()<FSLableSliderViewDelegate>

@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic, weak) UISegmentedControl *segmentedControl;

@property (nonatomic, strong) NSArray *sliderViews;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation FSController01

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 音频会话 单例
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *error = nil;
    
    [session setActive:YES error:&error];
    
    [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"right" style:UIBarButtonItemStylePlain target:self action:@selector(doRightAction)];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat x = 35;
    
    CGFloat y = 100;
    
    CGFloat width = self.view.width - 2 * x;
    
    CGFloat height = 30;
    
    self.segmentedControl.frame = CGRectMake(x, y, width, height);
    
    height = 40;
    
    CGFloat gapY = 10;
    
    for (int i = 0; i < self.sliderViews.count; i++)
    {
        UIView *sliderView = [self.sliderViews objectAtIndex:i];
        
        y = self.segmentedControl.maxY + gapY + (height + gapY) * i;
        
        sliderView.frame = CGRectMake(x, y, width, height);
    }
}

- (void)doRightAction
{
    [self demo02];
}


@end

@implementation FSController01 (Demo02)

- (void)demo02
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"yibaiwanzhongkeneng" ofType:@"mp3"];
    
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSError *error = nil;
    
    /*
     在播放音频过程中，音频播放对象player不能被销毁。否则无法正常播放音频
     */
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    player.enableRate = YES;
    
    /*
     立体声.
     */
    player.pan = 0;
    
    /*
     播放速率
     */
    player.rate = 1;
    
    //    player.enableRate
    
    player.numberOfLoops = -1;
    
    self.player = player;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    
    NSLog(@"%lf",player.duration);
    
    [self setupDemo02Subviews];
}

- (void)updateProgress
{
    float current = [self.player currentTime];
    
    FSLableSliderView *progressView = self.sliderViews.lastObject;
    
    progressView.currentValue = @(current);
}

- (void)setupDemo02Subviews
{
    NSArray *array = @[@"start",@"pause",@"stop"];
    
    UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:array];
    
    self.segmentedControl = control;
    
    [control addTarget:self action:@selector(segementValueChange:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:control];
    
    array = [self prepareSliderItemsWithPlayer:self.player];
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    for (int i = 0; i < array.count; i++)
    {
        FSSliderItem *item = [array objectAtIndex:i];
        
        FSLableSliderView *sliderView = [[FSLableSliderView alloc] init];
        
        sliderView.delegate = self;
        
        sliderView.title = item.title;
        
        sliderView.minValue = item.minValue;
        
        sliderView.maxValue = item.maxValue;
        
        sliderView.currentValue = item.currentValue;
        
        sliderView.identifier = item.identifier;
        
        [tmpArray addObject:sliderView];
        
        [self.view addSubview:sliderView];
    }
    
    self.sliderViews = tmpArray;
    
    [self.view setNeedsLayout];
    
    self.segmentedControl.selectedSegmentIndex = 0;
    
    [self segementValueChange:self.segmentedControl];
}

- (void)segementValueChange:(UISegmentedControl *)control
{
    if (control.selectedSegmentIndex == 0)
    {
        /*
         音频播放预加载。主要是加载播放音频是的一些硬件条件。（可选的。如果不调用该方法，后面的play方法也会隐式的执行预加载)
         调用这个函数可以最大限度的减少在调用play函数后和听到声音之间的延时
         */
        [self.player prepareToPlay];
        
        //        NSLog(@"%lf",self.player.deviceCurrentTime);
        
        /*
         播放音频的主要函数，只有调用了play才会播放音频
         */
        /*
         - (BOOL)play 直接播放
         - (BOOL)playAtTime:  在将来某个时间播放，
         */
        
        FSLableSliderView *volumeSlider = [self.sliderViews firstObject];
        
        self.player.volume = volumeSlider.currentValue.floatValue;
        
        BOOL rst = [self.player playAtTime:self.player.deviceCurrentTime + .1];
        
        NSLog(@"volume: %f",self.player.volume);
    }
    else if (control.selectedSegmentIndex == 1)
    {
        NSTimeInterval during = 3;
        
        /*
         声音渐渐消失
         */
        [self.player setVolume:0 fadeDuration:during];
        
        NSLog(@"begin");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(during * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.player pause];
            
            NSLog(@"end");
        });
    }
    else if (control.selectedSegmentIndex == 2)
    {
        [self.player stop];
        
        self.player.currentTime = 0;
    }
}

- (NSArray *)prepareSliderItemsWithPlayer:(AVAudioPlayer *)player
{
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    FSSliderItem *volumeItem = [FSSliderItem itemWithTitle:@"声音" minValue:@(0) maxValue:@(1) idx:kVolumeId];
    
    volumeItem.currentValue = @(player.volume);
    
    [tmpArray addObject:volumeItem];
    
    FSSliderItem *rateItem = [FSSliderItem itemWithTitle:@"播放倍数" minValue:@(0.5) maxValue:@(2) idx:kRateId];
    
    rateItem.currentValue = @(player.rate);
    
    [tmpArray addObject:rateItem];
    
    FSSliderItem *progress = [FSSliderItem itemWithTitle:@"进度" minValue:@(0) maxValue:@(player.duration) idx:kProgressId];
    
    progress.currentValue = @(0);
    
    [tmpArray addObject:progress];
    
    return tmpArray;
}

- (void)sliderViewDidChangedValue:(FSLableSliderView *)view
{
    if ([view.identifier isEqualToString:kVolumeId])
    {
        self.player.volume = view.currentValue.floatValue;
    }
    else if ([view.identifier isEqualToString:kRateId])
    {
        self.player.rate = view.currentValue.floatValue;
    }
    else if ([view.identifier isEqualToString:kProgressId])
    {
        self.player.currentTime = view.currentValue.floatValue;
    }
}

@end

@implementation FSController01 (Demo01)

- (void)demo01
{
    //    NSString *text = @"hello world";
    
    NSString *text = @"My university is beijing, which is located in the rural area of beijing. I am very proud to tell you that my school in science and engineering can rank in the top 10 in my country";
    
    //    text = @"For maximum security, passwords should not be cohesive words or phrases and should not be too obviously related to something like your birthday or the birthday of someone close to you. Personal information is one of the first things used when people attempt to break passwords. Having a password of \"Password\" is indeed humorous and ironic but it is not in the least bit secure.";
    
    [[FSSpeechTool shareInstance] readText:text];
}

@end
