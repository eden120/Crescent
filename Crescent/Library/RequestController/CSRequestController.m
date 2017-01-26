//
//  RequestController.m
//  Crescent
//
//  Created by Debaprasad Mondal on 25/12/14.
//  Copyright (c) 2015 Debaprasad Mondal. All rights reserved.
//

#import "CSRequestController.h"
#import "CSUtils.h"
#import "AppDelegate.h"

#define BASEURL @"http://www.crescentapp.com/mobileapp/services/"
//#define BASEURL @"http://178.62.116.93:81/crescentapp/index.php/services/"

@implementation CSRequestController


+(CSRequestController *)sharedInstance
{
    static CSRequestController *sharedInstance_ = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance_ = [[CSRequestController alloc] init];
    });
    return sharedInstance_;
}

-(id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
#pragma mark -
#pragma mark Error Helper Methods
- (NSError *)errorWithCode:(CSErrorCode)code
{
    return [NSError errorWithDomain:kCSErrorDomain code:code userInfo:nil];
}

- (NSError *)errorFromError:(NSError *)error
{
    return [self errorWithCode:(error.code == -1001 ? CSErrorCodeSessionExpired : CSErrorCodeUnknownError)];
}

-(void)dofetchUserByFBId:(NSString *)fbid success:(void (^)(NSDictionary *responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *endpoint=[NSString stringWithFormat:@"%@/fetchUserByFBId",BASEURL];
    
    NSDictionary *params;
    
    params = @{ @"device":@"ios",
                 @"devicetoken":[[CSUtils sharedInstance] checkNullStringAndReplace:[CSUtils sharedInstance].appDelegate.deviceTokenString],
                 @"FBId":fbid
                 };
    
    NSLog(@"fetch User By FBId in with params: %@", params);
    // Make sure to set the responseSerializer correctly
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self POST:endpoint
    parameters:params
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           if (![responseObject isKindOfClass:[NSDictionary class]]) {
               failure(operation, nil);
           }
           success(responseObject);
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSString *str=[[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding];
           NSLog(@"%@",str);
           if (operation.responseData) {
               id responseObject = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil] ;
               if ([responseObject isKindOfClass:[NSDictionary class]]){
                   // Handling this case here as well in case the WS response codes get corrected.
                   success(responseObject);
               }
               else{
                   failure(operation, [self errorFromError:error]);
               }
           }
           else
               failure(operation, [self errorFromError:error]);
           
           
       }];

}
-(void)doSignUpWithEmailId:(NSString *)email Password:(NSString *)password Name:(NSString *)name UserImage:(NSString *)image PhNo:(NSString*)phno About:(NSString *)about Birthday:(NSString *)birthday Gender:(NSString *)gender Location:(NSString *)location LoginType:(NSString *)logintype Latitude:(NSString *)latitude Longitude:(NSString *)longitude FBID:(NSString*)fbid success:(void (^)(NSDictionary *responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *endpoint=[NSString stringWithFormat:@"%@/RegisterUser",BASEURL];
    
    NSDictionary *params;
    
    params = @{@"name":name,
               @"email":email,
               @"password":password,
               @"image":image,
               @"phoneno":phno,
               @"about":about,
               @"birthday":birthday,
               @"gender":gender,
               @"location":location,
               @"login_type":logintype,
               @"latitude":latitude,
               @"longitude":longitude,
               @"device":@"ios",
               @"devicetoken":[[CSUtils sharedInstance] checkNullStringAndReplace:[CSUtils sharedInstance].appDelegate.deviceTokenString],
               @"FBId":fbid
                   };
    
    NSLog(@"RegisterUser with params: %@", params);
    // Make sure to set the responseSerializer correctly
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self POST:endpoint
    parameters:params
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           if (![responseObject isKindOfClass:[NSDictionary class]]) {
               failure(operation, nil);
           }
           success(responseObject);
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSString *str=[[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding];
           NSLog(@"%@",str);
           if (operation.responseData) {
               id responseObject = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil] ;
               if ([responseObject isKindOfClass:[NSDictionary class]]){
                   // Handling this case here as well in case the WS response codes get corrected.
                   success(responseObject);
               }
               else{
                   failure(operation, [self errorFromError:error]);
               }
           }
           else
               failure(operation, [self errorFromError:error]);
           

       }];
    
}

-(void)doUpdateUserWithId:(NSString *)userid Email:(NSString *)email Password:(NSString *)password Name:(NSString *)name UserImage:(NSString *)image PhNo:(NSString*)phno About:(NSString *)about Birthday:(NSString *)birthday Gender:(NSString *)gender Location:(NSString *)location LoginType:(NSString *)logintype Latitude:(NSString *)latitude Longitude:(NSString *)longitude FBID:(NSString*)fbid success:(void (^)(NSDictionary *responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *endpoint=[NSString stringWithFormat:@"%@/UpdateMyProfile",BASEURL];
    
    NSDictionary *params;
    
    params = @{@"userid":userid,
               @"name":name,
               @"email":email,
               @"password":password,
               @"image":image,
               @"phoneno":phno,
               @"About":about,
               @"birthday":birthday,
               @"gender":gender,
               @"location":location,
               @"login_type":logintype,
               @"latitude":latitude,
               @"longitude":longitude,
               @"device":@"ios",
               @"devicetoken":[[CSUtils sharedInstance] checkNullStringAndReplace:[CSUtils sharedInstance].appDelegate.deviceTokenString],
               @"FBId":fbid
               };
    
    NSLog(@"UpdateMyProfile with params: %@", params);
    // Make sure to set the responseSerializer correctly
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self POST:endpoint
    parameters:params
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           if (![responseObject isKindOfClass:[NSDictionary class]]) {
               failure(operation, nil);
           }
           success(responseObject);
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSString *str=[[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding];
           NSLog(@"%@",str);
           if (operation.responseData) {
               id responseObject = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil] ;
               if ([responseObject isKindOfClass:[NSDictionary class]]){
                   // Handling this case here as well in case the WS response codes get corrected.
                   success(responseObject);
               }
               else{
                   failure(operation, [self errorFromError:error]);
               }
           }
           else
               failure(operation, [self errorFromError:error]);
           
           
       }];
    
}



-(void)doLoginWithEmailId:(NSString *)email Password:(NSString *)password success:(void (^)(NSDictionary *responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    NSString *endpoint=[NSString stringWithFormat:@"%@/Login",BASEURL];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:endpoint]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"email=%@&password=%@&devicetoken=%@&device=%@",email,password,[CSUtils sharedInstance].appDelegate.deviceTokenString, @"ios"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    // Make sure to set the responseSerializer correctly
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            failure(operation, nil);
        }
        success(responseObject);
    }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if ([operation.responseObject isKindOfClass:[NSDictionary class]] && ![operation.responseObject[@"response"] isEqualToString:@"success"]){
             // Handling this case here as well in case the WS response codes get corrected.
             failure(operation, [self errorWithCode:CSErrorCodeAuthenticationFailed]);
         }
         else{
             failure(operation, [self errorFromError:error]);
         }

         
     }];
    [operation start];

}
-(void)doForgotPasswordWithEmailId:(NSString *)email success:(void (^)(NSDictionary *responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *endpoint = [NSString stringWithFormat:@"%@/ForgotPassword",BASEURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:endpoint]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"email=%@",email ];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    // Make sure to set the responseSerializer correctly
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            failure(operation, nil);
        }
        success(responseObject);
    }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if ([operation.responseObject isKindOfClass:[NSDictionary class]] && ![operation.responseObject[@"response"] isEqualToString:@"success"]){
             // Handling this case here as well in case the WS response codes get corrected.
             failure(operation, [self errorWithCode:CSErrorCodeAuthenticationFailed]);
         }
         else{
             failure(operation, [self errorFromError:error]);
         }

         
     }];
    [operation start];
 
}
-(void)updateMyinterestsWithUserId:(NSString *)userid Interests:(NSString *)interests success:(void (^)(NSDictionary *responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *endpoint = [NSString stringWithFormat:@"%@/UpdateMyInterest",BASEURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:endpoint]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"userid=%@&interests=%@",userid, interests ];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    // Make sure to set the responseSerializer correctly
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            failure(operation, nil);
        }
        success(responseObject);
    }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if ([operation.responseObject isKindOfClass:[NSDictionary class]] && ![operation.responseObject[@"response"] isEqualToString:@"success"]){
             // Handling this case here as well in case the WS response codes get corrected.
             failure(operation, [self errorWithCode:CSErrorCodeAuthenticationFailed]);
         }
         else{
             failure(operation, [self errorFromError:error]);
         }

         
     }];
    [operation start];
    
}
-(void)updateDiscoverWithUserId:(NSString *)userid Show:(NSString *)show AgeRange:(NSString *)agerange success:(void (^)(NSDictionary *responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *endpoint = [NSString stringWithFormat:@"%@/UpdateDiscover",BASEURL];
    
    NSDictionary *params;
    
    NSString *showParams = @"Men";
    
    if ([show isEqualToString:@"Only Women"]) {
        showParams = @"OnlyWomen";
    } else if ([show isEqualToString:@"Men & Women"]) {
        showParams = show;
    }
    
    params = @{@"userid":userid,
               @"show":showParams,
               @"agerange":agerange
               };
    
    NSLog(@"UpdateDiscover with params: %@", params);
    // Make sure to set the responseSerializer correctly
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self POST:endpoint
    parameters:params
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           if (![responseObject isKindOfClass:[NSDictionary class]]) {
               failure(operation, nil);
           }
           success(responseObject);
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSString *str=[[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding];
           NSLog(@"%@",str);
           if (operation.responseData) {
               id responseObject = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil] ;
               if ([responseObject isKindOfClass:[NSDictionary class]]){
                   // Handling this case here as well in case the WS response codes get corrected.
                   success(responseObject);
               }
               else{
                   failure(operation, [self errorFromError:error]);
               }
           }
           else
               failure(operation, [self errorFromError:error]);
           
           
       }];

   /* NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:endpoint]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"userid=%@&show=%@&agerange=%@",userid, show, agerange];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    // Make sure to set the responseSerializer correctly
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            failure(operation, nil);
        }
        success(responseObject);
    }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if ([operation.responseObject isKindOfClass:[NSDictionary class]] && ![operation.responseObject[@"response"] isEqualToString:@"success"]){
             // Handling this case here as well in case the WS response codes get corrected.
             failure(operation, [self errorWithCode:CSErrorCodeAuthenticationFailed]);
         }
         else{
             failure(operation, [self errorFromError:error]);
         }
         
         
     }];
    [operation start];*/
    
}

-(void)findPeopleNearWithUserId:(NSString *)userid Latitude:(NSString *)latitude Longitude:(NSString *)longitude Pageno:(int)pageno Pagesize:(int )pagesize success:(void (^)(NSDictionary *responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *endpoint = [NSString stringWithFormat:@"%@/FindingPeopleNear",BASEURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:endpoint]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:120.0];
    
    
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"userid=%@&latitude=%@&longitude=%@&pageno=%d&pagesize=%d",userid, latitude, longitude,pageno, pagesize];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
  
    if (delegate.friendID) {
        
        postString = [NSString stringWithFormat:@"userid=%@&latitude=%@&longitude=%@&pageno=%d&pagesize=%d&friendid=%@",userid, latitude, longitude,pageno, pagesize, delegate.friendID];
        delegate.friendID = nil;
        
    }
    
    NSLog(@"findPeopleNearWithUserId: %@", postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    // Make sure to set the responseSerializer correctly
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            failure(operation, nil);
        }
        NSLog(@"Discovery:%@",responseObject);
        success(responseObject);
    }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if ([operation.responseObject isKindOfClass:[NSDictionary class]] && ![operation.responseObject[@"response"] isEqualToString:@"success"]){
             // Handling this case here as well in case the WS response codes get corrected.
             failure(operation, [self errorWithCode:CSErrorCodeAuthenticationFailed]);
         }
         else{
             failure(operation, [self errorFromError:error]);
         }
         
         
     }];
    [operation start];
    
}

-(void)getFriendsProfileWithUserId:(NSString *)userid Friendid:(NSString *)friendid success:(void (^)(NSDictionary *responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *endpoint = [NSString stringWithFormat:@"%@/FriendProfile",BASEURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:endpoint]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"userid=%@&friendid=%@",userid,friendid];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    // Make sure to set the responseSerializer correctly
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            failure(operation, nil);
        }
        success(responseObject);
    }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if ([operation.responseObject isKindOfClass:[NSDictionary class]] && ![operation.responseObject[@"response"] isEqualToString:@"success"]){
             // Handling this case here as well in case the WS response codes get corrected.
             failure(operation, [self errorWithCode:CSErrorCodeAuthenticationFailed]);
         }
         else{
             failure(operation, [self errorFromError:error]);
         }
         
         
     }];
    [operation start];
    
}

-(void)logOutWithUserId:(NSString *)userid success:(void (^)(NSDictionary *responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *endpoint = [NSString stringWithFormat:@"%@/Logout",BASEURL];
    
    NSDictionary *params;
    
    params = @{@"userid":userid
               };
    
    NSLog(@"Logout with params: %@", params);
    // Make sure to set the responseSerializer correctly
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self POST:endpoint
    parameters:params
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           if (![responseObject isKindOfClass:[NSDictionary class]]) {
               failure(operation, nil);
           }
           success(responseObject);
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSString *str=[[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding];
           NSLog(@"%@",str);
           if (operation.responseData) {
               id responseObject = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil] ;
               if ([responseObject isKindOfClass:[NSDictionary class]]){
                   // Handling this case here as well in case the WS response codes get corrected.
                   success(responseObject);
               }
               else{
                   failure(operation, [self errorFromError:error]);
               }
           }
           else
               failure(operation, [self errorFromError:error]);
           
           
       }];
}

-(void)updateNotiFicationSettingsWithUserId:(NSString *)userid newMatches:(NSString *)newmatches Messages:(NSString *)message success:(void (^)(NSDictionary *responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *endpoint = [NSString stringWithFormat:@"%@/UpdateNotificationSettings",BASEURL];
    
    NSDictionary *params;
    
    params = @{@"userid":userid,
               @"newmatches":newmatches,
               @"messages":message
               };
    
    NSLog(@"UpdateNotificationSettings with params: %@", params);
    // Make sure to set the responseSerializer correctly
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self POST:endpoint
    parameters:params
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           if (![responseObject isKindOfClass:[NSDictionary class]]) {
               failure(operation, nil);
           }
           success(responseObject);
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSString *str=[[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding];
           NSLog(@"%@",str);
           if (operation.responseData) {
               id responseObject = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil] ;
               if ([responseObject isKindOfClass:[NSDictionary class]]){
                   // Handling this case here as well in case the WS response codes get corrected.
                   success(responseObject);
               }
               else{
                   failure(operation, [self errorFromError:error]);
               }
           }
           else
               failure(operation, [self errorFromError:error]);
           
           
       }];
}
-(void)getNotificationListWithUserId:(NSString *)userid success:(void (^)(NSDictionary *responseObject))success
                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *endpoint = [NSString stringWithFormat:@"%@/NotificationList",BASEURL];
    
    NSDictionary *params;
    
    params = @{@"userid":userid
               };
    
    NSLog(@"NotificationList with params: %@", params);
    // Make sure to set the responseSerializer correctly
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self POST:endpoint
    parameters:params
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           if (![responseObject isKindOfClass:[NSDictionary class]]) {
               failure(operation, nil);
           }
           success(responseObject);
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSString *str=[[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding];
           NSLog(@"ttt%@",str);
           if (operation.responseData) {
               id responseObject = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil] ;
               if ([responseObject isKindOfClass:[NSDictionary class]]){
                   // Handling this case here as well in case the WS response codes get corrected.
                   success(responseObject);
               }
               else{
                   failure(operation, [self errorFromError:error]);
               }
           }
           else
               failure(operation, [self errorFromError:error]);
           
           
       }];
}

-(void)getMatchedUserListWithUserId:(NSString *)userid success:(void (^)(NSDictionary *responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *endpoint = [NSString stringWithFormat:@"%@/MatchedList",BASEURL];
    
    NSDictionary *params;
    
    params = @{@"userid":userid
               };
    
    NSLog(@"MatchedList with params: %@", params);
    // Make sure to set the responseSerializer correctly
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self POST:endpoint
    parameters:params
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           if (![responseObject isKindOfClass:[NSDictionary class]]) {
               failure(operation, nil);
           }
           success(responseObject);
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSString *str=[[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding];
           NSLog(@"ttt%@",str);
           if (operation.responseData) {
               id responseObject = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil] ;
               if ([responseObject isKindOfClass:[NSDictionary class]]){
                   // Handling this case here as well in case the WS response codes get corrected.
                   success(responseObject);
               }
               else{
                   failure(operation, [self errorFromError:error]);
               }
           }
           else
               failure(operation, [self errorFromError:error]);
           
           
       }];
}


-(void)deleteAccountWithUserId:(NSString *)userid success:(void (^)(NSDictionary *responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *endpoint = [NSString stringWithFormat:@"%@/DeleteAccount",BASEURL];
    
    NSDictionary *params;
    
    params = @{@"userid":userid
               };
    
    NSLog(@"DeleteAccount with params: %@", params);
    // Make sure to set the responseSerializer correctly
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self POST:endpoint
    parameters:params
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           if (![responseObject isKindOfClass:[NSDictionary class]]) {
               failure(operation, nil);
           }
           success(responseObject);
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSString *str=[[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding];
           NSLog(@"%@",str);
           if (operation.responseData) {
               id responseObject = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil] ;
               if ([responseObject isKindOfClass:[NSDictionary class]]){
                   // Handling this case here as well in case the WS response codes get corrected.
                   success(responseObject);
               }
               else{
                   failure(operation, [self errorFromError:error]);
               }
           }
           else
               failure(operation, [self errorFromError:error]);
           
           
       }];
}
-(void)likeOrDislikeFriendWithUserId:(NSString *)userid FriendId:(NSString *)frndid Likestatus:(NSString *)likestatus success:(void (^)(NSDictionary *responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *endpoint = [NSString stringWithFormat:@"%@/LikeOrDislikeFriend",BASEURL];
    
    NSDictionary *params;
    
    params = @{@"userid":userid,
               @"friendid":frndid,
               @"like":likestatus
               };
    
    NSLog(@"LikeOrDislikeFriend with params: %@", params);
    // Make sure to set the responseSerializer correctly
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self POST:endpoint
    parameters:params
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           if (![responseObject isKindOfClass:[NSDictionary class]]) {
               failure(operation, nil);
           }
           success(responseObject);
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSString *str=[[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding];
           NSLog(@"%@",str);
           if (operation.responseData) {
               id responseObject = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil] ;
               if ([responseObject isKindOfClass:[NSDictionary class]]){
                   // Handling this case here as well in case the WS response codes get corrected.
                   success(responseObject);
               }
               else{
                   failure(operation, [self errorFromError:error]);
               }
           }
           else
               failure(operation, [self errorFromError:error]);
           
           
       }];
}

-(void)updateQBIdWith:(NSString *)userid BQId:(NSString *)BQId success:(void (^)(NSDictionary *responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *endpoint = [NSString stringWithFormat:@"%@/UpdateMyProfile",BASEURL];
    
    NSDictionary *params;
    
    params = @{@"userid":userid,
               @"quickblox_id":BQId
               };
    
    NSLog(@"UpdateMyProfile with params: %@", params);
    // Make sure to set the responseSerializer correctly
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self POST:endpoint
    parameters:params
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           if (![responseObject isKindOfClass:[NSDictionary class]]) {
               failure(operation, nil);
           }
           success(responseObject);
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSString *str=[[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding];
           NSLog(@"%@",str);
           if (operation.responseData) {
               id responseObject = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil] ;
               if ([responseObject isKindOfClass:[NSDictionary class]]){
                   // Handling this case here as well in case the WS response codes get corrected.
                   success(responseObject);
               }
               else{
                   failure(operation, [self errorFromError:error]);
               }
           }
           else
               failure(operation, [self errorFromError:error]);
           
           
       }];
}

-(void)updateProfileWithUserId:(NSString *)userid Name:(NSString *)name About:(NSString *)about Birthday:(NSString *)birthday Gender:(NSString *)gender Interests:(NSString *)interest Image1:(NSString *)image1 Image2:(NSString *)image2 Image3:(NSString *)image3 Image4:(NSString *)image4 success:(void (^)(NSDictionary *responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *endpoint = [NSString stringWithFormat:@"%@/UpdateMyProfile",BASEURL];
    
    NSDictionary *params;
    
    params = @{@"userid":userid,
               @"name":name,
               @"About":about,
               @"birthday":birthday,
               @"gender":gender,
               @"interests":interest,
               @"image1":image1,
               @"image2":image2,
               @"image3":image3,
               @"image4":image4
               };
    
    NSLog(@"UpdateMyProfile with params: %@", params);
    // Make sure to set the responseSerializer correctly
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self POST:endpoint
    parameters:params
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           if (![responseObject isKindOfClass:[NSDictionary class]]) {
               failure(operation, nil);
           }
           success(responseObject);
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSString *str=[[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding];
           NSLog(@"%@",str);
           if (operation.responseData) {
               id responseObject = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil] ;
               if ([responseObject isKindOfClass:[NSDictionary class]]){
                   // Handling this case here as well in case the WS response codes get corrected.
                   success(responseObject);
               }
               else{
                   failure(operation, [self errorFromError:error]);
               }
           }
           else
               failure(operation, [self errorFromError:error]);
           
           
       }];
}
-(void)notificationListWithUserId:(NSString *)userid success:(void (^)(NSDictionary *responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *endpoint = [NSString stringWithFormat:@"%@/NotificationList",BASEURL];
    
    NSDictionary *params;
    
    params = @{@"userid":userid
               };
    
    NSLog(@"NotificationList with params: %@", params);
    // Make sure to set the responseSerializer correctly
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self POST:endpoint
    parameters:params
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           if (![responseObject isKindOfClass:[NSDictionary class]]) {
               failure(operation, nil);
           }
           success(responseObject);
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSString *str=[[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding];
           NSLog(@"%@",str);
           if (operation.responseData) {
               id responseObject = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil] ;
               if ([responseObject isKindOfClass:[NSDictionary class]]){
                   // Handling this case here as well in case the WS response codes get corrected.
                   success(responseObject);
               }
               else{
                   failure(operation, [self errorFromError:error]);
               }
           }
           else
               failure(operation, [self errorFromError:error]);
           
           
       }];
}

-(void)profileLikeOrDislikeWithUserId:(NSString *)userid FriendId:(NSString *)frndid Likestatus:(NSString *)likestatus success:(void (^)(NSDictionary *responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *endpoint = [NSString stringWithFormat:@"%@/ProfileLikeOrDislike",BASEURL];
    
    NSDictionary *params;
    
    params = @{@"userid":userid,
               @"friendsid":frndid,
               @"islike":likestatus
               };
    
    NSLog(@"ProfileLikeOrDislike with params: %@", params);
    // Make sure to set the responseSerializer correctly
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self POST:endpoint
    parameters:params
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           NSString *str=[[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding];
           NSLog(@"%@",str);
           if (![responseObject isKindOfClass:[NSDictionary class]]) {
               failure(operation, nil);
           }
           success(responseObject);
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSString *str=[[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding];
           NSLog(@"%@",str);
           if (operation.responseData) {
               id responseObject = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil] ;
               if ([responseObject isKindOfClass:[NSDictionary class]]){
                   // Handling this case here as well in case the WS response codes get corrected.
                   success(responseObject);
               }
               else{
                   failure(operation, [self errorFromError:error]);
               }
           }
           else
               failure(operation, [self errorFromError:error]);
           
           
       }];
}


-(void)sendNotiFicationinAndroidDeviceWithDeviceToken:(NSString *)deviceToken Messages:(NSString *)message success:(void (^)(NSDictionary *responseObject))success
                                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSString *endpoint = [NSString stringWithFormat:@"%@/SendPushNotification",BASEURL];
    
    NSDictionary *params;
    
    params = @{@"devicetoken":deviceToken,@"message":message
               };
    
    NSLog(@"SendPushNotification with params: %@", params);
    // Make sure to set the responseSerializer correctly
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self POST:endpoint
    parameters:params
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           if (![responseObject isKindOfClass:[NSDictionary class]]) {
               failure(operation, nil);
           }
           success(responseObject);
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSString *str=[[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding];
           NSLog(@"%@",str);
           if (operation.responseData) {
               id responseObject = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil] ;
               if ([responseObject isKindOfClass:[NSDictionary class]]){
                   // Handling this case here as well in case the WS response codes get corrected.
                   success(responseObject);
               }
               else{
                   failure(operation, [self errorFromError:error]);
               }
           }
           else
               failure(operation, [self errorFromError:error]);
           
           
       }];

    
}


-(void)profileBlockWithUserId:(NSString *)userid FriendId:(NSString *)frndid Reason:(NSString *)reason  success:(void (^)(NSDictionary *responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *endpoint = [NSString stringWithFormat:@"%@/BlockUser",BASEURL];
    
    NSDictionary *params;
    
    params = @{@"userid":userid,
               @"friendid":frndid,
               @"reason":reason
               };
    
    NSLog(@"profileBlockWithUserId with params: %@", params);
    // Make sure to set the responseSerializer correctly
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self POST:endpoint
    parameters:params
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           NSString *str=[[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding];
           NSLog(@"%@",str);
           if (![responseObject isKindOfClass:[NSDictionary class]]) {
               failure(operation, nil);
           }
           success(responseObject);
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSString *str=[[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding];
           NSLog(@"%@",str);
           if (operation.responseData) {
               id responseObject = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil] ;
               if ([responseObject isKindOfClass:[NSDictionary class]]){
                   success(responseObject);
               }
               else{
                   failure(operation, [self errorFromError:error]);
               }
           }
           else
               failure(operation, [self errorFromError:error]);
           
           
       }];
}

-(void)reportUserkWithUserId:(NSString *)userid FriendId:(NSString *)frndid Reason:(NSString *)reason  success:(void (^)(NSDictionary *responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *endpoint = [NSString stringWithFormat:@"%@/ReportUser",BASEURL];
    
    NSDictionary *params;
    
    params = @{@"userid":userid,
               @"friendid":frndid,
               @"reason":reason
               };
    
    NSLog(@"reportUserkWithUserId with params: %@", params);
    // Make sure to set the responseSerializer correctly
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self POST:endpoint
    parameters:params
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           NSString *str=[[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding];
           NSLog(@"%@",str);
           if (![responseObject isKindOfClass:[NSDictionary class]]) {
               failure(operation, nil);
           }
           success(responseObject);
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSString *str=[[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding];
           NSLog(@"%@",str);
           if (operation.responseData) {
               id responseObject = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil] ;
               if ([responseObject isKindOfClass:[NSDictionary class]]){
                   success(responseObject);
               }
               else{
                   failure(operation, [self errorFromError:error]);
               }
           }
           else
               failure(operation, [self errorFromError:error]);
           
           
       }];
}

@end
