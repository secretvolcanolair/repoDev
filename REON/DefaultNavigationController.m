//
//  DefaultNavigationController.m
//  REON
//
//  Created by Robert Kehoe on 7/14/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import "DefaultNavigationController.h"

@interface DefaultNavigationController ()

@end

@implementation DefaultNavigationController


- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
        
    [self.navigationBar setOpaque:NO];
    [self.navigationBar setTranslucent:NO];
    [self.navigationBar setBarTintColor:[UIColor whiteColor]];
    
}

@end
