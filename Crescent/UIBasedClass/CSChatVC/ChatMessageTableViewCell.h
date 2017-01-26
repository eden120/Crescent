//
//  ChatMessageTableViewCell.h
//  sample-chat
//
//  Created by Igor Khomenko on 10/19/13.
//  Copyright (c) 2013 Igor Khomenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quickblox/Quickblox.h>
@interface ChatMessageTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UITextView  *messageTextView;
@property (nonatomic, strong) IBOutlet UILabel     *dateLabel;
@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView,*imgOppnt,*imgUser;
@property (nonatomic, strong) IBOutlet UIImageView * photoView;
@property (nonatomic, weak) id delegate;


+ (CGFloat)heightForCellWithMessage:(QBChatAbstractMessage *)message;
- (void)configureCellWithMessage:(QBChatAbstractMessage *)message oppImage:(NSString *)oppImg;

@end
