//
//  ITMInteractionManager.h
//  IntiMate
//
//  Created by Konstantin Kim on 23/07/13.
//  Copyright (c) 2013 IntiMate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITMInteractionManager : NSObject

typedef void (^ITMCancelBlock)();
typedef void (^ITMPhotoPickedBlock)(UIImage *chosenImage);

@property (nonatomic, copy) ITMPhotoPickedBlock photoPickedBlock;
@property (nonatomic, copy) ITMCancelBlock cancelBlock;

+ (ITMInteractionManager *)shared;

// API
- (void)presentCameraOnController:(UIViewController *)vc
                        withBlock:(ITMPhotoPickedBlock)photoPickedBlock
                      cancelBlock:(ITMCancelBlock)cancelBlock;

@end
