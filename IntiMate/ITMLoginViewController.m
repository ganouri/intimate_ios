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
    
    [self setUIType:self.type];
}

#pragma mark - UI

- (void)setUIType:(ITMLoginViewType)type {
    switch (type) {
        case ITMLoginViewTypeCreate:
            _emailTextField.hidden = NO;
            [_emailTextField becomeFirstResponder];
            _loginButton.hidden = NO;
            _createAccountButton.hidden = NO;
            _unlockButton.hidden = YES;
            _termsButton.hidden = NO;
            _termsLabel.hidden = NO;
            _interactButton.hidden = YES;
            _nicknameTextFiled.hidden = NO;
            _logoutButton.hidden = YES;
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
            _nicknameTextFiled.hidden = NO;
            _logoutButton.hidden = YES;
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
            _nicknameTextFiled.hidden = YES;
            _logoutButton.hidden = NO;
            break;
    }
}

#pragma mark - User Events

- (IBAction)loginClicked:(id)sender {
    
    [[ITMAuthManager shared] loginWithLogin:_emailTextField.text
                                  authToken:[ITMAuthManager authTokenForEmail:_emailTextField.text password:_passwordTextField.text]
                                 completion:^(BOOL success, NSString *loginToken) {
                                     if (success) {
                                         NSLog(@"loginToken : %@", loginToken);
                                         
                                         NSString *tokenMD5 = [[NSString stringWithFormat:@":%@:%@:",
                                                                _emailTextField.text,
                                                                [_passwordTextField.text MD5Digest]]
                                                               MD5Digest];
                                         
                                         [[ITMAuthManager shared] setAuthToken:tokenMD5];
                                         [[ITMAuthManager shared] setSecureToken:loginToken];
                                         [[ITMAuthManager shared] setEmail:_emailTextField.text];
                                         [[ITMAuthManager shared] setNickmane:_nicknameTextFiled.text];
                                         
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
//                                             NSString *pass = responseData[@"password"];

                                             // login automatically
                                             [self loginClicked:nil];

                                             // TODO:
//                                             NSArray *rooms = responseData[@"rooms"];
                                             
                                         } else {
                                             [UIAlertView alertViewWithTitle:nil message:@"Could not create user"];
                                         }
                                     }];
}

- (IBAction)unlockClicked:(id)sender {
    
    NSString *stringToValidate = [[NSString stringWithFormat:@":%@:%@:",
                                  [ITMAuthManager shared].email,
                                  [_passwordTextField.text MD5Digest]] MD5Digest];
    
    if ([[ITMAuthManager shared].authToken isEqualToString:stringToValidate]) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    } else {
        [UIAlertView alertViewWithTitle:nil message:@"Password is not correct"];
    }
}

- (IBAction)interactClicked:(id)sender {
    [[ITMInteractionManager shared] presentCameraOnController:self
                                                    withBlock:^(UIImage *chosenImage) {
                                                        
                                                    } cancelBlock:^{
                                                        
                                                    }];
}

- (IBAction)logoutButtonClicked:(id)sender {
    [UIAlertView alertViewWithTitle:nil
                            message:@"Do you want to Log out?"
                  cancelButtonTitle:@"No"
                  otherButtonTitles:@[@"Yes"]
                          onDismiss:^(int buttonIndex) {
                              [[ITMAuthManager shared] setSecureToken:nil];
                              [[ITMAuthManager shared] setAuthToken:nil];
                              [self setUIType:ITMLoginViewTypeCreate];
                          } onCancel:^{}];
}

@end
