//
//  ChatMessageTableViewCell.m
//  sample-chat
//
//  Created by Igor Khomenko on 10/19/13.
//  Copyright (c) 2013 Igor Khomenko. All rights reserved.
//

#import "ChatMessageTableViewCell.h"
#import <Quickblox/Quickblox.h>
#import "LocalStorageService.h"
#import "CSUtils.h"
#import "EXPhotoViewer.h"
#import "ChatViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define padding 20

NSString *strUserImage;

@implementation ChatMessageTableViewCell

static NSDateFormatter *messageDateFormatter;
static UIImage *orangeBubble;
static UIImage *aquaBubble;


+ (void)initialize{
    [super initialize];
    
    
  

}


- (void)awakeFromNib {
    // Initialization code
    // init message datetime formatter
    messageDateFormatter = [[NSDateFormatter alloc] init];
    [messageDateFormatter setDateFormat: kDateFormat];
    
    // init bubbles
    orangeBubble = [[UIImage imageNamed:@"orange"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
    aquaBubble = [[UIImage imageNamed:@"aqua"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
    
    NSArray *imageArr=[CSUserHelper sharedInstance].userDict[@"userimage"];
    if (imageArr.count>0) {
        strUserImage=imageArr[0][@"image"];
    }
    self.imgUser.layer.cornerRadius=self.imgUser.frame.size.width/2;
    self.photoView.layer.cornerRadius= 5.;
    self.photoView.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    self.photoView.layer.borderWidth = 1.;

}

-(void)openImage:(UITapGestureRecognizer *)tap{
    [EXPhotoViewer showImageFrom:(UIImageView *)tap.view];
}

- (void)openUserProfile:(UITapGestureRecognizer *)tap {
    
    if ([self.delegate respondsToSelector:@selector(tapProfileImage:)]) {
        [self.delegate tapProfileImage:tap];
    }
    
}

+ (CGFloat)heightForCellWithMessage:(QBChatAbstractMessage *)message
{
    NSString *text = message.text;

    
    if([[text lowercaseString] isEqualToString:@"null"]){
        return 160.;
    }
    
    
	CGSize  textSize = {260.0, 10000.0};
	CGSize size = [text sizeWithFont:[UIFont boldSystemFontOfSize:13]
                   constrainedToSize:textSize
                       lineBreakMode:NSLineBreakByWordWrapping];
    
    if(size.height == 0){
        size.height = 30;
    }
    
	size.height += 55.0;
	return size.height;

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        /**
        self.dateLabel = [[UILabel alloc] init];
        [self.dateLabel setFrame:CGRectMake(10, 5, 300, 20)];
        [self.dateLabel setFont:[UIFont systemFontOfSize:11.0]];
        [self.dateLabel setTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.dateLabel];
        
       
        
       
        
        self.imgUser = [[UIImageView alloc] init];
       
        [self.imgUser setBackgroundColor:[UIColor clearColor]];
        
        
        [self.contentView addSubview:self.imgUser];
        
        
        self.backgroundImageView = [[UIImageView alloc] init];
        [self.backgroundImageView setFrame:CGRectZero];
		[self.contentView addSubview:self.backgroundImageView];
        
		self.messageTextView = [[UITextView alloc] init];
        [self.messageTextView setBackgroundColor:[UIColor clearColor]];
        [self.messageTextView setEditable:NO];
        [self.messageTextView setScrollEnabled:NO];
		[self.messageTextView sizeToFit];
		[self.contentView addSubview:self.messageTextView];
        self.backgroundColor=[UIColor clearColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
         */
    }
    return self;
}

- (void)configureCellWithMessage:(QBChatAbstractMessage *)message oppImage:(NSString *)oppImg
{    
    self.messageTextView.text = message.text;
    
    
    
    CGSize textSize = { 260.0, 10000.0 };
    
	CGSize size = [self.messageTextView.text sizeWithFont:[UIFont boldSystemFontOfSize:13]constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
    
//    NSLog(@"message: %@", message);
    if(size.width < 20){
        size.width = 20;
    }
    
	size.width += 10;
    
    NSString *time = [messageDateFormatter stringFromDate:message.datetime];
    
    // Left/Right bubble
    
   
    
    if ([LocalStorageService shared].currentUser.ID == message.senderID) {

        
        [self.imgUser sd_setImageWithURL:[NSURL URLWithString:strUserImage]];
        self.dateLabel.text = [NSString stringWithFormat:@"%@, %@", @"You", time];

        UITapGestureRecognizer *oneTouchUser = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openUserProfile:)];
        [self.imgUser addGestureRecognizer:oneTouchUser];

        if([[message.text lowercaseString] isEqualToString:@"null"]){
            if([message attachments].count > 0){
                QBChatAttachment * attach = [message attachments][0];
                [self.photoView sd_setImageWithURL:[NSURL URLWithString:attach.url]];
                UITapGestureRecognizer *oneTouch=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openImage:)];
                [self.photoView addGestureRecognizer:oneTouch];
            }
        } else {
            CGRect messageFrame = self.messageTextView.frame;
            messageFrame.size = CGSizeMake(size.width, size.height);
            self.messageTextView.frame = messageFrame;
            [self.messageTextView sizeToFit];
            self.messageTextView.textColor=[UIColor blackColor];
            
            CGRect bgFrame = self.backgroundImageView.frame;
            bgFrame.size = CGSizeMake(messageFrame.size.width + padding/2, size.height+padding);
            self.backgroundImageView.frame = bgFrame;
        

        }
        
        
    } else {
        

        [self.imgUser sd_setImageWithURL:[NSURL URLWithString:oppImg]];
        if([[message.text lowercaseString] isEqualToString:@"null"]){
            if([message attachments].count > 0){
                QBChatAttachment * attach = [message attachments][0];
                [self.photoView sd_setImageWithURL:[NSURL URLWithString:attach.url]];
                UITapGestureRecognizer *oneTouch=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openImage:)];
                [self.photoView addGestureRecognizer:oneTouch];
            }
        }else {
            CGRect messageFrame = self.messageTextView.frame;
            messageFrame.size = CGSizeMake(size.width, size.height);
            messageFrame.origin = CGPointMake(CGRectGetMinX(self.imgUser.frame)-size.width-padding/2, messageFrame.origin.y);
            self.messageTextView.frame = messageFrame;
            
            [self.messageTextView sizeToFit];
            self.messageTextView.textColor=[UIColor whiteColor];
            
            CGRect bgFrame = self.backgroundImageView.frame;
            bgFrame.size = CGSizeMake(messageFrame.size.width + padding/2, size.height+padding);
            bgFrame.origin = CGPointMake(CGRectGetMinX(self.imgUser.frame)-size.width-padding, bgFrame.origin.y);
            self.backgroundImageView.frame = bgFrame;
            }
        
        NSUserDefaults *defaultOpponentName = [NSUserDefaults standardUserDefaults];
        self.dateLabel.text = [NSString stringWithFormat:@"%@, %@", [defaultOpponentName objectForKey:@"opponentName"], time];
    }
        
   
}

@end
