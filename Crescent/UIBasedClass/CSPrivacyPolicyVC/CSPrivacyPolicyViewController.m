//
//  CSPrivacyPolicyViewController.m
//  Crescent
//
//  Created by Debaprasad Mondal on 27/12/14.
//  Copyright (c) 2014 Debaprasad Mondal. All rights reserved.
//

#import "CSPrivacyPolicyViewController.h"

@interface CSPrivacyPolicyViewController ()

@end

@implementation CSPrivacyPolicyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isPrivacy) {
        [self.lblTitle setText:@"Privacy Policy"];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"CrescentPrivacyPolicy" ofType:@"pdf"];
        NSURL *targetURL = [NSURL fileURLWithPath:path];
        NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
        [self.privacyWebView loadRequest:request];
    }
    else
    {
        [self.lblTitle setText:@"Terms of Use"];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"CrescentTerms" ofType:@"pdf"];
        NSURL *targetURL = [NSURL fileURLWithPath:path];
        NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
        [self.privacyWebView loadRequest:request];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
