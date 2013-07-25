//
//  ITMAuthManager.m
//  IntiMate
//
//  Created by Konstantin Kim on 22/07/13.
//  Copyright (c) 2013 IntiMate. All rights reserved.
//

#import "ITMAuthManager.h"
#import "ITMLoginViewController.h"
#import "AFNetworking.h"

@interface ITMAuthManager() {
    AFHTTPClient *_afHTTPClient;
}

@end

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
        
        _afHTTPClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://localhost:8080"]];
    }
    return self;
}

#pragma mark - 

- (void)applicationDidBecomeActiveNotification {
    [self presentLoginViewControllerPasswordOnly:NO
                                        animated:NO
                                      completion:^{}];
}

- (void)presentLoginViewControllerPasswordOnly:(BOOL)passOnly
                                      animated:(BOOL)animated
                                    completion:(void (^)())completion {
    ITMLoginViewController *loginViewController = [ITMLoginViewController new];
    loginViewController.isPasswordOnly = passOnly;
    loginViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.mainNavigationController presentViewController:loginViewController
                                                animated:YES
                                              completion:^{
                                                  completion();
                                              }];
}

- (void)loginWithLogin:(NSString *)login
             authToken:(NSString *)token
            completion:(void (^)(BOOL success, NSString *loginToken))completion {
    
    NSDictionary *params = @{@"user": login,
                             @"auth_hash": token};
    
    NSURLRequest *request = [_afHTTPClient requestWithMethod:@"POST"
                                                        path:@"login"
                                                  parameters:params];
//    NSMutableURLRequest *request1 = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:8080"]];
//    [request1 setHTTPMethod:@"POST"];
    
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        
                                                        NSString *token = JSON[@"payload"];
                                                        
                                                        if (token) {
                                                            NSLog(@"Success! Token: %@", token);
                                                        } else {
                                                            NSLog(@"Fail, error: %@", JSON[@"errors"]);
                                                        }
                                                        
                                                        completion(token!=nil,token);
                                                        
                                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        NSLog(@"Failed: %@", JSON);
                                                        
                                                        if (token) {
                                                            NSLog(@"Success! Token: %@", token);
                                                        } else {
                                                            NSLog(@"Fail, error: %@", JSON[@"errors"]);
                                                        }
                                                        
                                                        completion(token!=nil,token);
                                                        
                                                    }];
    /*
    [_afHTTPClient  HTTPRequestOperationWithRequest:request
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    NSLog(@"Failed: %@", error);
                                }];
    */
    //[_afHTTPClient enqueueHTTPRequestOperation:operation];
    [operation start];
    
}


@end
