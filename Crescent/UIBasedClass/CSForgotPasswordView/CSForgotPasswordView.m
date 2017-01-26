//
//  BSForgotPasswordView.m
//  BridgestoneFootball
//
//  Created by Debaprasad Mondal on 25/11/14.
//  Copyright (c) 2014 Indusnet Technologies Pvt Ltd. All rights reserved.
//

#import "CSForgotPasswordView.h"
#import "CSUtils.h"

@implementation CSForgotPasswordView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setForgotViewProperty
{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    self.bgImageView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.6];
    self.forgotPasswordBgView.layer.cornerRadius=5.0;
    
    self.lcForgotPasswordViewTopmargin.constant=(SCREENHEIGHT-64)/2-self.forgotPasswordBgView.frame.size.height/2;
  
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [self removeFromSuperview];
}

#pragma mark -
#pragma mark - Text filed delegate -

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



#pragma mark - Keyboard events

//Handling the keyboard appear and disappering events

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    __weak typeof(self) weakSelf = self;
   // NSDictionary* info = [aNotification userInfo];
   // CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         if (IS_IPHONE_4) {
                             weakSelf.lcForgotPasswordViewTopmargin.constant=60;
                         }
                         else
                             weakSelf.lcForgotPasswordViewTopmargin.constant=110;
                        
                         [weakSelf layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         [weakSelf layoutIfNeeded];
                     }];
    
    
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    __weak typeof(self) weakSelf = self;
    //NSDictionary* info = [aNotification userInfo];
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                       self.lcForgotPasswordViewTopmargin.constant=(SCREENHEIGHT-64)/2-self.forgotPasswordBgView.frame.size.height/2;
                         [weakSelf layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         [weakSelf layoutIfNeeded];
                     }];}

- (IBAction)submitButtonClicked:(id)sender {
    if(self.emailTxtfld.text.length>0)
    {
        [self doForgotPassword];
    }
    else
        [[CSUtils sharedInstance]showNormalAlert:@"Please enter your email id."];
}

-(void)doForgotPassword
{
    if([[AFNetworkReachabilityManager sharedManager] isReachable]) // checking network reachable
    {
        [[CSUtils sharedInstance]showLoadingMode];

        self.userInteractionEnabled=NO;
        [[CSRequestController sharedInstance] doForgotPasswordWithEmailId:self.emailTxtfld.text
                                                                  success:^(NSDictionary *responsedict){
                                                                      [[CSUtils sharedInstance]hideLoadingMode];

                                                                      self.userInteractionEnabled=YES;
                                                                      if ([responsedict[@"response"]integerValue]==200) {
                                                                          [[CSUtils sharedInstance] showNormalAlert:responsedict[@"message"]];
                                                                          [self removeFromSuperview];
                                                                      }
                                                                      else if ([responsedict[@"response"]integerValue] ==201)
                                                                      {
                                                                          [[CSUtils sharedInstance] showNormalAlert:responsedict[@"message"]];
                                                                      }
                                                                      
                                                                      
                                                                  }
                                                                  failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             self.userInteractionEnabled=YES;
             [[CSUtils sharedInstance]hideLoadingMode];

             if (error.code==CSErrorCodeSessionExpired) {
                 [SVProgressHUD showErrorWithStatus:@"Connection timed out. Please try again!"];
             }
             else
             {
                 [SVProgressHUD showErrorWithStatus:@"Connection timed out. Please try again!"];
                 
             }
         }];
    }
    else
    {
        [[CSUtils sharedInstance]showNormalAlert:@"Please check your network connection and try again!"];
    }
}

@end
