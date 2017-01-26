//
//  ChatVCViewController.h
//  GameApp
//
//  Created by Apple on 07/02/15.
//  Copyright (c) 2015 Unos2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quickblox/Quickblox.h>
#import "Person.h"

@interface ChatViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) QBChatDialog *dialog;
@property (strong, nonatomic)Person *mPerson;
@property (nonatomic, strong) NSString *chatUserName,*chatOpponentImg;
@property(nonatomic,strong) IBOutlet UILabel *lblHeader;

- (IBAction)tapProfileImage:(UITapGestureRecognizer *)sender;

@end
