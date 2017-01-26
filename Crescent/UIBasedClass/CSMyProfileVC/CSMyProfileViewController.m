//
//  CSMyProfileViewController.m
//  Crescent
//
//  Created by Debaprasad Mondal on 19/12/14.
//  Copyright (c) 2014 Debaprasad Mondal. All rights reserved.
//

#import "CSMyProfileViewController.h"
#import "CSUtils.h"
#import <UIImageView+AFNetworking.h>
#import "ImageLabelView.h"


@interface CSMyProfileViewController ()
@property (nonatomic, strong) UIView *interestsView;
//@property (nonatomic, strong) UIScrollView *interestsView;
@property (nonatomic, readwrite) NSInteger selectedindex;
- (IBAction)backButtonClicked:(id)sender;
- (IBAction)editButtonClicked:(id)sender;

@end

@implementation CSMyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.profileScrVw setContentSize:CGSizeMake(self.imageScrVw.frame.size.width, 504)];
    
    [self.view layoutIfNeeded];
   // [self constructInterestsView];
    UISwipeGestureRecognizer *swipeleftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    [swipeleftGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.imageScrVw addGestureRecognizer:swipeleftGestureRecognizer];
    
    UISwipeGestureRecognizer *swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [swipeRightGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.imageScrVw addGestureRecognizer:swipeRightGestureRecognizer];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setProfileDetails];
    [self constructInterestsView];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setProfileDetails
{
    [self.lblUsername setText:[CSUserHelper sharedInstance].userDict[@"name"]];
    [self.lblLocation setText:[CSUserHelper sharedInstance].userDict[@"location"]];
    [self.lblAbout setText:[CSUserHelper sharedInstance].userDict[@"about"]];
    __weak NSArray *imageArr=[CSUserHelper sharedInstance].userDict[@"userimage"];
    float X_Origin=20;
    for (UIView *view in [self.imageScrVw subviews] ) {
        if ([view isKindOfClass:[UIImageView class]]) {
            if (view.tag==1111) {
                [view removeFromSuperview];
            }
            
        }
    }
    for (int i=0; i<imageArr.count; i++) {
        UIImageView *pimage=[[UIImageView alloc]initWithFrame:CGRectMake(X_Origin, 0, self.imageScrVw.frame.size.width-40, self.imageScrVw.frame.size.height)];
        [pimage setContentMode:UIViewContentModeScaleAspectFill];
        pimage.clipsToBounds = YES;
        pimage.tag=1111;
        pimage.backgroundColor=[UIColor grayColor];
        [pimage setImageWithURL:[NSURL URLWithString:imageArr[i][@"image"]] placeholderImage:nil];
        [self.imageScrVw addSubview:pimage];
        X_Origin=X_Origin+self.imageScrVw.frame.size.width-30;
        
    }
    [self.imageScrVw setContentOffset:CGPointMake(0, 0)];
    [self.imageScrVw setContentSize:CGSizeMake(self.imageScrVw.frame.size.width*imageArr.count, self.imageScrVw.frame.size.height)];
    self.pageController.numberOfPages=imageArr.count;
    self.pageController.currentPage=0;
}

- (void)constructInterestsView {
    //CGFloat leftPadding = 10.f;
    float X_origin=5.0;
    
    
  //  _interestsView.clipsToBounds = YES
   // _interestsView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
   // UIViewAutoresizingFlexibleTopMargin;
  /*
   __weak NSArray *temparr= [[CSUserHelper sharedInstance].userDict[@"interests"] componentsSeparatedByString:@","];
    if (temparr.count<5) {
         _interestsView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+5, _lblAbout.frame.origin.y+_lblAbout.frame.size.height+5+self.imageScrVw.frame.size.height+self.imageScrVw.frame.origin.y+20, temparr.count*60, 50)];
    }else
    _interestsView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+5, _lblAbout.frame.origin.y+_lblAbout.frame.size.height+5+self.imageScrVw.frame.size.height+self.imageScrVw.frame.origin.y+20, self.view.frame.size.width-5, 50)];//temparr.count*60
     //_interestsView = [[UIView alloc] initWithFrame:CGRectMake(10, _lblAbout.frame.origin.y+_lblAbout.frame.size.height+5+self.imageScrVw.frame.size.height+self.imageScrVw.frame.origin.y+10, temparr.count*60, 50)];
    _interestsView.backgroundColor = [UIColor clearColor];
    for (int i=0; i<temparr.count; i++) {
        UIView *tempView= [self buildImageLabelViewLeftOf:X_origin
                                                    image:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%@",[temparr[i] lowercaseString]]]
                                                     text:temparr[i]];
        [_interestsView addSubview:tempView];
        X_origin=CGRectGetMaxX(tempView.frame)+10;//X_origin+50+10;
        
    }
//    if (X_origin<_interestsView.frame.size.width) {
//        _interestsView.frame=CGRectMake(leftPadding, _lblAbout.frame.origin.y+_lblAbout.frame.size.height+5, X_origin, 44);
//    }
    _interestsView.scrollEnabled=YES;
    [_interestsView setShowsHorizontalScrollIndicator:NO];
    [_interestsView setContentSize:CGSizeMake(X_origin, 50)];//temparr.count+1*60 X_origin+80
    [self.profileScrVw addSubview:_interestsView];
    if (temparr.count<5){
       [_interestsView setCenter:CGPointMake(self.view.frame.size.width/2, (_lblAbout.frame.origin.y+_lblAbout.frame.size.height+5)+22+(self.imageScrVw.frame.size.height+self.imageScrVw.frame.origin.y+10+self.pageController.frame.size.height))]; 
    }
    */
    
    for(UIView *subview in self.profileScrVw.subviews)
        if (subview ==_interestsView)
        {
            
            [subview removeFromSuperview];
            
        }

    __weak NSArray *temparr= [[CSUserHelper sharedInstance].userDict[@"interests"] componentsSeparatedByString:@","];
    _interestsView = [[UIView alloc] initWithFrame:CGRectMake(20, _lblAbout.frame.origin.y+_lblAbout.frame.size.height+5+self.imageScrVw.frame.size.height+self.imageScrVw.frame.origin.y+10, temparr.count*60, 50)];
    _interestsView.backgroundColor = [UIColor clearColor];
    for (int i=0; i<temparr.count; i++) {
        UIView *tempView= [self buildImageLabelViewLeftOf:X_origin
                                                    image:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%@",[temparr[i] lowercaseString]]]
                                                     text:temparr[i]];
        [_interestsView addSubview:tempView];
        X_origin=X_origin+50+10;
        
    }
    [self.profileScrVw addSubview:_interestsView];
    [_interestsView setCenter:CGPointMake(self.view.frame.size.width/2, (_lblAbout.frame.origin.y+_lblAbout.frame.size.height+5)+22+(self.imageScrVw.frame.size.height+self.imageScrVw.frame.origin.y+10+self.pageController.frame.size.height))];
    
}
- (ImageLabelView *)buildImageLabelViewLeftOf:(CGFloat)x image:(UIImage *)image text:(NSString *)text {
    CGRect frame = CGRectMake(x ,
                              0,
                              50,
                              38);
    ImageLabelView *view = [[ImageLabelView alloc] initWithFrame:frame
                                                           image:image
                                                            text:text];
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    return view;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //int indexOfPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    //self.pageController.currentPage=indexOfPage;
    //your stuff with index
}
#pragma mark -
#pragma mark - Handle Swipe method -

// Swipe the view left to view the next news
-(void)handleSwipeLeft:(UIGestureRecognizer *)gesture
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    __weak NSArray *imageArr=[CSUserHelper sharedInstance].userDict[@"userimage"];
    if (self.selectedindex<[imageArr count]-1) {
        self.selectedindex++;
        [self.imageScrVw scrollRectToVisible:CGRectMake(self.selectedindex*(self.imageScrVw.frame.size.width-30), self.imageScrVw.frame.origin.y, self.imageScrVw.frame.size.width, self.imageScrVw.frame.size.height) animated:YES];
        self.pageController.currentPage=self.selectedindex;
    }
}

// Swipe the view right to view the previous news
-(void)handleSwipeRight:(UIGestureRecognizer *)gesture
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    if (self.selectedindex>0) {
        self.selectedindex--;
       [self.imageScrVw scrollRectToVisible:CGRectMake(self.selectedindex*(self.imageScrVw.frame.size.width-30), self.imageScrVw.frame.origin.y, self.imageScrVw.frame.size.width, self.imageScrVw.frame.size.height) animated:YES];
        self.pageController.currentPage=self.selectedindex;
    }
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editButtonClicked:(id)sender {
}
@end
