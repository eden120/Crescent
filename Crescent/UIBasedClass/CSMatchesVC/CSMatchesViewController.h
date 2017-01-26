//
//  CSMatchesViewController.h
//  Crescent
//
//  Created by Debaprasad Mondal on 22/01/15.
//  Copyright (c) 2015 Debaprasad Mondal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
#import "UsersPaginator.h"
#import <Quickblox/Quickblox.h>

@interface CSMatchesViewController : UIViewController<NMPaginatorDelegate, QBActionStatusDelegate>

@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, strong) NSMutableArray *usersId;
@property (nonatomic, strong) NSMutableArray *usersLogin;
@property (nonatomic, strong) UsersPaginator *paginator;

@property (weak, nonatomic) IBOutlet UIImageView *myProfieImage;
@property (weak, nonatomic) IBOutlet UIImageView *friendImage;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnSendMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnMaybeLater;
@property (strong, nonatomic)Person *mPerson;
@property (weak, nonatomic) IBOutlet UILabel *lblMutualMatch;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property(nonatomic,strong) NSString *userLoginEmail;

- (IBAction)messageButtonClicked:(id)sender;
- (IBAction)mayBeLaterButtonClicked:(id)sender;

@end
