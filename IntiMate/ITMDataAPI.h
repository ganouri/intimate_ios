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

+ (void)getRoomsForToken:(NSString *)token
              completion:(void (^)(BOOL success, NSArray *rooms))completion;

+ (void)sendImage:(UIImage *)image
       completion:(void (^)(BOOL success, NSString *resourceId))completion;


+ (void)associateResource:(NSString *)resourceId
                 withRoom:(NSString *)roomId
               completion:(void (^)(BOOL success, NSString *assiciationTimestamp))completion;


+ (void)createRoomWithUsers:(NSString *)colonSeparatedUsers
                 completion:(void (^)(BOOL success, NSString *roomId))completion;

@end
