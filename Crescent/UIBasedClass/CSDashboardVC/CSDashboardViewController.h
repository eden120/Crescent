//
//  CSDashboardViewController.h
//  Crescent
//
//  Created by Debaprasad Mondal on 09/12/14.
//  Copyright (c) 2014 Debaprasad Mondal. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DashboardViewDelegate <NSObject>

@optional

-(void)finishLiked;
@end
@interface CSDashboardViewController : UIViewController
@property(nonatomic, strong)NSMutableArray *arrFriends;
@property(nonatomic,assign) id<DashboardViewDelegate>dashboardViewDelegate;
@property (weak, nonatomic) IBOutlet UIScrollView *coachMarkScrView;

@end
