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


@interface FSController01 ()

@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic, weak) UISegmentedControl *segmentedControl;

@end

@implementation FSController01

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"right" style:UIBarButtonItemStylePlain target:self action:@selector(doRightAction)];
    
    NSArray *array = @[@"start",@"pause",@"stop"];
    
    UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:array];
    
    self.segmentedControl = control;
    
    control.frame = CGRectMake(20, 100, 200, 30);
    
    [control addTarget:self action:@selector(segementValueChange:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:control];
}

- (void)doRightAction
{
    [self demo02];
}

- (void)demo02
{
    /// 音频会话 单例
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *error = nil;
    
    [session setActive:YES error:&error];
    
    [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"jiazhuang" ofType:@"mp3"];
    
    NSURL *url = [NSURL fileURLWithPath:path];
    
    
    /*
     在播放音频过程中，音频播放对象player不能被销毁。否则无法正常播放音频
     */
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    self.player = player;
    
    if (error)
    {
        NSLog(@"error %@",error.localizedDescription);
        
        return;
    }
    
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
        
        NSLog(@"%lf",self.player.deviceCurrentTime);
        
        NSDate *futureDate = [NSDate dateWithTimeIntervalSinceNow:5];
        
        NSTimeInterval timeInterval = [futureDate timeIntervalSince1970];
        
        /*
         播放音频的主要函数，只有调用了play才会播放音频
         */
        BOOL rst = [self.player playAtTime:self.player.deviceCurrentTime + 5];
        
        NSLog(@"%d",rst);
    }
    else if (control.selectedSegmentIndex == 1)
    {
        [self.player pause];
    }
    else if (control.selectedSegmentIndex == 2)
    {
        [self.player stop];
        
        self.player.currentTime = 0;
    }
}

- (void)demo01
{
    NSString *text = @"hello world";
    
    //    NSString *text = @"你好世界";
    
    text = @"For maximum security, passwords should not be cohesive words or phrases and should not be too obviously related to something like your birthday or the birthday of someone close to you. Personal information is one of the first things used when people attempt to break passwords. Having a password of \"Password\" is indeed humorous and ironic but it is not in the least bit secure.";
    
    [[FSSpeechTool shareInstance] readText:text];
}

@end
