//
//  CSSettingsViewController.m
//  Crescent
//
//  Created by Debaprasad Mondal on 19/12/14.
//  Copyright (c) 2014 Debaprasad Mondal. All rights reserved.
//

#import "CSSettingsViewController.h"
#import "CSUtils.h"
#import "CSPrivacyPolicyViewController.h"

#define LOGOUT_TAG 123
#define DELETEACCOUNT_TAG 1234

@interface CSSettingsViewController ()
{
    NSInteger isMatchesOn;
    NSInteger isMessage;
}
- (IBAction)backButtonClicked:(id)sender;
- (IBAction)doneButtonClicked:(id)sender;

@end

@implementation CSSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isMatchesOn=[[CSUserHelper sharedInstance].userDict[@"newmatchesnotifystatus"]integerValue];
    isMessage=[[CSUserHelper sharedInstance].userDict[@"messagesnotifystatus"]integerValue];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
    
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return 0;
    }
    else
        return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0||section==1) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    if (indexPath.section==0) {
        cell= [tableView dequeueReusableCellWithIdentifier:@"settingsFirstCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingsFirstCell"];
        }
        UILabel *lblTitle=(UILabel *)[cell.contentView viewWithTag:11];
        UISwitch *mswitch=(UISwitch *)[cell.contentView viewWithTag:22];
        switch (indexPath.row) {
            case 0:
                [lblTitle setText:@"NEW MATCHES"];
                if (isMatchesOn) {
                    [mswitch setOn:YES animated:NO];
                }
                else
                    [mswitch setOn:NO animated:NO];
                [mswitch addTarget:self action:@selector(matchesValueChanged:) forControlEvents:UIControlEventValueChanged];
                
                break;
            case 1:
                [lblTitle setText:@"MESSAGES"];
                if (isMessage) {
                    [mswitch setOn:YES animated:NO];
                }
                else
                    [mswitch setOn:NO animated:NO];
                [mswitch addTarget:self action:@selector(messagesValueChanged:) forControlEvents:UIControlEventValueChanged];
                break;
            default:
                break;

        }

        
    }
    else
    {
        cell= [tableView dequeueReusableCellWithIdentifier:@"settingsSecondCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingsSecondCell"];
        }
        
        
        UILabel *lblTitle=(UILabel *)[cell.contentView viewWithTag:11];
        [lblTitle setTextAlignment:NSTextAlignmentLeft];
        [lblTitle setTextColor:[UIColor blackColor]];
        cell.accessoryType=UITableViewCellAccessoryNone;
        switch (indexPath.section) {
            
            case 1:
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                
                switch (indexPath.row) {
                    case 0:
                        [lblTitle setText:@"PRIVACY POLICY"];
                        break;
                    case 1:
                        [lblTitle setText:@"TERMS OF SERVICE"];
                        break;
                }
                break;
            case 2:
                [lblTitle setTextAlignment:NSTextAlignmentCenter];

                [lblTitle setText:@"LOGOUT"];
                break;
            case 3:
                [lblTitle setTextAlignment:NSTextAlignmentCenter];
                [lblTitle setTextColor:[UIColor redColor]];
                [lblTitle setText:@"DELETE ACCOUNT"];
                break;
                
            default:
                break;
        }
        
    }
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    ;
                    break;
                case 1:
                    ;
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                {
                    CSPrivacyPolicyViewController *mPrivacy=[self.storyboard instantiateViewControllerWithIdentifier:@"CSPrivacyPolicyViewController"];
                    mPrivacy.isPrivacy=YES;
                    [self.navigationController pushViewController:mPrivacy animated:YES];
                }
                    break;
                case 1:
                {
                    CSPrivacyPolicyViewController *mPrivacy=[self.storyboard instantiateViewControllerWithIdentifier:@"CSPrivacyPolicyViewController"];
                    mPrivacy.isPrivacy=NO;
                    [self.navigationController pushViewController:mPrivacy animated:YES];

                }
                    break;
            }
            break;
        case 2:
            // Log out
        {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:ALERT_TITLE message:@"Would you like to logout now?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
            alert.tag=LOGOUT_TAG;
            [alert show];
        }
            break;
        case 3:
        {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:ALERT_TITLE message:@"Would you like to delete your account?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
            alert.tag=DELETEACCOUNT_TAG;
            [alert show];
        }
            break;
            
        default:
            break;
    }

}
#pragma mark Alert view Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==LOGOUT_TAG) {
        if (buttonIndex==0) {
            [self doLogOut];
        }
    }
    else if (alertView.tag==DELETEACCOUNT_TAG)
    {
        if (buttonIndex==0) {
            [self doDeleteAccount];
        }
    }
}
#pragma mark Log out API call
-(void)doLogOut
{
    if([[AFNetworkReachabilityManager sharedManager] isReachable]) // checking network reachable
    {
        [[CSUtils sharedInstance]showLoadingMode];

        //[SVProgressHUD showWithStatus:@"Signing out..."];
        self.view.userInteractionEnabled=NO;
        [[CSRequestController sharedInstance]logOutWithUserId:[CSUserHelper sharedInstance].userDict[@"user_id"]
                                                                 success:^(NSDictionary *responsedict){
                                                                     [[CSUtils sharedInstance]hideLoadingMode];

                                                                     self.view.userInteractionEnabled=YES;
                                                                     if ([responsedict[@"response"]integerValue]==200) {
                                                                         [CSUserHelper sharedInstance].userDict=nil;
                                                                         [self.navigationController popToRootViewControllerAnimated:YES];
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
             if (error.code==CSErrorCodeSessionExpired) {
                 [SVProgressHUD showErrorWithStatus:@"Connection timed out. Please try again!"];
             }
             else
             {
                 [SVProgressHUD showErrorWithStatus:@"Unknown error occured. Please try again!"];
                 
             }
             
         }];
    }
    else
    {
        [[CSUtils sharedInstance]showNormalAlert:@"Please check your network connection and try again!"];
    }
}

#pragma mark Log out API call
-(void)doDeleteAccount
{
    if([[AFNetworkReachabilityManager sharedManager] isReachable]) // checking network reachable
    {
        [[CSUtils sharedInstance]showLoadingMode];
       // [SVProgressHUD showWithStatus:@"Deleting.."];
        self.view.userInteractionEnabled=NO;
        [[CSRequestController sharedInstance]deleteAccountWithUserId:[CSUserHelper sharedInstance].userDict[@"user_id"]
                                                      success:^(NSDictionary *responsedict){
                                                          [[CSUtils sharedInstance]hideLoadingMode];
                                                         // [SVProgressHUD dismiss];
                                                          self.view.userInteractionEnabled=YES;
                                                          if ([responsedict[@"response"]integerValue]==200) {
                                                              [CSUserHelper sharedInstance].userDict=nil;
                                                              [self.navigationController popToRootViewControllerAnimated:YES];
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
             if (error.code==CSErrorCodeSessionExpired) {
                 [SVProgressHUD showErrorWithStatus:@"Connection timed out. Please try again!"];
             }
             else
             {
                 [SVProgressHUD showErrorWithStatus:@"Unknown error occured. Please try again!"];
                 
             }
             
         }];
    }
    else
    {
        [[CSUtils sharedInstance]showNormalAlert:@"Please check your network connection and try again!"];
    }
}
#pragma mark Log out API call
-(void)updateNotificationSettings:(NSString *)matches Message:(NSString *)message
{
    if([[AFNetworkReachabilityManager sharedManager] isReachable]) // checking network reachable
    {
        [[CSUtils sharedInstance]showLoadingMode];
        //[SVProgressHUD showWithStatus:@"Updating.."];
        self.view.userInteractionEnabled=NO;
        [[CSRequestController sharedInstance]updateNotiFicationSettingsWithUserId:[CSUserHelper sharedInstance].userDict[@"user_id"] newMatches:matches Messages:message
                                                                          success:^(NSDictionary *responsedict){
                                                                              [[CSUtils sharedInstance]hideLoadingMode];
                                                                              self.view.userInteractionEnabled=YES;
                                                                              if ([responsedict[@"response"]integerValue]==200) {
                                                                                  [[CSUserHelper sharedInstance].userDict setObject:[NSString stringWithFormat:@"%ld",(long)isMatchesOn] forKey:@"newmatchesnotifystatus"];
                                                                                  
                                                                                  [[CSUserHelper sharedInstance].userDict setObject:[NSString stringWithFormat:@"%ld",(long)isMessage] forKey:@"messagesnotifystatus"];
                                                                                  
                                                                                  [self.navigationController popViewControllerAnimated:YES];
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
             if (error.code==CSErrorCodeSessionExpired) {
                 [SVProgressHUD showErrorWithStatus:@"Connection timed out. Please try again!"];
             }
             else
             {
                 [SVProgressHUD showErrorWithStatus:@"Unknown error occured. Please try again!"];
                 
             }
             
         }];
    }
    else
    {
        [[CSUtils sharedInstance]showNormalAlert:@"Please check your network connection and try again!"];
    }
}


#pragma mark -
#pragma mark - Button Action -
- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneButtonClicked:(id)sender {
    [self updateNotificationSettings:[NSString stringWithFormat:@"%ld",(long)isMatchesOn] Message:[NSString stringWithFormat:@"%ld",(long)isMessage]];
}

-(void)matchesValueChanged:(id)sender
{
    UISwitch *tempSwitch=(UISwitch *)sender;
    if (tempSwitch.on) {
        isMatchesOn=YES;
    }
    else
        isMatchesOn=NO;
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

-(void)messagesValueChanged:(id)sender
{
    UISwitch *tempSwitch=(UISwitch *)sender;
    if (tempSwitch.on) {
        isMessage=YES;
    }
    else
        isMessage=NO;
    NSLog(@"%s",__PRETTY_FUNCTION__);
}
@end
