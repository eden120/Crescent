//
//  CSLogInViewController.h
//  Crescent
//
//  Created by Debaprasad Mondal on 27/12/14.
//  Copyright (c) 2014 Debaprasad Mondal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSULoginState.h"
#import "SSUChangesLoginState.h"

@class SSULoginState;
@interface CSLogInViewController : UIViewController<SSUChangesLoginState>
@property (weak, nonatomic) IBOutlet UITextField *emailTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *pswdTxtFld;
@property (nonatomic, weak) SSULoginState* loginState;
- (IBAction)backButtonClicked:(id)sender;
- (IBAction)nextButtonClicked:(id)sender;

@end
