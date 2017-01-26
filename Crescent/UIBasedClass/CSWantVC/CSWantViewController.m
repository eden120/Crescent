//
//  CSWantViewController.m
//  Crescent
//
//  Created by Debaprasad Mondal on 07/12/14.
//  Copyright (c) 2014 Debaprasad Mondal. All rights reserved.
//

#import "CSWantViewController.h"
#import "RangeSlider.h"
#import "CSUtils.h"
#import "CSFindingFriendsViewController.h"
#import "CSDiscoveryViewController.h"


@interface CSWantViewController ()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIView *ageSliderView;
@property (weak, nonatomic) IBOutlet UILabel *lblAgeRange;
@property (weak, nonatomic) IBOutlet UITextField *showTxtFld;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
- (IBAction)showButtonClicked:(id)sender;
- (IBAction)nextButtonClicked:(id)sender;

@end

@implementation CSWantViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    // Do any additional setup after loading the view.
    
    RangeSlider *mRangeSlider=[[RangeSlider alloc]initWithFrame:CGRectMake(21, 49, 280,30)];
    mRangeSlider.minimumValue=17;
    mRangeSlider.maximumValue=59;
    mRangeSlider.minimumRange = 1;
    //if (self.isUpdate) {
        NSString *agerange=[CSUserHelper sharedInstance].userDict[@"agerange"];
    if(agerange.length > 2){
        NSArray *agerangearr=[agerange componentsSeparatedByString:@"-"];
        if (agerangearr.count>1) {
            
            mRangeSlider.upperValue=[agerangearr [1]integerValue];
            mRangeSlider.lowerValue=[agerangearr[0] integerValue];
        }
    } else {
        mRangeSlider.upperValue=59;
        mRangeSlider.lowerValue=17;
    }
    
        
        if ([[CSUserHelper sharedInstance].userDict[@"show"] rangeOfString:@"Men"].location!=NSNotFound) {
            if ([[CSUserHelper sharedInstance].userDict[@"show"] rangeOfString:@"Women"].location!=NSNotFound) {
                self.showTxtFld.text=@"Men & Women";
            }
            else
                self.showTxtFld.text=@"Only Men";
        }
        else
            self.showTxtFld.text=@"Men & Women";
        
        
   // }
   // else
   // {
   //     mRangeSlider.upperValue=28;
   //     mRangeSlider.lowerValue=24;
   // }
    self.lblAgeRange.text = [NSString stringWithFormat:@"%d-%d",(int)mRangeSlider.lowerValue, (int)mRangeSlider.upperValue];
    
    [mRangeSlider addTarget:self action:@selector(clickOnslider:) forControlEvents:UIControlEventValueChanged];
    [self.ageSliderView addSubview:mRangeSlider];
    if (self.showTxtFld.text.length>0) {
        self.btnNext.enabled=YES;
    }
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"isLogin"] && !self.isFromSignUp && !self.isUpdate) {
        self.btnBack.hidden=YES;
        NSString *agerange=[CSUserHelper sharedInstance].userDict[@"agerange"];
        NSArray *agerangearr=[agerange componentsSeparatedByString:@"-"];
        if (agerangearr.count>1) {
            
            mRangeSlider.upperValue=[agerangearr [1]integerValue];
            mRangeSlider.lowerValue=[agerangearr[0] integerValue];
        } else {
            mRangeSlider.upperValue=59;
            mRangeSlider.lowerValue=17;
        }
        self.lblAgeRange.text = [NSString stringWithFormat:@"%d-%d",(int)mRangeSlider.lowerValue, (int)mRangeSlider.upperValue];
        
        if ([[CSUserHelper sharedInstance].userDict[@"show"] rangeOfString:@"Men"].location!=NSNotFound) {
            if ([[CSUserHelper sharedInstance].userDict[@"show"] rangeOfString:@"Women"].location!=NSNotFound) {
                self.showTxtFld.text=@"Men & Women";
            }
            else
                self.showTxtFld.text=@"Only Men";
        }
        else
            self.showTxtFld.text=@"Men & Women";
        
        if (self.showTxtFld.text.length>0) {
            self.btnNext.enabled=YES;
        }
       // CSFindingFriendsViewController *mFindFriendVc= [self.storyboard instantiateViewControllerWithIdentifier:@"CSFindingFriendsViewController"];
        //[self.navigationController pushViewController:mFindFriendVc animated:NO];
        
    }
    
    //Notification
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotificationReceived) name:@"pushNotification" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (delegate.showNotifications) {
        [self performSegueWithIdentifier:@"loadCSFindPeopleVC" sender:self];
    }
}

// Notification nevagation
-(void)pushNotificationReceived{
    
    
    //CSDiscoveryViewController *mWantVc= [self.storyboard instantiateViewControllerWithIdentifier:@"DVC"];
    //[self.navigationController pushViewController:mWantVc animated:YES];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark --------------- Button Action -----------------
-(IBAction)clickOnslider:(RangeSlider *)sender
{
    
    [self updateSliderLabels:sender];
}

- (void) updateSliderLabels:(RangeSlider*)slider
{
    // You get get the center point of the slider handles and use this to arrange other subviews
    
   // CGPoint lowerCenter;
   // lowerCenter.x = (slider.minThumb.center.x + slider.frame.origin.x);
  //  lowerCenter.y = (slider.minThumb.center.y - 30.0f);
    //self.lowerIndicator.center = lowerCenter;
   // self.lowerLabel.text = [NSString stringWithFormat:@"$%.f",slider.selectedMinimumValue];
    
   // CGPoint upperCenter;
  //  upperCenter.x = (slider.maxThumb.center.x + slider.frame.origin.x);
   // upperCenter.y = self.upperindicator.center.y;
   // self.upperindicator.center = upperCenter;
    self.lblAgeRange.text = [NSString stringWithFormat:@"%d-%d",(int)slider.lowerValue, (int)slider.upperValue];
}


- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showGederOptionView
{
    if ([[CSUtils sharedInstance]getSystemVersion]>=8.0) {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Show"
                                      message:nil
                                      preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* male = [UIAlertAction actionWithTitle:@"Only Men" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         self.showTxtFld.text=@"Only Men";
                                                             self.btnNext.enabled=YES;                                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                                         
                                                     }];
        UIAlertAction* female = [UIAlertAction actionWithTitle:@"Only Women" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           self.showTxtFld.text=@"Only Women";
                                                            self.btnNext.enabled=YES;
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                           
                                                       }];
        UIAlertAction* malefemale = [UIAlertAction actionWithTitle:@"Men & Women" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           self.showTxtFld.text=@"Men & Women";
                                                            self.btnNext.enabled=YES;
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                           
                                                       }];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
        
        [alert addAction:male];
        [alert addAction:female];
        [alert addAction:malefemale];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        UIActionSheet *actionsheet=[[UIActionSheet alloc] initWithTitle:@"Select your gender" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Only Men",@"Only Women",@"Men & Women", nil];
        actionsheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionsheet showInView:self.view];
    }
    
}
#pragma mark
#pragma mark Actionsheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if (buttonIndex==0) {
            self.showTxtFld.text=@"Only Men";
        }
        else if (buttonIndex==1) {
            self.showTxtFld.text=@"Only Women";
        }
        else
            self.showTxtFld.text=@"Men & Women";
     self.btnNext.enabled=YES; 
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)showButtonClicked:(id)sender {
    [self showGederOptionView];
}

- (IBAction)nextButtonClicked:(id)sender {
    if (self.showTxtFld.text.length>0 && self.lblAgeRange.text.length>0) {
        [self updateMyDiscover];
    }
    else
        [[CSUtils sharedInstance] showNormalAlert:@"Almost there, just complete everything"];
    
}

-(void)updateMyDiscover
{
    if([[AFNetworkReachabilityManager sharedManager] isReachable]) // checking network reachable
    {
        [[CSUtils sharedInstance]showLoadingMode];

        self.view.userInteractionEnabled=NO;
        [[CSRequestController sharedInstance]updateDiscoverWithUserId:[CSUserHelper sharedInstance].userDict[@"user_id"] Show:self.showTxtFld.text AgeRange:self.lblAgeRange.text success:^(NSDictionary *responsedict){
            [[CSUtils sharedInstance]hideLoadingMode];

            self.view.userInteractionEnabled=YES;
            if ([responsedict[@"response"]integerValue]==200) {
                [[CSUserHelper sharedInstance].userDict setObject:self.lblAgeRange.text forKey:@"agerange"];
                [[CSUserHelper sharedInstance].userDict setObject:self.showTxtFld.text forKey:@"show"];
                [[CSUtils sharedInstance]saveUserDetailsIntoPlistFile];
                if (self.isUpdate) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                    [self performSegueWithIdentifier:@"loadCSFindPeopleVC" sender:self];
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

@end
