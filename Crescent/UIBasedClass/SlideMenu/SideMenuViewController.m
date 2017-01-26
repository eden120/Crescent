//
//  SideMenuViewController.m
//  MFSideMenuDemo
//
//  Created by Michael Frederick on 3/19/12.

#import "SideMenuViewController.h"
#import "MFSideMenu.h"
#import "CSNotificationViewController.h"
#import "CSWantViewController.h"
#import "CSSettingsViewController.h"
#import "AppDelegate.h"
#import "CSMyProfileViewController.h"
#import "CSUtils.h"
#import <UIImageView+AFNetworking.h>


#define NO_OF_ROWS_IN_SETTINGS 6

#define CELL_PROFILE_LBL_TAG     3001
#define CELL_PROFILE_IMG_TAG     3002
#define CELL_SWITCH     4002
#define CELL_NOTIFICATION_SWITCH     4003
#define LOGOUT_TAG 123

@implementation SideMenuViewController 

#pragma mark -
#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    }


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.menuTable reloadData];
}

#pragma mark -
#pragma mark - UITableViewDataSource

/*
 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
 return [NSString stringWithFormat:@"Section %d", section];
 }
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        return 100;
    }
    else
    {
        return 60;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell;
    if (indexPath.row==0) {
        cell= [tableView dequeueReusableCellWithIdentifier:@"menuFirstCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menuFirstCell"];
        }
        UILabel *lblTitle=(UILabel *)[cell.contentView viewWithTag:11];
        UIImageView *pimage=(UIImageView*)[cell.contentView viewWithTag:1];
        [lblTitle setText:[CSUserHelper sharedInstance].userDict[@"name"]];
        __weak NSArray *imageArr=[CSUserHelper sharedInstance].userDict[@"userimage"];
        if(imageArr.count>0)
            [pimage setImageWithURL:[NSURL URLWithString:imageArr[0][@"image"]] placeholderImage:nil];
        pimage.backgroundColor=[UIColor grayColor];
        pimage.layer.cornerRadius=pimage.frame.size.width/2;
        pimage.layer.masksToBounds=YES;
        pimage.layer.borderColor=[UIColor whiteColor].CGColor;
        pimage.layer.borderWidth=2.0;
    }
        else
        {
                cell= [tableView dequeueReusableCellWithIdentifier:@"menuSecondCell"];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menuSecondCell"];
                }
            UILabel *lblTitle=(UILabel *)[cell.contentView viewWithTag:11];
            switch (indexPath.row-1) {
                case 0:
                    [lblTitle setText:@"NOTIFICATIONS"];
                    break;
                case 1:
                    [lblTitle setText:@"WHO I WANT"];
                    break;
                case 2:
                    [lblTitle setText:@"SETTINGS"];
                    break;
                case 3:
                    [lblTitle setText:@"CONTACT CRESCENT"];
                    break;
                case 4:
                    [lblTitle setText:@"SHARE CRESCENT"];
                    break;
                case 5:
                    [lblTitle setText:@"LOGOUT"];
                    break;
                    
                default:
                    break;
            }
            
        }
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    return cell;
}

#pragma mark -
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
        switch(indexPath.row)
        {
            case 0:
            {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                CSMyProfileViewController *mNotificationController = [storyboard instantiateViewControllerWithIdentifier:@"CSMyProfileViewController"];
                [app.navigationController pushViewController:mNotificationController animated:NO];
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            }
                break;
            case 1:
            {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                CSNotificationViewController *mNotificationController = [storyboard instantiateViewControllerWithIdentifier:@"CSNotificationViewController"];
                [app.navigationController pushViewController:mNotificationController animated:NO];
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            }
                    break;
            case 2:
            {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                CSWantViewController *mNotificationController = [storyboard instantiateViewControllerWithIdentifier:@"CSWantViewController"];
                mNotificationController.isUpdate=YES;
                [app.navigationController pushViewController:mNotificationController animated:NO];
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            }
                break;
            case 3:
            {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                CSSettingsViewController *mNotificationController = [storyboard instantiateViewControllerWithIdentifier:@"CSSettingsViewController"];
                [app.navigationController pushViewController:mNotificationController animated:NO];
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            }
                break;
            case 4:
            {
                if([MFMailComposeViewController canSendMail]){
                    MFMailComposeViewController * mailController = [[MFMailComposeViewController alloc] init] ;
                    [mailController setToRecipients:[NSArray arrayWithObjects:[NSString stringWithFormat:@"info@crescentapp.com"],nil]];
                    [mailController setSubject:@"Salaam Crescent! I Have Something to Tell You"];
                    mailController.mailComposeDelegate = self;
                    [self presentViewController:mailController animated:YES completion:nil];
                } else {
                    [[CSUtils sharedInstance]showNormalAlert:@"Please configure your email client!"];
                }
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
                
            }

            break;
            case 5:
            {
                NSMutableArray *sharingItems = [NSMutableArray new];
                
                /*
                 if (text) {
                 [sharingItems addObject:text];
                 }
                 if (image) {
                 [sharingItems addObject:image];
                 }
                 if (url) {
                 [sharingItems addObject:url];
                 }*/
                
                [sharingItems addObject:@"Hey, you should should download Crescent - The Muslim Love App to find your Muslim love. Here's the link: http://www.crescentapp.com"];
                [sharingItems addObject:[NSURL URLWithString:@"http://www.crescentapp.com/"]];
                
                UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
                [self presentViewController:activityController animated:YES completion:nil];
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
                break;
            }
                
            case 6:
                // Log out
            {
                UIAlertView *alert =[[UIAlertView alloc]initWithTitle:ALERT_TITLE message:@"Would you like to logout now?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
                alert.tag=LOGOUT_TAG;
                [alert show];
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            }
                break;
        }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==LOGOUT_TAG) {
        if (buttonIndex==0) {
            [self doLogOut];
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
                                                              [[CSUtils sharedInstance]saveUserDetailsIntoPlistFile];
                                                              [[[CSUtils sharedInstance].CurrentViewController navigationController] popToRootViewControllerAnimated:YES];
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


#pragma mark EmailComposer Delegate-

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    
    if(result==MFMailComposeResultCancelled)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    else if(result==MFMailComposeResultFailed)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    else if(result==MFMailComposeResultSaved)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    else if(result==MFMailComposeResultSent)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end