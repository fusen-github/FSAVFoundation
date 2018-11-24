//
//  FSPhotoBrowser.m
//  FSPhotoPicker
//
//  Created by 付森 on 2018/9/10.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSPhotoBrowser.h"
#import "FSPhotoContainer.h"
#import "FSPhoto.h"
#import "FSPhotoPickerUtil.h"
#import "FSPhotoPickerConstance.h"


@interface FSPhotoBrowser ()
<UIPageViewControllerDelegate,
UIPageViewControllerDataSource,
FSPhotoContainerDelegate>


@property (nonatomic, strong) NSArray *photoArray;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, copy) void (^popBlock)(void);

@end

@implementation FSPhotoBrowser

- (instancetype)initWithPhotos:(NSArray<FSPhoto *> *)photos currentIndex:(NSInteger)index
{
    if (!photos.count || index < 0 || index >= photos.count)
    {
        return nil;
    }
    
    if (self = [super init])
    {
        self.photoArray = photos;
        
        self.index = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setleftBarButtonItemWithAction:@selector(popSelf)];
    
    UIButton *rightButton = [FSPhotoPickerUtil confirmButton];
    
    [rightButton addTarget:self
                    action:@selector(confirmSelectedPhotos)
          forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    NSInteger count = [self getSelectedPhotos].count;
    
    [self configConfirmButton:rightButton selectedCount:count];
    
    NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey:@(20)};
    
    UIPageViewController *pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    
    pageViewController.delegate = self;
    
    pageViewController.dataSource = self;
    
    pageViewController.view.frame = self.view.bounds;
    
    [self.view addSubview:pageViewController.view];
    
    [self addChildViewController:pageViewController];
    
    FSPhotoContainer *indexContainer = [self containerWithIndex:self.index];
    
    if (indexContainer)
    {
        [pageViewController setViewControllers:@[indexContainer] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
    
    [self updateNavTitle:self.index];
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

- (NSArray *)getSelectedPhotos
{
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    for (FSPhoto *obj in self.photoArray)
    {
        if (obj.selected)
        {
            [tmpArray addObject:obj];
        }
    }
    
    return tmpArray;
}

- (void)updateNavTitle:(NSInteger)currentIndex
{
    self.title = [NSString stringWithFormat:@"%ld/%ld",currentIndex + 1, self.photoArray.count];
}

- (void)confirmSelectedPhotos
{
    NSArray *array = [self getSelectedPhotos];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kFSPhotoPickerDidFinishSelectedAssetsEvent object:array];
}

- (void)setupPopBlock:(void (^)(void))block
{
    self.popBlock = block;
}

- (void)popSelf
{
    if (self.popBlock)
    {
        self.popBlock();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (FSPhotoContainer *)containerWithIndex:(NSInteger)index
{
    if (index < 0 || index >= self.photoArray.count)
    {
        return nil;
    }
    
    FSPhoto *photo = [self.photoArray objectAtIndex:index];
    
    FSPhotoContainer *container = [[FSPhotoContainer alloc] initWithPhoto:photo];
    
    container.delegate = self;
    
    return container;
}

- (NSInteger)indexOfContainer:(FSPhotoContainer *)container
{
    FSPhoto *photo = container.photo;
    
    NSInteger index = [self.photoArray indexOfObject:photo];
    
    return index;
}

#pragma UIPageViewControllerDataSource and UIPageViewControllerDelegate

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = NSNotFound;
    
    if ([viewController isKindOfClass:[FSPhotoContainer class]])
    {
        index = [self indexOfContainer:(FSPhotoContainer *)viewController];
    }
    
    index--;
    
    FSPhotoContainer *container = [self containerWithIndex:index];
    
    return container;
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = NSNotFound;
    
    if ([viewController isKindOfClass:[FSPhotoContainer class]])
    {
        index = [self indexOfContainer:(FSPhotoContainer *)viewController];
    }
    
    index++;
    
    FSPhotoContainer *container = [self containerWithIndex:index];
    
    return container;
}


- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (finished || completed)
    {
        FSPhotoContainer *last = (id)pageViewController.viewControllers.lastObject;
        
        NSInteger index = [self.photoArray indexOfObject:last.photo];
        
        [self updateNavTitle:index];
    }
    
}

#pragma mark FSPhotoContainerDelegate
- (void)container:(FSPhotoContainer *)container wantToCheckButton:(UIButton *)button
{
    NSInteger count = [self getSelectedPhotos].count;
    
    if (!button.selected &&  count == self.maxPickerCount)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kFSPhotoPickerAlreadySelectedMaxCountEvent object:@(count)];
        
        return;
    }
    
    button.selected = !button.selected;

    container.photo.selected = button.selected;
    
    if (button.selected)
    {
        count++;
    }
    else
    {
        count--;
    }
    
    UIButton *confirmBtn = (id)self.navigationItem.rightBarButtonItem.customView;
    
    [self configConfirmButton:confirmBtn selectedCount:count];
}

@end
