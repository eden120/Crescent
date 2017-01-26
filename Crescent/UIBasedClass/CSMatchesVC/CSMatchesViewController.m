//
//  CSMatchesViewController.m
//  Crescent
//
//  Created by Debaprasad Mondal on 22/01/15.
//  Copyright (c) 2015 Debaprasad Mondal. All rights reserved.
//

#import "CSMatchesViewController.h"
#import <UIImageView+AFNetworking.h>
#import "CSUtils.h"
#import "ChatViewController.h"
#import "LocalStorageService.h"
#import "ChatService.h"
#import "UsersPaginator.h"
#import <Quickblox/Quickblox.h>


@interface CSMatchesViewController ()<NMPaginatorDelegate, QBActionStatusDelegate>
@property(nonatomic,strong)NSString *strSelectedID;
@end

@implementation CSMatchesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myProfieImage.layer.cornerRadius=self.myProfieImage .frame.size.width/2;
    self.myProfieImage .layer.masksToBounds=YES;
    self.friendImage.layer.cornerRadius=self.friendImage.frame.size.width/2;
    self.friendImage.layer.masksToBounds=YES;
    
     self.paginator = [[UsersPaginator alloc] initWithPageSize:10000 delegate:self];
    // Do any additional setup after loading the view.
    [self setMutualMatchDetails];
    
    [self.scrollView setContentSize:self.contentView.frame.size];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setMutualMatchDetails
{
    __weak NSArray *imageArr=[CSUserHelper sharedInstance].userDict[@"userimage"];
    if (imageArr.count>0) {
        [self.myProfieImage setImageWithURL:[NSURL URLWithString:imageArr[0][@"image"]] placeholderImage:nil];
    }
    
    if (self.mPerson.imageurl.length>0) {
        [self.friendImage setImageWithURL:[NSURL URLWithString:self.mPerson.imageurl] placeholderImage:nil];
    }
    //self.lblMutualMatch.text=@"We Have a Match!";
    
    self.lblMessage.text=[NSString stringWithFormat:@"You and %@ liked each other. The rest is up to you",self.mPerson.name];
    [self.btnSendMessage setTitle:[NSString stringWithFormat:@"Send %@ a Message",self.mPerson.name] forState:UIControlStateNormal];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)messageButtonClicked:(id)sender {
    NSLog(@"tttt==%@",self.mPerson.email);
    [[CSUtils sharedInstance]showLoadingMode];
    
  //  [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeClear];
    [self createChatSession];
    
    
}

- (IBAction)mayBeLaterButtonClicked:(id)sender {
    [UIView animateWithDuration:1.0
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
                     }];
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)createChatSession{
    
    QBSessionParameters *extendedAuthRequest = [[QBSessionParameters alloc] init];
    //NSString *login = [CSUserHelper sharedInstance].userDict[@"email"];
      NSString *login = [[[CSUserHelper sharedInstance].userDict[@"email"] stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
    /*
    if([[CSUserHelper sharedInstance].userDict[@"name"] containsString:@" "]){
        login = [[[CSUserHelper sharedInstance].userDict[@"name"] componentsSeparatedByString:@" "] firstObject];
    } else {
        login = [CSUserHelper sharedInstance].userDict[@"name"];
    }*/
    extendedAuthRequest.userLogin = login;
    extendedAuthRequest.userPassword = kQuickBloxPwd;
    //
    [QBRequest createSessionWithExtendedParameters:extendedAuthRequest successBlock:^(QBResponse *response, QBASession *session) {
        
        
        // Save current user
        //
        QBUUser *currentUser = [QBUUser user];
        currentUser.ID = session.userID;
        //NSString *login = [CSUserHelper sharedInstance].userDict[@"email"];
          NSString *login = [[CSUtils sharedInstance] getQBLogin];
        /*
        if([[CSUserHelper sharedInstance].userDict[@"name"] containsString:@" "]){
            login = [[[CSUserHelper sharedInstance].userDict[@"name"] componentsSeparatedByString:@" "] firstObject];
        } else {
            login = [CSUserHelper sharedInstance].userDict[@"name"];
        }*/
        currentUser.login = login;
        currentUser.email = [CSUserHelper sharedInstance].userDict[@"email"];
        currentUser.password = kQuickBloxPwd;
        //
        [[LocalStorageService shared] setCurrentUser:currentUser];
        
        // Login to QuickBlox Chat
        //
        [[CSUtils sharedInstance]hideLoadingMode];
        if([[QBChat instance] isLoggedIn]) {
            QBUUserGetByEmailQuery * query = [[QBUUserGetByEmailQuery alloc] initWithUserEmail:self.mPerson.email];
            [query performAsyncWithDelegate:self];
        } else {
            [[ChatService instance] loginWithUser:currentUser completionBlock:^{
                [[CSUtils sharedInstance] showLoadingMode];
                
                QBUUserGetByEmailQuery * query = [[QBUUserGetByEmailQuery alloc] initWithUserEmail:self.mPerson.email];
                [query performAsyncWithDelegate:self];
                
            }];
        }
        
        
        
    } errorBlock:^(QBResponse *response) {
        [[CSUtils sharedInstance]hideLoadingMode];
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
        if ([obj isEqualToString:self.mPerson.email]) {//
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
        return;
    }
    
    chatDialog.occupantIDs = tempArray;
    chatDialog.type = QBChatDialogTypePrivate;
    [QBChat createDialog:chatDialog delegate:self];
    
    //[self.usersTableView reloadData];
}
#pragma mark -
#pragma mark QBActionStatusDelegate

// QuickBlox API queries delegate

- (void)completedWithResult:(QBResult *)result{
    if (result.success && [result isKindOfClass:[QBUUserResult class]]) {
        
        
        QBUUser * selectedUser = ((QBUUserResult *)result).user;
        QBChatDialog *chatDialog = [QBChatDialog new];
        //chatDialog.userID = selectedUser.ID;
        chatDialog.occupantIDs = @[@(selectedUser.ID)];
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
            chat.mPerson = self.mPerson;
            
            
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

/*
-(void)completedWithResult:(QBResult *)result{
    if (result.success && [result isKindOfClass:[QBChatDialogResult class]]) {
        // dialog created
        ChatViewController *chat = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
        
        QBChatDialogResult *dialogRes = (QBChatDialogResult *)result;
        //ChatViewController *chat;
        chat.dialog=dialogRes.dialog;
        chat.chatUserName=self.mPerson.name;//@"test";
        chat.chatOpponentImg=self.mPerson.imageurl;
       [[CSUtils sharedInstance]hideLoadingMode];
        [self.navigationController pushViewController:chat animated:YES];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errors"
                                                        message:[[result errors] componentsJoinedByString:@","]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles: nil];
        [alert show];
    }
}*/
@end
