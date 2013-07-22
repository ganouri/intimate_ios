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
    
}

- (IBAction)loginClicked:(id)sender;
- (IBAction)createClicked:(id)sender;


@end
