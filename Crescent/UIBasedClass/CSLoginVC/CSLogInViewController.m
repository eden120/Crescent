//
//  CSLogInViewController.m
//  Crescent
//
//  Created by Debaprasad Mondal on 27/12/14.
//  Copyright (c) 2014 Debaprasad Mondal. All rights reserved.
//

#import "CSLogInViewController.h"
#import <SVProgressHUD.h>
#import "CSRequestController.h"
#import "CSUserHelper.h"
#import "CSUtils.h"
#import "CSForgotPasswordView.h"
#import "SideMenuViewController.h"
#import "CSWantViewController.h"
#import <Quickblox/Quickblox.h>
#import "SSUUserCache.h"
#import "SSULoginState.h"

@interface CSLogInViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@end

@implementation CSLogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)QBRegistration{
    QBUUser *user = [QBUUser user];
    user.password = kQuickBloxPwd;
    user.login = [[CSUtils sharedInstance] getQBLogin];
    user.email = [CSUserHelper sharedInstance].userDict[@"email"];
    
    [QBRequest logInWithUserLogin:[[CSUtils sharedInstance] getQBLogin] password:kQuickBloxPwd successBlock:[self successBlock] errorBlock:^(QBResponse *response) {
        //User doesn't exist, try to signup
        // Registration/sign up of User
        [QBRequest signUp:user successBlock:[self successBlock] errorBlock:^(QBResponse *response) {
            // Oops, something goes wrong
            [SVProgressHUD showErrorWithStatus:@"QuickBlox SignUp Error"];
        }];
    }];
}

- (void (^)(QBResponse *response, QBUUser *user))successBlock
{
    return ^(QBResponse *response, QBUUser *user) {
        if([[AFNetworkReachabilityManager sharedManager] isReachable]) // checking network reachable
        {
            [[CSUtils sharedInstance] showLoadingMode];
            [[CSRequestController sharedInstance] updateQBIdWith:[CSUserHelper sharedInstance].userDict[@"user_id"] BQId:[NSString stringWithFormat:@"%lu", (unsigned long)user.ID] success:^(NSDictionary *responsedict){
                [[CSUtils sharedInstance]hideLoadingMode];
                
                self.view.userInteractionEnabled=YES;
                if ([responsedict[@"response"]integerValue]==200) {
                    
                    [CSUserHelper sharedInstance].userDict=[responsedict[@"user"] mutableCopy];
                    [[CSUtils sharedInstance]saveUserDetailsIntoPlistFile];
                    isCoachShow=@"HIDDEN";
                    
                    CSWantViewController *mWantVc= [self.storyboard instantiateViewControllerWithIdentifier:@"CSWantViewController"];
                    [self.navigationController pushViewController:mWantVc animated:NO];
                    
                    
                }
                else if ([responsedict[@"response"]integerValue] ==201)
                {
                    [[CSUtils sharedInstance] showNormalAlert:responsedict[@"message"]];
                }
                
                
            }
                                                         failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
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
            [[CSUtils sharedInstance] showNormalAlert:@"Please check your network connection and try again!"];
        }
        
        
        
    };
}
-(void)checkAndSetNextButtonEnable
{
    if([self.emailTxtFld.text length]>0 && [self.pswdTxtFld.text length]>0)
        self.btnNext.enabled=YES;
    else
        _btnNext.enabled=NO;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
        [self nextButtonClicked:self.btnNext];
        
    }
    return NO;
    //return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.003 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self checkAndSetNextButtonEnable];
    });
    return YES;
}
- (IBAction)forgotPasswordButtonClicked:(id)sender {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"CSForgotPasswordView"
                                                         owner:self
                                                       options:nil];
    //I'm assuming here that your nib's top level contains only the view
    //you want, so it's the only item in the array.
    CSForgotPasswordView* mForgotPasswordView= [nibContents objectAtIndex:0];
    mForgotPasswordView.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height); //or whatever coordinates you need
    [mForgotPasswordView setForgotViewProperty];
    [self.view addSubview:mForgotPasswordView];
}

-(void)doLogin
{
    
    if([[AFNetworkReachabilityManager sharedManager] isReachable]) // checking network reachable
    {
        [[CSUtils sharedInstance]showLoadingMode];
       // [SVProgressHUD showWithStatus:@"Signing in..."];
        
     
        
        self.view.userInteractionEnabled=NO;
        [[CSRequestController sharedInstance] doLoginWithEmailId:self.emailTxtFld.text Password:self.pswdTxtFld.text
                                                         success:^(NSDictionary *responsedict){
                                                             [[CSUtils sharedInstance]hideLoadingMode];
                                                             //[SVProgressHUD dismiss];
                                                             self.view.userInteractionEnabled=YES;
                                                             if ([responsedict[@"response"]integerValue] ==200) {
                                                                 isCoachShow=@"HIDDEN";
                                                                 [CSUserHelper sharedInstance].userDict=[responsedict[@"user"] mutableCopy];
                                                                 [[CSUtils sharedInstance]saveUserDetailsIntoPlistFile];
                                                                 if ([[CSUtils sharedInstance] hasQBId]){
                                                                     CSWantViewController *mWantVc= [self.storyboard instantiateViewControllerWithIdentifier:@"CSWantViewController"];
                                                                     [self.navigationController pushViewController:mWantVc animated:NO];
                                                                 } else {
                                                                     //QB User registration time
                                                                     [self QBRegistration];
                                                                 }
                                                             }
                                                             else if ([responsedict[@"response"]integerValue] ==201)
                                                             {
                                                                 [[CSUtils sharedInstance] showNormalAlert:responsedict[@"message"]];
                                                             }
                                                             
                                                             
                                                         }
                                                         failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
              [[CSUtils sharedInstance]hideLoadingMode];
             self.view.userInteractionEnabled=YES;
            // [SVProgressHUD dismiss];
             if (error.code==CSErrorCodeSessionExpired) {
                 [SVProgressHUD showErrorWithStatus:@"Connection timed out. Please try again!" maskType:SVProgressHUDMaskTypeBlack];
             }
             else
             {
                 [SVProgressHUD showErrorWithStatus:@"Connection timed out. Please try again!" maskType:SVProgressHUDMaskTypeBlack];
                 
             }
         }];
    }
    else
    {
        [[CSUtils sharedInstance]showNormalAlert:@"Please check your network connection and try again!"];
    }
}
//register the device with parse

-(void)registerUserForPushNotification
{
   // AppDelegate *app=(AppDelegate*) [UIApplication sharedApplication].delegate;
    /*
    PFUser *user = [PFUser currentUser];
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setObject:user forKey:@"Owner"];
    [[PFUser currentUser] setObject:[CSUserHelper sharedInstance].userDict[@"user_id"] forKey:@"UniId"];
    [currentInstallation saveInBackground];
    */
    NSString *channelNew=[NSString stringWithFormat:@"crescent_%@",[CSUserHelper sharedInstance].userDict[@"user_id"]];
    
    NSLog(@"DeviceToken=%@",gDeviceToken);
    
    /*
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:gDeviceToken];
    [currentInstallation addUniqueObject:[NSString stringWithFormat:@"crescent_%@",[CSUserHelper sharedInstance].userDict[@"user_id"]] forKey:@"channels"];
    //currentInstallation.channels =@[ channelNew ];
    [currentInstallation saveInBackground];
    
    */
    
}



- (IBAction)backButtonClicked:(id)sender {
    [UIView animateWithDuration:1.0
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
                     }];
    [self.navigationController popViewControllerAnimated:NO];
    //[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextButtonClicked:(id)sender {
    [self.emailTxtFld resignFirstResponder];
    [self.pswdTxtFld resignFirstResponder];
    if (self.emailTxtFld.text.length>0 && self.pswdTxtFld.text.length>0) {
        [self doLogin];
    }
    else
    {
        if (self.emailTxtFld.text.length==0 && self.pswdTxtFld.text.length==0)
            [[CSUtils sharedInstance]showNormalAlert:@"Please enter your email id and password."];
        else if (self.emailTxtFld.text.length==0) {
            [[CSUtils sharedInstance]showNormalAlert:@"Please enter your email id"];
        }
        else if (self.pswdTxtFld.text.length==0)
            [[CSUtils sharedInstance]showNormalAlert:@"Please enter your password"];
        
    }
}


@end
