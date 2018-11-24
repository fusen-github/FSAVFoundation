//
//  FSController02.m
//  FSAVFoundation
//
//  Created by 付森 on 2018/10/20.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSController02.h"
#import <AVFoundation/AVFoundation.h>
#import "FSAudioRecorderBar.h"
#import "FSRecorderTool.h"


@interface FSController02 ()<UITableViewDelegate,UITableViewDataSource,FSAudioRecorderBarDelegate>

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;

@property (nonatomic, weak) FSAudioRecorderBar *recordBar;

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation FSController02

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"right" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
    
    FSAudioRecorderBar *recordBar = [[FSAudioRecorderBar alloc] init];
    
    recordBar.delegate = self;
    
    recordBar.backgroundColor = [UIColor redColor];
    
    self.recordBar = recordBar;
    
    [self.view addSubview:recordBar];
    
    UITableView *tableView = [[UITableView alloc] init];
    
    self.tableView = tableView;
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
//    CGContextRef
    
    
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat barY = self.navigationController.navigationBar.height + 20;
    
    self.recordBar.frame = CGRectMake(0, barY, self.view.width, 80);
    
    CGFloat tvH = self.view.height - self.recordBar.maxY;
    
    self.tableView.frame = CGRectMake(0, self.recordBar.maxY, self.view.width, tvH);
    
}

- (void)rightAction
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    path = [path stringByAppendingPathComponent:@"voice.m4a"];
    
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSDictionary *setting = @{AVFormatIDKey:@(kAudioFormatMPEG4AAC),
                              AVSampleRateKey:@(22050.f),
                              AVNumberOfChannelsKey:@(1),};
    
    NSError *error = nil;
    
    AVAudioRecorder *audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:&error];
    
    self.audioRecorder = audioRecorder;
    
}

#pragma mark FSAudioRecorderBarDelegate

- (void)startRecord:(UIButton *)button
{
    
}

- (void)pauseRecord:(UIButton *)button
{
    
}

- (void)stopRecord:(UIButton *)button
{
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const kCellId = @"controller02_cell_id";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellId];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        cell.textLabel.textColor = [UIColor darkTextColor];
    }
    
    cell.textLabel.text = @"123456";
    
    return cell;
}


@end
