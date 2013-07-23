//
//  ITMInteractionManager.m
//  IntiMate
//
//  Created by Konstantin Kim on 23/07/13.
//  Copyright (c) 2013 IntiMate. All rights reserved.
//

#import "ITMInteractionManager.h"

@interface ITMInteractionManager() <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    
}

@end

@implementation ITMInteractionManager

+ (ITMInteractionManager *)shared {
    static dispatch_once_t onceToken;
    static ITMInteractionManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[self class] new];
    });
    return instance;
}

#pragma mark - Private



#pragma mark - Public API

- (void)presentCameraOnController:(UIViewController *)vc
                        withBlock:(ITMPhotoPickedBlock)photoPickedBlock
                      cancelBlock:(ITMCancelBlock)cancelBlock {
    
    self.photoPickedBlock = photoPickedBlock;
    self.cancelBlock = cancelBlock;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])	{
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [vc presentViewController:picker animated:YES completion:^{}];
	}
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *editedImage = (UIImage *)[info valueForKey:UIImagePickerControllerEditedImage];
    if(!editedImage)
        editedImage = (UIImage *)[info valueForKey:UIImagePickerControllerOriginalImage];
    
	[picker dismissViewControllerAnimated:YES completion:^{
        self.photoPickedBlock(editedImage);
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    self.cancelBlock();
}

@end
