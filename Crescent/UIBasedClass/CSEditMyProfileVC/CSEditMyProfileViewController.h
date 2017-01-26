//
//  CSEditMyProfileViewController.h
//  Crescent
//
//  Created by Debaprasad Mondal on 19/12/14.
//  Copyright (c) 2014 Debaprasad Mondal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSEditMyProfileViewController : UIViewController
{
    UIImageView *pImage1;
    UIImageView *pImage2;
    UIImageView *pImage3;
    UIImageView *pImage4;
    UIButton *btnCross3;
    UIButton *btnCross4;
    UIButton *btnCross1;
    UIButton *btnCross2;
    UIButton *btnAdd1;
    UIButton *btnAdd2;
    UIButton *btnAdd3;
    UIButton *btnAdd4;
    UITextField *usernameTxtFld;
    UITextField *dobTxtFld;
    UITextField *genderTxtFld;
    UITextView *aboutTxtVw;
    UILabel *lblAboutTextCount;
    IBOutlet UITableView *tableView;
    
}

@end
