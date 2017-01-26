//
//  CSSignUpSecondViewController.m
//  Crescent
//
//  Created by Debaprasad Mondal on 30/11/14.
//  Copyright (c) 2014 Debaprasad Mondal. All rights reserved.
//

#import "CSSignUpSecondViewController.h"
#import "CSUtils.h"
#import "CSSignUpFirstViewController.h"
#import "CSPrivacyPolicyViewController.h"

@interface CSSignUpSecondViewController ()<SignUpViewDelegate>
{
    BOOL isPrivacy;
}

@end

@implementation CSSignUpSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setUserInputData:(NSString *)username About:(NSString *)about Dob:(NSString *)dob Gender:(NSString *)gender Location:(NSString *)location Image:(UIImage *)pImage
{
    self.yourName=username;
    self.aboutme=about;
    self.dob=dob;
    self.gender=gender;
    self.location=location;
    self.profileImage=pImage;

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"loadSignUpFirstVC"]) {
        CSSignUpFirstViewController *msignup=(CSSignUpFirstViewController*)[segue destinationViewController];
        msignup.signupviewdelegate=self;
        msignup.emailid=self.emailTxtFld.text;
        msignup.password=self.pswdTxtFld.text;
       // msignup.phno=self.phnoTxtFld.text;
        msignup.currentlatitude=self.currentlatitude;
        msignup.currentlongitude=self.currentlongitude;
        msignup.yourName=self.yourName;
        msignup.aboutme=self.aboutme;
        msignup.dob=self.dob;
        msignup.gender=self.gender;
        msignup.location=self.location;
        msignup.pImage=self.profileImage;
    }
    else if ([segue.identifier isEqualToString:@"loadPrivacyVC"])
    {
        CSPrivacyPolicyViewController *mPrivacy=(CSPrivacyPolicyViewController*)[segue destinationViewController];
        mPrivacy.isPrivacy=isPrivacy;
    }
    
}

-(void)checkAndSetNextButtonEnable
{
    if([self.emailTxtFld.text length]>0 && [self.pswdTxtFld.text length]>0 )
        self.btnNext.enabled=YES;
    else
        _btnNext.enabled=NO;
}

- (IBAction)nextButtonClicked:(id)sender {
    [self.emailTxtFld resignFirstResponder];
    [self.pswdTxtFld resignFirstResponder];
    
    if(self.emailTxtFld.text.length>0 && self.pswdTxtFld.text.length>0 )
        [self performSegueWithIdentifier:@"loadSignUpFirstVC" sender:self];//
    else
        [[CSUtils sharedInstance] showNormalAlert:@"Almost there, just complete everything"];
}

- (IBAction)termsButtonClicked:(id)sender {
    isPrivacy=NO;
    [self performSegueWithIdentifier:@"loadPrivacyVC" sender:self];
}

- (IBAction)privacyButtonClicked:(id)sender {
    isPrivacy=YES;
    [self performSegueWithIdentifier:@"loadPrivacyVC" sender:self];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==1)
    {
        [[CSUtils sharedInstance] ValidateEmail:textField];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
        
    }
    return NO;
    //return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.003 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self checkAndSetNextButtonEnable];
    });
    return YES;
}

- (IBAction)backButtonClicked:(id)sender {
    [UIView animateWithDuration:1.0
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
                     }];
    [self.navigationController popViewControllerAnimated:NO];
}
@end
