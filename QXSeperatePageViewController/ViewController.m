//
//  ViewController.m
//  QXSeperatePageViewController
//
//  Created by 崇庆旭 on 15/7/16.
//  Copyright (c) 2015年 崇庆旭. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

/**
 *  标题数组
 */
@property (nonatomic,strong) NSMutableArray *titles;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titles = [NSMutableArray arrayWithObjects:@"Page A", @"Page B", @"Page C", @"Page D", @"Page E", @"Page F",@"Page.G" ,nil];
    
    NSUInteger _pageNumber = self.titles.count;
    [self setBlock_numberOfPages:^(void){
        return _pageNumber;
    }];
    
    __weak NSArray *weak_array = self.titles;
    [self setBlock_titleForPageAtIndex:^(NSUInteger index){
        NSArray *strong_array = weak_array;
        return [strong_array objectAtIndex:index];
    }];
    
    [self setBlock_viewControllerAtIndex:^(NSUInteger index){
        return [QXSeperatePageChildViewController CreateViewControllerWithAlias:[NSString stringWithFormat:@"Page %lu", (unsigned long)index]];
    }];
    
   
    
    [self reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
