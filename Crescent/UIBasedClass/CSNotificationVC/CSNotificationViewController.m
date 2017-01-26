//
//  CSNotificationViewController.m
//  Crescent
//
//  Created by Debaprasad Mondal on 19/12/14.
//  Copyright (c) 2014 Debaprasad Mondal. All rights reserved.
//

#import "CSNotificationViewController.h"
#import "CSUtils.h"
#import <UIImageView+AFNetworking.h>
#import "CSMatchesViewController.h"
#import "CSFriendProfileViewController.h"
#import "CSFindingFriendsViewController.h"

@interface CSNotificationViewController ()
@property (weak, nonatomic) IBOutlet UITableView *notificationTable;
@property (strong, nonatomic) NSMutableArray *notifictaionArr;
- (IBAction)backButtonClicked:(id)sender;

@end

@implementation CSNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.notifictaionArr=[NSMutableArray array];
    [self getNotificationList];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.showNotifications = NO;
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
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.notifictaionArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
        cell= [tableView dequeueReusableCellWithIdentifier:@"notificationCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"notificationCell"];
        }
    
    UILabel *lblName=(UILabel *)[cell.contentView viewWithTag:11];
    UILabel *lblTime=(UILabel *)[cell.contentView viewWithTag:12];
    UIImageView *profileImage=(UIImageView *)[cell.contentView viewWithTag:1];
    profileImage.layer.cornerRadius=profileImage.frame.size.width/2;
    profileImage.layer.masksToBounds=YES;
    NSString *username=self.notifictaionArr[indexPath.row][@"username"];
    if ([self.notifictaionArr[indexPath.row][@"notificationtype"] integerValue]==1) {
        NSString * strEmail =[NSString stringWithFormat:@"%@ likes your photo",[[CSUtils sharedInstance] checkNullStringAndReplace:username]] ;
        NSMutableAttributedString * attributedEmail = [[NSMutableAttributedString alloc] initWithString:strEmail];
        NSRange nameboldedRange = NSMakeRange(0, [[CSUtils sharedInstance] checkNullStringAndReplace:username].length);
        [attributedEmail addAttribute: NSFontAttributeName value:[UIFont fontWithName:FONT_SEMIBOLD size:14] range:nameboldedRange];
        //[attributedEmail addAttribute: NSForegroundColorAttributeName value: [*UICOLOR*] range:boldedRange]; // if needed
        [lblName setAttributedText: attributedEmail];
    }
    else if([self.notifictaionArr[indexPath.row][@"notificationtype"] integerValue]==2)
    {
        NSString * strEmail =[NSString stringWithFormat:@"%@ message you",[[CSUtils sharedInstance] checkNullStringAndReplace:username]];
        NSMutableAttributedString * attributedEmail = [[NSMutableAttributedString alloc] initWithString:strEmail];
        NSRange nameboldedRange = NSMakeRange(0, username.length);
        [attributedEmail addAttribute: NSFontAttributeName value:[UIFont fontWithName:FONT_SEMIBOLD size:14] range:nameboldedRange];
        //[attributedEmail addAttribute: NSForegroundColorAttributeName value: [*UICOLOR*] range:boldedRange]; // if needed
        [lblName setAttributedText: attributedEmail];
    }
    else if([self.notifictaionArr[indexPath.row][@"notificationtype"] integerValue]==3)
    {
        NSString * strEmail =[NSString stringWithFormat:@"You and %@ like each other",[[CSUtils sharedInstance] checkNullStringAndReplace:username]] ;
        NSMutableAttributedString * attributedEmail = [[NSMutableAttributedString alloc] initWithString:strEmail];
        //NSRange nameboldedRange = NSMakeRange(0, username.length);
        //[attributedEmail addAttribute: NSFontAttributeName value:[UIFont fontWithName:FONT_SEMIBOLD size:14] range:nameboldedRange];
        //[attributedEmail addAttribute: NSForegroundColorAttributeName value: [*UICOLOR*] range:boldedRange]; // if needed
        [lblName setAttributedText: attributedEmail];
        
    }
    else
    {
        NSString * strEmail =[NSString stringWithFormat:@"%@ likes your profile",[[CSUtils sharedInstance] checkNullStringAndReplace:username]] ;
        NSMutableAttributedString * attributedEmail = [[NSMutableAttributedString alloc] initWithString:strEmail];
        NSRange nameboldedRange = NSMakeRange(0, [[CSUtils sharedInstance] checkNullStringAndReplace:username].length);
        [attributedEmail addAttribute: NSFontAttributeName value:[UIFont fontWithName:FONT_SEMIBOLD size:14] range:nameboldedRange];
        //[attributedEmail addAttribute: NSForegroundColorAttributeName value: [*UICOLOR*] range:boldedRange]; // if needed
        [lblName setAttributedText: attributedEmail];
        
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDateFormat];
    NSDate * date = [[NSDate alloc] initWithTimeIntervalSince1970:[self.notifictaionArr[indexPath.row][@"notifytime"] doubleValue]];
    NSString * dateString = [dateFormatter stringFromDate:date];
    [lblTime setText:dateString];
    if (self.notifictaionArr[indexPath.row][@"imageurl"]) {
        [profileImage setImageWithURL:[NSURL URLWithString:self.notifictaionArr[indexPath.row][@"imageurl"]] placeholderImage:nil];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.chatUserName = self.notifictaionArr[indexPath.row][@"username"];
    NSUserDefaults *defaultOpponentName = [NSUserDefaults standardUserDefaults];
    [defaultOpponentName setObject:self.chatUserName forKey:@"opponentName"];
    [defaultOpponentName synchronize];
    
    if([self.notifictaionArr[indexPath.row][@"notificationtype"] integerValue] == 3)
    {
        CSMatchesViewController *mMatch = [self.storyboard instantiateViewControllerWithIdentifier:@"CSMatchesViewController"];
        Person *mperson=[[Person alloc]init];
        mperson.name=self.notifictaionArr[indexPath.row][@"username"];
        mperson.imageurl=self.notifictaionArr[indexPath.row][@"imageurl"];
        mperson.userid=self.notifictaionArr[indexPath.row][@"userid"];
        mperson.email=self.notifictaionArr[indexPath.row][@"email"];
        mMatch.mPerson=mperson;
        [self.navigationController pushViewController:mMatch animated:NO];
        [UIView transitionWithView:self.navigationController.view duration:1 options:UIViewAnimationOptionTransitionFlipFromRight animations:nil completion:nil];
    } else if([self.notifictaionArr[indexPath.row][@"notificationtype"] integerValue]==1){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        CSFriendProfileViewController *mfriendcontroller = [storyboard instantiateViewControllerWithIdentifier:@"CSFriendProfileViewController"];
        Person *mperson=[[Person alloc]init];
        mperson.name=self.notifictaionArr[indexPath.row][@"username"];
        mperson.imageurl=self.notifictaionArr[indexPath.row][@"imageurl"];
        mperson.userid=self.notifictaionArr[indexPath.row][@"userid"];
        mperson.email=self.notifictaionArr[indexPath.row][@"email"];
        mfriendcontroller.mperson=mperson;
        [self.navigationController pushViewController:mfriendcontroller animated:YES];
        
    } else if([self.notifictaionArr[indexPath.row][@"notificationtype"] integerValue]==4){
     
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.friendID = self.notifictaionArr[indexPath.row][@"userid"];
        
         CSFindingFriendsViewController *mFindFriendVc= [self.storyboard instantiateViewControllerWithIdentifier:@"CSFindingFriendsViewController"];
        [self.navigationController pushViewController:mFindFriendVc animated:YES];
        
    }
}


- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)updateNotificationsList
{
    [self getNotificationList];
}

#pragma mark Log out API call
-(void)getNotificationList
{
    if([[AFNetworkReachabilityManager sharedManager] isReachable]) // checking network reachable
    {
        [[CSUtils sharedInstance]showLoadingMode];

        self.view.userInteractionEnabled=NO;
        __weak typeof(self) weakSelf = self;
        [[CSRequestController sharedInstance]getNotificationListWithUserId:[CSUserHelper sharedInstance].userDict[@"user_id"]
                                                                          success:^(NSDictionary *responsedict){
                                                                              [[CSUtils sharedInstance]hideLoadingMode];

                                                                              weakSelf.view.userInteractionEnabled=YES;
                                                                              if ([responsedict[@"response"]integerValue]==200) {
                                                                                  
                                                                                  NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"notifytime"  ascending:NO];
                                                                                  weakSelf.notifictaionArr = [[responsedict[@"values"] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]] mutableCopy];
                                                                                  
                                                                                  
                                                                                  [weakSelf.notificationTable reloadData];
                                                                              }
                                                                              else if ([responsedict[@"response"]integerValue] ==201)
                                                                              {
                                                                                  [[CSUtils sharedInstance] showNormalAlert:responsedict[@"message"]];
                                                                              }
                                                                              
                                                                              
                                                                          }
                                                                          failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [[CSUtils sharedInstance]hideLoadingMode];

             weakSelf.view.userInteractionEnabled=YES;
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

@end
