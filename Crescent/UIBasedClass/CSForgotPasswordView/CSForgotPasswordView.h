//
//  BSForgotPasswordView.h
//  BridgestoneFootball
//
//  Created by Debaprasad Mondal on 25/11/14.
//  Copyright (c) 2014 Indusnet Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSForgotPasswordView : UIView
@property (weak, nonatomic) IBOutlet UIView *forgotPasswordBgView;
@property (weak, nonatomic) IBOutlet UIImageView *lblForgotPassword;
@property (weak, nonatomic) IBOutlet UITextField *emailTxtfld;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcForgotPasswordViewTopmargin;
- (IBAction)submitButtonClicked:(id)sender;
-(void)setForgotViewProperty;
@end
