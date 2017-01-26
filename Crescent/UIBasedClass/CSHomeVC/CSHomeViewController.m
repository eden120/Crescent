//
//  CSHomeViewController.m
//  Crescent
//
//  Created by Debaprasad Mondal on 27/12/14.
//  Copyright (c) 2014 Debaprasad Mondal. All rights reserved.
//

#import "CSHomeViewController.h"
#import "CSSignUpSecondViewController.h"
#import "CSSignUpFirstViewController.h"
#import "CSLogInViewController.h"
#import "CSFacebookHelper.h"
#import "CSUtils.h"
#import "CSWantViewController.h"
#import "CSFindingFriendsViewController.h"
#import "SideMenuViewController.h"
#import <Quickblox/Quickblox.h>

#import "SSUUserCache.h"
#import "SSULoginState.h"
#import "AppDelegate.h"

@interface CSHomeViewController ()<FacebookInteractionDelegate>
{
    
}

@end

@implementation CSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if(![CSUtils sharedInstance].QBSessionCreated){
            [self createQBSesstion];
        };
    });
        
    [CSFacebookHelper sharedFacebook].fbDelegate = self;
 
    [self.view layoutIfNeeded];
    [self setOnBoardView];
}

-(void)createQBSesstion{
    if([[AFNetworkReachabilityManager sharedManager] isReachable]) // checking network reachable
    {
        [[CSUtils sharedInstance] showLoadingMode];
        [QBRequest createSessionWithSuccessBlock:^(QBResponse *response, QBASession *session) {
            [CSUtils sharedInstance].QBSessionCreated = YES;
            [[CSUtils sharedInstance]hideLoadingMode];
            if ( [[CSUtils sharedInstance] hasValidUser]) {
                if ([[CSUtils sharedInstance] hasQBId]){
                    
                    CSWantViewController *mWantVc= [self.storyboard instantiateViewControllerWithIdentifier:@"CSWantViewController"];
                    [self.navigationController pushViewController:mWantVc animated:NO];
                    
                } else {
                    //QB User registration time
                    [self QBRegistration];
                }
            }
            
        } errorBlock:^(QBResponse *response) {
            [[CSUtils sharedInstance]hideLoadingMode];
            self.view.userInteractionEnabled = NO;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", "")
                                                            message:[response.error description]
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", "")
                                                  otherButtonTitles:nil];
            [alert show];
            
        }];
    }else
    {
        [[CSUtils sharedInstance] showNormalAlert:@"Please check your network connection and try again!"];
    }
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
                                                                      id userDic = responsedict[@"user"];
                                                                      if(userDic || userDic != [NSNull null]){
                                                                          [CSUserHelper sharedInstance].userDict = [userDic mutableCopy];
                                                                      } else {
                                                                          [SVProgressHUD showErrorWithStatus:@"Internal error"];
                                                                          return;
                                                                      }
                                                                     // [CSUserHelper sharedInstance].userDict = [responsedict[@"user"] mutableCopy];

                                                                          [[CSUtils sharedInstance]saveUserDetailsIntoPlistFile];
                                                                      //GETBOOl_DEFAUL_VALUE(@"isRegister");
                                                                      if ([[CSUserHelper sharedInstance].userDict[@"isnewuser"] isEqualToString:@"1"]) {
                                                                          isCoachShow=@"SHOW";
                                                                      }
                                                                      else
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


-(void)setOnBoardView
{
    float X_Origin=0.0;
    for (int i=1; i<=3; i++) {
        UIView *onBoardView=[[UIView alloc]initWithFrame:CGRectMake(X_Origin, 0, self.homeScrView.frame.size.width, self.homeScrView.frame.size.height-20)];
        UIImageView *pimage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, onBoardView.frame.size.width, onBoardView.frame.size.height)];
        pimage.tag=1111;
        pimage.backgroundColor=[UIColor grayColor];
        [pimage setContentMode:UIViewContentModeScaleAspectFill];
        pimage.clipsToBounds = YES;
        [pimage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Onboarding_bg%d",i ]]];
        [onBoardView addSubview:pimage];
        UILabel *lblHint;
        if (i<=1) {
           lblHint =[[UILabel alloc] initWithFrame:CGRectMake(self.homeScrView.frame.size.width/2-110, 40, 220, 60)];
            if (i==1) {
                [lblHint setText:@"Check out interesting Muslims"];
            }
//          else
//                [lblHint setText:@"Swipe right to anonymously show interest"];
        }
        else
        {
            lblHint=[[UILabel alloc] initWithFrame:CGRectMake(self.homeScrView.frame.size.width/2-124, 40, 248, 60)];
            if (i==2) {
                [lblHint setText:@"Swipe right to anonymously show interest"];
            }
            else
                [lblHint setText:@"If you both like each other, we'll connect you"];
        }
        
        [lblHint setFont:[UIFont fontWithName:FONT_SEMIBOLD size:20]];
        lblHint.numberOfLines=0;
        lblHint.lineBreakMode=NSLineBreakByWordWrapping;
        lblHint.textColor=[UIColor whiteColor];
        
        lblHint.textAlignment=NSTextAlignmentCenter;
        [onBoardView addSubview:lblHint];
        
        [self.homeScrView addSubview:onBoardView];
        X_Origin=X_Origin+self.homeScrView.frame.size.width;
        onBoardView=nil;
    }
    [self.homeScrView setContentOffset:CGPointMake(0, 0)];
    [self.homeScrView setContentSize:CGSizeMake(self.homeScrView.frame.size.width*3, self.homeScrView.frame.size.height-20)];
    //self.pageController.numberOfPages=imageArr.count;
    self.pageController.currentPage=0;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int indexOfPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageController.currentPage=indexOfPage;
    //your stuff with index
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)signupWithFacebookButtonClicked:(id)sender {
    if(![CSUtils sharedInstance].QBSessionCreated){
        [self createQBSesstion];
        return;
    }
    [[CSFacebookHelper sharedFacebook] loginThroughFacebookAllowLoginUI:YES];
}

#pragma mark- Facebook Interaction Delegates

-(void)successfulLogin:(id)dict
{
    NSLog(@"User Info %@",dict);
    NSString *email=@"";
    NSString *name=@"";
    NSString *birthday=@"";
    NSString *gender=@"";
    NSString *location=@"";
    
    if (dict[@"email"]) {
        email=dict[@"email"];
    }
    if (dict[@"first_name"]) {
        name=dict[@"first_name"];
    }
    if (dict[@"birthday"]) {
        birthday=dict[@"birthday"];
    }
    if (dict[@"gender"]) {
        gender=dict[@"gender"];
        if ([gender isEqualToString:@"male"]) {
            gender=@"Male";
        }
        else
            gender=@"Female";

    }
    if (dict[@"location"]) {
        NSDictionary *tempdict=dict[@"location"];
        if (tempdict[@"name"])
            location=tempdict[@"name"];
    }
    
    NSMutableDictionary *userdict=[NSMutableDictionary dictionary];
   
    [userdict setObject:dict[@"id"] forKey:@"id"];
    [userdict setObject:email forKey:@"email"];
    [userdict setObject:name forKey:@"name"];
    [userdict setObject:birthday forKey:@"birthday"];
    [userdict setObject:gender forKey:@"gender"];
    [userdict setObject:location forKey:@"location"];
    //  [self postLoginWithFacebookWithEmail:email Password:@"" Username:dict[@"name"] FBID:dict[@"id"] UserImage:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",dict[@"id"]]];
    //[self dofetchUserByFBid:userdict];
    [self loginByFBid:userdict];
}

-(void)requestLoadError
{
    NSLog(@"Error Loggin in");
}



- (IBAction)signUpButtonClicked:(id)sender {
    if(![CSUtils sharedInstance].QBSessionCreated){
        [self createQBSesstion];
        return;
    }
    CSSignUpSecondViewController *msignup = [self.storyboard instantiateViewControllerWithIdentifier:@"CSSignUpSecondViewController"];
    msignup.currentlatitude=[CSUtils sharedInstance].appDelegate.latitude;
    msignup.currentlongitude=[CSUtils sharedInstance].appDelegate.longitude;
    [self.navigationController pushViewController:msignup animated:NO];
    [UIView transitionWithView:self.navigationController.view duration:1 options:UIViewAnimationOptionTransitionFlipFromRight animations:nil completion:nil];
}

- (IBAction)signInButtonClicked:(id)sender {
    if(![CSUtils sharedInstance].QBSessionCreated){
        [self createQBSesstion];
        return;
    }
    CSLogInViewController *mLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"CSLogInViewController"];
    [self.navigationController pushViewController:mLogin animated:NO];
    [UIView transitionWithView:self.navigationController.view duration:1 options:UIViewAnimationOptionTransitionFlipFromRight animations:nil completion:nil];
}


-(void)loginByFBid:(NSMutableDictionary *)userdict
{
    AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    if([[AFNetworkReachabilityManager sharedManager] isReachable]) // checking network reachable
    {
        [[CSUtils sharedInstance] showLoadingMode];
        [[CSRequestController sharedInstance] doSignUpWithEmailId:userdict[@"email"] Password:@"" Name:userdict[@"name"] UserImage:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&width=1200", userdict[@"id"]] PhNo:@"" About:@"" Birthday:userdict[@"birthday"] Gender:userdict[@"gender"]  Location:userdict[@"location"]LoginType:@"F" Latitude:app.latitude Longitude:app.longitude FBID:userdict[@"id"]
                                                          success:^(NSDictionary *responsedict){
                                                           [[CSUtils sharedInstance]hideLoadingMode];
                                                           
                                                           self.view.userInteractionEnabled=YES;
                                                           if ([responsedict[@"response"]integerValue]==200) {
                                                               id userDic = responsedict[@"user"];
                                                               if(userDic || userDic != [NSNull null]){
                                                                   [CSUserHelper sharedInstance].userDict = [userDic mutableCopy];
                                                               } else {
                                                                   [SVProgressHUD showErrorWithStatus:@"Internal error"];
                                                                   return;
                                                               }
                                                               //[CSUserHelper sharedInstance].userDict=[responsedict[@"user"] mutableCopy];
                                                               [[CSUtils sharedInstance]saveUserDetailsIntoPlistFile];
                                                               
                                                               if ([[CSUserHelper sharedInstance].userDict[@"isnewuser"] isEqualToString:@"1"]) {
                                                                   isCoachShow=@"SHOW";
                                                                   
                                                                   CSSignUpFirstViewController *msignup = [self.storyboard instantiateViewControllerWithIdentifier:@"CSSignUpFirstViewController"];
                                                                   msignup.currentlatitude=[CSUtils sharedInstance].appDelegate.latitude;
                                                                   msignup.currentlongitude=[CSUtils sharedInstance].appDelegate.longitude;
                                                                   msignup.isSignUpFromFacebook=YES;
                                                                   msignup.userDict=userdict;
                                                                   [self.navigationController pushViewController:msignup animated:NO];
                                                                   [UIView transitionWithView:self.navigationController.view duration:1 options:UIViewAnimationOptionTransitionFlipFromRight animations:nil completion:nil];
                                                               }
                                                               else {
                                                                   isCoachShow=@"HIDDEN";
                                                                   if ( [[CSUtils sharedInstance] hasValidUser]) {
                                                                       if ([[CSUtils sharedInstance] hasQBId]){
                                                                           
                                                                           CSWantViewController *mWantVc= [self.storyboard instantiateViewControllerWithIdentifier:@"CSWantViewController"];
                                                                           [self.navigationController pushViewController:mWantVc animated:NO];
                                                                       } else {
                                                                           //QB User registration time
                                                                           [self QBRegistration];
                                                                       }
                                                                   }
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
}

/*
-(void)dofetchUserByFBid:(NSMutableDictionary *)userdict
{
    if([[AFNetworkReachabilityManager sharedManager] isReachable]) // checking network reachable
    {
        
        
        [[CSUtils sharedInstance]showLoadingMode];

       // [SVProgressHUD showWithStatus:@"Loading"];
        self.view.userInteractionEnabled=NO;
        
        [[CSRequestController sharedInstance]dofetchUserByFBId:userdict[@"id"]
                                                       success:^(NSDictionary *responsedict){
                                                           [[CSUtils sharedInstance]hideLoadingMode];

                                                              self.view.userInteractionEnabled=YES;
                                                           if ([responsedict[@"response"]integerValue]==200) {
                                                               if ([responsedict[@"isexists"]integerValue]==1) {
                                                                   
                                                                   SAVEBOOL_AS_DEFAULT(@"isLogin", YES);
                                                                   [CSUserHelper sharedInstance].userDict=[responsedict[@"user"] mutableCopy];
                                                                   
                                                                   
                                                                   
                                                                   QBUUser *user = [QBUUser user];
                                                                   user.password = kQuickBloxPwd;
                                                                   user.email = [CSUserHelper sharedInstance].userDict[@"email"];
                                                                   
                                                            
                                                                    NSString *login = [[[CSUserHelper sharedInstance].userDict[@"email"] stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
                                                                   if(!login || [@"" isEqualToString:login]){
                                                                       if([[CSUserHelper sharedInstance].userDict[@"name"] containsString:@" "]){
                                                                           login = [[[CSUserHelper sharedInstance].userDict[@"name"] componentsSeparatedByString:@" "] firstObject];
                                                                       } else {
                                                                           login = [CSUserHelper sharedInstance].userDict[@"name"];
                                                                       }
                                                                   }
                                                                  
                                                                   user.login = login;
                                                                   // create User
                                                                   [QBRequest signUp:user successBlock:^(QBResponse *response, QBUUser *user) {
                                                                       NSLog(@"SuccessFull Register qB");
                                                                       
                                                                       [QBRequest logInWithUserLogin:login password:kQuickBloxPwd
                                                                                        successBlock:[self successBlock] errorBlock:[self errorBlock]];
                                                                       
                                                                   } errorBlock:^(QBResponse *response) {
                                                                       NSLog(@"QBErr==%@",[response.error description]);
                                                                       [QBRequest logInWithUserLogin:login password:kQuickBloxPwd
                                                                                        successBlock:[self successBlock] errorBlock:[self errorBlock]];
                                                                       
                                                                   }];
                                                                   
                                                                   
                                                                   
                                                                   //GETBOOl_DEFAUL_VALUE(@"isRegister");
                                                                   if ([[CSUserHelper sharedInstance].userDict[@"isnewuser"] isEqualToString:@"1"]) {
                                                                       isCoachShow=@"SHOW";
                                                                   }
                                                                   else
                                                                       isCoachShow=@"HIDDEN";
                                                                   
                                                                   
                                                                   SideMenuViewController *mSideMenu= (SideMenuViewController *)[[[CSUtils sharedInstance]appDelegate]leftSideMenuViewController];
                                                                   [mSideMenu.menuTable reloadData];
                                                                   [[CSUtils sharedInstance]saveUserDetailsIntoPlistFile];
                                                                   
                                                                   CSWantViewController *mNotificationController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSWantViewController"];
                                                                   [self.navigationController pushViewController:mNotificationController animated:YES];
                                                                   
                                                               }
                                                               else
                                                               {
                                                                   CSSignUpFirstViewController *msignup = [self.storyboard instantiateViewControllerWithIdentifier:@"CSSignUpFirstViewController"];
                                                                   msignup.currentlatitude=[CSUtils sharedInstance].appDelegate.latitude;
                                                                   msignup.currentlongitude=[CSUtils sharedInstance].appDelegate.longitude;
                                                                   msignup.isSignUpFromFacebook=YES;
                                                                   msignup.userDict=userdict;
                                                                   [self.navigationController pushViewController:msignup animated:NO];
                                                                   [UIView transitionWithView:self.navigationController.view duration:1 options:UIViewAnimationOptionTransitionFlipFromRight animations:nil completion:nil];
                                                               }
                                                           }
                                                               else if ([responsedict[@"response"]integerValue] ==201)
                                                               {
                                                                   [[CSUtils sharedInstance] showNormalAlert:responsedict[@"message"]];
                                                               }
                                                               
                                                               
                                                       }
                                                          failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             self.view.userInteractionEnabled=YES;
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
*/
 

@end
