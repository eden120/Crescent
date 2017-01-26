//
//  CSTopbarViewController.m
//  Crescent
//
//  Created by Debaprasad Mondal on 01/01/15.
//  Copyright (c) 2015 Debaprasad Mondal. All rights reserved.
//

#import "CSTopbarViewController.h"
#import "UIViewController+MFSideMenuAdditions.h"
#import "SideMenuViewController.h"
#import "MFSideMenuContainerViewController.h"


@interface CSTopbarViewController ()
- (IBAction)messageButtonClicked:(id)sender;

@end

@implementation CSTopbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)menuButtonClicked:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)messageButtonClicked:(id)sender {
    if (self.topbardelegate) {
        if ([self.topbardelegate respondsToSelector:@selector(setMessageView)]) {
            [self.topbardelegate setMessageView];
        }
    }
}
@end
