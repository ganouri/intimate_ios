//
//  ITMLoginViewController.h
//  IntiMate
//
//  Created by Konstantin Kim on 22/07/13.
//  Copyright (c) 2013 IntiMate. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ITMLoginViewController : UIViewController {
    
    __weak IBOutlet UITextField *_emailTextField;
    __weak IBOutlet UITextField *_passwordTextField;
    __weak IBOutlet UIButton *_loginButton;
    
    __weak IBOutlet UIButton *_createAccountButton;
    __weak IBOutlet UIButton *_unlockButton;
    __weak IBOutlet UILabel *_termsLabel;
    __weak IBOutlet UIButton *_termsButton;
}

@property (nonatomic) BOOL isPasswordOnly;

- (IBAction)loginClicked:(id)sender;
- (IBAction)createClicked:(id)sender;
- (IBAction)unlockClicked:(id)sender;


@end
