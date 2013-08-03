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

+ (void)sendImage:(UIImage *)image
       completion:(void (^)(BOOL success, NSDictionary *response))completion {

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
//                                                        if   (![token isKindOfClass:[NSNull class]]) {
//                                                            NSLog(@"Success! Token: %@", token);
//                                                        } else {
//                                                            NSLog(@"Fail, error: %@", JSON[@"errors"]);
//                                                        }
                                                        
//                                                        completion(token!=nil && ![token isKindOfClass:[NSNull class]], token);
                                                        
                                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        NSLog(@"Failed: %@", JSON);
                                                        completion(NO, JSON);
                                                    }];
    [operation start];
}

@end
