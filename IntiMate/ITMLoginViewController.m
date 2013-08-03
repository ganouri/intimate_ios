//
//  ITMLoginViewController.m
//  IntiMate
//
//  Created by Konstantin Kim on 22/07/13.
//  Copyright (c) 2013 IntiMate. All rights reserved.
//

#import "ITMLoginViewController.h"
#import "NSString+MD5.h"

@interface ITMLoginViewController ()

@end

@implementation ITMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (self.type) {
        case ITMLoginViewTypeCreate:
            _emailTextField.hidden = NO;
            [_emailTextField becomeFirstResponder];
            _loginButton.hidden = NO;
            _createAccountButton.hidden = NO;
            _unlockButton.hidden = YES;
            _termsButton.hidden = NO;
            _termsLabel.hidden = NO;
            _interactButton.hidden = YES;
            _loginButton.hidden = YES;
            _createAccountButton.hidden = NO;
            break;
        case ITMLoginViewTypeLogin:
            _emailTextField.hidden = NO;
            [_emailTextField becomeFirstResponder];
            _loginButton.hidden = NO;
            _createAccountButton.hidden = NO;
            _unlockButton.hidden = YES;
            _termsButton.hidden = NO;
            _termsLabel.hidden = NO;
            _interactButton.hidden = YES;
            _loginButton.hidden = NO;
            _createAccountButton.hidden = NO;
            break;
        case ITMLoginViewTypeLockscreen:
            _emailTextField.hidden = YES;
            [_passwordTextField becomeFirstResponder];
            _loginButton.hidden = YES;
            _createAccountButton.hidden = YES;
            _unlockButton.hidden = NO;
            _termsButton.hidden = YES;
            _termsLabel.hidden = YES;
            _interactButton.hidden = NO;
            break;
    }
    
}

#pragma mark - User Events

- (IBAction)loginClicked:(id)sender {
    
    [[ITMAuthManager shared] loginWithLogin:_emailTextField.text
                                  authToken:[ITMAuthManager shared].authToken
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
    
    [[ITMAuthManager shared] signupWithNickname:_nicknameTextFiled.text
                                          email:_emailTextField.text
                                       password:_passwordTextField.text
                                     completion:^(BOOL success, NSDictionary *responseData) {
                                         if (success) {
                                             NSLog(@"%@", responseData);
                                             NSString *pass = responseData[@"password"];
                                             
                                             NSString *tokenMD5 = [[NSString stringWithFormat:@":%@:%@:", _emailTextField.text, pass] MD5Digest];
                                             [[ITMAuthManager shared] setAuthToken:tokenMD5];
                                             
                                             NSString *nickname = responseData[@"nickname"];
                                             _nicknameTextFiled.text = nickname;
                                             
                                             NSArray *rooms = responseData[@"rooms"];
                                             
                                             [self dismissViewControllerAnimated:YES completion:^{}];
                                         } else {
                                             [UIAlertView alertViewWithTitle:nil message:@"Could not create user"];
                                         }
                                     }];
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
