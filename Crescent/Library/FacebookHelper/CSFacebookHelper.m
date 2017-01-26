//
//  CSFacebookHelper.m
//  Crescent
//
//  Created by Debaprasad Mondal on 25/12/14.
//  Copyright (c) 2015 Debaprasad Mondal. All rights reserved.
//

#import "CSFacebookHelper.h"
#import <FacebookSDK/FacebookSDK.h>

@interface CSFacebookHelper (){
    
}

//@property(nonatomic,assign) BOOL isLoggingThroughFacebook;
@property(nonatomic,readwrite) FBRequestType FBREQUEST_CATEGORY;

@end

@implementation CSFacebookHelper

+(CSFacebookHelper *)sharedFacebook
{
    static dispatch_once_t onceToken;
    static CSFacebookHelper *sharedInstance = nil;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CSFacebookHelper alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self != nil) {
    }
    return self;
}


#pragma mark- Open/Close Facebook Session

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI
{
    return [FBSession openActiveSessionWithReadPermissions:[NSArray arrayWithObjects:@"user_hometown", @"user_location", @"public_profile",@"email", @"user_birthday", @"user_location", nil]
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
                                             [self sessionStateChanged:session
                                                                 state:state
                                                                 error:error];
                                         }];
}

/*
 * Closes a Facebook session.
 */

- (void)closeFBSession
{
    [FBSession.activeSession closeAndClearTokenInformation];
}

#pragma mark- Session Change Handler

/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state)
    {
        case FBSessionStateOpen:
        {
            if (!error)
            {
                // We have a valid session
                NSLog(@"User session found");
                
                switch (self.FBREQUEST_CATEGORY)
                {
                    case eSELF_DETAILS:
                    {
                        [self getSelfDetails];
                    }
                        break;
                        
                    case eSHARE_ON_WALL:
                    {
                        [self requestToPublishToFacebook];
                    }
                        break;
                        
                        
                    default:
                        break;
                }
            }
        }
            break;
            
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
        {
            [FBSession.activeSession closeAndClearTokenInformation];
            
            if (self.fbDelegate && [self.fbDelegate respondsToSelector:@selector(requestLoadError)])
                [self.fbDelegate requestLoadError];
        }
            break;
            
        default:
            break;
    }
    
 
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark- Login and Get Self Details

/*
 * Check if facebook session is active. If yes then retrieve self details else Open facebook session.
 */

- (void)loginThroughFacebookAllowLoginUI:(BOOL)allowLoginUI
{
    if(FBSession.activeSession.isOpen){
        [self getSelfDetails];
    }
    else
    {
        self.FBREQUEST_CATEGORY = eSELF_DETAILS;
        [self openSessionWithAllowLoginUI:allowLoginUI];
    }
}

/*
 * Retrieve self details.
 */

- (void)getSelfDetails
{
    if(FBSession.activeSession.isOpen)
    {
        [FBRequestConnection startWithGraphPath:@"me"
                                     parameters:@{@"fields": @"first_name, last_name, picture.type(normal), email, birthday, gender, location, locale"}
                                     HTTPMethod:@"GET"
                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
             
             if (!error) {
                 NSString* firstname = [result objectForKey:@"first_name"];
                 NSString* lastName = [result objectForKey:@"last_name"];
                 NSString* bday = [result objectForKey:@"birthday"];
                 NSString* email = [result objectForKey:@"email"];
                 NSString* gender = [result objectForKey:@"gender"];
                 NSString* city = [result objectForKey:@"city"];
                 NSString* country = [result objectForKey:@"locale"];
                 
                NSLog(@"FIRST: %@ LAST: %@ BDAY: %@ GENDER: %@ EMAIL: %@ CITY: %@ COUNTRY: %@", firstname, lastName, bday, gender, email, city, country);
                 
                 if(firstname == nil) firstname = @"";
                 if(lastName == nil) lastName = @"";
                 if(bday == nil) bday = @"";
                 if(email == nil) email = @"";
                 if(gender == nil) gender = @"";
                 if(city == nil) city = @"";
                 if(country == nil) country = @"";
                                  
                 //--- Pass the userinfo Dictionary to the Delegate method ---//
                 
                 if (self.fbDelegate && [self.fbDelegate respondsToSelector:@selector(successfulLogin:)]) {
                     [self.fbDelegate successfulLogin:result];
                 }
             }
             else
             {
                 if (self.fbDelegate && [self.fbDelegate respondsToSelector:@selector(requestLoadError)])
                     [self.fbDelegate requestLoadError];
             }
             
         }];
    }
}

#pragma mark- Publish in Facebook wall

/*
 * Check if facebook session is active. If yes then request to publish in self wall.
 */

-(void)initiatePublishInWall
{
    if(FBSession.activeSession.isOpen)
    {
        [self requestToPublishToFacebook];
    }
    else
    {
        self.FBREQUEST_CATEGORY = eSHARE_ON_WALL;
        [self openSessionWithAllowLoginUI:YES];
    }
}

/*
 * Check if facebook session has publish action permission. If yes then proceed to Publish in wall else ask for new permissions.
 */

- (void)requestToPublishToFacebook
{
    // Ask for publish_actions permissions in context
    if ([FBSession.activeSession.permissions
         indexOfObject:@"publish_actions"] == NSNotFound)
    {
        // No permissions found in session, ask for it
        [FBSession.activeSession
         requestNewPublishPermissions:
         [NSArray arrayWithObject:@"publish_actions"]
         defaultAudience:FBSessionDefaultAudienceFriends
         completionHandler:^(FBSession *session, NSError *error) {
             if (!error)
             {
                 // If permissions granted, publish the story
                  NSLog(@"Now Have Permissions");
                 [self publishInFacebookWall];
             }
             else
             {
                 if (self.fbDelegate && [self.fbDelegate respondsToSelector:@selector(requestLoadError)])
                     [self.fbDelegate requestLoadError];
             }
         }];
    }
    else
    {
        // If permissions present, publish the story
        NSLog(@"Have Permissions");
        [self publishInFacebookWall];
    }
}

/*
 * Publish content in user's wall. The below method will vary depending upon project's requirement.
 */

- (void)publishInFacebookWall
{
    NSString *fbPageLink = @"http://bit.ly/1pMrJmq";
    
    NSString *messageString = [NSString stringWithFormat:@"Prost! I've entered Oktoberfest Pursuit for a chance to win tickets to Oktoberfest 2014! Check out the app to join in %@", fbPageLink];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
  /*  [params setObject:@"http://www.els.edu/" forKey:@"link"];
    [params setObject:@"ELS" forKey:@"name"];
    [params setObject:@"Learn what you can expect from the leader in English language instruction" forKey:@"caption"];
    [params setObject:@"For over 50 years, students have chosen ELS to achieve their English language goals. With 12 class levels, state-of-the-art language technology centers, multiple testing services and university admission assistance, ELS ensures success through our personalized approach and commitment to student achievement." forKey:@"description"]; */
    
    [params setObject:messageString forKey:@"message"];
    
    [FBRequestConnection
     startWithGraphPath:@"me/feed"
     parameters:params
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         NSString *alertText;
         if (error)
         {
             alertText = [NSString stringWithFormat:
                          @"error: domain = %@, code = %ld",
                          error.domain, (long)error.code];
             
             if (self.fbDelegate && [self.fbDelegate respondsToSelector:@selector(requestLoadError)])
                 [self.fbDelegate requestLoadError];
         }
         else
         {
             alertText = [NSString stringWithFormat:
                          @"Successfully Posted to Facebook."];
             
             if (self.fbDelegate && [self.fbDelegate respondsToSelector:@selector(postToWallSuccessful)])
                 [self.fbDelegate postToWallSuccessful];
         }
         
         // Show the result in an alert
         [[[UIAlertView alloc] initWithTitle:@"Result"
                                     message:alertText
                                    delegate:self
                           cancelButtonTitle:@"Ok"
                           otherButtonTitles:nil]
          show];
         
     }];
}

#pragma mark- Get FriendList

/*
 * Check if facebook session is active. If yes then request to get friend List.
 */

/*
-(void)getFriendList
{
    if(FBSession.activeSession.isOpen)
    {
        [self requestToGetFriendList];
    }
    else
    {
        self.FBREQUEST_CATEGORY = eFRIEND_LIST;
        [self openSessionWithAllowLoginUI:YES];
    }
}*/

/*
 * Check if facebook session has Read Friendlist permission. If yes then proceed to get friend list else ask for new permissions.
 */
/*
-(void)requestToGetFriendList
{
    // Ask for read_friendlists permissions in context
    if ([FBSession.activeSession.permissions
         indexOfObject:@"read_friendlists"] == NSNotFound)
    {
        // No permissions found in session, ask for it
        [FBSession.activeSession
         requestNewReadPermissions:
         [NSArray arrayWithObject:@"read_friendlists"]
         completionHandler:^(FBSession *session, NSError *error) {
             if (!error)
             {
                 // If permissions granted
                 NSLog(@"Now Have Permissions");
                 [self retrieveFriendListForUser];
             }
             else
             {
                 if (self.fbDelegate && [self.fbDelegate respondsToSelector:@selector(requestLoadError)])
                     [self.fbDelegate requestLoadError];
             }
         }];
    }
    else
    {
        // If permissions present, publish the story
        NSLog(@"Have Permissions");
        [self retrieveFriendListForUser];
    }
}*/

/*
-(void)retrieveFriendListForUser
{
    [FBRequestConnection startWithGraphPath:@"me/friends"
                                 parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"picture,id,name,link,gender",@"fields",nil]
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                             
                              if (error)
                              {
                                  if (self.fbDelegate && [self.fbDelegate respondsToSelector:@selector(requestLoadError)])
                                      [self.fbDelegate requestLoadError];
                              }
                              else
                              {
                                  if (self.fbDelegate && [self.fbDelegate respondsToSelector:@selector(retrievedFriendList:)])
                                      [self.fbDelegate retrievedFriendList:result];
                              }

                          }];
}*/



@end
