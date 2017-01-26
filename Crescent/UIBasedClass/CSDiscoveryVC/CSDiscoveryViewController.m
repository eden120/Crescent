//
//  CSDiscoveryViewController.m
//  Crescent
//
//  Created by Debaprasad Mondal on 14/12/14.
//  Copyright (c) 2014 Debaprasad Mondal. All rights reserved.
//

#import "CSDiscoveryViewController.h"
#import "AppDelegate.h"
#import "MDCSwipeToChoose.h"
#import "Person.h"
#import "CSUtils.h"
#import "SideMenuViewController.h"
#import "CSNotificationViewController.h"

//#import <Parse/Parse.h>


@interface CSDiscoveryViewController ()<MDCSwipeToChooseDelegate,PersonViewDelegate,TopbarDelegate>
@property (nonatomic, strong) Person *currentPerson;
@property (nonatomic, strong) NSMutableArray *people;
@property (nonatomic, strong) NSMutableArray *tempPeople;

@end

@implementation CSDiscoveryViewController

/*- (void)viewDidLoad {
    [super viewDidLoad];
    // You can customize MDCSwipeToChooseView using MDCSwipeToChooseViewOptions.
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.likedText = @"Keep";
    options.likedColor = [UIColor blueColor];
    options.nopeText = @"Delete";
    options.onPan = ^(MDCPanState *state){
        if (state.thresholdRatio == 1.f && state.direction == MDCSwipeDirectionLeft) {
            NSLog(@"Let go now to delete the photo!");
        }
    };
    
    MDCSwipeToChooseView *view = [[MDCSwipeToChooseView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 400)
                                                                     options:options];
    view.imageView.image = [UIImage imageNamed:@"my_pf1"];
    [self.view addSubview:view];
    // Do any additional setup after loading the view.
}

#pragma mark - MDCSwipeToChooseDelegate Callbacks

// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"Couldn't decide, huh?");
}

// Sent before a choice is made. Cancel the choice by returning `NO`. Otherwise return `YES`.
- (BOOL)view:(UIView *)view shouldBeChosenWithDirection:(MDCSwipeDirection)direction {
    if (direction == MDCSwipeDirectionLeft) {
        return YES;
    } else {
        // Snap the view back and cancel the choice.
        [UIView animateWithDuration:0.16 animations:^{
            view.transform = CGAffineTransformIdentity;
            view.center = self.view.superview.center;
        }];
        return NO;
    }
}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    if (direction == MDCSwipeDirectionLeft) {
        NSLog(@"Photo deleted!");
    } else {
        NSLog(@"Photo saved!");
    }
}
*/
#pragma mark - UIViewController Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    _tempPeople=[NSMutableArray array];
    [self defaultPeople];
    // Display the first ChoosePersonView in front. Users can swipe to indicate
    // whether they like or dislike the person displayed.
    [self.view layoutIfNeeded];
    self.frontCardView = [self popPersonViewWithFrame:[self frontCardViewFrame]];
    [self.view addSubview:self.frontCardView];
    
    // Display the second ChoosePersonView in back. This view controller uses
    // the MDCSwipeToChooseDelegate protocol methods to update the front and
    // back views after each user swipe.
    self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]];
    
   // dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      //  self.backCardView.alpha = 1.f;
        [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        
  //  });
   
    // Add buttons to programmatically swipe the view left or right.
    // See the `nopeFrontCardView` and `likeFrontCardView` methods.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    SideMenuViewController *mSideMenu= (SideMenuViewController *)[[[CSUtils sharedInstance]appDelegate]leftSideMenuViewController];
    [mSideMenu.menuTable reloadData];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (delegate.showNotifications) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        CSNotificationViewController *mNotificationController = [storyboard instantiateViewControllerWithIdentifier:@"CSNotificationViewController"];
        [self.navigationController pushViewController:mNotificationController animated:YES];
    }
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - MDCSwipeToChooseDelegate Protocol Methods

// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"You couldn't decide on %@.", self.currentPerson.name);
}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    // MDCSwipeToChooseView shows "NOPE" on swipes to the left,
    // and "LIKED" on swipes to the right.
    if (direction == MDCSwipeDirectionLeft) {
        NSLog(@"You noped %@.", self.currentPerson.name);
        if (_people.count>0) {
        //     [self.tempPeople addObject:[_people objectAtIndex:0]];
        }
        [self dislikeFriend:self.currentPerson];
       
    } else {
        NSLog(@"You liked %@.", self.currentPerson.name);
       
        [self likeOrDislikeFriend:self.currentPerson];
    }
    
    // MDCSwipeToChooseView removes the view from the view hierarchy
    // after it is swiped (this behavior can be customized via the
    // MDCSwipeOptions class). Since the front card view is gone, we
    // move the back card to the front, and create a new back card.
    self.frontCardView = self.backCardView;
    if ((self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]])) {
        // Fade the back card into view.
        self.backCardView.alpha = 0.f;
        [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.backCardView.alpha = 1.f;
                         } completion:nil];
    }
}

#pragma mark - Internal Methods

- (void)setFrontCardView:(ChoosePersonView *)frontCardView {
    // Keep track of the person currently being chosen.
    // Quick and dirty, just for the purposes of this sample app.
    _frontCardView = frontCardView;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
    _frontCardView.frame=[self frontCardViewFrame];
                     }completion:nil];
    self.currentPerson = frontCardView.person;
}

- (void)defaultPeople {
    // It would be trivial to download these from a web service
    // as needed, but for the purposes of this sample app we'll
    // simply store them in memory.
    if (!_people) {
        _people=[NSMutableArray array];
    }
    for (int i=0; i<self.arrFriends.count; i++) {
        NSArray *temparr= [self.arrFriends[i][@"interests"] componentsSeparatedByString:@","];
        Person *mperson= [[Person alloc] initWithName:self.arrFriends[i][@"name"]
                                                email:self.arrFriends[i][@"email"]
                                 age:[self.arrFriends[i][@"age"] integerValue]
                            location:self.arrFriends[i][@"location"]
                               about:self.arrFriends[i][@"about"]
                            imageurl:self.arrFriends[i][@"userimage"]
                           interests:temparr
                          personLike:[self.arrFriends[i][@"friendlikestatus"] integerValue]
                          heartImgLike:[self.arrFriends[i][@"imagelikestatus"] integerValue]
                          deviceName:self.arrFriends[i][@"device"] deviceToken:self.arrFriends[i][@"devicetoken"]
                                  Id:self.arrFriends[i][@"user_id"]]; // personLike:[self.arrFriends[i][@"userlikestatus"] integerValue]
        [self.people addObject:mperson];
    }
}

- (ChoosePersonView *)popPersonViewWithFrame:(CGRect)frame {
    
    // UIView+MDCSwipeToChoose and MDCSwipeToChooseView are heavily customizable.
    // Each take an "options" argument. Here, we specify the view controller as
    // a delegate, and provide a custom callback that moves the back card view
    // based on how far the user has panned the front card view.
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.threshold = 160.f;
    options.onPan = ^(MDCPanState *state){
        CGRect frame = [self backCardViewFrame];
        self.backCardView.frame = CGRectMake(frame.origin.x,
                                             frame.origin.y - (state.thresholdRatio * 10.f),
                                             CGRectGetWidth(frame),
                                             CGRectGetHeight(frame));
    };
    
    // Create a personView with the top person in the people array, then pop
    // that person off the stack.
    if (self.people.count>0) {
        ChoosePersonView *personView = [[ChoosePersonView alloc] initWithFrame:frame
                                                                        person:self.people[0]
                                                                       options:options];
        personView.personviewdelegate=self;
        [self.people removeObjectAtIndex:0];
        return personView;
    }
    else
    {
        if (!_frontCardView) {
            if (self.discoveryviewdelegate) {
                [self.discoveryviewdelegate popToPreviousScreen];
            }
        }
        
       /* [_people addObjectsFromArray: self.tempPeople];
        [self.tempPeople removeAllObjects];
        if (self.people.count>0) {
            ChoosePersonView *personView = [[ChoosePersonView alloc] initWithFrame:frame
                                                                            person:self.people[0]
                                                                           options:options];
            personView.personviewdelegate=self;
            return personView;

        }
        else*/
            return nil;
        // Display the second ChoosePersonView in back. This view controller uses
        // the MDCSwipeToChooseDelegate protocol methods to update the front and
        // back views after each user swipe.
//self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]];
        
    }
        
}

#pragma mark View Contruction

- (CGRect)frontCardViewFrame {
    CGFloat horizontalPadding = 10.0f;
    CGFloat topPadding = 20.f;
    CGFloat bottomPadding = 60.f;
    return CGRectMake(horizontalPadding,
                      topPadding,
                      CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),
                      CGRectGetHeight(self.view.frame) - bottomPadding);
}

- (CGRect)backCardViewFrame {
    CGRect frontFrame = [self frontCardViewFrame];
    return CGRectMake(frontFrame.origin.x,
                      frontFrame.origin.y /*+ frontFrame.size.height*/+10 ,
                      CGRectGetWidth(frontFrame),
                      CGRectGetHeight(frontFrame));
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setFriendsProfileView:(Person *)person likeButton:(UIButton*)button {
    if (self.discoveryviewdelegate) {
        if ([self.discoveryviewdelegate respondsToSelector:@selector(setFriendProfileView:likeButton:)]) {
            [self.discoveryviewdelegate setFriendProfileView:person likeButton:button];
        }
    }
}
-(void)likeButtonClicked:(Person *)person
{
   // [self.frontCardView mdc_swipe:MDCSwipeDirectionRight];
   // [self likeOrDislikeFriend:person];
}
-(void)likeOrDislikeFriend:(Person *)mperson
{
    if([[AFNetworkReachabilityManager sharedManager] isReachable]) // checking network reachable
    {
        [[CSRequestController sharedInstance]likeOrDislikeFriendWithUserId:[CSUserHelper sharedInstance].userDict[@"user_id"] FriendId:mperson.userid Likestatus:@"1"
                                                                   success:^(NSDictionary *responsedict){
                                                                       if ([responsedict[@"response"]integerValue]==200) {
                                                                          
                                                                           
                                                                        
                                                                           
                                                                       }
                                                                       else if ([responsedict[@"response"]integerValue] ==201)
                                                                       {
                                                                          // [[CSUtils sharedInstance] showNormalAlert:responsedict[@"message"]];
                                                                       }
                                                                       if (mperson.isLike==1) {
                                                                           
                                                                           if (self.discoveryviewdelegate) {
                                                                               //Push Fire
                                                                               //[self pushSend:mperson.userid likeUserName:mperson.name];
                                                                               
                                                                               [self.discoveryviewdelegate foundMutualFriendView:mperson];
                                                                           }
                                                                       }
                                                                       
                                                                       
                                                                   }
                                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
//             if (error.code==CSErrorCodeSessionExpired) {
//                 [SVProgressHUD showErrorWithStatus:@"Connection timed out. Please try again!"];
//             }
//             else
//             {
//                 [SVProgressHUD showErrorWithStatus:@"Connection timed out. Please try again!"];
//                 
//             }
             
         }];
    }
    else
    {
        [[CSUtils sharedInstance]showNormalAlert:@"Please check your network connection and try again!"];
    }

}
//dislike profile frnds
-(void)dislikeFriend:(Person *)mperson
{
    if([[AFNetworkReachabilityManager sharedManager] isReachable]) // checking network reachable
    {
        [[CSRequestController sharedInstance]likeOrDislikeFriendWithUserId:[CSUserHelper sharedInstance].userDict[@"user_id"] FriendId:mperson.userid Likestatus:@"0"
                                                                   success:^(NSDictionary *responsedict){
                                                                       if ([responsedict[@"response"]integerValue]==200) {
                                                                              // if (mperson.isLike==0) {
                                                                              // if (self.discoveryviewdelegate) {
                                                                              //     [self.discoveryviewdelegate foundMutualFriendView:mperson];
                                                                              // }
                                                                           //}
                                                                           
                                                                       }
                                                                       else if ([responsedict[@"response"]integerValue] ==201)
                                                                       {
                                                                           // [[CSUtils sharedInstance] showNormalAlert:responsedict[@"message"]];
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


-(void)setMessageView;
{
    NSLog(@"tt");
    [self performSegueWithIdentifier:@"loadMessageVC" sender:self];
}

@end
