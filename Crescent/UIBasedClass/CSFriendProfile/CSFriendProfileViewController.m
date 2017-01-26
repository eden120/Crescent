//
//  CSFriendProfileViewController.m
//  Crescent
//
//  Created by Debaprasad Mondal on 20/12/14.
//  Copyright (c) 2014 Debaprasad Mondal. All rights reserved.
//

#import "CSFriendProfileViewController.h"
#import "CSUtils.h"
#import "ImageLabelView.h"
#import <UIImageView+AFNetworking.h>
#import <UIActionSheet+Blocks.h>

static const CGFloat ChoosePersonViewImageLabelWidth = 50.f;
static const CGFloat ChoosePersonViewImageLabelHeight =44.f;

@interface CSFriendProfileViewController ()
- (IBAction)doneButtonClicked:(id)sender;
@property(nonatomic, strong)NSMutableDictionary *userdict;
@property (nonatomic, readwrite) NSInteger selectedindex;
@end

@implementation CSFriendProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.profileScrView setContentSize:CGSizeMake(320*3, self.profileScrView.frame.size.height)];
    [self getFriendsProfile];
    UISwipeGestureRecognizer *swipeleftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    [swipeleftGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.profileScrView addGestureRecognizer:swipeleftGestureRecognizer];
    
    UISwipeGestureRecognizer *swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [swipeRightGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.profileScrView addGestureRecognizer:swipeRightGestureRecognizer];
    // Do any additional setup after loading the view.
    [self.bottomScrView setContentSize:self.aboutView.frame.size];
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

- (IBAction)doneButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getFriendsProfile
{
    if([[AFNetworkReachabilityManager sharedManager] isReachable]) // checking network reachable
    {
        [[CSUtils sharedInstance]showLoadingMode];

        self.view.userInteractionEnabled=NO;
        [[CSRequestController sharedInstance]getFriendsProfileWithUserId:[CSUserHelper sharedInstance].userDict[@"user_id"] Friendid:self.mperson.userid
                                                                 success:^(NSDictionary *responsedict){
                                                                     [[CSUtils sharedInstance]hideLoadingMode];

                                                                     self.view.userInteractionEnabled=YES;
                                                                     if ([responsedict[@"response"]integerValue]==200) {
                                                                         _userdict=[responsedict mutableCopy];
                                                                         [self setProfileDetails];
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

-(void)setProfileDetails
{
    self.lblProfileName.text=[NSString stringWithFormat:@"%@'s Profile",self.userdict[@"name"]];
    self.lblName.text=[NSString stringWithFormat:@"%@, %@",self.userdict[@"name"],self.userdict[@"age"]];
    self.lblLocation.text=self.userdict[@"location"];
    self.btnHeart.hidden=NO;
    if (self.mperson.isHeartImgLike ==1) {
        self.btnHeart.selected=YES;
    }
    else
        self.btnHeart.selected=NO;
    
    if (self.userdict[@"about"]==nil) {
        self.lblAbout.text=@"";
    }else
    self.lblAbout.text=[NSString stringWithFormat:@"\"%@\"",self.userdict[@"about"]];
    NSArray *temparr= [self.userdict[@"interests"] componentsSeparatedByString:@","];
    float X_origin=0;
    
    if ([self.userdict[@"userimage"] isKindOfClass:[NSArray class]]) {
        __weak NSArray *imagearr=self.userdict[@"userimage"];
        if (imagearr.count>0) {
            if ([imagearr[0] isKindOfClass:[NSDictionary class]]) {
               // [self.profileImage setImageWithURL:[NSURL URLWithString:imagearr[0][@"image"]]];
            }
            
        }
        float X_Origin=20;
        for (UIView *view in [self.profileScrView subviews] ) {
            if ([view isKindOfClass:[UIImageView class]]) {
                if (view.tag==1111) {
                    [view removeFromSuperview];
                }
                
            }
        }
        for (int i=0; i<imagearr.count; i++) {
            UIImageView *pimage=[[UIImageView alloc]initWithFrame:CGRectMake(X_Origin, 0, self.profileScrView.frame.size.width-40, self.profileScrView.frame.size.height)];
            pimage.tag=1111;
            pimage.clipsToBounds = YES;
            pimage.contentMode = UIViewContentModeScaleAspectFill;
            pimage.backgroundColor=[UIColor grayColor];
            [pimage setImageWithURL:[NSURL URLWithString:imagearr[i][@"image"]] placeholderImage:nil];
            [self.profileScrView addSubview:pimage];
            X_Origin=X_Origin+self.profileScrView.frame.size.width-30;
            
        }
        [self.profileScrView setContentOffset:CGPointMake(0, 0)];
        [self.profileScrView setContentSize:CGSizeMake(self.profileScrView.frame.size.width*imagearr.count, self.profileScrView.frame.size.height)];
        self.pageController.numberOfPages=imagearr.count;
        self.pageController.currentPage=0;

    }
    
   // self.pageController.numberOfPages=1;
   // self.pageController.currentPage=0;
    /*
    UIScrollView *interestsView;
    if (temparr.count<5) {
        interestsView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, _lblAbout.frame.origin.y+_lblAbout.frame.size.height+5, temparr.count*(ChoosePersonViewImageLabelWidth+10), ChoosePersonViewImageLabelHeight)];
    }else
        interestsView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, _lblAbout.frame.origin.y+_lblAbout.frame.size.height+5, self.view.frame.size.width-5, ChoosePersonViewImageLabelHeight)];
    
    
    for (int i=0; i<temparr.count; i++) {
        UIView *tempView= [self buildImageLabelViewLeftOf:X_origin
                                                    image:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%@",[temparr[i] lowercaseString]]]
                                                     text:temparr[i]];
        [interestsView addSubview:tempView];
        X_origin=X_origin+ChoosePersonViewImageLabelWidth+10;
        
    }
    interestsView.backgroundColor=[UIColor clearColor];
    
    interestsView.scrollEnabled=YES;
    [interestsView setShowsHorizontalScrollIndicator:NO];
    [interestsView setContentSize:CGSizeMake(X_origin, ChoosePersonViewImageLabelHeight)];
    [self.aboutView addSubview:interestsView];
    
    if (temparr.count<5){
       [interestsView setCenter:CGPointMake(self.view.frame.size.width/2, _lblAbout.frame.origin.y+_lblAbout.frame.size.height+(ChoosePersonViewImageLabelHeight/2))]; 
    }
    */
    X_origin=5;
    UIView *interestsView = [[UIView alloc] initWithFrame:CGRectMake(20, _lblAbout.frame.origin.y+_lblAbout.frame.size.height+5, temparr.count*(ChoosePersonViewImageLabelWidth+10), ChoosePersonViewImageLabelHeight)];
    interestsView.backgroundColor = [UIColor clearColor];
    for (int i=0; i<temparr.count; i++) {
        UIView *tempView= [self buildImageLabelViewLeftOf:X_origin
                                                    image:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%@",[temparr[i] lowercaseString]]]
                                                     text:temparr[i]];
        [interestsView addSubview:tempView];
        X_origin=X_origin+ChoosePersonViewImageLabelWidth+8;
        
    }
    [self.aboutView addSubview:interestsView];
    [interestsView setCenter:CGPointMake(self.view.frame.size.width/2, _lblAbout.frame.origin.y+_lblAbout.frame.size.height+(ChoosePersonViewImageLabelHeight/2))];

}

- (ImageLabelView *)buildImageLabelViewLeftOf:(CGFloat)x image:(UIImage *)image text:(NSString *)text {
    CGRect frame = CGRectMake(x ,
                              0,
                              ChoosePersonViewImageLabelWidth,
                              ChoosePersonViewImageLabelHeight);
    ImageLabelView *view = [[ImageLabelView alloc] initWithFrame:frame
                                                           image:image
                                                            text:text];
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    return view;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int indexOfPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageController.currentPage=indexOfPage;
    //your stuff with index
}

#pragma mark -
#pragma mark - Handle Swipe method -

// Swipe the view left to view the next news
-(void)handleSwipeLeft:(UIGestureRecognizer *)gesture
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    if ([self.userdict[@"userimage"] isKindOfClass:[NSArray class]]) {
        __weak NSArray *imageArr=self.userdict[@"userimage"];
    if (self.selectedindex<[imageArr count]-1) {
        self.selectedindex++;
        [self.profileScrView scrollRectToVisible:CGRectMake(self.selectedindex*(self.profileScrView.frame.size.width-30), self.profileScrView.frame.origin.y, self.profileScrView.frame.size.width, self.profileScrView.frame.size.height) animated:YES];
        self.pageController.currentPage=self.selectedindex;
    }
    }
}

// Swipe the view right to view the previous news
-(void)handleSwipeRight:(UIGestureRecognizer *)gesture
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    if (self.selectedindex>0) {
        self.selectedindex--;
        [self.profileScrView scrollRectToVisible:CGRectMake(self.selectedindex*(self.profileScrView.frame.size.width-30), self.profileScrView.frame.origin.y, self.profileScrView.frame.size.width, self.profileScrView.frame.size.height) animated:YES];
        self.pageController.currentPage=self.selectedindex;
    }
}

-(IBAction)heartButtonClicked:(id)sender
{
    UIButton *btnTemp=(UIButton *)sender;
    NSString *isLike;
    
    if([[AFNetworkReachabilityManager sharedManager] isReachable]) // checking network reachable
    {
        if (btnTemp.selected) {
            btnTemp.selected=NO;
            isLike=@"0";
        }
        else{
            btnTemp.selected=YES;
            isLike=@"1";
        }
        [[CSRequestController sharedInstance]profileLikeOrDislikeWithUserId:[CSUserHelper sharedInstance].userDict[@"user_id"] FriendId:self.userdict[@"user_id"] Likestatus:isLike
                                                                    success:^(NSDictionary *responsedict){
                                                                        if ([responsedict[@"response"]integerValue]==200) {
                                                                            _mperson.isHeartImgLike=[isLike integerValue];
                                                                            _likeButton.selected=[isLike boolValue];
                                                                           // Post_Notification(@"likeOrDislikePeople", isLike);
                                                                            
                                                                            if ([responsedict[@"success"]integerValue]==1) {
                                                                                  // [[CSUtils sharedInstance]showNormalAlert:[NSString stringWithFormat:@"%@",responsedict[@"message"]]];
                                                                                
                                                                               /* if ([_person.deviceName isEqualToString:@"android"] && _person.deviceToken!=nil && [isLike isEqualToString:@"1"]) {
                                                                                    
                                                                                    [[CSRequestController sharedInstance]sendNotiFicationinAndroidDeviceWithDeviceToken:_person.deviceToken Messages:[NSString stringWithFormat:@"%@ Likes Your Photo",[CSUserHelper sharedInstance].userDict[@"name"]] success:^(NSDictionary *responseObject) {
                                                                                        
                                                                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                                        
                                                                                    }];
                                                                                    
                                                                                }*/
                                                                                
                                                                            }
                                                                            
                                                                        }
                                                                        
                                                                    }
                                                                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             
         }];
    }
    else
    {
        [[CSUtils sharedInstance]showNormalAlert:@"Please check your network connection and try again!"];
    }
    
}

-(IBAction)showBlockAlert:(id)sender{

[UIActionSheet showInView:self.view
                withTitle:nil
        cancelButtonTitle:@"Cancel"
   destructiveButtonTitle:nil
        otherButtonTitles:@[@"Block User", @"Report User"]
                 tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                     if (actionSheet.cancelButtonIndex == buttonIndex)
                         return;
                     
                     if(buttonIndex == 0){
                         if([[AFNetworkReachabilityManager sharedManager] isReachable]) // checking network reachable
                         {
                             
                             [[CSRequestController sharedInstance] profileBlockWithUserId:[CSUserHelper sharedInstance].userDict[@"user_id"] FriendId:self.userdict[@"user_id"] Reason:@""
                                                                                         success:^(NSDictionary *responsedict){
                                                                                             if ([responsedict[@"response"]integerValue]==200) {

                                                                                                    [self.navigationController popViewControllerAnimated:YES];
                                                                                                    [self performSegueWithIdentifier:@"findPeopleAfterBlock" sender:self];
                                                                                                 
                                                                                                 
                                                                                             }
                                                                                             
                                                                                         }
                                                                                         failure:^(AFHTTPRequestOperation *operation, NSError *error)
                              {
                                  
                              }];
                         }
                         else
                         {
                             [[CSUtils sharedInstance] showNormalAlert:@"Please check your network connection and try again!"];
                         }
                     } else {
                         if([[AFNetworkReachabilityManager sharedManager] isReachable]) // checking network reachable
                         {
                             
                             [[CSRequestController sharedInstance] reportUserkWithUserId:[CSUserHelper sharedInstance].userDict[@"user_id"] FriendId:self.userdict[@"user_id"] Reason:@""
                                                                                         success:^(NSDictionary *responsedict){
                                                                                             if ([responsedict[@"response"]integerValue]==200) {
                                                                                                     [[CSUtils sharedInstance] showNormalAlert:@"Reported"];

                                                                                             }
                                                                                             
                                                                                         }
                                                                                         failure:^(AFHTTPRequestOperation *operation, NSError *error)
                              {
                                  
                              }];
                         }
                         else
                         {
                             [[CSUtils sharedInstance] showNormalAlert:@"Please check your network connection and try again!"];
                         }
                     }
                     
           
                 }];
}

@end
