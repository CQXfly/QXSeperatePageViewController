//
//  QXSeperatePageHeadSelectedView.m
//  QXSeperatePageViewController
//
//  Created by 崇庆旭 on 15/7/16.
//  Copyright (c) 2015年 崇庆旭. All rights reserved.
//

#import "QXSeperatePageHeadSelectedView.h"

#define defaultSeparatorLineColor [UIColor orangeColor]
#define defaultIndicatorColor [UIColor whiteColor]
#define kItemTagBase 1000
#define kItemWidth 80

@interface QXSeperatePageHeadSelectedView ()

/**
 *  类导航指示器
 */
@property (nonatomic,strong) UIScrollView *scrollView;




- (void)cleanupItems;
@end

@implementation QXSeperatePageHeadSelectedView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        
        /**
         UIView中有个属性是autoresizingMask，该属性是用来控制控件的自适应。
         UIViewAutoresizingNone
         UIViewAutoresizingFlexibleLeftMargin
         UIViewAutoresizingFlexibleWidth
         UIViewAutoresizingFlexibleRightMargin
         UIViewAutoresizingFlexibleTopMargin
         UIViewAutoresizingFlexibleHeight
         UIViewAutoresizingFlexibleBottomMargin
         
         UIViewAutoresizingNone：控件相对于父视图坐标值不变；
         UIViewAutoresizingFlexibleWidth：控件的宽度随着父视图的宽度按比例改变；
         例如：label宽度为100，屏幕的宽度为320。当屏幕宽度为480时，label宽度变为100*480/320
         UIViewAutoresizingFlexibleHeight：与UIViewAutoresizingFlexibleWidth相同
         UIViewAutoresizingFlexibleLeftMargin：到屏幕左边的距离随着父视图的宽度按比例改变；
         例如：CGRectMake(50, 100, 200, 40)]; 当屏幕的宽度为320，x为50；当屏幕宽度为480时，labelx坐标变为 50*480/320。
         控件坐标变为 CGRectMake(75, 100, 200, 40)];
         UIViewAutoresizingFlexibleRightMargin
         UIViewAutoresizingFlexibleTopMargin
         UIViewAutoresizingFlexibleBottomMargin
         UIViewAutoresizingFlexibleLeftMargin类似
         */
        
        
        self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        
        
    }
    return self;
}




- (instancetype) initWithFrame:(CGRect)frame itemTitles:(NSArray *)array
{
    if (self = [self initWithFrame:frame]) {
        
        self.sourceItems = array;
        
    }
    return self;
}

- (void) cleanupItems
{
    for (UIView *vc in self.scrollView.subviews) {
        if ([vc isKindOfClass:[QXSeperatePageHeadSelectedViewItem class]]) {
            
            [vc removeFromSuperview];
        }
    }
}

/**
 *  设置items
 */

- (void)setSourceItems:(NSArray *)sourceItems
{
    _sourceItems = sourceItems;
    [self cleanupItems];
    if (self.sourceItems.count > 0) {
        
        int i = 0;
        
        for (NSString *title in sourceItems) {
            QXSeperatePageHeadSelectedViewItem *item = [[QXSeperatePageHeadSelectedViewItem alloc] init];
            //给每个按钮设置tag
            item.tag = kItemTagBase + i;
            
            [item setTitle:title forState:UIControlStateNormal];
            [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            //设置item的选择器的颜色
            item.indicatorColor = [UIColor orangeColor];
            
             [item addTarget:self action:@selector(itemSelect:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:item];
            
            item.frame = CGRectMake(i * kItemWidth, 0, kItemWidth, self.frame.size.height);
            
            i ++;
            
        }
    }
    self.scrollView.contentSize = CGSizeMake(kItemWidth * sourceItems.count, self.frame.size.height);
}

/**
 *  设置分割线
 *
 *  @param item <#item description#>
 */

- (void)setSeparatorLineColor:(UIColor *)separatorLineColor
{
    _separatorLineColor = separatorLineColor;
    [self setNeedsDisplay];
}

- (UIColor *)separatorLineColor
{
    if (!_separatorLineColor) {
        _separatorLineColor = defaultSeparatorLineColor;
    }
    return _separatorLineColor;
}



- (void) itemSelect:(QXSeperatePageHeadSelectedViewItem *) item
{
    NSUInteger willSelectedIndex =item.tag - kItemTagBase;
    
    if(willSelectedIndex==self.selectedIndex){
        return;
    }
    if(self.blockdidSelectedAtIndex){
        self.blockdidSelectedAtIndex (willSelectedIndex);
    }

}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
   
    //scrollView的方法
    UIButton *lastBtn = (UIButton *)[self.scrollView viewWithTag:(_selectedIndex+kItemTagBase)];
    lastBtn.selected = NO;
     _selectedIndex = selectedIndex;
    UIButton *selectedBtn = (UIButton *)[self.scrollView viewWithTag:(selectedIndex+kItemTagBase)];
    selectedBtn.selected = YES;
    
    UIView *willSelectedBarItem = [_scrollView viewWithTag:(selectedIndex+kItemTagBase)];
    CGRect visibleFrame = willSelectedBarItem.frame;
    visibleFrame.origin.x -= kItemWidth * 2 ;
    visibleFrame.size.width = CGRectGetWidth(self.frame);
    
    [_scrollView scrollRectToVisible:visibleFrame animated:YES];
    
    [self setNeedsDisplay];
    
}

/**
 *  绘制上面的线条
 *
 *  @param rect <#rect description#>
 */
- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [self.separatorLineColor setStroke];
    [bezierPath setLineWidth:1.0];
    
    [bezierPath moveToPoint:CGPointMake(0.0, 0.0)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), 0.0)];
    [bezierPath stroke];
    
    [bezierPath moveToPoint:CGPointMake(0.0, CGRectGetHeight(rect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect))];
    [bezierPath stroke];
}

@end
#pragma mark - item的实现方法

@implementation QXSeperatePageHeadSelectedViewItem

@synthesize indicatorColor =  _indicatorColor;

- (UIColor *)indicatorColor
{
    if (!_indicatorColor) {
        
        return defaultIndicatorColor;
    }
    return _indicatorColor;
}

- (void)setIndicatorColor:(UIColor *)indicatorColor
{
    _indicatorColor = indicatorColor;
    
    [self setTitleColor:indicatorColor forState:UIControlStateSelected];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    if (self.selected) {
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        // Draw the indicator
        [bezierPath moveToPoint:CGPointMake(0.0, CGRectGetHeight(rect) - 1.0)];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) - 1.0)];
        [bezierPath setLineWidth:3.0];
        [self.indicatorColor setStroke];
        [bezierPath stroke];
    }
}

@end
