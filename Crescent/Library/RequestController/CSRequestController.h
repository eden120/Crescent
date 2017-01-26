//
//  RequestController.h
//  Crescent
//
//  Created by Debaprasad Mondal on 25/12/14.
//  Copyright (c) 2015 Debaprasad Mondal. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"


@interface CSRequestController : AFHTTPRequestOperationManager

+(CSRequestController *)sharedInstance;

// fetch User By FBId Api call
-(void)dofetchUserByFBId:(NSString *)fbid success:(void (^)(NSDictionary *responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
// Register Api call
-(void)doSignUpWithEmailId:(NSString *)email Password:(NSString *)password Name:(NSString *)name UserImage:(NSString *)image PhNo:(NSString*)phno About:(NSString *)about Birthday:(NSString *)birthday Gender:(NSString *)gender Location:(NSString *)location LoginType:(NSString *)logintype Latitude:(NSString *)latitude Longitude:(NSString *)longitude FBID:(NSString*)fbid success:(void (^)(NSDictionary *responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)doUpdateUserWithId:userid Email:(NSString *)email Password:(NSString *)password Name:(NSString *)name UserImage:(NSString *)image PhNo:(NSString*)phno About:(NSString *)about Birthday:(NSString *)birthday Gender:(NSString *)gender Location:(NSString *)location LoginType:(NSString *)logintype Latitude:(NSString *)latitude Longitude:(NSString *)longitude FBID:(NSString*)fbid success:(void (^)(NSDictionary *responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// Login Api call
-(void)doLoginWithEmailId:(NSString *)email Password:(NSString *)password success:(void (^)(NSDictionary *responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//Forgot Password call
-(void)doForgotPasswordWithEmailId:(NSString *)email success:(void (^)(NSDictionary *responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// Update My Interest
-(void)updateMyinterestsWithUserId:(NSString *)userid Interests:(NSString *)interests success:(void (^)(NSDictionary *responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
// Update discover
-(void)updateDiscoverWithUserId:(NSString *)userid Show:(NSString *)show AgeRange:(NSString *)agerange success:(void (^)(NSDictionary *responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// Find people near by
-(void)findPeopleNearWithUserId:(NSString *)userid Latitude:(NSString *)latitude Longitude:(NSString *)longitude Pageno:(int)pageno Pagesize:(int )pagesize success:(void (^)(NSDictionary *responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failur;

// Friends Profile
-(void)getFriendsProfileWithUserId:(NSString *)userid Friendid:(NSString *)friendid success:(void (^)(NSDictionary *responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// Update my profile
-(void)updateProfileWithUserId:(NSString *)userid Name:(NSString *)name About:(NSString *)about Birthday:(NSString *)birthday Gender:(NSString *)gender Interests:(NSString *)interest Image1:(NSString *)image1 Image2:(NSString *)image2 Image3:(NSString *)image3 Image4:(NSString *)image4 success:(void (^)(NSDictionary *responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// Like or Dislike Friend
-(void)likeOrDislikeFriendWithUserId:(NSString *)userid FriendId:(NSString *)frndid Likestatus:(NSString *)likestatus success:(void (^)(NSDictionary *responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// Delete an account
-(void)deleteAccountWithUserId:(NSString *)userid success:(void (^)(NSDictionary *responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// Get Notification list
-(void)getNotificationListWithUserId:(NSString *)userid success:(void (^)(NSDictionary *responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// Update notification settings
-(void)updateNotiFicationSettingsWithUserId:(NSString *)userid newMatches:(NSString *)newmatches Messages:(NSString *)message success:(void (^)(NSDictionary *responseObject))success
                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// log out from app
-(void)logOutWithUserId:(NSString *)userid success:(void (^)(NSDictionary *responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// notification list
-(void)notificationListWithUserId:(NSString *)userid success:(void (^)(NSDictionary *responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// Profile Like or Dislike
-(void)profileLikeOrDislikeWithUserId:(NSString *)userid FriendId:(NSString *)frndid Likestatus:(NSString *)likestatus success:(void (^)(NSDictionary *responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//Send notification in Android device
-(void)sendNotiFicationinAndroidDeviceWithDeviceToken:(NSString *)deviceToken Messages:(NSString *)message success:(void (^)(NSDictionary *responseObject))success
                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)getMatchedUserListWithUserId:(NSString *)userid success:(void (^)(NSDictionary *responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)updateQBIdWith:(NSString *)userid BQId:(NSString *)BQId success:(void (^)(NSDictionary *responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)reportUserkWithUserId:(NSString *)userid FriendId:(NSString *)frndid Reason:(NSString *)reason  success:(void (^)(NSDictionary *responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


-(void)profileBlockWithUserId:(NSString *)userid FriendId:(NSString *)frndid Reason:(NSString *)reason  success:(void (^)(NSDictionary *responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
