//
//  CSMyProfileViewController.h
//  Crescent
//
//  Created by Debaprasad Mondal on 19/12/14.
//  Copyright (c) 2014 Debaprasad Mondal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSMyProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *profileScrVw;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrVw;
@property (weak, nonatomic) IBOutlet UIPageControl *pageController;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblAbout;

@end
