//
//  CSSignUpSecondViewController.h
//  Crescent
//
//  Created by Debaprasad Mondal on 30/11/14.
//  Copyright (c) 2014 Debaprasad Mondal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSSignUpSecondViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *emailTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *pswdTxtFld;
//@property (weak, nonatomic) IBOutlet UITextField *phnoTxtFld;
@property (strong, nonatomic)NSString *currentlatitude;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (strong, nonatomic)NSString *currentlongitude;
@property (strong, nonatomic)NSString *yourName;
@property (strong, nonatomic)NSString *aboutme;
@property (strong, nonatomic)NSString *dob;
@property (strong, nonatomic)NSString *gender;
@property (strong, nonatomic)NSString *location;
@property (strong, nonatomic)UIImage *profileImage;
- (IBAction)nextButtonClicked:(id)sender;
- (IBAction)termsButtonClicked:(id)sender;
- (IBAction)privacyButtonClicked:(id)sender;

@end
