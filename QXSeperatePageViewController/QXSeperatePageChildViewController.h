//
//  QXSeperatePageChildViewController.h
//  QXSeperatePageViewController
//
//  Created by 崇庆旭 on 15/7/16.
//  Copyright (c) 2015年 崇庆旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QXSeperatePageChildViewController : UIViewController
{
    NSString *alias;
}

@property(nonatomic, strong) NSString *alias;


+ (instancetype)CreateViewControllerWithAlias:(NSString *)string;
@end
