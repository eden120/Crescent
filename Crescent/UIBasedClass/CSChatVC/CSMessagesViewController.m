//
//  CSMessagesViewController.m
//  Crescent
//
//  Created by Debaprasad Mondal on 16/12/14.
//  Copyright (c) 2014 Debaprasad Mondal. All rights reserved.
//

#import "CSMessagesViewController.h"
#import "CSUtils.h"
#import <UIImageView+AFNetworking.h>
#import "ChatViewController.h"
#import "LocalStorageService.h"
#import "ChatService.h"
#import "UsersPaginator.h"
#import <Quickblox/Quickblox.h>
#import <Quickblox/QBChat.h>

@interface CSMessagesViewController ()<NMPaginatorDelegate, QBActionStatusDelegate>
@property(nonatomic,strong)NSString *strSelectedID;
@property(nonatomic,strong)NSString *strSelectedEmail;
@property (strong, nonatomic) NSMutableArray *arrMatchedUser;
- (IBAction)backButtonClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tblMatchedUser;

@end

@implementation CSMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getMatchedUserList];
    
    self.paginator = [[UsersPaginator alloc] initWithPageSize:10000 delegate:self];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrMatchedUser count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 70 ;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell= [tableView dequeueReusableCellWithIdentifier:@"messagesCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"messagesCell"];
    }
    
    UILabel *lblName=(UILabel *)[cell.contentView viewWithTag:11];
    UILabel *lblTime=(UILabel *)[cell.contentView viewWithTag:12];
    UIImageView *profileImage=(UIImageView *)[cell.contentView viewWithTag:1];
    profileImage.layer.cornerRadius=profileImage.frame.size.width/2;
    profileImage.layer.masksToBounds=YES;
    NSString *username=self.arrMatchedUser[indexPath.row][@"username"];
    NSString *userlocation=self.arrMatchedUser[indexPath.row][@"userLocation"];
    lblName.text = username;
    lblTime.text = userlocation;//@"some static text";
    if (self.arrMatchedUser[indexPath.row][@"imageurl"]) {
        [profileImage setImageWithURL:[NSURL URLWithString:self.arrMatchedUser[indexPath.row][@"imageurl"]] placeholderImage:nil];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}
#pragma mark Tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.arrMatchedUser[indexPath.row][@"useractive"] integerValue] == 0) {
        
        [[[UIAlertView alloc] initWithTitle:@"Crescent" message:@"Name is no longer active on Crescent. Don't worry, there are tons of potential new matches joining daily!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        
        return;
        
    }
    
    NSString *strUserName = self.arrMatchedUser[indexPath.row][@"username"];
    NSUserDefaults *defaultOpponentName = [NSUserDefaults standardUserDefaults];
    [defaultOpponentName setObject:strUserName forKey:@"opponentName"];//imageurl
    [defaultOpponentName setObject:self.arrMatchedUser[indexPath.row][@"imageurl"] forKey:@"opponentImage"];
    [defaultOpponentName synchronize];
    self.strSelectedEmail = self.arrMatchedUser[indexPath.row][@"email"];
    //[SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeClear];
     [[CSUtils sharedInstance]showLoadingMode];
    [self createChatSession];
}

#pragma mark Log out API call
-(void)getMatchedUserList
{
    if([[AFNetworkReachabilityManager sharedManager] isReachable]) // checking network reachable
    {
        [[CSUtils sharedInstance]showLoadingMode];
        
        self.view.userInteractionEnabled=NO;
        __weak typeof(self) weakSelf = self;
        [[CSRequestController sharedInstance]getMatchedUserListWithUserId:[CSUserHelper sharedInstance].userDict[@"user_id"] success:^(NSDictionary *responsedict){
           [[CSUtils sharedInstance]hideLoadingMode];
           
           weakSelf.view.userInteractionEnabled=YES;
           if ([responsedict[@"response"]integerValue]==200) {
               weakSelf.arrMatchedUser=responsedict[@"values"];
               [weakSelf.tblMatchedUser reloadData];
           }
           else if ([responsedict[@"response"]integerValue] ==201)
           {
               [[CSUtils sharedInstance] showNormalAlert:responsedict[@"message"]];
           }
            
                                                                       
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
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
- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark QBChat

-(void)createChatSession{
    
    //NSString *login = [CSUserHelper sharedInstance].userDict[@"email"];
    NSString *login = [[CSUtils sharedInstance] getQBLogin];
    /*
    if([[CSUserHelper sharedInstance].userDict[@"name"] containsString:@" "]){
        login = [[[CSUserHelper sharedInstance].userDict[@"name"] componentsSeparatedByString:@" "] firstObject];
    } else {
        login = [CSUserHelper sharedInstance].userDict[@"name"];
    }
    [[CSUserHelper sharedInstance].userDict[@"name"] stringByTrimmingCharactersInSet:
                       [NSCharacterSet whitespaceCharacterSet]];
     */
    QBSessionParameters *extendedAuthRequest = [[QBSessionParameters alloc] init];
    extendedAuthRequest.userLogin = login;//[CSUserHelper sharedInstance].userDict[@"email"];
    extendedAuthRequest.userPassword = kQuickBloxPwd;
    //
    
    [QBRequest createSessionWithExtendedParameters:extendedAuthRequest successBlock:^(QBResponse *response, QBASession *session) {
        
        
        // Save current user
        //
        QBUUser *currentUser = [QBUUser user];
        currentUser.ID = session.userID;
       // NSString *login = [CSUserHelper sharedInstance].userDict[@"email"];
          NSString *login = [[CSUtils sharedInstance] getQBLogin];
        /*
        if([[CSUserHelper sharedInstance].userDict[@"name"] containsString:@" "]){
            login = [[[CSUserHelper sharedInstance].userDict[@"name"] componentsSeparatedByString:@" "] firstObject];
        } else {
            login = [CSUserHelper sharedInstance].userDict[@"name"];
        }*/
        currentUser.email = [CSUserHelper sharedInstance].userDict[@"email"];
        currentUser.login = login;//;
        currentUser.password = kQuickBloxPwd;
        //
        [[LocalStorageService shared] setCurrentUser:currentUser];
        
        // Login to QuickBlox Chat
        //
        [[CSUtils sharedInstance]hideLoadingMode];
        if([[QBChat instance] isLoggedIn]) {
            QBUUserGetByEmailQuery * query = [[QBUUserGetByEmailQuery alloc] initWithUserEmail:self.strSelectedEmail];
            [query performAsyncWithDelegate:self];
        } else {
                [[ChatService instance] loginWithUser:currentUser completionBlock:^{
                    [[CSUtils sharedInstance] showLoadingMode];
                    
                    QBUUserGetByEmailQuery * query = [[QBUUserGetByEmailQuery alloc] initWithUserEmail:self.strSelectedEmail];
                    [query performAsyncWithDelegate:self];
                    
                }];
            }
        
        
        
    } errorBlock:^(QBResponse *response) {
         [[CSUtils sharedInstance] hideLoadingMode];
        NSString *errorMessage = [[response.error description] stringByReplacingOccurrencesOfString:@"(" withString:@""];
        errorMessage = [errorMessage stringByReplacingOccurrencesOfString:@")" withString:@""];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errors"message:errorMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }];
    
    
    
    
}

#pragma mark
#pragma mark Paginator

- (void)fetchNextPage
{
    [self.paginator fetchNextPage];
    //[self.activityIndicator startAnimating];
}
#pragma mark
#pragma mark NMPaginatorDelegate

- (void)paginator:(id)paginator didReceiveResults:(NSArray *)results
{
    // update tableview footer
    //[self updateTableViewFooter];
    //[self.activityIndicator stopAnimating];
    
    // reload table with users
    NSMutableArray *tempArray=[[NSMutableArray alloc]init];
    [self.users addObjectsFromArray:results];
    [self.users enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        QBUUser *user = (QBUUser *)self.users[idx];
        [self.usersLogin addObject:user.login];
        [self.usersId addObject:@(user.ID)];
        
        
    }];
    [self.usersLogin enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        if ([obj isEqualToString:self.strSelectedEmail]) {//
            self.strSelectedID=[self.usersId objectAtIndex:idx];
            [tempArray addObject:self.strSelectedID];
        }
        
    }];
    
    QBChatDialog *chatDialog = [QBChatDialog new];
    
    
    NSMutableArray *selectedUsersNames = [NSMutableArray array];
    /*for(QBUUser *user in self.selectedUsers){
     [selectedUsersIDs addObject:@(user.ID)];
     [selectedUsersNames addObject:user.login == nil ? user.email : user.login];
     }*/
    if ([tempArray count]==0) {
        [[CSUtils sharedInstance]hideLoadingMode];
        //[self.paginator fetchNextPage];
        return;
    }
    chatDialog.occupantIDs = tempArray;
    chatDialog.type = QBChatDialogTypePrivate;
    [QBRequest createDialog:chatDialog successBlock:^(QBResponse *response,  QBChatDialog *createdDialog) {
        
        ChatViewController *chat = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
        
        //QBChatDialogResult *dialogRes = (QBChatDialogResult *)result;
        //ChatViewController *chat;
        chat.dialog=createdDialog;
        NSUserDefaults *defaultOpponentName = [NSUserDefaults standardUserDefaults];
        //imageurl
        
        
        chat.chatUserName=[defaultOpponentName valueForKey:@"opponentName"];
        chat.chatOpponentImg=[defaultOpponentName  valueForKey:@"opponentImage"];
        
        
        
        [[CSUtils sharedInstance]hideLoadingMode];
        [self.navigationController pushViewController:chat animated:YES];
        
    } errorBlock:^(QBResponse *response) {
        
        [[CSUtils sharedInstance]hideLoadingMode];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errors"
                                                        message:response.error.error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles: nil];
        [alert show];
        
    }];
    
    //[self.usersTableView reloadData];
}
#pragma mark -
#pragma mark QBActionStatusDelegate

// QuickBlox API queries delegate

- (void)completedWithResult:(QBResult *)result{
      if (result.success && [result isKindOfClass:[QBUUserResult class]]) {
          
          
          QBUUser * selectedUser = ((QBUUserResult *)result).user;
          QBChatDialog *chatDialog = [QBChatDialog new];
          chatDialog.occupantIDs = @[@(selectedUser.ID)];//tempArray;
          chatDialog.type = QBChatDialogTypePrivate;
          
          [QBRequest createDialog:chatDialog successBlock:^(QBResponse *response,  QBChatDialog *createdDialog) {
              
              ChatViewController *chat = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
              
              //QBChatDialogResult *dialogRes = (QBChatDialogResult *)result;
              //ChatViewController *chat;
              chat.dialog=createdDialog;
              NSUserDefaults *defaultOpponentName = [NSUserDefaults standardUserDefaults];
              //imageurl
              
              
              chat.chatUserName=[defaultOpponentName valueForKey:@"opponentName"];
              chat.chatOpponentImg=[defaultOpponentName  valueForKey:@"opponentImage"];
              
              
              
              [[CSUtils sharedInstance]hideLoadingMode];
              [self.navigationController pushViewController:chat animated:YES];
              
          } errorBlock:^(QBResponse *response) {
              
              [[CSUtils sharedInstance]hideLoadingMode];
              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errors"
                                                              message:response.error.error.localizedDescription
                                                             delegate:nil
                                                    cancelButtonTitle:@"Ok"
                                                    otherButtonTitles: nil];
              [alert show];
              
          }];
          
          return;
      } else{
        
        [[CSUtils sharedInstance]hideLoadingMode];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errors"
                                                        message:[[result errors] componentsJoinedByString:@","]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles: nil];
        [alert show];
    }
}
@end
