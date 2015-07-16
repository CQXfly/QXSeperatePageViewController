//
//  QXSeperatePageViewController.m
//  QXSeperatePageViewController
//
//  Created by 崇庆旭 on 15/7/16.
//  Copyright (c) 2015年 崇庆旭. All rights reserved.
//

#import "QXSeperatePageViewController.h"
#import "QXSeperatePageHeadSelectedView.h"

// Tabbar macro
#define ktarBarHeight  40
#define kTabBarTopMargin  64
#define kTabBarLeftMargin 0
// Tabbar item macro
#define kBarWidth 60
#define kBarTagBase 1000
@interface QXSeperatePageViewController () <UIScrollViewDelegate>

@property (nonatomic,strong) QXSeperatePageHeadSelectedView *tabBarView;

@property (nonatomic,strong) UIScrollView *contentContainer;

@property (nonatomic,assign) NSUInteger  numberOfPage;

@property (nonatomic,assign) BOOL scrollByDragging;
@end

@implementation QXSeperatePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self initializeSubviews];
    
#warning  底部的scroll 颜色要和自控制器颜色一样
    
    self.contentContainer.backgroundColor = [UIColor yellowColor];
    
    
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)initializeSubviews
{
    if (!self.tabBarView) {
        
        self.tabBarView = [[QXSeperatePageHeadSelectedView alloc] initWithFrame:CGRectMake(kTabBarLeftMargin , kTabBarTopMargin, self.view.frame.size.width-kTabBarLeftMargin, ktarBarHeight)];
        _tabBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:_tabBarView];
        _tabBarView.backgroundColor = [UIColor whiteColor];
        
        __weak typeof(self) weakSelf = self;
        [self.tabBarView setBlockdidSelectedAtIndex:^(NSUInteger index){
            [weakSelf transitionToIndex:index];
        }];
    }
    
    if(!_contentContainer){
        float originY = kTabBarTopMargin+ktarBarHeight;
        _contentContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height-originY)];
        _contentContainer.delegate = self;
        _contentContainer.pagingEnabled = YES;
        _contentContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_contentContainer];
        _contentContainer.backgroundColor = [UIColor whiteColor];
        _contentContainer.showsHorizontalScrollIndicator = NO;
    }

}

/**
 *  清除子控制器
 */
- (void)cleanupSubviewControllers
{
    for(id elem in self.childViewControllers){
        if([elem isEqual:[NSNull null]]==NO){
            if([elem isKindOfClass:[UIViewController class]]){
                UIViewController *vc = (UIViewController *)elem;
                [vc willMoveToParentViewController:nil];
                [vc.view removeFromSuperview];
                [vc removeFromParentViewController];
            }
        }
    }
}

/**
 *  刷新
 */
- (void)reloadData
{
    if (_block_numberOfPages) {
        //bloc执行
        _numberOfPage = _block_numberOfPages();
    } else
    {
        _numberOfPage = 0;
    }
    
    [self cleanupSubviewControllers];
    
    if (!_subviewControllers) {
        _subviewControllers = [NSMutableArray array];
    }
    [_subviewControllers removeAllObjects];
    
    //刷新标题
    NSMutableArray *barItemTitles = [NSMutableArray array];
    if (_numberOfPage > 0) {
        if (_block_titleForPageAtIndex) {
            for (int i = 0; i < _numberOfPage; i ++) {
                [barItemTitles addObject:_block_titleForPageAtIndex(i)];
            }
        }
        else {
            for (int i = 0; i < _numberOfPage; i ++) {
                [barItemTitles addObject:[NSString stringWithFormat:@"Page %d", i]];
            }
        }
        
        if (_block_viewControllerAtIndex) {
            for (int i = 0; i < _numberOfPage; i ++) {
                [_subviewControllers addObject:[NSNull null]];
            }
        }
    }
    _tabBarView.sourceItems = barItemTitles;
    
    self.selectedIndex = 0;
    
    [_contentContainer setContentSize:CGSizeMake(_contentContainer.frame.size.width*_numberOfPage, _contentContainer.frame.size.height)];
    
    
}


- (void)transitionToIndex:(NSUInteger)index
{
    [self setSelectedIndex:index];
    [_contentContainer setContentOffset:CGPointMake(index*_contentContainer.frame.size.width, 0) animated:YES];
}

- (void)setSelectedIndex:(NSInteger)index
{
    _selectedIndex = index;
    _tabBarView.selectedIndex = index;
    [self loadViewControllerAtIndex:_selectedIndex];
}

- (void)loadViewControllerAtIndex:(NSUInteger)index
{
    UIViewController *viewController = [self viewControllerAtIndex:index];
    if([self.childViewControllers containsObject:viewController]==NO){
        [self addChildViewController:viewController];
        viewController.view.frame = CGRectMake(index*_contentContainer.frame.size.width, 0, _contentContainer.frame.size.width, _contentContainer.frame.size.height);
        [_contentContainer addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
    }
}
- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if(index >= _subviewControllers.count)
        return nil;
    UIViewController *viewController = [_subviewControllers objectAtIndex:index];
    if([viewController isEqual:[NSNull null]]){
        if(_block_viewControllerAtIndex){
            viewController = _block_viewControllerAtIndex(index);
        }
        [_subviewControllers replaceObjectAtIndex:index withObject:viewController];
    }
    return [_subviewControllers objectAtIndex:index];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _tabBarView.frame = CGRectMake(kTabBarLeftMargin, kTabBarTopMargin, self.view.frame.size.width-kTabBarLeftMargin, ktarBarHeight);
    
    float originY = kTabBarTopMargin+ktarBarHeight;
    _contentContainer.frame = CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height-originY);
}


#pragma mark- scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(!_scrollByDragging){
        return;
    }
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    [self setSelectedIndex:page];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _scrollByDragging = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _scrollByDragging = NO;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end
