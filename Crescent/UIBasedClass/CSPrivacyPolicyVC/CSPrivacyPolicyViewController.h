//
//  CSPrivacyPolicyViewController.h
//  Crescent
//
//  Created by Debaprasad Mondal on 27/12/14.
//  Copyright (c) 2014 Debaprasad Mondal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSPrivacyPolicyViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIWebView *privacyWebView;
@property (assign, nonatomic) BOOL isPrivacy;
- (IBAction)backButtonClicked:(id)sender;

@end
