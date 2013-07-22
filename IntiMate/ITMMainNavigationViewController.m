//
//  ITMMainNavigationViewController.m
//  IntiMate
//
//  Created by Konstantin Kim on 22/07/13.
//  Copyright (c) 2013 IntiMate. All rights reserved.
//

#import "ITMMainNavigationViewController.h"

@interface ITMMainNavigationViewController ()

@end

@implementation ITMMainNavigationViewController

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

@end
