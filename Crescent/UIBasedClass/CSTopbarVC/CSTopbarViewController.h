//
//  CSTopbarViewController.h
//  Crescent
//
//  Created by Debaprasad Mondal on 01/01/15.
//  Copyright (c) 2015 Debaprasad Mondal. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TopbarDelegate <NSObject>

@optional

-(void)setMessageView;
@end
@interface CSTopbarViewController : UIViewController
@property(nonatomic,assign) id<TopbarDelegate>topbardelegate;
- (IBAction)menuButtonClicked:(id)sender;

@end
