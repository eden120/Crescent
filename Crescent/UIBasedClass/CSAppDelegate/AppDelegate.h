//
//  AppDelegate.h
//  Crescent
//
//  Created by Debaprasad Mondal on 30/11/14.
//  Copyright (c) 2014 Debaprasad Mondal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

NSData *gDeviceToken;
@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *leftSideMenuViewController;
@property (assign, nonatomic) BOOL isShowingSlideMenu;
@property (strong, nonatomic)UINavigationController *navigationController;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic)NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (assign, nonatomic) BOOL isLocationFound;
@property(nonatomic,strong)NSString *DeviceToken;
@property (nonatomic, strong) NSString *deviceTokenString;

@property (nonatomic, strong) NSString *friendID;
@property (nonatomic, assign) BOOL showNotifications;

@end

