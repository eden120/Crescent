//
//  CSEditMyProfileViewController.m
//  Crescent
//
//  Created by Debaprasad Mondal on 19/12/14.
//  Copyright (c) 2014 Debaprasad Mondal. All rights reserved.
//

#import "CSEditMyProfileViewController.h"
#import "CSUtils.h"
#import "Base64.h"
#import <SDWebImage/UIImageView+WebCache.h>


#define GENDER_ACTIONSHEET_TAG 99

@interface CSEditMyProfileViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextViewDelegate,UITextFieldDelegate>
{
    UIDatePicker *theDatePicker;
    UIView *pickerView;
    NSString *myInterests;
}
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)saveButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *myProfileTable;
@property (strong, nonatomic)NSArray *menuOptionArray;
@property (strong, nonatomic)NSArray *iconImageArr;
@property (strong, nonatomic)NSMutableArray *arrPicture;

@end

@implementation CSEditMyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuOptionArray=[NSArray arrayWithObjects:@"Fashion",@"Sports",@"Politics",@"Music",@"Fitness",@"Tech",@"Food",@"Business",@"Art",@"Movies",@"Travel",@"Events", nil];
    self.iconImageArr=[NSArray arrayWithObjects:@"icon_fashion",@"icon_sports",@"icon_politics",@"icon_music",@"icon_fitness",@"icon_tech",@"icon_food",@"icon_business",@"icon_art",@"icon_movies",@"icon_travel",@"icon_events", nil];
    _arrPicture=[NSMutableArray array];
    __weak NSArray *imageArr=[CSUserHelper sharedInstance].userDict[@"userimage"];
    for (int i=0; i <imageArr.count; i ++) {
        [self.arrPicture addObject:[NSNull null]];
    }
    myInterests=[CSUserHelper sharedInstance].userDict[@"interests"];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return 288;
            break;
        case 1:
            return 322;
            break;
        case 2:
            return 540;
            break;
            
        default:
            break;
    }
    return 0;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    if (indexPath.row==0) {
        cell= [tableView dequeueReusableCellWithIdentifier:@"myProfileFirstCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myProfileFirstCell"];
        }
        
         pImage1=(UIImageView*)[cell.contentView viewWithTag:1];
         pImage2=(UIImageView*)[cell.contentView viewWithTag:2];
         pImage3=(UIImageView*)[cell.contentView viewWithTag:3];
         pImage4=(UIImageView*)[cell.contentView viewWithTag:4];
        
        btnCross1=(UIButton*)[cell.contentView viewWithTag:5];
        btnCross2=(UIButton*)[cell.contentView viewWithTag:6];
        btnCross3=(UIButton*)[cell.contentView viewWithTag:7];
        btnCross4=(UIButton*)[cell.contentView viewWithTag:8];
        
        btnAdd1=(UIButton*)[cell.contentView viewWithTag:10];
        btnAdd2=(UIButton*)[cell.contentView viewWithTag:11];
        btnAdd3=(UIButton*)[cell.contentView viewWithTag:12];
        btnAdd4=(UIButton*)[cell.contentView viewWithTag:13];
        [btnAdd1 addTarget:self action:@selector(clickToAdd:) forControlEvents:UIControlEventTouchUpInside];
        [btnAdd2 addTarget:self action:@selector(clickToAdd:) forControlEvents:UIControlEventTouchUpInside];
        [btnAdd3 addTarget:self action:@selector(clickToAdd:) forControlEvents:UIControlEventTouchUpInside];
        [btnAdd4 addTarget:self action:@selector(clickToAdd:) forControlEvents:UIControlEventTouchUpInside];
        [btnCross1 addTarget:self action:@selector(clickToCross:) forControlEvents:UIControlEventTouchUpInside];
        [btnCross2 addTarget:self action:@selector(clickToCross:) forControlEvents:UIControlEventTouchUpInside];
        [btnCross3 addTarget:self action:@selector(clickToCross:) forControlEvents:UIControlEventTouchUpInside];
        [btnCross4 addTarget:self action:@selector(clickToCross:) forControlEvents:UIControlEventTouchUpInside];
        __weak NSArray *imageArr=[CSUserHelper sharedInstance].userDict[@"userimage"];
        
        if (imageArr.count==1) {
//            [self.arrPicture addObject:[NSNull null]];
            [self setProfileImage:pImage1 Imageurl:imageArr[0][@"image"] Index:0];
        }
        else if (imageArr.count==2) {
            //[self.arrPicture addObject:[NSNull null]];
            //[self.arrPicture addObject:[NSNull null]];
            [self setProfileImage:pImage1 Imageurl:imageArr[0][@"image"] Index:0];
            [self setProfileImage:pImage2 Imageurl:imageArr[1][@"image"] Index:1];
        }
        else if (imageArr.count==3) {
//            [self.arrPicture addObject:[NSNull null]];
//            [self.arrPicture addObject:[NSNull null]];
//            [self.arrPicture addObject:[NSNull null]];
            [self setProfileImage:pImage1 Imageurl:imageArr[0][@"image"] Index:0];
            [self setProfileImage:pImage2 Imageurl:imageArr[1][@"image"] Index:1];
            [self setProfileImage:pImage3 Imageurl:imageArr[2][@"image"] Index:2];
        }
        else if (imageArr.count==4) {
//            [self.arrPicture addObject:[NSNull null]];
//            [self.arrPicture addObject:[NSNull null]];
//            [self.arrPicture addObject:[NSNull null]];
//            [self.arrPicture addObject:[NSNull null]];
            [self setProfileImage:pImage1 Imageurl:imageArr[0][@"image"] Index:0];
            [self setProfileImage:pImage2 Imageurl:imageArr[1][@"image"] Index:1];
            [self setProfileImage:pImage3 Imageurl:imageArr[2][@"image"] Index:2];
            [self setProfileImage:pImage4 Imageurl:imageArr[3][@"image"] Index:3];
        }
        
        [self setButtonInteraction];
        [self SetNewImagesOfProduct];
    }
    else if (indexPath.row==1)
    {
        cell= [tableView dequeueReusableCellWithIdentifier:@"myProfileSecondCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myProfileSecondCell"];
        }
        usernameTxtFld=(UITextField *)[cell.contentView viewWithTag:1];
         dobTxtFld=(UITextField *)[cell.contentView viewWithTag:3];
         genderTxtFld=(UITextField *)[cell.contentView viewWithTag:5];
         aboutTxtVw=(UITextView *)[cell.contentView viewWithTag:2];
         lblAboutTextCount=(UILabel *)[cell.contentView viewWithTag:11];
        usernameTxtFld.delegate=self;
        aboutTxtVw.delegate=self;
        [usernameTxtFld setText:[CSUserHelper sharedInstance].userDict[@"name"]];
        [aboutTxtVw setText:[CSUserHelper sharedInstance].userDict[@"about"]];
        [genderTxtFld setText:[CSUserHelper sharedInstance].userDict[@"gender"]];
        [dobTxtFld setText:[CSUserHelper sharedInstance].userDict[@"birthday"]];
        lblAboutTextCount.text=[NSString stringWithFormat:@"%lu/200",(unsigned long)aboutTxtVw.text.length];
        UIButton *btnGender=(UIButton*)[cell.contentView viewWithTag:13];
        [btnGender addTarget:self action:@selector(genderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *btnDOB=(UIButton*)[cell.contentView viewWithTag:12];
        [btnDOB addTarget:self action:@selector(dobButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        

    }
    else
    {
        cell= [tableView dequeueReusableCellWithIdentifier:@"myProfileThirdCell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myProfileThirdCell"];
            }

    }
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)setProfileImage:(UIImageView *)imageview Imageurl:(NSString *)imageurl Index:(NSInteger)index
{
    
    /*
    __weak typeof(self) weakSelf = self;
    [imageview setImageWithURLRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageurl]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0]  placeholderImage:[UIImage imageNamed:@""] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [weakSelf.arrPicture replaceObjectAtIndex:index withObject:image];
        
        
    }
     
                            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                NSLog(@"Image load error %@", error.localizedDescription);
                            }];
     */
    __weak typeof(self) weakSelf = self;
    [imageview sd_setImageWithURL:[NSURL URLWithString:imageurl] completed:^(UIImage * image, NSError * error, SDImageCacheType cacheType, NSURL * imageUrl){
        if(!error){
            [weakSelf.arrPicture replaceObjectAtIndex:index withObject:image];
        } else {
             NSLog(@"Image load error %@", error.localizedDescription);
        }
        
    }];
    
}

#pragma mark -
#pragma mark UICollectionViewDataSource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout* )collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return (CGSize){94,94};
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 9;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    /* if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
     {
     return self.menuOptionArray.count;
     }
     else if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
     return 2;
     else
     return 0;*/
    return 1;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.menuOptionArray.count;
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(10, 10, 0, 10);
    
    
}
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell;
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myInterestCell" forIndexPath:indexPath]; // cell for iphone 5, 5s, 4 devices.
    
    UILabel *lblMenuOption=(UILabel *)[cell viewWithTag:11];
    UIImageView *imgMenuBG=(UIImageView *)[cell viewWithTag:1];
    
    UIImageView *imgMenuOption=(UIImageView *)[cell viewWithTag:2];
    [lblMenuOption setText:self.menuOptionArray [indexPath.row]];
    imgMenuOption.image = [UIImage imageNamed:self.iconImageArr [indexPath.row]];
    if ([myInterests rangeOfString:self.menuOptionArray [indexPath.row]].location==NSNotFound)
        imgMenuBG.layer.borderColor=[UIColor lightGrayColor].CGColor;
    else
        imgMenuBG.layer.borderColor=[UIColor colorWithRed:235.0/255.0 green:54.0/255.0 blue:44.0/255.0 alpha:1.0].CGColor;
    
    imgMenuBG.layer.borderWidth=1.0;
    return cell;
}

#pragma mark -
#pragma UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
        NSArray *temparr=[myInterests componentsSeparatedByString:@","];
        if ([temparr containsObject:self.menuOptionArray [indexPath.row]]) {
            myInterests=[myInterests stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",self.menuOptionArray [indexPath.row]] withString:@""];
            myInterests=[myInterests stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@",%@",self.menuOptionArray [indexPath.row]] withString:@""];
            myInterests=[myInterests stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@",self.menuOptionArray [indexPath.row]] withString:@""];
            
        }
        else
        {
            if (temparr.count<5) {
                
                if ([myInterests rangeOfString:self.menuOptionArray [indexPath.row]].location==NSNotFound) {
                    if (myInterests.length>0) {
                        myInterests=[myInterests stringByAppendingString:[NSString stringWithFormat:@",%@",self.menuOptionArray [indexPath.row]]];
                    }
                    else
                        myInterests=[myInterests stringByAppendingString:[NSString stringWithFormat:@"%@",self.menuOptionArray [indexPath.row]]];
                    
                }
                else{
                    NSArray *temparr=[myInterests componentsSeparatedByString:@","];
                    myInterests=@"";
                    for (int i=0; i<temparr.count; i++) {
                        if (![temparr[i] isEqualToString:self.menuOptionArray [indexPath.row]]) {
                            if (myInterests.length>0) {
                                myInterests=[myInterests stringByAppendingString:[NSString stringWithFormat:@",%@",temparr[i]]];
                            }
                            else
                                myInterests=[myInterests stringByAppendingString:[NSString stringWithFormat:@"%@",temparr[i]]];
                        }
                        
                    }
                    
                }
            }
        }
        
        [collectionView reloadData];
}

#pragma mark
#pragma mark Actionsheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==GENDER_ACTIONSHEET_TAG) {
        if (buttonIndex==0) {
            genderTxtFld.text=@"Male";
        }
        else
            genderTxtFld.text=@"Female";
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
    
    if(self.arrPicture.count<4)
    {
        image=[CSUtils imageByScalingAndCroppingForSize:CGSizeMake(560 , 560) Image:image];
        [self.arrPicture addObject:image];
    }
    [self setButtonInteraction];
    [self SetNewImagesOfProduct];
    // [[picker parentViewController] dismissModalViewControllerAnimated:YES];
}


-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveButtonClicked:(id)sender {
    if (myInterests.length>0) {
        NSArray *temparr=[myInterests componentsSeparatedByString:@","];
        //temparr.count>=3&&
        if (usernameTxtFld.text.length>0&& dobTxtFld.text.length>0&& genderTxtFld.text.length>0) {
            [self updateMyProfile];
        }
//        else if(aboutTxtVw.text.length==0)
//        {
//           [[CSUtils sharedInstance] showNormalAlert:@"Tell us a little about yourself."];
//        }
        else if(usernameTxtFld.text.length==0)
        {
            [[CSUtils sharedInstance] showNormalAlert:@"Please enter your user name."];
        }
        else if(dobTxtFld.text.length==0)
        {
            [[CSUtils sharedInstance] showNormalAlert:@"Please enter your date of birth."];
        }
        if(genderTxtFld.text.length==0)
        {
            [[CSUtils sharedInstance] showNormalAlert:@"Please select your gender."];
        }
        
       // else
         //   [[CSUtils sharedInstance] showNormalAlert:@"You must love something. Give us at least 3 interests"];
    }
    else
        [[CSUtils sharedInstance] showNormalAlert:@"You must love something. Give us at least 1 interests"];
}
-(IBAction)clickToCross:(id)sender
{
    UIButton *bt=(UIButton *)sender;
    if(self.arrPicture.count>=(bt.tag-4))
    {
        [self.arrPicture removeObjectAtIndex:bt.tag-5];
    }
    [self setButtonInteraction];
    [self SetNewImagesOfProduct];
}
-(void)clickToAdd:(id)sender
{
    UIActionSheet *ImageAction;
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        ImageAction =[[UIActionSheet alloc]initWithTitle:@"Upload Profile Picture" delegate:self cancelButtonTitle:@"Cancel"destructiveButtonTitle:nil otherButtonTitles:@"Take a Photo",@"Choose from Library", nil];
    }
    else
        ImageAction =[[UIActionSheet alloc]initWithTitle:@"Upload Profile Picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose from Library", nil];
    
    ImageAction.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [ImageAction showInView:self.view];
}
- (IBAction)dobButtonClicked:(id)sender {
    [self datePickerViewFromDOB];
}

- (IBAction)genderButtonClicked:(id)sender {
    [self showGederOptionView];
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
                         
                         dobTxtFld.text =dateString;
                         
                     }
                     completion:^(BOOL finished){
                         NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                         NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitYear
                                                                             fromDate:theDatePicker.date
                                                                               toDate:[NSDate date]
                                                                              options:0];
                         if (components.year<17) {
                             [[CSUtils sharedInstance] showNormalAlert:@"Crescent is for people 17+. We recommend trying then. If you continue, we will delete your account"];
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
                                                         genderTxtFld.text=@"Male";
                                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                                         
                                                     }];
        UIAlertAction* female = [UIAlertAction actionWithTitle:@"Female" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           genderTxtFld.text=@"Female";
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

-(void)SetNewImagesOfProduct
{
    if(self.arrPicture.count==1)
    {
        if (![self.arrPicture[0] isKindOfClass:[NSNull class]]) {
            pImage1.image=[self.arrPicture objectAtIndex:0];
        }
        
        pImage2.image=[UIImage imageNamed:@"picture_add"];
        pImage3.image=[UIImage imageNamed:@"picture_add"];
        pImage4.image=[UIImage imageNamed:@"picture_add"];
    }
    else if(self.arrPicture.count==2)
    {
        if (![self.arrPicture[0] isKindOfClass:[NSNull class]]) {
            pImage1.image=[self.arrPicture objectAtIndex:0];
        }
        if (![self.arrPicture[1] isKindOfClass:[NSNull class]]) {
            pImage2.image=[self.arrPicture objectAtIndex:1];
        }
        
        pImage3.image=[UIImage imageNamed:@"picture_add"];
        pImage4.image=[UIImage imageNamed:@"picture_add"];
    }
    else if(self.arrPicture.count==3)
    {
        if (![self.arrPicture[0] isKindOfClass:[NSNull class]]) {
            pImage1.image=[self.arrPicture objectAtIndex:0];
        }
        if (![self.arrPicture[1] isKindOfClass:[NSNull class]]) {
            pImage2.image=[self.arrPicture objectAtIndex:1];
        }
        if (![self.arrPicture[2] isKindOfClass:[NSNull class]]) {
            pImage3.image=[self.arrPicture objectAtIndex:2];
        }
        
        pImage4.image=[UIImage imageNamed:@"picture_add"];
        
    }
    else if(self.arrPicture.count==4)
    {
        if (![self.arrPicture[0] isKindOfClass:[NSNull class]]) {
            pImage1.image=[self.arrPicture objectAtIndex:0];
        }
        if (![self.arrPicture[1] isKindOfClass:[NSNull class]]) {
            pImage2.image=[self.arrPicture objectAtIndex:1];
        }
        if (![self.arrPicture[2] isKindOfClass:[NSNull class]]) {
            pImage3.image=[self.arrPicture objectAtIndex:2];
        }
        if (![self.arrPicture[3] isKindOfClass:[NSNull class]]) {
            pImage4.image=[self.arrPicture objectAtIndex:3];
        }
    }
    else
    {
        pImage1.image=[UIImage imageNamed:@"picture_add"];
        pImage2.image=[UIImage imageNamed:@"picture_add"];
        pImage3.image=[UIImage imageNamed:@"picture_add"];
        pImage4.image=[UIImage imageNamed:@"picture_add"];
    }
    
    
}

-(void)setButtonInteraction
{
    if(self.arrPicture.count==1)
    {
        btnAdd1.userInteractionEnabled=NO;
        btnAdd2.userInteractionEnabled=YES;
        btnAdd3.userInteractionEnabled=NO;
        btnAdd4.userInteractionEnabled=NO;
        btnCross1.hidden=NO;
        btnCross2.hidden=YES;
        btnCross3.hidden=YES;
        btnCross4.hidden=YES;
    }
    else if(self.arrPicture.count==2)
    {
        btnAdd1.userInteractionEnabled=NO;
        btnAdd2.userInteractionEnabled=NO;
        btnAdd3.userInteractionEnabled=YES;
        btnAdd4.userInteractionEnabled=NO;
        btnCross1.hidden=NO;
        btnCross2.hidden=NO;
        btnCross3.hidden=YES;
        btnCross4.hidden=YES;
    }
    else if(self.arrPicture.count>=3)
    {
        btnAdd1.userInteractionEnabled=NO;
        btnAdd2.userInteractionEnabled=NO;
        btnAdd3.userInteractionEnabled=NO;
        btnAdd4.userInteractionEnabled=YES;
        btnCross1.hidden=NO;
        btnCross2.hidden=NO;
        btnCross3.hidden=NO;
        btnCross4.hidden=YES;
        if (self.arrPicture.count==4) {
            btnCross4.hidden=NO;
            pImage4.userInteractionEnabled=NO;
        }
    }
    
    else
    {
        btnAdd1.userInteractionEnabled=YES;
        btnAdd2.userInteractionEnabled=NO;
        btnAdd3.userInteractionEnabled=NO;
        btnAdd4.userInteractionEnabled=NO;
        btnCross1.hidden=YES;
        btnCross2.hidden=YES;
        btnCross3.hidden=YES;
        btnCross4.hidden=YES;
    }
}
//-(void)checkAndSetNextButtonEnable
//{
//    if([usernameTxtFld.text length]>0 && [aboutTxtVw.text length]>0 && [dobTxtFld.text length]>0 && [genderTxtFld.text length]>0 )
//        btn.enabled=YES;
//    else
//        _btnNext.enabled=NO;
//}
#pragma mark -
#pragma mark - Text field delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.myProfileTable setContentOffset:CGPointMake(0, 200) animated:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
        
   return YES;
}
#pragma mark -
#pragma mark - Text view delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.myProfileTable setContentOffset:CGPointMake(0, 280) animated:YES];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    /*
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.003 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        lblAboutTextCount.text=[NSString stringWithFormat:@"%lu",(unsigned long)textView.text.length];
        //[self checkAndSetNextButtonEnable];
    });
     */
    ///*
    if ([text isEqualToString:@""]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.003 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            lblAboutTextCount.text=[NSString stringWithFormat:@"%lu/200",(unsigned long)textView.text.length];
            //[self checkAndSetNextButtonEnable];
        });
    }
    else if (textView.text.length<200) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.003 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            lblAboutTextCount.text=[NSString stringWithFormat:@"%lu/200",(unsigned long)textView.text.length];
           // [self checkAndSetNextButtonEnable];
        });
    }
    else
        return NO;
    //*/
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    //if (textView.text.length<100)
      //  [[CSUtils sharedInstance] showNormalAlert:@"Come on, that's it? Give us least 100 characters of details to work from"];
}

-(void)updateMyProfile
{
    if([[AFNetworkReachabilityManager sharedManager] isReachable]) // checking network reachable
    {
        [[CSUtils sharedInstance]showLoadingMode];

        //[SVProgressHUD showWithStatus:@"Updating..."];
        self.view.userInteractionEnabled=NO;
        NSString *profileimage1=@"";
        NSString *profileimage2=@"";
        NSString *profileimage3=@"";
        NSString *profileimage4=@"";
        if (self.arrPicture.count==1) {
            if (![self.arrPicture[0] isKindOfClass:[NSNull class]]) {
                NSData *dataobj=UIImageJPEGRepresentation(self.arrPicture[0], 1.0);
                profileimage1=[Base64 encodedata:dataobj];
            }
        }
        if (self.arrPicture.count==2) {
            if (![self.arrPicture[0] isKindOfClass:[NSNull class]]) {
                NSData *dataobj=UIImageJPEGRepresentation(self.arrPicture[0], 1.0);
                profileimage1=[Base64 encodedata:dataobj];
            }
            if (![self.arrPicture[1] isKindOfClass:[NSNull class]]) {
                NSData *dataobj=UIImageJPEGRepresentation(self.arrPicture[1], 1.0);
                profileimage2=[Base64 encodedata:dataobj];
            }
        }
        if (self.arrPicture.count==3) {
            if (![self.arrPicture[0] isKindOfClass:[NSNull class]]) {
                NSData *dataobj=UIImageJPEGRepresentation(self.arrPicture[0], 1.0);
                profileimage1=[Base64 encodedata:dataobj];
            }
            if (![self.arrPicture[1] isKindOfClass:[NSNull class]]) {
                NSData *dataobj=UIImageJPEGRepresentation(self.arrPicture[1], 1.0);
                profileimage2=[Base64 encodedata:dataobj];
            }
            if (![self.arrPicture[2] isKindOfClass:[NSNull class]]) {
                NSData *dataobj=UIImageJPEGRepresentation(self.arrPicture[2], 1.0);
                profileimage3=[Base64 encodedata:dataobj];
            }

        }
        if (self.arrPicture.count==4) {
            if (![self.arrPicture[0] isKindOfClass:[NSNull class]]) {
                NSData *dataobj=UIImageJPEGRepresentation(self.arrPicture[0], 1.0);
                profileimage1=[Base64 encodedata:dataobj];
            }
            if (![self.arrPicture[1] isKindOfClass:[NSNull class]]) {
                NSData *dataobj=UIImageJPEGRepresentation(self.arrPicture[1], 1.0);
                profileimage2=[Base64 encodedata:dataobj];
            }
            if (![self.arrPicture[2] isKindOfClass:[NSNull class]]) {
                NSData *dataobj=UIImageJPEGRepresentation(self.arrPicture[2], 1.0);
                profileimage3=[Base64 encodedata:dataobj];
            }
            if (![self.arrPicture[3] isKindOfClass:[NSNull class]]) {
                NSData *dataobj=UIImageJPEGRepresentation(self.arrPicture[3], 1.0);
                profileimage4=[Base64 encodedata:dataobj];
            }
            
        }
       
        [[CSRequestController sharedInstance]updateProfileWithUserId:[CSUserHelper sharedInstance].userDict[@"user_id"] Name:usernameTxtFld.text About:aboutTxtVw.text Birthday:dobTxtFld.text Gender:genderTxtFld.text Interests:myInterests Image1:profileimage1 Image2:profileimage2 Image3:profileimage3 Image4:profileimage4  success:^(NSDictionary *responsedict){
            [[CSUtils sharedInstance]hideLoadingMode];

            self.view.userInteractionEnabled=YES;
            if ([responsedict[@"response"]integerValue]==200) {
                [CSUserHelper sharedInstance].userDict=[responsedict[@"user"] mutableCopy];
                [[CSUtils sharedInstance]saveUserDetailsIntoPlistFile];
                [SVProgressHUD showSuccessWithStatus:@"Your profile has been succcessfully updated" maskType:SVProgressHUDMaskTypeBlack];
                [self.navigationController popViewControllerAnimated:YES];
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

@end
