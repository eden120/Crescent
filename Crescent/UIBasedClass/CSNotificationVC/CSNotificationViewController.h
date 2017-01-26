//
//  CSNotificationViewController.h
//  Crescent
//
//  Created by Debaprasad Mondal on 19/12/14.
//  Copyright (c) 2014 Debaprasad Mondal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSNotificationViewController : UIViewController
@property(nonatomic,strong)NSString *chatUserName;

- (void)updateNotificationsList;

@end
