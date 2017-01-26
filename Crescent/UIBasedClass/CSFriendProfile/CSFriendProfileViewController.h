//
//  CSFriendProfileViewController.h
//  Crescent
//
//  Created by Debaprasad Mondal on 20/12/14.
//  Copyright (c) 2014 Debaprasad Mondal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface CSFriendProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *profileScrView;
@property (weak, nonatomic) IBOutlet UIScrollView *bottomScrView;
@property (strong, nonatomic)Person *mperson;
@property (strong, nonatomic)NSString *profileName;
@property (weak, nonatomic) IBOutlet UILabel *lblProfileName;
@property (weak, nonatomic) IBOutlet UIPageControl *pageController;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblAbout;
//@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIView *aboutView;
@property (weak, nonatomic) IBOutlet UIButton *btnHeart;
@property (strong, nonatomic) UIButton *likeButton;
- (IBAction)heartButtonClicked:(id)sender;

@end
