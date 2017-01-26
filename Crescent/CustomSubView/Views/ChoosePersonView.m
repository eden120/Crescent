//
// ChoosePersonView.m
//  Crescent
//
//  Created by Debaprasad Mondal on 01/01/15.
//  Copyright (c) 2015 Debaprasad Mondal. All rights reserved.
//
#import "ChoosePersonView.h"
#import "ImageLabelView.h"
#import "Person.h"
#import <UIImageView+AFNetworking.h>
#import "CSUtils.h"

//#import <Parse/Parse.h>

static const CGFloat ChoosePersonViewImageLabelWidth = 50.f;
static const CGFloat ChoosePersonViewImageLabelHeight =38.f;

@interface ChoosePersonView ()
@property (nonatomic, strong) UIView *informationView;
@property (nonatomic, strong) UIView *interestsView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *aboutLabel;
@property (nonatomic, strong) ImageLabelView *cameraImageLabelView;
@property (nonatomic, strong) ImageLabelView *interestsImageLabelView;
@property (nonatomic, strong) ImageLabelView *friendsImageLabelView;
@end

NSString *isLike;
@implementation ChoosePersonView

#pragma mark - Object Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
                       person:(Person *)person
                      options:(MDCSwipeToChooseViewOptions *)options {
    self = [super initWithFrame:frame options:options];
    if (self) {
        
        
        _person = person;
        self.imageView.backgroundColor=[UIColor lightGrayColor];
     //   [self.imageView setImageWithURL:[NSURL URLWithString:_person.imageurl] placeholderImage:nil];
        self.imageView.frame=CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.frame.size.width, self.imageView.frame.size.height-180);
       // self.imageView.image=[UIImage imageNamed:@"sample_pic4"];
        [self.imageView setImageWithURL:[NSURL URLWithString:_person.imageurl] placeholderImage:nil];

        self.autoresizingMask = UIViewAutoresizingFlexibleHeight |
                                UIViewAutoresizingFlexibleWidth |
                                UIViewAutoresizingFlexibleBottomMargin;
        self.imageView.autoresizingMask = self.autoresizingMask;

        
        
        UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnView)];
        tapgesture.numberOfTapsRequired=1;
        [self addGestureRecognizer:tapgesture];
        [self constructInformationView];
    }
    return self;
}

#pragma mark - Internal Methods

- (void)constructInformationView {
    CGFloat bottomHeight = 180.f;
    CGRect bottomFrame = CGRectMake(0,
                                    CGRectGetHeight(self.bounds) - bottomHeight,
                                    CGRectGetWidth(self.bounds),
                                    bottomHeight);
    _informationView = [[UIView alloc] initWithFrame:bottomFrame];
    _informationView.backgroundColor = [UIColor whiteColor];
    _informationView.clipsToBounds = YES;
    _informationView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                        UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:_informationView];
//    [self constructLikeView];
    [self constructNameLabel];
    [self constructLocationLabel];
    [self constructAboutLabel];
    [self constructInterestsView];
}
-(void)constructLikeView
{
    UIButton *likeImage=[UIButton buttonWithType:UIButtonTypeCustom ];// alloc]init];
    self.likeButton=likeImage;
    [_likeButton setFrame:CGRectMake(CGRectGetWidth(self.bounds)-55, 15, 40, 40)];
    [_likeButton addTarget:self action:@selector(likeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    if (_person.isHeartImgLike==1) {
        _likeButton.selected=YES;
    }
    else
        _likeButton.selected=NO;
        
    [_likeButton setImage:[UIImage imageNamed:@"icon_heart_red"] forState:UIControlStateSelected];
    [_likeButton setImage:[UIImage imageNamed:@"icon_heart_grey"] forState:UIControlStateNormal];

//        [likeImage setImage:[UIImage imageNamed:@"icon_heart_grey"]];
    [self addSubview:_likeButton];
   // [self bringSubviewToFront:likeImage];
}
- (void)constructNameLabel {
    CGFloat leftPadding = 12.f;
    CGFloat topPadding = 13.f;
    CGRect frame = CGRectMake(leftPadding,
                              topPadding,
                              floorf(CGRectGetWidth(_informationView.frame))-(leftPadding*2),
                              22);
    _nameLabel = [[UILabel alloc] initWithFrame:frame];
    _nameLabel.text = [NSString stringWithFormat:@"%@, %@", _person.name, @(_person.age)];
    _nameLabel.font=[UIFont fontWithName:FONT_REGULAR size:17.0];
    _nameLabel.textAlignment=NSTextAlignmentCenter;
    [_informationView addSubview:_nameLabel];
}
- (void)constructLocationLabel {
    CGFloat leftPadding = 12.f;
  //  CGFloat topPadding = 17.f;
    CGRect frame = CGRectMake(leftPadding,
                              _nameLabel.frame.origin.y+_nameLabel.frame.size.height+5,
                              floorf(CGRectGetWidth(_informationView.frame))-(leftPadding*2),
                              20);
    _locationLabel = [[UILabel alloc] initWithFrame:frame];
    _locationLabel.text = [NSString stringWithFormat:@"%@", _person.location];
    _locationLabel.font=[UIFont fontWithName:FONT_LIGHT size:13.0];
    _locationLabel.textAlignment=NSTextAlignmentCenter;
    _locationLabel.textColor=[UIColor lightGrayColor];
    [_informationView addSubview:_locationLabel];
}
- (void)constructAboutLabel {
    CGFloat leftPadding = 12.f;
    //  CGFloat topPadding = 17.f;
    CGRect frame = CGRectMake(leftPadding,
                              _locationLabel.frame.origin.y+_locationLabel.frame.size.height+5,
                              floorf(CGRectGetWidth(_informationView.frame))-(leftPadding*2),
                              50);
    _aboutLabel = [[UILabel alloc] initWithFrame:frame];
    _aboutLabel.text = [NSString stringWithFormat:@"\"%@\"", _person.about];
    _aboutLabel.font=[UIFont fontWithName:FONT_REGULAR size:12.0];
    _aboutLabel.numberOfLines=0;
    _aboutLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    _aboutLabel.textAlignment=NSTextAlignmentCenter;
    _aboutLabel.textColor=[UIColor grayColor];
    [_informationView addSubview:_aboutLabel];
}

- (void)constructInterestsView {
    CGFloat leftPadding = 10.f;
    float X_origin=5.0;
    
    _interestsView = [[UIView alloc] initWithFrame:CGRectMake(leftPadding, _aboutLabel.frame.origin.y+_aboutLabel.frame.size.height+10, (_person.interests.count>5?5:_person.interests.count)*(ChoosePersonViewImageLabelWidth+10), ChoosePersonViewImageLabelHeight)];
    _interestsView.backgroundColor = [UIColor clearColor];

    for (int i=0; i<(_person.interests.count>5?5:_person.interests.count); i++) {
       UIView *tempView= [self buildImageLabelViewLeftOf:X_origin
                                  image:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%@",[_person.interests[i] lowercaseString]]]
                                   text:_person.interests[i]];
        [_interestsView addSubview:tempView];
        tempView.backgroundColor = [UIColor clearColor];
            X_origin=X_origin+ChoosePersonViewImageLabelWidth+10;
        
    }
 
    
    [_informationView addSubview:_interestsView];
    [_interestsView setCenter:CGPointMake(self.frame.size.width/2, _aboutLabel.frame.origin.y+_aboutLabel.frame.size.height+10+(ChoosePersonViewImageLabelHeight/2))];
    
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

-(void)tapOnView
{
    if (self.personviewdelegate) {
        if ([self.personviewdelegate respondsToSelector:@selector(setFriendsProfileView:likeButton:)]) {
            [self.personviewdelegate setFriendsProfileView:_person likeButton:_likeButton];
        }
    }
}

-(IBAction)likeButtonClicked:(id)sender
{
    UIButton *btnTemp=(UIButton *)sender;
    if (btnTemp.selected) {
        btnTemp.selected=NO;
        isLike=@"0";
    }
    else{
        btnTemp.selected=YES;
    isLike=@"1";
    }
   // [btnTemp setImage:[UIImage imageNamed:@"icon_heart_red"] forState:UIControlStateNormal];
//    if (self.personviewdelegate) {
//        if ([self.personviewdelegate respondsToSelector:@selector(likeButtonClicked:)]) {
//            [self.personviewdelegate likeButtonClicked:_person];
//        }
//    }
   ///*
    if([[AFNetworkReachabilityManager sharedManager] isReachable]) // checking network reachable
    {
        [[CSRequestController sharedInstance]profileLikeOrDislikeWithUserId:[CSUserHelper sharedInstance].userDict[@"user_id"] FriendId:_person.userid Likestatus:isLike
                                                                   success:^(NSDictionary *responsedict){
                                                                       if ([responsedict[@"response"]integerValue]==200) {
                                                                           _person.isHeartImgLike=[isLike integerValue];
                                                                           if ([responsedict[@"success"]integerValue]==1) {
                                                                        
                                                                              
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

//*/
}






@end
