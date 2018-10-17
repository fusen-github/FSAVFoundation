//
//  FSMainViewController.m
//  FSAVFoundation
//
//  Created by 付森 on 2018/10/15.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSMainViewController.h"
#import <AVKit/AVKit.h>


static NSString * const kTitleKey = @"title";

static NSString * const kControllerKey = @"controller";

@interface FSMainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation FSMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] init];
    
    tableView.dataSource = self;
    
    tableView.delegate = self;
    
    tableView.frame = self.view.bounds;
    
    tableView.cellLayoutMarginsFollowReadableWidth = NO;
    
    [self.view addSubview:tableView];
    
    self.dataArray = @[@{kTitleKey:@"demo01",kControllerKey:@"FSController01"},];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        cell.textLabel.textColor = [UIColor darkTextColor];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    
    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
    
    NSString *title = [dict objectForKey:kTitleKey];
    
    cell.textLabel.text = title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
    
    NSString *className = [dict objectForKey:kControllerKey];
    
    Class cls = NSClassFromString(className);
    
    id vc = [[cls alloc] init];
    
    if (![vc isKindOfClass:[FSBaseViewController class]])
    {
        return;
    }
    
    NSString *title = [dict objectForKey:kTitleKey];
    
    [vc setTitle:title];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
