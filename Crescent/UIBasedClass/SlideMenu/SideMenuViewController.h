//
//  SideMenuViewController.h
//  MFSideMenuDemoStoryboard
//
//  Created by Michael Frederick on 5/7/13.
//  Copyright (c) 2013 Michael Frederick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface SideMenuViewController : UIViewController<MFMailComposeViewControllerDelegate>
{
    BOOL isSettingSectionOpen;
    
    UILabel *manuLbl;
    UIImageView *septImgVw;
    
    UILabel *cellLbl;
    UIImageView *cellImgVw;
    UIImageView *cellSeptImgVw;

    UISwitch *Standbymode_Switch;
    UISwitch *Notification_Switch;
    
    float X_GAP_FOR_CELL;
}
@property (weak, nonatomic) IBOutlet UITableView *menuTable;

@end
