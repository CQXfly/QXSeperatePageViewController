//
//  QXSeperatePageChildViewController.m
//  QXSeperatePageViewController
//
//  Created by 崇庆旭 on 15/7/16.
//  Copyright (c) 2015年 崇庆旭. All rights reserved.
//

#import "QXSeperatePageChildViewController.h"

@interface QXSeperatePageChildViewController ()

@end

@implementation QXSeperatePageChildViewController

@synthesize alias;



- (id)initWithAlias:(NSString *)string nibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        alias = string;
    }
    return self;
}

+ (instancetype)CreateViewControllerWithAlias:(NSString *)string
{
    QXSeperatePageChildViewController *vc = [[QXSeperatePageChildViewController alloc] initWithAlias:string
                                                                             nibName:nil
                                                                              bundle:nil];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *centerLabel = [[UILabel alloc] init];
    centerLabel.font = [UIFont boldSystemFontOfSize:25.0f];
    [self.view addSubview:centerLabel];
    self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1];
    centerLabel.text = alias;
    [centerLabel sizeToFit];
    centerLabel.center = self.view.center;
    centerLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    
    
//    self.view.backgroundColor = [UIColor whiteColor];
    
    }

@end
