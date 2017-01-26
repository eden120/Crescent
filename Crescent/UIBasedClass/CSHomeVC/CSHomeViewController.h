//
//  CSHomeViewController.h
//  Crescent
//
//  Created by Debaprasad Mondal on 27/12/14.
//  Copyright (c) 2014 Debaprasad Mondal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSUChangesLoginState.h"

@class SSULoginState;
@interface CSHomeViewController : UIViewController<SSUChangesLoginState>
@property (weak, nonatomic) IBOutlet UIScrollView *homeScrView;
- (IBAction)signupWithFacebookButtonClicked:(id)sender;
- (IBAction)signUpButtonClicked:(id)sender;
- (IBAction)signInButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIPageControl *pageController;
@property (nonatomic, weak) SSULoginState* loginState;

@end
