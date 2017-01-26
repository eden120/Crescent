//
//  CSDiscoveryViewController.h
//  Crescent
//
//  Created by Debaprasad Mondal on 14/12/14.
//  Copyright (c) 2014 Debaprasad Mondal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoosePersonView.h"
#import "CSTopbarViewController.h"


@protocol DiscoveryViewDelegate <NSObject>

@optional

-(void)setFriendProfileView:(Person *)person likeButton:(UIButton*)button;
-(void)popToPreviousScreen;
-(void)foundMutualFriendView:(Person *)mperson;
@end
@interface CSDiscoveryViewController : UIViewController
@property (nonatomic, strong) ChoosePersonView *frontCardView;
@property (nonatomic, strong) ChoosePersonView *backCardView;
@property(nonatomic,assign) id<DiscoveryViewDelegate>discoveryviewdelegate;
@property (nonatomic, strong) NSMutableArray *arrFriends;

@end
