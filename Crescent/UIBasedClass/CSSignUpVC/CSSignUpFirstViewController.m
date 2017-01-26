//
//  ViewController.m
//  Crescent
//
//  Created by Debaprasad Mondal on 30/11/14.
//  Copyright (c) 2014 Debaprasad Mondal. All rights reserved.
//

#import "CSSignUpFirstViewController.h"
#import "CSUtils.h"
#import "CSRequestController.h"
#import "CSUserHelper.h"
#import "Base64.h"
#import <SVProgressHUD.h>
#import <UIImageView+AFNetworking.h>
#import "SideMenuViewController.h"
#import "CSWantViewController.h"
#import <Quickblox/Quickblox.h>

#define GENDER_ACTIONSHEET_TAG 99

@interface CSSignUpFirstViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    CGSize kbSize;
    UIDatePicker *theDatePicker;
    UIView *pickerView;
    NSString *profileImageBase64;
}

@end

@implementation CSSignUpFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.aboutTxtView.placeholder=@"Tell us a little about yourself and who you're looking for.";
    if (self.isSignUpFromFacebook) {
      //  [userdict setObject:email forKey:@"email"];
        self.nameTxtFld.text=[_userDict valueForKey:@"name"];
        self.dobTxtFld.text=[_userDict valueForKey:@"birthday"];
        self.genderTxtFld.text=[_userDict valueForKey:@"gender"];
        self.locationTxtFld.text=[_userDict valueForKey:@"location"];
        //[self.profileImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",_userDict[@"id"]] ] placeholderImage:nil];
        NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&width=1200", _userDict[@"id"]];
        [self.profileImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:/*[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",_userDict[@"id"]]*/userImageURL ]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [self.profileImage setImage:image];
            [self blurImage:image];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            ;
        }];
        self.emailid=_userDict[@"email"];
    }
    else
    {
        self.nameTxtFld.text=self.yourName;
        self.aboutTxtView.text=self.aboutme;
        self.dobTxtFld.text=self.dob;
        self.genderTxtFld.text=self.gender;
        self.locationTxtFld.text=self.location;
        self.profileImage.image=self.pImage;
    }
    self.profileImage.layer.cornerRadius=self.profileImage.frame.size.width/2;
    self.profileImage.layer.borderWidth=2;
    self.profileImage.layer.borderColor=[UIColor whiteColor].CGColor;
    self.profileImage.layer.masksToBounds=YES;
    
   
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.signupScrvw setContentSize:CGSizeMake(self.signupScrvw.frame.size.width, 648)];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}




-(void)QBRegistration{
    QBUUser *user = [QBUUser user];
    user.password = kQuickBloxPwd;
    user.login = [[CSUtils sharedInstance] getQBLogin];
    user.email = [CSUserHelper sharedInstance].userDict[@"email"];
    
    [QBRequest logInWithUserLogin:[[CSUtils sharedInstance] getQBLogin] password:kQuickBloxPwd successBlock:[self successBlock] errorBlock:^(QBResponse *response) {
        //User doesn't exist, try to signup
        // Registration/sign up of User
        [QBRequest signUp:user successBlock:[self successBlock] errorBlock:^(QBResponse *response) {
            // Oops, something goes wrong
            [[CSUtils sharedInstance]hideLoadingMode];
            [SVProgressHUD showErrorWithStatus:@"QuickBlox SignUp Error"];
        }];
    }];
}

- (void (^)(QBResponse *response, QBUUser *user))successBlock
{
    return ^(QBResponse *response, QBUUser *user) {
        if([[AFNetworkReachabilityManager sharedManager] isReachable]) // checking network reachable
        {
            [[CSUtils sharedInstance] showLoadingMode];
            [[CSRequestController sharedInstance] updateQBIdWith:[CSUserHelper sharedInstance].userDict[@"user_id"] BQId:[NSString stringWithFormat:@"%lu", (unsigned long)user.ID] success:^(NSDictionary *responsedict){
                [[CSUtils sharedInstance]hideLoadingMode];
                
                self.view.userInteractionEnabled=YES;
                if ([responsedict[@"response"]integerValue]==200) {
                    
                    [CSUserHelper sharedInstance].userDict=[responsedict[@"user"] mutableCopy];
                    [[CSUtils sharedInstance]saveUserDetailsIntoPlistFile];
                    
                    if ([CSUserHelper sharedInstance].userDict[@"interests"]) {
                        NSString *str=[CSUserHelper sharedInstance].userDict[@"interests"];
                        if (str.length>0) {
                            CSWantViewController *mNotificationController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSWantViewController"];
                            [self.navigationController pushViewController:mNotificationController animated:YES];
                        }
                        else
                            [self performSegueWithIdentifier:@"loadMyInterestVC" sender:self];
                    }
                    else {
                        [self performSegueWithIdentifier:@"loadMyInterestVC" sender:self];
                    }
                    
                    
                }
                else if ([responsedict[@"response"]integerValue] ==201)
                {
                    [[CSUtils sharedInstance] showNormalAlert:responsedict[@"message"]];
                }
                
                
            }
                                                         failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
                 [[CSUtils sharedInstance]hideLoadingMode];
                 
                 if (error.code==CSErrorCodeSessionExpired) {
                     [SVProgressHUD showErrorWithStatus:@"Connection timed out. Please try again!"];
                 }
                 else
                 {
                     [SVProgressHUD showErrorWithStatus:@"Connection timed out. Please try again!"];
                     
                 }
             }];
            
        }
        else
        {
            [[CSUtils sharedInstance] showNormalAlert:@"Please check your network connection and try again!"];
        }
        
        
        
    };
}


-(void)checkAndSetNextButtonEnable
{
    if([self.nameTxtFld.text length]>0 && [self.locationTxtFld.text length]>0 && [self.genderTxtFld.text length]>0 && [self.dobTxtFld.text length]>0 && ([profileImageBase64 length]>0||self.isSignUpFromFacebook) )
        self.btnNext.enabled=YES;
    else
        _btnNext.enabled=NO;
}
#pragma mark - Keyboard events

//Handling the keyboard appear and disappering events

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    __weak typeof(self) weakSelf = self;
     NSDictionary* info = [aNotification userInfo];
      kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:0.0f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         if (weakSelf.nameTxtFld.isFirstResponder) {
                             [weakSelf.signupScrvw setContentOffset:CGPointMake(0, weakSelf.userNameView.frame.origin.y+weakSelf.userNameView.frame.size.height-kbSize.height) animated:YES];
                         }
                         else if (weakSelf.aboutTxtView.isFirstResponder) {
                             [weakSelf.signupScrvw setContentOffset:CGPointMake(0, weakSelf.aboutMeView.frame.origin.y+weakSelf.aboutMeView.frame.size.height-kbSize.height) animated:YES];
                         }
                         else if (weakSelf.locationTxtFld.isFirstResponder) {
                             [weakSelf.signupScrvw setContentOffset:CGPointMake(0, weakSelf.locationView.frame.origin.y+weakSelf.locationView.frame.size.height-kbSize.height) animated:YES];
                         }
                     }
                     completion:^(BOOL finished) {
                     }];
    
    
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    //__weak typeof(self) weakSelf = self;
    //NSDictionary* info = [aNotification userInfo];
    [UIView animateWithDuration:0.0f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                     }
                     completion:^(BOOL finished) {
                     }];}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==self.nameTxtFld) {
        [self.aboutTxtView becomeFirstResponder];
        [self.signupScrvw setContentOffset:CGPointMake(0, self.aboutMeView.frame.origin.y+self.aboutMeView.frame.size.height-kbSize.height) animated:YES];
    }
    else
    {
        [textField resignFirstResponder];
        [self.signupScrvw setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.003 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self checkAndSetNextButtonEnable];
    });
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    /*
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.003 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.lbltextCount.text=[NSString stringWithFormat:@"%lu",(unsigned long)textView.text.length];
        [self checkAndSetNextButtonEnable];
    });
*/
   // /*
        if ([text isEqualToString:@""]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.003 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.lbltextCount.text=[NSString stringWithFormat:@"%lu/200",(unsigned long)textView.text.length];
                [self checkAndSetNextButtonEnable];
            });
        }
        else if (textView.text.length<200) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.003 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 self.lbltextCount.text=[NSString stringWithFormat:@"%lu/200",(unsigned long)textView.text.length];
                [self checkAndSetNextButtonEnable];
            });
        }
        else
            return NO;
    //*/
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
   // if (textView.text.length<100)
   // [[CSUtils sharedInstance] showNormalAlert:@"Come on, that's it? Give us least 100 characters of details to work from"];
}
- (IBAction)addPhotoButtonClicked:(id)sender {
    UIActionSheet *ImageAction;
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        ImageAction =[[UIActionSheet alloc]initWithTitle:@"Upload Profile Picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a photo",@"Choose from library", nil];
    }
    else
        ImageAction =[[UIActionSheet alloc]initWithTitle:@"Upload Profile Picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose from library", nil];
    
    
    ImageAction.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [ImageAction showInView:self.view];
}


- (IBAction)nextButtonClicked:(id)sender {
    if(self.nameTxtFld.text.length>0 && self.dobTxtFld.text.length>0 && self.genderTxtFld.text.length>0&& self.locationTxtFld.text.length>0&& (profileImageBase64.length>0 || self.isSignUpFromFacebook))
//        if (_aboutTxtView.text.length<100)
//            [[CSUtils sharedInstance] showNormalAlert:@"Come on, that's it? Give us least 100 characters of details to work from"];
//    else
        if(self.isSignUpFromFacebook){
             [self doLogin];
        } else {
             [self doSignup];
        }
    
    
    else
        [[CSUtils sharedInstance] showNormalAlert:@"Almost there, just complete everything"];
    //
    //[self performSegueWithIdentifier:@"loadMyInterestVC" sender:self];
}

- (IBAction)dobButtonClicked:(id)sender {
    [self.view endEditing:YES];
    [self datePickerViewFromDOB];
}

- (IBAction)genderButtonClicked:(id)sender {
    [self showGederOptionView];
    }
- (IBAction)backButtonClicked:(id)sender {
    if (self.signupviewdelegate) {
        if ([self.signupviewdelegate respondsToSelector:@selector(setUserInputData:About:Dob:Gender:Location:Image:)]) {
            [self.signupviewdelegate setUserInputData:_nameTxtFld.text About:_aboutTxtView.text Dob:_dobTxtFld.text Gender:_genderTxtFld.text Location:_locationTxtFld.text Image:_profileImage.image];
        }
    }

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark
#pragma mark Actionsheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==GENDER_ACTIONSHEET_TAG) {
        if (buttonIndex==0) {
            self.genderTxtFld.text=@"Male";
        }
        else
            self.genderTxtFld.text=@"Female";
    }
    else{
        switch(buttonIndex)
        {
            case 0:
            {
                if ([UIImagePickerController isSourceTypeAvailable:
                     UIImagePickerControllerSourceTypeCamera])
                {
                    UIImagePickerController *imagePicker =[[UIImagePickerController alloc]init];
                    imagePicker.delegate=self;
                    imagePicker.sourceType =UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:imagePicker animated:YES completion:nil];
                }
                else
                {
                    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
                    {
                        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
                        picker.delegate=self;
                        picker.sourceType =UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                        [self presentViewController:picker animated:YES completion:nil];
                    }
                    
                }
                break;
                
            }
            case 1:
            {
                if (buttonIndex==actionSheet.cancelButtonIndex) {
                    return;
                }
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
                {
                    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
                    picker.delegate=self;
                    picker.sourceType =UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                    [self presentViewController:picker animated:YES completion:nil];
                }
                break;
            }
            default:
            {
                break;
            }
        }
    }
    
}

#pragma mark-
#pragma mark-ImagePicker delegate


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    [self dismissModalViewControllerAnimated:YES];
    self.profileImage.image=[CSUtils imageByScalingAndCroppingForSize:CGSizeMake(560 , 560) Image:image];
    //converting image to bas64 string
    NSData *dataobj=UIImageJPEGRepresentation(self.profileImage.image, 1.0);
    profileImageBase64=[Base64 encodedata:dataobj];
    [self checkAndSetNextButtonEnable];
    [self blurImage:self.profileImage.image];
    // [[picker parentViewController] dismissModalViewControllerAnimated:YES];
}

/*
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}*/

-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void) datePickerViewFromDOB {
    
    UIToolbar *controlToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, pickerView.bounds.size.width, 44)];
    
    [controlToolbar sizeToFit];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissDateSet:)];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelDateSet)];
    
    [controlToolbar setItems:[NSArray arrayWithObjects:spacer, cancelButton, setButton, nil] animated:NO];
    if(theDatePicker == nil) {
        theDatePicker = [[UIDatePicker alloc] init];
        theDatePicker.datePickerMode = UIDatePickerModeDate;
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *currentDate = [NSDate date];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setYear:-60];
        NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
        
        [theDatePicker setMaximumDate:[NSDate date]];
        [theDatePicker setMinimumDate:minDate];
        [theDatePicker setBackgroundColor:[UIColor clearColor]];
    }
    [theDatePicker setFrame:CGRectMake(0, controlToolbar.frame.size.height - 15, theDatePicker.frame.size.width, theDatePicker.frame.size.height)];
    
    if (!pickerView) {
        pickerView = [[UIView alloc] initWithFrame:theDatePicker.frame];
    } else {
        [pickerView setHidden:NO];
    }
    
    
    CGFloat pickerViewYpositionHidden = self.view.frame.size.height + pickerView.frame.size.height;
    
    CGFloat pickerViewYposition = self.view.frame.size.height - pickerView.frame.size.height;
    
    [pickerView setFrame:CGRectMake(pickerView.frame.origin.x,
                                    pickerViewYpositionHidden,
                                    pickerView.frame.size.width,
                                    pickerView.frame.size.height)];
    [pickerView setBackgroundColor:[UIColor whiteColor]];
    [pickerView addSubview:controlToolbar];
    [pickerView addSubview:theDatePicker];
    [theDatePicker setHidden:NO];
    
    
    [self.view addSubview:pickerView];
    
    [UIView animateWithDuration:0.2f
                     animations:^{
                         [pickerView setFrame:CGRectMake(pickerView.frame.origin.x,
                                                         pickerViewYposition,
                                                         pickerView.frame.size.width,
                                                         pickerView.frame.size.height)];
                     }
                     completion:nil];
    
}

//And to dismiss the DatePicker:

-(void) cancelDateSet {
    CGFloat pickerViewYpositionHidden = self.view.frame.size.height + pickerView.frame.size.height;
    
    [UIView animateWithDuration:0.2f
                     animations:^{
                         [pickerView setFrame:CGRectMake(pickerView.frame.origin.x,
                                                         pickerViewYpositionHidden,
                                                         pickerView.frame.size.width,
                                                         pickerView.frame.size.height)];
                     }
                     completion:nil];
}
-(void)dismissDateSet:(id)sender{
    
    CGFloat pickerViewYpositionHidden = self.view.frame.size.height + pickerView.frame.size.height;
    
    [UIView animateWithDuration:0.2f
                     animations:^{
                         [pickerView setFrame:CGRectMake(pickerView.frame.origin.x,
                                                         pickerViewYpositionHidden,
                                                         pickerView.frame.size.width,
                                                         pickerView.frame.size.height)];
                         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                         [formatter setDateFormat:@"MM/dd/yyyy"];
                         
                         NSString *dateString = [formatter stringFromDate:theDatePicker.date];
                         
                         self.dobTxtFld.text =dateString;

                     }
                     completion:^(BOOL finished){
                         NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                         NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitYear
                                                                             fromDate:theDatePicker.date
                                                                               toDate:[NSDate date]
                                                                              options:0];
                         if (components.year<17) {
                             [[CSUtils sharedInstance] showNormalAlert:@"Users must be 17 or older to use Crescent. If you continue, we will delete your account"];
                         }
                         
                     }
                                 
     ];
    }

-(void)showGederOptionView
{
    if ([[CSUtils sharedInstance]getSystemVersion]>=8.0) {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Select your gender"
                                      message:nil
                                      preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* male = [UIAlertAction actionWithTitle:@"Male" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         self.genderTxtFld.text=@"Male";
                                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                                         
                                                     }];
        UIAlertAction* female = [UIAlertAction actionWithTitle:@"Female" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           self.genderTxtFld.text=@"Female";
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                           
                                                       }];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
        
        [alert addAction:male];
        [alert addAction:female];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        UIActionSheet *actionsheet=[[UIActionSheet alloc] initWithTitle:@"Select your gender" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Male",@"Female", nil];
        actionsheet.tag=GENDER_ACTIONSHEET_TAG;
        actionsheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionsheet showInView:self.view];
    }

}

-(void)doSignup
{
    if([[AFNetworkReachabilityManager sharedManager] isReachable]) // checking network reachable
    {
        [[CSUtils sharedInstance]showLoadingMode];

       // [SVProgressHUD showWithStatus:@"Loading"];
        self.view.userInteractionEnabled=NO;
        
        [[CSRequestController sharedInstance] doSignUpWithEmailId:self.emailid
                                                         Password:self.isSignUpFromFacebook==YES? @"" : self.password
                                                             Name:self.nameTxtFld.text
                                                        UserImage:self.isSignUpFromFacebook==YES? [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&width=1200",_userDict[@"id"]] : profileImageBase64
                                                             PhNo:self.isSignUpFromFacebook==YES? @"" : @""
                                                            About:[[CSUtils sharedInstance]
                                                                   checkNullStringAndReplace:self.aboutTxtView.text]
                                                         Birthday:self.dobTxtFld.text
                                                           Gender:self.genderTxtFld.text
                                                         Location:self.locationTxtFld.text
                                                        LoginType:self.isSignUpFromFacebook==YES ? @"F" : @"N"
                                                         Latitude:self.currentlatitude
                                                        Longitude:self.currentlongitude
                                                             FBID:self.isSignUpFromFacebook==YES ? _userDict[@"id"] : @""
                                                          success:^(NSDictionary *responsedict) {
                                                              
                                                              
                                                              
                                                              [[CSUtils sharedInstance]hideLoadingMode];

                                                              self.view.userInteractionEnabled=YES;
                                                              if ([responsedict[@"response"]integerValue]==200) {
                                                                 
                                                                  [CSUserHelper sharedInstance].userDict=[responsedict[@"user"] mutableCopy];
                                                                  [[CSUtils sharedInstance]saveUserDetailsIntoPlistFile];
                 
                                                                  
                                                                  if ([[CSUserHelper sharedInstance].userDict[@"isnewuser"] isEqualToString:@"1"]) {
                                                                     isCoachShow=@"SHOW";
                                                                  }
                                                                  else
                                                                      isCoachShow=@"HIDDEN";
                                                                  
                                                                  
                                                              
                                                                  
                                                                  
                                                                  if ([[CSUtils sharedInstance] hasQBId]){
                                                                      if ([CSUserHelper sharedInstance].userDict[@"interests"]) {
                                                                          NSString *str=[CSUserHelper sharedInstance].userDict[@"interests"];
                                                                          if (str.length>0) {
                                                                              CSWantViewController *mNotificationController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSWantViewController"];
                                                                              [self.navigationController pushViewController:mNotificationController animated:YES];
                                                                          }
                                                                          else
                                                                              [self performSegueWithIdentifier:@"loadMyInterestVC" sender:self];
                                                                      }
                                                                      else {
                                                                          [self performSegueWithIdentifier:@"loadMyInterestVC" sender:self];
                                                                      }
                                                                  } else {
                                                                      //QB User registration time
                                                                      [[CSUtils sharedInstance] showLoadingMode];
                                                                       self.view.userInteractionEnabled=NO;
                                                                      [self QBRegistration];
                                                                  }

                                                                  
                                                                 
                                                               
                                                              }
                                                              else if ([responsedict[@"response"]integerValue] ==201)
                                                              {
                                                                  [[CSUtils sharedInstance] showNormalAlert:responsedict[@"message"]];
                                                              }
                                                              
                                                              
                                                          }
                                                          failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             self.view.userInteractionEnabled=YES;
             [[CSUtils sharedInstance]hideLoadingMode];

             if (error.code==CSErrorCodeSessionExpired) {
                 [SVProgressHUD showErrorWithStatus:@"Connection timed out. Please try again!"];
             }
             else
             {
                 [SVProgressHUD showErrorWithStatus:@"Connection timed out. Please try again!"];
                 
             }
         }];
    }
    else
    {
        [[CSUtils sharedInstance]showNormalAlert:@"Please check your network connection and try again!"];
    }
}
-(void)doLogin
{
    if([[AFNetworkReachabilityManager sharedManager] isReachable]) // checking network reachable
    {
        [[CSUtils sharedInstance]showLoadingMode];
        
        // [SVProgressHUD showWithStatus:@"Loading"];
        self.view.userInteractionEnabled=NO;
        
        [[CSRequestController sharedInstance] doUpdateUserWithId:[CSUserHelper sharedInstance].userDict[@"user_id"] Email:self.emailid Password:self.isSignUpFromFacebook==YES?@"":self.password Name:self.nameTxtFld.text UserImage:self.isSignUpFromFacebook==YES?[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&width=1200",_userDict[@"id"]]:profileImageBase64 PhNo:self.isSignUpFromFacebook==YES?@"":@"" About:[[CSUtils sharedInstance] checkNullStringAndReplace:self.aboutTxtView.text] Birthday:self.dobTxtFld.text Gender:self.genderTxtFld.text Location:self.locationTxtFld.text LoginType:self.isSignUpFromFacebook==YES?@"F":@"N" Latitude:self.currentlatitude Longitude:self.currentlongitude FBID:self.isSignUpFromFacebook==YES?_userDict[@"id"]:@""
                                                          success:^(NSDictionary *responsedict){
                                                              
                                                              
                                                              
                                                              [[CSUtils sharedInstance]hideLoadingMode];
                                                              
                                                              self.view.userInteractionEnabled=YES;
                                                              if ([responsedict[@"response"]integerValue]==200) {
                                                                  
                                                                  [CSUserHelper sharedInstance].userDict=[responsedict[@"user"] mutableCopy];
                                                                  [[CSUtils sharedInstance]saveUserDetailsIntoPlistFile];
                                                                  

                                                                  
                                                                  
                                                                  if ([[CSUtils sharedInstance] hasQBId]){
                                                                      if ([CSUserHelper sharedInstance].userDict[@"interests"]) {
                                                                          NSString *str=[CSUserHelper sharedInstance].userDict[@"interests"];
                                                                          if (str.length>0) {
                                                                              CSWantViewController *mNotificationController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSWantViewController"];
                                                                              [self.navigationController pushViewController:mNotificationController animated:YES];
                                                                          }
                                                                          else
                                                                              [self performSegueWithIdentifier:@"loadMyInterestVC" sender:self];
                                                                      }
                                                                      else {
                                                                          [self performSegueWithIdentifier:@"loadMyInterestVC" sender:self];
                                                                      }
                                                                  } else {
                                                                      //QB User registration time
                                                                      [[CSUtils sharedInstance]showLoadingMode];
                                                                      self.view.userInteractionEnabled=NO;
                                                                      [self QBRegistration];
                                                                  }
                                                                  
                                                                  
                                                                  
                                                                  
                                                              }
                                                              else if ([responsedict[@"response"]integerValue] ==201)
                                                              {
                                                                  [[CSUtils sharedInstance] showNormalAlert:responsedict[@"message"]];
                                                              }
                                                              
                                                              
                                                          }
                                                          failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             self.view.userInteractionEnabled=YES;
             [[CSUtils sharedInstance]hideLoadingMode];
             
             if (error.code==CSErrorCodeSessionExpired) {
                 [SVProgressHUD showErrorWithStatus:@"Connection timed out. Please try again!"];
             }
             else
             {
                 [SVProgressHUD showErrorWithStatus:@"Connection timed out. Please try again!"];
                 
             }
         }];
    }
    else
    {
        [[CSUtils sharedInstance]showNormalAlert:@"Please check your network connection and try again!"];
    }
}


-(void)blurImage:(UIImage *)image {
    
    __block UIImage *returnImage;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // create our blurred image
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
        
        // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
        CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
        [filter setValue:inputImage forKey:kCIInputImageKey];
        [filter setValue:[NSNumber numberWithFloat:15.0f] forKey:@"inputRadius"];
        CIImage *result = [filter valueForKey:kCIOutputImageKey];
        
        // CIGaussianBlur has a tendency to shrink the image a little,
        // this ensures it matches up exactly to the bounds of our original image
        CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
        
        //create a UIImage for this function to "return" so that ARC can manage the memory of the blur... ARC can't manage CGImageRefs so we need to release it before this function "returns" and ends.
        returnImage = [UIImage imageWithCGImage:cgImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.profileBgImage.image=returnImage;
        });
        
        //release CGImageRef because ARC doesn't manage this on its own.
        CGImageRelease(cgImage);
    });
}


@end
