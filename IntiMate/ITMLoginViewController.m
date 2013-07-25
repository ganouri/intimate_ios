//
//  ITMLoginViewController.m
//  IntiMate
//
//  Created by Konstantin Kim on 22/07/13.
//  Copyright (c) 2013 IntiMate. All rights reserved.
//

#import "ITMLoginViewController.h"


@interface ITMLoginViewController ()

@end

@implementation ITMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isPasswordOnly) {
        _emailTextField.hidden = YES;
        [_passwordTextField becomeFirstResponder];
        _loginButton.hidden = YES;
        _createAccountButton.hidden = YES;
        _unlockButton.hidden = NO;
        _termsButton.hidden = YES;
        _termsLabel.hidden = YES;
        _interactButton.hidden = NO;
    } else {
        _emailTextField.hidden = NO;
        [_emailTextField becomeFirstResponder];
        _loginButton.hidden = NO;
        _createAccountButton.hidden = NO;
        _unlockButton.hidden = YES;
        _termsButton.hidden = NO;
        _termsLabel.hidden = NO;
        _interactButton.hidden = YES;
    }
}

#pragma mark - User Events

- (IBAction)loginClicked:(id)sender {
    
    [[ITMAuthManager shared] loginWithLogin:@"kostia@me.com"
                                  authToken:@"93e7c45926d723391f3a9629c09dec17"
                                 completion:^(BOOL success, NSString *loginToken) {
                                     if (success) {
                                         NSLog(@"loginToken : %@", loginToken);
                                         [self dismissViewControllerAnimated:YES completion:^{}];
                                     } else {
                                         [UIAlertView alertViewWithTitle:nil message:@"Could not authenticate"];
                                     }
                                 }];
}

- (IBAction)createClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)unlockClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)interactClicked:(id)sender {
    [[ITMInteractionManager shared] presentCameraOnController:self
                                                    withBlock:^(UIImage *chosenImage) {
                                                        
                                                    } cancelBlock:^{
                                                        
                                                    }];
}

@end
