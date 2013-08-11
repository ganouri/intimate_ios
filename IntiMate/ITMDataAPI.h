//
//  ITMDataAPI.h
//  IntiMate
//
//  Created by Konstantin Kim on 3/08/13.
//  Copyright (c) 2013 IntiMate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITMDataAPI : NSObject

@property (nonatomic, retain) NSDictionary *users;
@property (nonatomic, retain) NSArray *resources;

+ (ITMDataAPI *)shared;

+ (void)getAllDataForToken:(NSString *)token
                completion:(void (^)(BOOL success, NSDictionary *rooms))completion;

+ (void)getListOf:(NSString *)entity
         forToken:(NSString *)token
       completion:(void (^)(BOOL success, id list))completion;

+ (void)getRoomData:(NSString *)roomId
         completion:(void (^)(BOOL success, id list))completion;

+ (void)getAllResourcesWithCompletion:(void (^)(BOOL success, id list))completion;

+ (void)getResource:(NSString *)resourceId
            forRoom:(NSString *)roomId
         completion:(void (^)(BOOL success, id list))completion;

+ (void)sendImage:(UIImage *)image
       completion:(void (^)(BOOL success, NSString *resourceId))completion;


+ (void)associateResource:(NSString *)resourceId
                 withRoom:(NSString *)roomId
               completion:(void (^)(BOOL success, NSString *assiciationTimestamp))completion;


+ (void)createRoomWithUsers:(NSString *)colonSeparatedUsers
                 completion:(void (^)(BOOL success, NSString *roomId))completion;

@end
