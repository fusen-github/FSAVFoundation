//
//  FSController03.m
//  FSAVFoundation
//
//  Created by 付森 on 2018/11/22.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSController03.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "FSSmartAlbumController.h"
#import "FSAlbumManager.h"


@interface FSController03 (Extension)

/**
 处理iOS系统“照片app”中的“相簿”tab
 */
- (void)fs_handleAblum;

@end

@interface FSController03 ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@end

/*
 AVFragmentedAsset: 只能用在macOS上
 AVAsset、AVURLAsset: 可以用在iOS、macOS
 AVAsset是一个抽象类，最好使用AVURLAsset
 */

/*
 背景知识
 对iOS系统“照片APP”结构的基本了解
 1、该APP包含“照片”、“回忆”、“共享”、“相簿”四个tab页
 */

@implementation FSController03

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] init];
    
    self.tableView = tableView;
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
    self.dataArray = @[@"获取“相簿”中系统分组", @"获取“相簿”中自定义分组"];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const kCellId = @"controller03_cell_id";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellId];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        cell.textLabel.textColor = [UIColor darkTextColor];
    }
    
    NSString *title = [self.dataArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [FSAlbumManager requestAuthorization:^(BOOL granted) {
        
        if (granted)
        {
            [self loadAlbumWithIndexPath:indexPath];
        }
    }];
}

- (void)loadAlbumWithIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        [self getSystemAlbum];
    }
    else if (indexPath.row == 1)
    {
//        [self getCustomAlbum];
    }
}

- (void)getSystemAlbum
{
    FSSmartAlbumController *smart = [[FSSmartAlbumController alloc] init];
    
    [self.navigationController pushViewController:smart animated:YES];
}



/**
 AVURLAsset初步探究
 */
- (void)demo01
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"jiazhuang" ofType:@"mp3"];
    
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    
    /*
     // YES表示客户端希望用多一点的时间来获取更精确的时长和时间信息
     AVURLAssetPreferPreciseDurationAndTimingKey
     AVURLAssetReferenceRestrictionsKey
     */
    
    [options setObject:@(YES) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:options];
    
    NSLog(@"%@",urlAsset.description);
}

@end
