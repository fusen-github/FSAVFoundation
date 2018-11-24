//
//  FSPhotoGridController.m
//  
//
//  Created by 付森 on 2018/9/5.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSPhotoGridController.h"
#import "FSPhotoViewCell.h"
#import "FSPhotoGridFlowLayout.h"
#import "FSPhotoPickerUtil.h"
#import "FSPhotoBrowser.h"
#import "FSPhotoPickerConstance.h"



static NSString * const kReuseCellId = @"fs_photo_cell";


@interface FSPhotoGridController ()
<UICollectionViewDelegate,
UICollectionViewDataSource,FSPhotoViewCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *photos;

@property (nonatomic, weak) FSPhotoBrowser *browser;

@end

@implementation FSPhotoGridController

- (instancetype)initWithPhotos:(NSArray<FSPhoto *> *)photos
{
    if (self = [super init])
    {
        self.photos = photos;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setleftBarButtonItemWithAction:@selector(popSelf)];
    
    self.title = @"照片列表";
    
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *rightBtn = [FSPhotoPickerUtil confirmButton];
    
    rightBtn.enabled = NO;
    
    [rightBtn addTarget:self
                 action:@selector(clickConfirmAction)
       forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    FSPhotoGridFlowLayout *layout = [[FSPhotoGridFlowLayout alloc] init];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    
    self.collectionView = collectionView;
    
    collectionView.delegate = self;
    
    collectionView.dataSource = self;
    
    collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:collectionView];
    
    /// 注册cell
    [collectionView registerClass:[FSPhotoViewCell class] forCellWithReuseIdentifier:kReuseCellId];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.collectionView.frame = self.view.bounds;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat offsetY = self.collectionView.contentSize.height - self.collectionView.height;
    
    CGPoint offset = CGPointMake(0, offsetY);
    
    [self.collectionView setContentOffset:offset animated:NO];
}

- (void)clickConfirmAction
{
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    for (FSPhoto *photoObj in self.photos)
    {
        if (photoObj.selected)
        {
            [tmpArray addObject:photoObj];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kFSPhotoPickerDidFinishSelectedAssetsEvent object:tmpArray];
}

- (void)popSelf
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setMaxPickerCount:(NSInteger)maxPickerCount
{
    _maxPickerCount = maxPickerCount;
    
    [self.browser setMaxPickerCount:maxPickerCount];
}

#pragma UICollectionView代理和数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseCellId forIndexPath:indexPath];
    
    cell.delegate = self;
    
    CGSize size = cell.contentView.bounds.size;
    
    cell.image = [FSPhotoPickerUtil whiteImageWithSize:size];
    
    FSPhoto *photo = [self.photos objectAtIndex:indexPath.row];
    
    [FSPhotoPickerUtil imageWithAsset11:photo.asset size:size completion:^(UIImage *image, NSDictionary *info) {
       
        cell.image = image;
    }];
    
    cell.checked = photo.selected;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSPhotoBrowser *browser = [[FSPhotoBrowser alloc] initWithPhotos:self.photos currentIndex:indexPath.row];
    
    browser.maxPickerCount = self.maxPickerCount;
    
    self.browser = browser;
    
    if (browser == nil)
    {
        return;
    }
    
    __weak typeof(self) wSelf = self;
    
    [browser setupPopBlock:^{
        
        [wSelf didPopPhotoBrowser];
    }];
    
    [self.navigationController pushViewController:browser animated:YES];
}

- (void)didPopPhotoBrowser
{
    [self.collectionView reloadData];
    
    UIButton *rightItem = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
    
    NSInteger count = [self getSelectedPhotos].count;
    
    [self configConfirmButton:rightItem selectedCount:count];
}

- (NSArray *)getSelectedPhotos
{
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    for (FSPhoto *obj in self.photos)
    {
        if (obj.selected)
        {
            [tmpArray addObject:obj];
        }
    }
    
    return tmpArray;
}

- (void)configConfirmButton:(UIButton *)button selectedCount:(NSInteger)count
{
    NSString *title = nil;
    
    if (count)
    {
        title = [NSString stringWithFormat:@"确定(%ld)",count];
        
        [button setTitle:title forState:UIControlStateNormal];
        
        button.enabled = YES;
    }
    else
    {
        title = @"确定";
        
        [button setTitle:title forState:UIControlStateDisabled];
        
        button.enabled = NO;
    }
}

#pragma mark FSPhotoViewCellDelegate
- (void)cell:(FSPhotoViewCell *)cell didClickCheckButton:(UIButton *)button
{
    NSInteger selectedCount = [self getSelectedPhotos].count;
    
    /// 已经达到最大值
    if (!button.selected && selectedCount == self.maxPickerCount)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kFSPhotoPickerAlreadySelectedMaxCountEvent object:@(selectedCount)];
        
        return;
    }
    
    button.selected = !button.selected;
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    FSPhoto *photo = [self.photos objectAtIndex:indexPath.row];
    
    photo.selected = button.selected;
    
    if (button.selected)
    {
        selectedCount++;
    }
    else
    {
        selectedCount--;
    }
    
    UIButton *rightItem = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
    
    [self configConfirmButton:rightItem selectedCount:selectedCount];
}

@end
