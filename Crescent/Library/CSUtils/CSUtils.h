//
//  CSUtils.h
//  Crescent
//
//  Created by Debaprasad Mondal on 26/12/14.
//  Copyright (c) 2014 Debaprasad Mondal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import <SVProgressHUD.h>
#import "CSRequestController.h"
#import "CSUserHelper.h"

NSString *isCoachShow;
 NSString *strOpponentId;

#define ALERT_TITLE @"Crescent"
#define ALT_BTN_OK @"OK"
#define IS_IPHONE_4 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 480)
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SAVEBOOL_AS_DEFAULT(_key,_value) [[NSUserDefaults standardUserDefaults]setBool:_value forKey:_key]
#define GETBOOl_DEFAUL_VALUE(_key) [[NSUserDefaults standardUserDefaults] boolForKey:_key]
#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]

#define FONT_SEMIBOLD @"SourceSansPro-Semibold"
#define FONT_LIGHT @"SourceSansPro-Light"
#define FONT_REGULAR @"SourceSansPro-Regular"
#define kQuickBloxPwd @"crescent123"

#define kDateFormat @"MMM d, yyyy hh:mm a"

typedef NS_ENUM(NSUInteger, CSErrorCode)
{
    CSErrorCodeAuthenticationFailed = 1,
    CSErrorCodeSessionExpired,
    CSErrorCodeNoConnection,
    CSErrorCodeUnknownError,
};

@interface CSUtils : NSObject


extern NSString * const kCSErrorDomain;
@property (nonatomic,retain) AppDelegate *appDelegate;
@property (nonatomic,strong)id CurrentViewController;
@property (nonatomic)NSString *chatUserName;
@property (nonatomic, assign) BOOL QBSessionCreated;
+ (CSUtils *)sharedInstance;

-(float)getSystemVersion;
-(void)ValidateEmail:(UITextField *)txtField;
-(void)showNormalAlert:(NSString *)_message;
-(void)showNormalAlertWithoutTitle:(NSString *)_message;
+(UIImage *)resizeImage:(UIImage *)_cutImage Width:(float)_Width Height:(float)_Height;
+ (UIImage *)imageWithImage:(UIImage *)imagess convertToSize:(CGSize)size;
+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize Image:(UIImage *)_cutImage;
-(NSString *)convertNotificationDate:(NSString *)matchdate Dateformat:(NSString *)format;
-(void)saveUserDetailsIntoPlistFile;
-(void)getUserDetailsIntoPlistFile;
-(NSString *)checkNullStringAndReplace:(NSString*)_inputString;
-(void)showLoadingMode;
-(void)hideLoadingMode;
-(BOOL)hasValidUser;
-(BOOL)hasQBId;
-(NSString *)getQBLogin;
-(void)registerUserForPushNotificationWithDeviceId:(NSData *)deviceId UserId:(NSString *)userId;
@end
