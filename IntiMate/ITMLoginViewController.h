//
//  ITMLoginViewController.h
//  IntiMate
//
//  Created by Konstantin Kim on 22/07/13.
//  Copyright (c) 2013 IntiMate. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ITMLoginViewTypeCreate = 99,
    ITMLoginViewTypeLogin,
    ITMLoginViewTypeLockscreen,
} ITMLoginViewType;

@interface ITMLoginViewController : UIViewController {
    
    __weak IBOutlet UITextField *_nicknameTextFiled;
    __weak IBOutlet UITextField *_emailTextField;
    __weak IBOutlet UITextField *_passwordTextField;
    __weak IBOutlet UIButton *_loginButton;
    
    __weak IBOutlet UIButton *_createAccountButton;
    __weak IBOutlet UIButton *_unlockButton;
    __weak IBOutlet UILabel *_termsLabel;
    __weak IBOutlet UIButton *_termsButton;
    __weak IBOutlet UIButton *_interactButton;
    __weak IBOutlet UIButton *_logoutButton;
}

@property (nonatomic) ITMLoginViewType type;

- (IBAction)loginClicked:(id)sender;
- (IBAction)createClicked:(id)sender;
- (IBAction)unlockClicked:(id)sender;
- (IBAction)interactClicked:(id)sender;
- (IBAction)logoutButtonClicked:(id)sender;


@end
