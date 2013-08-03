//
//  ITMDataAPI.h
//  IntiMate
//
//  Created by Konstantin Kim on 3/08/13.
//  Copyright (c) 2013 IntiMate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITMDataAPI : NSObject

+ (void)getAllDataForToken:(NSString *)token
                completion:(void (^)(BOOL success, NSDictionary *rooms))completion;

+ (void)sendImage:(UIImage *)image
       completion:(void (^)(BOOL success, NSDictionary *response))completion;


@end
