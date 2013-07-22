//
//  ITMAuthManager.h
//  IntiMate
//
//  Created by Konstantin Kim on 22/07/13.
//  Copyright (c) 2013 IntiMate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITMAuthManager : NSObject

@property (nonatomic, strong) UINavigationController *mainNavigationController;

+ (ITMAuthManager *)shared;
- (void)presentLoginViewControllerPasswordOnly:(BOOL)passOnly
                                      animated:(BOOL)animated
                                    completion:(void (^)())completion;

@end
