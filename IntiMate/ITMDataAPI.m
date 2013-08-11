//
//  ITMDataAPI.m
//  IntiMate
//
//  Created by Konstantin Kim on 3/08/13.
//  Copyright (c) 2013 IntiMate. All rights reserved.
//

#import "ITMDataAPI.h"
#import "AFNetworking.h"


@implementation ITMDataAPI

+ (void)getAllDataForToken:(NSString *)token
                completion:(void (^)(BOOL success, NSDictionary *allDataDict))completion {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/secure/%@", BASE_URL, token]]];
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        
                                                        NSDictionary *allData = JSON[@"payload"];
                                                        
                                                        if (![allData isKindOfClass:[NSNull class]]) {
                                                            NSLog(@"Success! allData: %@", allData);
                                                        } else {
                                                            NSLog(@"Fail, error: %@", JSON[@"errors"]);
                                                        }
                                                        
                                                        completion(allData!=nil && ![allData isKindOfClass:[NSNull class]], allData);
                                                        
                                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        NSLog(@"Failed: %@", JSON);
                                                        completion(NO, JSON);
                                                    }];
    [operation start];
}


+ (void)getListOf:(NSString *)entity
         forToken:(NSString *)token
       completion:(void (^)(BOOL success, id rooms))completion {
    
    NSString *path = [NSString stringWithFormat:@"%@/secure/%@/%@", BASE_URL, token, entity];
    NSURLRequest *request = [[ITMAuthManager shared].afHTTPClient requestWithMethod:@"POST"
                                                                               path:path
                                                                         parameters:nil];
    
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        
                                                        NSArray *list = JSON[@"payload"];
                                                        
                                                        if (![list isKindOfClass:[NSNull class]]) {
                                                            NSLog(@"Success! list: %@", list);
                                                        } else {
                                                            NSLog(@"Fail, error: %@", JSON[@"errors"]);
                                                        }
                                                        
                                                        completion(list!=nil && ![list isKindOfClass:[NSNull class]], list);
                                                        
                                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        NSLog(@"Failed: %@", JSON);
                                                        completion(NO, JSON);
                                                    }];
    [operation start];
}

+ (void)getRoomData:(NSString *)roomId
         completion:(void (^)(BOOL success, id list))completion {
    NSString *path = [NSString stringWithFormat:@"%@/secure/%@/room/%@", BASE_URL, [ITMAuthManager shared].secureToken, roomId];
    NSURLRequest *request = [[ITMAuthManager shared].afHTTPClient requestWithMethod:@"GET"
                                                                               path:path
                                                                         parameters:nil];
    
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        
                                                        NSArray *list = JSON[@"payload"][@"corr"];
                                                        
                                                        if (![list isKindOfClass:[NSNull class]]) {
                                                            NSLog(@"Success! list: %@", list);
                                                        } else {
                                                            NSLog(@"Fail, error: %@", JSON[@"errors"]);
                                                        }
                                                        
                                                        completion(list!=nil && ![list isKindOfClass:[NSNull class]], list);
                                                        
                                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        NSLog(@"Failed: %@", JSON);
                                                        completion(NO, JSON);
                                                    }];
    [operation start];
}

+ (void)getAllResourcesWithCompletion:(void (^)(BOOL success, id list))completion {
    NSString *path = [NSString stringWithFormat:@"%@/secure/%@/resources", BASE_URL, [ITMAuthManager shared].secureToken];
    NSURLRequest *request = [[ITMAuthManager shared].afHTTPClient requestWithMethod:@"POST"
                                                                               path:path
                                                                         parameters:nil];
    
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        
                                                        NSArray *list = JSON[@"payload"];
                                                        
                                                        if (![list isKindOfClass:[NSNull class]]) {
                                                            NSLog(@"Success! list: %@", list);
                                                        } else {
                                                            NSLog(@"Fail, error: %@", JSON[@"errors"]);
                                                        }
                                                        
                                                        completion(list!=nil && ![list isKindOfClass:[NSNull class]], list);
                                                        
                                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        NSLog(@"Failed: %@", JSON);
                                                        completion(NO, JSON);
                                                    }];
    [operation start];
}

+ (void)getResource:(NSString *)resourceId
            forRoom:(NSString *)roomId
         completion:(void (^)(BOOL success, id list))completion {
    // /secure/:hash/room/:room/resource/:resource
    NSString *path = [NSString stringWithFormat:@"%@/secure/%@/room/%@/resource/%@", BASE_URL, [ITMAuthManager shared].secureToken, roomId, resourceId];
    NSURLRequest *request = [[ITMAuthManager shared].afHTTPClient requestWithMethod:@"POST"
                                                                               path:path
                                                                         parameters:nil];
    
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        
                                                        NSArray *list = JSON[@"payload"][@"corr"];
                                                        
                                                        if (![list isKindOfClass:[NSNull class]]) {
                                                            NSLog(@"Success! list: %@", list);
                                                        } else {
                                                            NSLog(@"Fail, error: %@", JSON[@"errors"]);
                                                        }
                                                        
                                                        completion(list!=nil && ![list isKindOfClass:[NSNull class]], list);
                                                        
                                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        NSLog(@"Failed: %@", JSON);
                                                        completion(NO, JSON);
                                                    }];
    [operation start];
}

+ (void)sendImage:(UIImage *)image
       completion:(void (^)(BOOL success, NSString *resourceId))completion {

    AFHTTPClient *client= [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:BASE_URL]];
    
    NSMutableURLRequest *request =
    [client multipartFormRequestWithMethod:@"POST"
                                      path:[NSString stringWithFormat:@"secure/%@/resource/", [ITMAuthManager shared].secureToken]
                                parameters:nil
                 constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                     NSData *imageToUpload = UIImageJPEGRepresentation(image, 1.0);
        [formData appendPartWithFileData:imageToUpload
                                    name:@"image"
                                fileName:@"fileName.jpeg"
                                mimeType:@"image/jpeg"];
    }];

    
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        
                                                         NSString *resourceID = JSON[@"payload"];
                                                        NSLog(@"%@", JSON);
                                                        if   (![resourceID isKindOfClass:[NSNull class]]) {
                                                            NSLog(@"Success! resourceID: %@", resourceID);
                                                        } else {
                                                            NSLog(@"Fail, error: %@", JSON[@"errors"]);
                                                        }
                                                        
                                                        completion(resourceID != nil && ![resourceID isKindOfClass:[NSNull class]], resourceID);
                                                        
                                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        NSLog(@"Failed: %@", JSON);
                                                        completion(NO, nil);
                                                    }];
    [operation start];
}

+ (void)associateResource:(NSString *)resourceId
                 withRoom:(NSString *)roomId
               completion:(void (^)(BOOL success, NSString *associationTimestamp))completion {
    NSString *urlString = [NSString stringWithFormat:@"%@/secure/%@/room/%@/asc/%@",
                           BASE_URL,
                           [[ITMAuthManager shared] secureToken],
                           roomId,
                           resourceId];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        
                                                        NSString *associationTimestamp = JSON[@"payload"];
                                                        
                                                        if (![associationTimestamp isKindOfClass:[NSNull class]]) {
                                                            NSLog(@"Success! allData: %@", associationTimestamp);
                                                        } else {
                                                            NSLog(@"Fail, error: %@", JSON[@"errors"]);
                                                        }
                                                        
                                                        completion(associationTimestamp!=nil && ![associationTimestamp isKindOfClass:[NSNull class]], associationTimestamp);
                                                        
                                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        NSLog(@"Failed: %@", JSON);
                                                        completion(NO, JSON);
                                                    }];
    [operation start];
}


+ (void)createRoomWithUsers:(NSString *)colonSeparatedUsers
                 completion:(void (^)(BOOL success, NSString *roomId))completion {
    NSString *urlString = [NSString stringWithFormat:@"%@/secure/%@/roomid/%@",
                           BASE_URL, [[ITMAuthManager shared] secureToken], colonSeparatedUsers];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        
                                                        NSString *roomId = JSON[@"payload"];
                                                        
                                                        if (![roomId isKindOfClass:[NSNull class]]) {
                                                            NSLog(@"Success! allData: %@", roomId);
                                                        } else {
                                                            NSLog(@"Fail, error: %@", JSON[@"errors"]);
                                                        }
                                                        
                                                        completion(roomId!=nil && ![roomId isKindOfClass:[NSNull class]], roomId);
                                                        
                                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        NSLog(@"Failed: %@", JSON);
                                                        completion(NO, JSON);
                                                    }];
    [operation start];
}

#pragma mark - Singleton

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

+ (ITMDataAPI *)shared {
    static ITMDataAPI *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ITMDataAPI new];
    });
    return instance;
}

@end
