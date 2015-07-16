//
//  QXSeperatePageHeadSelectedView.h
//  QXSeperatePageViewController
//
//  Created by 崇庆旭 on 15/7/16.
//  Copyright (c) 2015年 崇庆旭. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^DidSelectedAtIndexBlock)(NSUInteger index) ;
@interface QXSeperatePageHeadSelectedView : UIView

{
    UIColor *_separatorLineColor;
}

/**
 *  选中按钮的索引
 */
@property(nonatomic, assign) NSUInteger selectedIndex;

/**
 *  下划线的颜色
 */
//@property (nonatomic,strong) UIColor *separatorLineColor;

/**
 *  需要选择的按钮数组
 */
@property(nonatomic, strong) NSArray *sourceItems;

/**
 *  定义选中时的block
 */
@property(nonatomic, copy) DidSelectedAtIndexBlock blockdidSelectedAtIndex;

/**
 *  构造头部选择控件
 *
 *  @param frame <#frame description#>
 *  @param array <#array description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithFrame:(CGRect)frame itemTitles:(NSArray *)array;
@end

#pragma  mark - selecteView上的按钮

@interface QXSeperatePageHeadSelectedViewItem : UIButton
/**
 *  指示器颜色
 */
@property (nonatomic,strong) UIColor *indicatorColor;


@end