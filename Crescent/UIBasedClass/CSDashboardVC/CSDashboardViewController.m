//
//  CSDashboardViewController.m
//  Crescent
//
//  Created by Debaprasad Mondal on 09/12/14.
//  Copyright (c) 2014 Debaprasad Mondal. All rights reserved.
//

#import "CSDashboardViewController.h"
#import "AppDelegate.h"
#import "CSTopbarViewController.h"
#import "CSDiscoveryViewController.h"
#import "CSFriendProfileViewController.h"
#import "CSUtils.h"
#import "CSMatchesViewController.h"
#import "CSFindingFriendsViewController.h"

@interface CSDashboardViewController ()<TopbarDelegate,DiscoveryViewDelegate>
{
    Person *frperson;
    UIButton *tempBtn;
    
}
@end

@implementation CSDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([isCoachShow  isEqualToString:@"SHOW"]) {//!GETBOOl_DEFAUL_VALUE(@"isRegister")
        float X_Origin=0.0;
        [self.view layoutIfNeeded];
        for (int i=1; i<=5; i++) {
            UIImageView *pimage=[[UIImageView alloc]initWithFrame:CGRectMake(X_Origin, 0, self.coachMarkScrView.frame.size.width, self.coachMarkScrView.frame.size.height)];
            pimage.tag=1111;
            pimage.contentMode = UIViewContentModeScaleToFill;
            pimage.backgroundColor=[UIColor clearColor];
            [pimage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"0%d_Coach_Marks",i]]];
            [self.coachMarkScrView addSubview:pimage];
            X_Origin=X_Origin+self.coachMarkScrView.frame.size.width;
            if (i==5) {
                pimage.userInteractionEnabled=YES;
                UIButton *btnGotIt=[UIButton buttonWithType:UIButtonTypeCustom];
                [btnGotIt setFrame:CGRectMake(pimage.frame.size.width-70, pimage.frame.size.height-40, 55, 25)];
                btnGotIt.titleLabel.font=[UIFont fontWithName:FONT_REGULAR size:16.0];
                btnGotIt.titleLabel.textColor=[UIColor whiteColor];
                [btnGotIt setTitle:@"Got it!" forState:UIControlStateNormal];
                //[btnGotIt setBackgroundImage:[UIImage imageNamed:@"button_red"] forState:UIControlStateNormal];
                [btnGotIt addTarget:self action:@selector(gotItButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [pimage addSubview:btnGotIt];
            }
            
        }
        [self.coachMarkScrView setContentOffset:CGPointMake(0, 0)];
        [self.coachMarkScrView setContentSize:CGSizeMake(self.coachMarkScrView.frame.size.width*5, self.coachMarkScrView.frame.size.height-20)];
        //SAVEBOOL_AS_DEFAULT(@"isRegister",YES);
        //GETBOOl_DEFAUL_VALUE(@"isRegister");
        isCoachShow=@"HIDDEN";
    }
    else
    {
        // GETBOOl_DEFAUL_VALUE(@"isLogin");
        isCoachShow=@"HIDDEN";
        self.coachMarkScrView.hidden=YES;
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [CSUtils sharedInstance].CurrentViewController=self.navigationController.visibleViewController;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    app.isShowingSlideMenu=YES;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    app.isShowingSlideMenu=NO;
}
#pragma mark -
#pragma mark ------------ Preparing For Segue --------------

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"loadDiscoveryVC"])
    {
        //[BSUtils sharedInstance].contentNavigationController = segue.destinationViewController;
        CSDiscoveryViewController *mdiscoverycontroller = segue.destinationViewController;
        mdiscoverycontroller.discoveryviewdelegate=self;
        mdiscoverycontroller.arrFriends=self.arrFriends;
        
    }
    else if ([segue.identifier isEqualToString:@"loadTopbarVC"])
    {
        CSTopbarViewController *mtopbarcontroller = segue.destinationViewController;
        mtopbarcontroller.topbardelegate=self;
    }
    else if ([segue.identifier isEqualToString:@"loadCSFriendProfileVC"])
    {
        CSFriendProfileViewController *mfriendcontroller = segue.destinationViewController;
        mfriendcontroller.mperson=frperson;
        mfriendcontroller.likeButton=tempBtn;
    }
}
-(void)setMessageView;
{
    [self performSegueWithIdentifier:@"loadMessageVC" sender:self];
}
-(void)setFriendProfileView:(Person *)person likeButton:(UIButton*)button
{
    tempBtn=button;
    frperson=person;
    [self performSegueWithIdentifier:@"loadCSFriendProfileVC" sender:self];
}
-(void)popToPreviousScreen
{
    if (self.dashboardViewDelegate) {
        [self.dashboardViewDelegate finishLiked];
    }
    
    [self.navigationController popViewControllerAnimated:YES];    
}

-(void)foundMutualFriendView:(Person *)mperson
{
    NSUserDefaults *defaultOpponentName = [NSUserDefaults standardUserDefaults];
    [defaultOpponentName setObject:mperson.name forKey:@"opponentName"];
    [defaultOpponentName synchronize];
    CSMatchesViewController *mMatch = [self.storyboard instantiateViewControllerWithIdentifier:@"CSMatchesViewController"];
    mMatch.mPerson=mperson;
    [self.navigationController pushViewController:mMatch animated:NO];
    [UIView transitionWithView:self.navigationController.view duration:1 options:UIViewAnimationOptionTransitionFlipFromRight animations:nil completion:nil];
}
-(IBAction)gotItButtonClicked:(id)sender
{
    self.coachMarkScrView.hidden=YES;
}
//
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
