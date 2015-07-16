//
//  QXSeperatePageViewController.h
//  QXSeperatePageViewController
//
//  Created by 崇庆旭 on 15/7/16.
//  Copyright (c) 2015年 崇庆旭. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QXSeperatePageHeadSelectedView;

/**
 *  页数
 * */
typedef NSUInteger(^NumberOfPagesBlock)(void);
/**
 *  对应页的对应内容的控制器
 *
 *  @param index <#index description#>
 *
 *  @return 内容控制器
 */
typedef UIViewController*(^ViewControllerAtIndexBlock)(NSUInteger index);

/**
 *  每一页的头部
 *
 *  @param index <#index description#>
 *
 *  @return <#return value description#>
 */
typedef NSString*(^TitleForPageAtIndexBlock)(NSUInteger index);


@interface QXSeperatePageViewController : UIViewController
/**
 *  自控制器容器
 */
@property(nonatomic, strong) NSMutableArray *subviewControllers;

/**
 *  选中的索引
 */
@property(nonatomic, assign) NSInteger selectedIndex;
// Datasource related blocks
@property(nonatomic, copy) NumberOfPagesBlock block_numberOfPages;
@property(nonatomic, copy) ViewControllerAtIndexBlock block_viewControllerAtIndex;
@property(nonatomic, copy) TitleForPageAtIndexBlock block_titleForPageAtIndex;


- (void)reloadData;
@end
