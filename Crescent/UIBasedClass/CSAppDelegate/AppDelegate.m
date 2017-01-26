//
//  AppDelegate.m
//  Crescent
//
//  Created by Debaprasad Mondal on 30/11/14.
//  Copyright (c) 2014 Debaprasad Mondal. All rights reserved.
//

#import "AppDelegate.h"
#import "MFSideMenuContainerViewController.h"
#import "SideMenuViewController.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import <AFNetworking.h>
#import <FacebookSDK/FacebookSDK.h>
#import "CSUtils.h"
#import "UICKeyChainStore.h"
#import "CSDiscoveryViewController.h"
#import "CSNotificationViewController.h"
#import <Quickblox/Quickblox.h>

@interface AppDelegate () <UIAlertViewDelegate>

@property (nonatomic, assign) BOOL notificationsAlertShow;

@end
NSString *const BFTaskMultipleExceptionsException = @"BFMultipleExceptionsException";

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // QB setting
    [QBApplication sharedApplication].applicationId = 24072;
    [QBConnection registerServiceKey:@"xOg7mbBdGg9-Tb8"];       // hamid996
    [QBConnection registerServiceSecret:@"vxSawJpKhPfBSZK"];
    [QBSettings setAccountKey:@"vCVy1heqscp1pg2YT18Q"];
    [QBSettings setLogLevel:QBLogLevelDebug];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSDictionary *userInfo = [launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    NSLog(@"%@", userInfo);
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    
    if(apsInfo) {
        self.showNotifications = YES;
    }
    
//    [QBApplication sharedApplication].applicationId = 22728;
//    [QBConnection registerServiceKey:@"m9mOOwPWrb3ZLtL"];
//    [QBConnection registerServiceSecret:@"qKg2vCwvNvdRq3d"];    //sandeep
//    [QBSettings setAccountKey:@"qYMtLwuWj12qZhvNXMep"];
    
        [[CSUtils sharedInstance] getUserDetailsIntoPlistFile];
    
    // Register for Push Notitications
    
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
        
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
        
    }else{
        
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
        
    }

    
    
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    _latitude=@"0";
    _longitude=@"0";
    //SAVEBOOL_AS_DEFAULT(@"isInstalled", NO);
 //   SAVEBOOL_AS_DEFAULT(@"isLogin", NO);
    // Override point for customization after application launch.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MFSideMenuContainerViewController *container = (MFSideMenuContainerViewController *)self.window.rootViewController;
    self.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"navigationController"];
    
    self.leftSideMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"leftSideMenuViewController"];
    
    [container setLeftMenuViewController:self.leftSideMenuViewController];
    [container setCenterViewController:self.navigationController];
      //--- Start Monitoring the AFNetworkReachabilityManager ---//
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
            case AFNetworkReachabilityStatusUnknown:
            {
                
            }
                break;
            default:
                
                break;
        }
    }];
    
    _locationManager= [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 20; // setting distance filter
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation]; // start location manager to get current location

    return YES;
}
#pragma mark - Location manager delegate -
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *newLocation = [locations lastObject];
    // get current location, state, country using geocoder.
    _latitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    _longitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    
    [manager stopUpdatingLocation]; // Turn off the location manager to save power.
    if (!_isLocationFound) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"findpeople" object:nil];
    }
    _isLocationFound=YES;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    /*NSString *errorType = (error.code == kCLErrorDenied) ? NSLocalizedString(@"access_denied", @"") : NSLocalizedString(@"unknown_error", @"");
     UIAlertView *alert = [[UIAlertView alloc]
     initWithTitle:NSLocalizedString(@"error_getting_location", @"")
     message:errorType
     delegate:nil
     cancelButtonTitle:NSLocalizedString(@"ok", @"")
     otherButtonTitles:nil];
     [alert show];*/
    
}


/*+
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    
#if !TARGET_IPHONE_SIMULATOR
    /*
    // Prepare the Device Token for Registration (remove spaces and < >)
    application.applicationIconBadgeNumber=0;
    NSString *deviceToken = [[[[devToken description]
                               stringByReplacingOccurrencesOfString:@"<"withString:@""]
                              stringByReplacingOccurrencesOfString:@">" withString:@""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""];
    self.DeviceToken=deviceToken;
    
    //DebugLog(@"self.DeviceToken %@",self.DeviceToken);
 */
    // Store the deviceToken in the current installation and save it to Parse.
    /*
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:devToken];
    currentInstallation.channels = @[ @"Crescent" ];
    
    [currentInstallation saveInBackground];
     */
   // gDeviceToken=devToken;
    
//#endif
//}*/
/**
 * Failed to Register for Remote Notifications
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
#if !TARGET_IPHONE_SIMULATOR
    
    NSLog(@"Error in registration. Error: %@", error);
    
#endif
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
#if !TARGET_IPHONE_SIMULATOR
    if (self.notificationsAlertShow == YES) {
        return;
    }
    
    application.applicationIconBadgeNumber = 1;
    NSLog(@"remote notification: %@",[userInfo description]);
    
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:ALERT_TITLE message:@"You have new notification" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Open", nil];
    
    self.notificationsAlertShow = YES;
    [alert show];
    
    
#endif
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}

-(void)registerForNotifications{
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)
                                           categories:nil]];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken  {
    NSLog(@"My token is: %@", deviceToken);
    
    self.deviceTokenString = [[[[deviceToken description]
                                stringByReplacingOccurrencesOfString:@"<"withString:@""]
                               stringByReplacingOccurrencesOfString:@">" withString:@""]
                              stringByReplacingOccurrencesOfString: @" " withString: @""];
    
}

#pragma markk - AlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        
        self.notificationsAlertShow = NO;
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        
        
        if ([self.navigationController.viewControllers.lastObject isKindOfClass:[CSNotificationViewController class]]) {
            
            CSNotificationViewController *mNotificationController = self.navigationController.viewControllers.lastObject;
            [mNotificationController updateNotificationsList];
            
            return;
        }
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        CSNotificationViewController *mNotificationController = [storyboard instantiateViewControllerWithIdentifier:@"CSNotificationViewController"];
        [self.navigationController pushViewController:mNotificationController animated:YES];
        
    }
}

@end
