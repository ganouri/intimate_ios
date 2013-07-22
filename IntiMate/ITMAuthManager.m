//
//  ITMAuthManager.m
//  IntiMate
//
//  Created by Konstantin Kim on 22/07/13.
//  Copyright (c) 2013 IntiMate. All rights reserved.
//

#import "ITMAuthManager.h"
#import "ITMLoginViewController.h"

@implementation ITMAuthManager

+ (ITMAuthManager *)shared {
    static dispatch_once_t onceToken;
    static ITMAuthManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[self class] new];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActiveNotification)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark - 

- (void)applicationDidBecomeActiveNotification {
    NSLog(@"ded");
    [self presentLoginViewController];
}

- (void)presentLoginViewController {
    ITMLoginViewController *loginViewController = [[ITMLoginViewController alloc] init];
    [self.mainNavigationController presentViewController:loginViewController animated:YES completion:^{}];
}


@end
