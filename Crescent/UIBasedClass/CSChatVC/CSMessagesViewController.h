//
//  CSMessagesViewController.h
//  Crescent
//
//  Created by Debaprasad Mondal on 16/12/14.
//  Copyright (c) 2014 Debaprasad Mondal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UsersPaginator.h"
#import <Quickblox/Quickblox.h>

@interface CSMessagesViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, strong) NSMutableArray *usersId;
@property (nonatomic, strong) NSMutableArray *usersLogin;
@property (nonatomic, strong) UsersPaginator *paginator;
@end
