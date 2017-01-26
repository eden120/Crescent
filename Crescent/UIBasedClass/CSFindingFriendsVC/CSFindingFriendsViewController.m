//
//  CSFindingFriendsViewController.m
//  Crescent
//
//  Created by Debaprasad Mondal on 09/12/14.
//  Copyright (c) 2014 Debaprasad Mondal. All rights reserved.
//

#import "CSFindingFriendsViewController.h"
#import "CSUtils.h"
#import <UIImageView+AFNetworking.h>
#import "CSDashboardViewController.h"
#import "CSNotificationViewController.h"

#define kPageSize 20
#define kFirstPage 1

@interface CSFindingFriendsViewController ()<DashboardViewDelegate>
{
    UIColor *rippleColor;
    NSArray *rippleColors;
    CAShapeLayer *circleShape;
    BOOL isLocationFound;
    NSInteger totalCount;
    int pageno;
}

@property (strong, nonatomic) NSMutableArray *arrFriends;
@property (assign, nonatomic) BOOL needReload;

- (IBAction)allowLocationButtonClicked:(id)sender;

@end

@implementation CSFindingFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    pageno=kFirstPage;
    self.profileView.layer.cornerRadius = self.profileView.frame.size.height/2;
    self.profileView.layer.borderWidth = 5;
    self.profileView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:0.9].CGColor;
    self.profileImageView.layer.cornerRadius=self.profileImageView.frame.size.width/2;
    self.profileImageView.layer.masksToBounds=YES;
    NSArray *imagearr=[CSUserHelper sharedInstance].userDict[@"userimage"];
    NSString *userimage=@"";
    if (imagearr.count>0) {
        userimage=imagearr[0][@"image"];
    }
    [self.profileImageView setImageWithURL:[NSURL URLWithString:userimage] placeholderImage:nil];
    rippleColor=[UIColor colorWithRed:246.f/255.f green:61.f/255.f blue:52.f/255.f alpha:1];
 //   [CSUtils sharedInstance].appDelegate.isLocationFound=NO;
  //  [[CSUtils sharedInstance].appDelegate.locationManager startUpdatingLocation];

    _arrFriends=[NSMutableArray array];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.005 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setRippleAnimation];
        [self getFindPeople];
    });
    
   // [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getFindPeople) name:@"findpeople" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.arrFriends removeAllObjects];
    
    if (self.needReload) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            self.needReload = NO;
            [self.navigationController popViewControllerAnimated:YES];
            
        });
        
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    
//    if (circleShape) {
//        [_profileView.layer removeFromSuperlayer];
//        [circleShape removeAllAnimations];
//        circleShape=nil;
//    }
   
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setRippleAnimation
{
    
        UIColor *stroke = rippleColor ? rippleColor : [UIColor colorWithWhite:0.8 alpha:0.8];
        
        CGRect pathFrame = CGRectMake(-CGRectGetMidX(self.profileView.bounds), -CGRectGetMidY(self.profileView.bounds), self.profileView.bounds.size.width, self.profileView.bounds.size.height);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:self.profileView.layer.cornerRadius];
        
        // accounts for left/right offset and contentOffset of scroll view
        CGPoint shapePosition = [self.profileView convertPoint:self.profileView.center fromView:nil];
        
        circleShape = [CAShapeLayer layer];
        circleShape.path = path.CGPath;
        circleShape.position = shapePosition;
        circleShape.fillColor = [UIColor clearColor].CGColor;
        circleShape.opacity = 0;
        circleShape.strokeColor = stroke.CGColor;
        circleShape.lineWidth = 3;
        
        [self.profileView.layer addSublayer:circleShape];
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.5, 2.5, 1)];
        
        CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        alphaAnimation.fromValue = @1;
        alphaAnimation.toValue = @0;
        
        CAAnimationGroup *animation = [CAAnimationGroup animation];
        animation.animations = @[scaleAnimation, alphaAnimation];
        animation.duration = 1.5f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [circleShape addAnimation:animation forKey:nil];
        [self performSelector:@selector(setRippleAnimation) withObject:nil afterDelay:0.75];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)moveToDashboardScreen
{
    [self performSegueWithIdentifier:@"loadDashboardVC" sender:self];
    
}
- (IBAction)allowLocationButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"loadDashboardVC" sender:self];
}
- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"loadDashboardVC"]) {
        CSDashboardViewController *mdashboard=(CSDashboardViewController*)[segue destinationViewController];
        mdashboard.dashboardViewDelegate=self;
        mdashboard.arrFriends=self.arrFriends;

    }
}

-(void)finishLiked
{
    if((pageno)*kPageSize >= totalCount){
        pageno = kFirstPage;
    } else {
        pageno++;
    }
    [self getFindPeople];
    /*if (totalCount>self.arrFriends.count) {
        pageno=(int) self.arrFriends.count/20 +1;
        [self getFindPeople];
    }
    else
    {
        [circleShape removeAllAnimations];
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self.lblFindingFriend setText:@"No matches found. Expand your search to see potential matches"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
       // [[CSUtils sharedInstance]showNormalAlert:@"No matches found. Expand your search to see potential matches"];
    }*/
}
-(void)getFindPeople
{
    if([[AFNetworkReachabilityManager sharedManager] isReachable]) // checking network reachable
    {
        self.view.userInteractionEnabled=NO;
        AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
        [[CSRequestController sharedInstance]findPeopleNearWithUserId:[CSUserHelper sharedInstance].userDict[@"user_id"] Latitude:app.latitude Longitude:app.longitude Pageno:pageno Pagesize:kPageSize
                                                              success:^(NSDictionary *responsedict){
            self.view.userInteractionEnabled=YES;
            if ([responsedict[@"response"]integerValue]==200) {
                self.arrFriends=[responsedict[@"values"]mutableCopy];
                if (self.arrFriends.count>0) {
                    totalCount=[responsedict[@"totalresult"]integerValue];
                    CSDashboardViewController *mdashboard= [self.storyboard instantiateViewControllerWithIdentifier:@"CSDashboardViewController"];
                    mdashboard.dashboardViewDelegate=self;
                    mdashboard.arrFriends=self.arrFriends;
                    
                    [self.navigationController pushViewController:mdashboard animated:YES];
                    
                     //[self performSegueWithIdentifier:@"loadDashboardVC" sender:self];
                }
                else{
                    [circleShape removeAllAnimations];
                    [NSObject cancelPreviousPerformRequestsWithTarget:self];
                    [self.lblFindingFriend setText:@"No matches found. Expand your search to see potential matches"];
                    
                    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    
                    if (delegate.showNotifications) {
                        
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                        CSNotificationViewController *mNotificationController = [storyboard instantiateViewControllerWithIdentifier:@"CSNotificationViewController"];
                        [self.navigationController pushViewController:mNotificationController animated:YES];
                        self.needReload = YES;

                    } else {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                    }
                    
                    
                }
               
            }
            else if ([responsedict[@"response"]integerValue] ==201)
            {
                //[[CSUtils sharedInstance] showNormalAlert:responsedict[@"message"]];
                [circleShape removeAllAnimations];
                [NSObject cancelPreviousPerformRequestsWithTarget:self];
                [self.lblFindingFriend setText:@"No matches found. Expand your search to see potential matches"];
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                
                if (delegate.showNotifications) {
                    
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                    CSNotificationViewController *mNotificationController = [storyboard instantiateViewControllerWithIdentifier:@"CSNotificationViewController"];
                    [self.navigationController pushViewController:mNotificationController animated:YES];
                    self.needReload = YES;
                    
                } else {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
            }
            
            
        }
                                                              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             

             self.view.userInteractionEnabled=YES;
             if (error.code==CSErrorCodeSessionExpired) {
                 [SVProgressHUD showErrorWithStatus:@"Connection timed out. Please try again!"];
                 [circleShape removeAllAnimations];
                 [NSObject cancelPreviousPerformRequestsWithTarget:self];
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [self.navigationController popViewControllerAnimated:YES];
                 });
             }
             else
             {
                 [circleShape removeAllAnimations];
                 [NSObject cancelPreviousPerformRequestsWithTarget:self];
                 [SVProgressHUD showErrorWithStatus:@"Connection timed out. Please try again!"];
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [self.navigationController popViewControllerAnimated:YES];
                 });
                 
             }
             
         }];
    }
    else
    {
        [[CSUtils sharedInstance]showNormalAlert:@"Please check your network connection and try again!"];
    }
}

@end
