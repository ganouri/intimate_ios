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
    } else {
        _emailTextField.hidden = NO;
        [_emailTextField becomeFirstResponder];
        _loginButton.hidden = NO;
        _createAccountButton.hidden = NO;
        _unlockButton.hidden = YES;
        _termsButton.hidden = NO;
        _termsLabel.hidden = NO;
    }

}

#pragma mark - User Events

- (IBAction)loginClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)createClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)unlockClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
