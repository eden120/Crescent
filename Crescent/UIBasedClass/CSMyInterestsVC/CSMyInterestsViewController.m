//
//  CSMyInterestsViewController.m
//  Crescent
//
//  Created by Debaprasad Mondal on 02/12/14.
//  Copyright (c) 2014 Debaprasad Mondal. All rights reserved.
//

#import "CSMyInterestsViewController.h"
#import "CSRequestController.h"
#import <SVProgressHUD.h>
#import "CSUserHelper.h"
#import "CSUtils.h"
#import "CSWantViewController.h"

@interface CSMyInterestsViewController ()
{
    NSString *myInterests;
}
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property(nonatomic, strong) NSArray *menuOptionArray;
@property(nonatomic, strong) NSArray *iconImageArr;
- (IBAction)nextbuttonClicked:(id)sender;
@end

@implementation CSMyInterestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    myInterests=@"";
    // Do any additional setup after loading the view.
    self.menuOptionArray=[NSArray arrayWithObjects:@"Fashion",@"Sports",@"Politics",@"Music",@"Fitness",@"Tech",@"Food",@"Business",@"Art",@"Movies",@"Travel",@"Events", nil];
    self.iconImageArr=[NSArray arrayWithObjects:@"icon_fashion",@"icon_sports",@"icon_politics",@"icon_music",@"icon_fitness",@"icon_tech",@"icon_food",@"icon_business",@"icon_art",@"icon_movies",@"icon_travel",@"icon_events", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark UICollectionViewDataSource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout* )collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return (CGSize){94,94};
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 9;
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
    NSLog(@"%s",__PRETTY_FUNCTION__);
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
    if (myInterests.length>0) {
        self.btnNext.enabled=YES;
    }
    else
        self.btnNext.enabled=NO;
    
    [collectionView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)nextbuttonClicked:(id)sender {
    if (myInterests.length>0) {
        NSArray *temparr=[myInterests componentsSeparatedByString:@","];
        if (temparr.count>=3) {
            [self updateMyInterests];
        }
        else
            [[CSUtils sharedInstance] showNormalAlert:@"You must love something. Give us at least 3 interests"];
    }
    else
        [[CSUtils sharedInstance] showNormalAlert:@"You must love something. Give us at least 3 interests"];
}
- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateMyInterests
{
    if([[AFNetworkReachabilityManager sharedManager] isReachable]) // checking network reachable
    {
        [[CSUtils sharedInstance]showLoadingMode];

        self.view.userInteractionEnabled=NO;
        [[CSRequestController sharedInstance]updateMyinterestsWithUserId:[CSUserHelper sharedInstance].userDict[@"user_id"] Interests:myInterests success:^(NSDictionary *responsedict){
            [[CSUtils sharedInstance]hideLoadingMode];

            self.view.userInteractionEnabled=YES;
            if ([responsedict[@"response"]integerValue]==200) {
                [[CSUserHelper sharedInstance].userDict setObject:myInterests forKey:@"interests"];
                [[CSUtils sharedInstance]saveUserDetailsIntoPlistFile];
                CSWantViewController *mFindFriendVc= [self.storyboard instantiateViewControllerWithIdentifier:@"CSWantViewController"];
                mFindFriendVc.isFromSignUp=YES;
                [self.navigationController pushViewController:mFindFriendVc animated:NO];
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
