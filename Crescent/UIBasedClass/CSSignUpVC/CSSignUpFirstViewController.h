//
//  ViewController.h
//  Crescent
//
//  Created by Debaprasad Mondal on 30/11/14.
//  Copyright (c) 2014 Debaprasad Mondal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSTextView.h"
@protocol SignUpViewDelegate <NSObject>

@optional

-(void)setUserInputData:(NSString *)username About:(NSString *)about Dob:(NSString *)dob Gender:(NSString *)gender Location:(NSString *)location Image:(UIImage *)pImage;
@end
@interface CSSignUpFirstViewController : UIViewController

@property(nonatomic,assign) id<SignUpViewDelegate>signupviewdelegate;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (strong, nonatomic)NSString *emailid;
@property (strong, nonatomic)NSString *password;
//@property (strong, nonatomic)NSString *phno;
@property (strong, nonatomic)NSString *yourName;
@property (strong, nonatomic)NSString *aboutme;
@property (strong, nonatomic)NSString *dob;
@property (strong, nonatomic)NSString *gender;
@property (strong, nonatomic)NSString *location;
@property (strong, nonatomic)UIImage *pImage;
@property (weak, nonatomic) IBOutlet UIScrollView *signupScrvw;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITextField *nameTxtFld;
- (IBAction)addPhotoButtonClicked:(id)sender;
- (IBAction)nextButtonClicked:(id)sender;
- (IBAction)dobButtonClicked:(id)sender;
- (IBAction)genderButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet CSTextView *aboutTxtView;
@property (weak, nonatomic) IBOutlet UILabel *lbltextCount;
@property (weak, nonatomic) IBOutlet UITextField *dobTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *genderTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *locationTxtFld;
@property (weak, nonatomic) IBOutlet UIImageView *profileBgImage;

@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet UIView *userNameView;
@property (weak, nonatomic) IBOutlet UIView *aboutMeView;
@property (strong, nonatomic)NSString *currentlatitude;
@property (strong, nonatomic)NSString *currentlongitude;
@property (strong, nonatomic)NSMutableDictionary *userDict;
@property (assign, nonatomic)BOOL isSignUpFromFacebook;
@end

