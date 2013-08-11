//
//  ITMAuthManager.m
//  IntiMate
//
//  Created by Konstantin Kim on 22/07/13.
//  Copyright (c) 2013 IntiMate. All rights reserved.
//

#import "ITMAuthManager.h"
#import "ITMLoginViewController.h"
#import "NSString+MD5.h"

#define AUTH_TOKEN @"AUTH_TOKEN"
#define SECURE_TOKEN @"SECURE_TOKEN"
#define USER_EMAIL @"USER_EMAIL"
#define USER_NICKNAME @"USER_NICKNAME"
#define Defaults [NSUserDefaults standardUserDefaults]

@interface ITMAuthManager() {
    AFHTTPClient *_afHTTPClient;
}

@end

@implementation ITMAuthManager
@synthesize afHTTPClient = _afHTTPClient;

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
        
        _afHTTPClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:BASE_URL]];
    }
    return self;
}

#pragma mark - 

+ (NSString *)authTokenForEmail:(NSString *)email password:(NSString *)password {
    return [[NSString stringWithFormat:@":%@:%@:", email, [password MD5Digest]] MD5Digest];
}

- (void)setAuthToken:(NSString *)authToken {
    [Defaults setObject:authToken forKey:AUTH_TOKEN];
    [Defaults synchronize];
}

- (NSString *)authToken {
    NSString *token = [Defaults objectForKey:AUTH_TOKEN];
    return token ? token : @"";
}

- (void)setSecureToken:(NSString *)secureToken {
    [Defaults setObject:secureToken forKey:SECURE_TOKEN];
    [Defaults synchronize];
}

- (NSString *)secureToken {
    return [Defaults objectForKey:SECURE_TOKEN];
}

- (void)setEmail:(NSString *)email {
    [Defaults setObject:email forKey:USER_EMAIL];
    [Defaults synchronize];
}

- (NSString *)email {
    return [Defaults objectForKey:USER_EMAIL];
}

- (void)setNickmane:(NSString *)nickmane {
    [Defaults setObject:nickmane forKey:USER_NICKNAME];
    [Defaults synchronize];
}

- (NSString *)nickmane {
    return [Defaults objectForKey:USER_NICKNAME];
}

#pragma mark -

- (void)applicationDidBecomeActiveNotification {
    if ([ITMAuthManager shared].secureToken == nil) {
        [self presentLoginViewControllerPasswordOnly:NO
                                            animated:NO
                                          completion:^{}];
    } else {
        [self presentLoginViewControllerPasswordOnly:YES
                                            animated:YES
                                          completion:^{}];
    }
}

- (void)presentLoginViewControllerPasswordOnly:(BOOL)passOnly
                                      animated:(BOOL)animated
                                    completion:(void (^)())completion {
    ITMLoginViewController *loginViewController = [ITMLoginViewController new];
    ITMLoginViewType type = passOnly ? ITMLoginViewTypeLockscreen : ITMLoginViewTypeLogin;
    loginViewController.type = type;
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
                             @"authHash": token};
    
    NSURLRequest *request = [_afHTTPClient requestWithMethod:@"POST"
                                                        path:@"login"
                                                  parameters:params];
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        
                                                        NSString *token = JSON[@"payload"];
                                                        
                                                        if (![token isKindOfClass:[NSNull class]]) {
                                                            NSLog(@"Success! Token: %@", token);
                                                        } else {
                                                            NSLog(@"Fail, error: %@", JSON[@"errors"]);
                                                        }
                                                        
                                                        completion(token!=nil && ![token isKindOfClass:[NSNull class]], token);
                                                        
                                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        NSLog(@"Failed: %@", JSON);
                                                        
                                                        if (token) {
                                                            NSLog(@"Success! Token: %@", token);
                                                        } else {
                                                            NSLog(@"Fail, error: %@", JSON[@"errors"]);
                                                        }
                                                        
                                                        completion(token!=nil,token);
                                                        
                                                    }];
    [operation start];
    
}

- (void)signupWithNickname:(NSString *)nickmane
                     email:(NSString *)email
                  password:(NSString *)password
                completion:(void (^)(BOOL success, NSDictionary *responseData))completion {
    NSDictionary *params = @{@"nickname": nickmane,
                             @"email": email,
                             @"password": password};
    
    NSURLRequest *request = [_afHTTPClient requestWithMethod:@"POST"
                                                        path:@"signup"
                                                  parameters:params];
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        
                                                        NSDictionary *responseDict = JSON[@"payload"];
                                                        
                                                        if (responseDict && ![responseDict isKindOfClass:[NSNull class]]) {
                                                            NSLog(@"Success! responseDict: %@", responseDict);
                                                            
                                                        } else {
                                                            NSLog(@"Fail in success, error: %@", JSON[@"errors"]);
                                                        }
                                                        
                                                        completion(responseDict != nil && ![responseDict isKindOfClass:[NSNull class]], responseDict);
                                                        
                                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        NSLog(@"Failed: %@", JSON);
                                                        completion(NO, nil);
                                                    }];
    [operation start];

}


@end
