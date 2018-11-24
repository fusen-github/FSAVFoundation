//
//  FSAlbumController.m
//  FSPhotoPicker
//
//  Created by 付森 on 2018/9/10.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSAlbumController.h"
#import "FSAlbumModel.h"
#import "FSAlbumCell.h"
#import <Photos/Photos.h>
#import "FSPhoto.h"
#import "FSPhotoGridController.h"
#import "FSPhotoPickerConstance.h"


static CGFloat const kMaxCount = 9;

@interface FSAlbumController ()<UITableViewDelegate,UITableViewDataSource,FSPhotoGridControllerDelegate>
{
    BOOL _showGridimmediately;
}


@property (nonatomic, strong) NSArray *albums;

@property (nonatomic, weak) FSPhotoGridController *gridController;

/// 最大选择图像数量，默认 9 张, 如果设置 <= 0，则取默认值
@property (nonatomic) NSInteger maxPickerCount;

@end

@implementation FSAlbumController

- (instancetype)initWithAlbums:(NSArray<FSAlbumModel *> *)albums
                maxPickerCount:(NSInteger)count
           showGridimmediately:(BOOL)show
{
    if (self = [super init])
    {
        self.albums = albums;
        
        self.maxPickerCount = count;
        
        _showGridimmediately = show;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"系统相册";
    
    self.maxPickerCount = kMaxCount;
    
    [self setleftBarButtonItemWithAction:@selector(popSelf)];
    
    UITableView *tableView = [[UITableView alloc] init];
    
    tableView.frame = self.view.bounds;
    
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    
    [tableView setLayoutMargins:UIEdgeInsetsZero];
    
    if (@available(iOS 9.0, *))
    {
        tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
    
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    tableView.rowHeight = 60;
    
    tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:tableView];
    
    if (self->_showGridimmediately)
    {
        [self showPhotoGrid:self.albums.firstObject animated:NO];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil)
    {
        cell = [[FSAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.album = [self.albums objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSAlbumModel *model = [self.albums objectAtIndex:indexPath.row];
    
    [self showPhotoGrid:model animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    
    [cell setLayoutMargins:UIEdgeInsetsZero];
}

- (void)showPhotoGrid:(FSAlbumModel *)album animated:(BOOL)animated
{
    NSArray *assetArray = album.assetArray;
    
    NSMutableArray *photoArr = [[NSMutableArray alloc] init];
    
    @synchronized(self)
    {
        CGSize targetSize = CGSizeMake(kFSPhotoPickerGridItemMaxWH, kFSPhotoPickerGridItemMaxWH);
        
        for (PHAsset *asset in assetArray)
        {
            FSPhoto *fsPhoto = [FSPhoto photoObjWithAsset:asset targetSize:targetSize];
            
            [photoArr addObject:fsPhoto];
        }
    }
    
    FSPhotoGridController *gridController = [[FSPhotoGridController alloc] initWithPhotos:photoArr];
    
    gridController.delegate = self;
    
    self.gridController = gridController;
    
    gridController.maxPickerCount = self.maxPickerCount;
    
    [self.navigationController pushViewController:gridController animated:animated];
}

- (void)popSelf
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    NSLog(@"%@ 死了", NSStringFromClass([self class]));
}

@end
