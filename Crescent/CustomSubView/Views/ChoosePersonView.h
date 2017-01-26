//
// ChoosePersonView.h
//  Crescent
//
//  Created by Debaprasad Mondal on 01/01/15.
//  Copyright (c) 2015 Debaprasad Mondal. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MDCSwipeToChoose.h"

@class Person;
@protocol PersonViewDelegate <NSObject>

@optional

-(void)setFriendsProfileView:(Person *)person likeButton:(UIButton*)button;
-(void)likeButtonClicked:(Person *)person;
@end
@interface ChoosePersonView : MDCSwipeToChooseView

@property (nonatomic, strong, readonly) Person *person;
@property (nonatomic, strong) UIButton *likeButton;
@property(nonatomic,assign) id<PersonViewDelegate>personviewdelegate;
- (instancetype)initWithFrame:(CGRect)frame
                       person:(Person *)person
                      options:(MDCSwipeToChooseViewOptions *)options;

@end
