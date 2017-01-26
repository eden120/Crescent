//
//  RequestController.h
//  PartyGorilla
//
//  Created by Pradipta Ghosh on 11/11/13.
//  Copyright (c) 2013 Indusnet. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Parser.h"
#import "URLRequestString.h"
#import "JSON.h"

@protocol RequestControllerDelegate <NSObject>

@optional

// For All Webservice Calls
-(void)dataReceivedTimedOut;
-(void)dataReceivedFailed;

//For Dashboard Webservice Call
-(void)recievedPriorityNewsResponse:(NSDictionary *)_dict;

//For NewsCategoryWise Webservice Call
-(void)recievedCategoryWiseNews:(NSDictionary *)_dict LastTblTag:(int)_tblTag;

//***tapash
//For Login Webservice Call
-(void)recievedLoginResponse:(NSDictionary *)_dict;
//For ForgotPassword Webservice Call
-(void)recievedForgotPasswordResponse:(NSDictionary *)_dict;
//For Register Webservice Call
-(void)recievedRegisterResponse:(NSDictionary *)_dict;

//For edit profile Webservice Call
-(void)recievedEditProfileResponse:(NSDictionary *)_dict;

//For ArticleNameWise Webservice Call
-(void)recievedArticleNameWiseResponse:(NSDictionary *)_dict;

//For ArticleDetails Webservice Call
-(void)recievedArticleDetailsResponse:(NSDictionary *)_dict;

//For IssueNameWise Webservice Call
-(void)recievedIssueNameWiseResponse:(NSDictionary *)_dict;
//For IssueDetails Webservice Call
-(void)recievedIssueDetailsResponse:(NSDictionary *)_dict;

//For Responsiblereply Webservice Call
-(void)recievedResponsiblereplyResponse:(NSDictionary *)_dict;

//For NewsDetail Webservice Call
-(void)recievedNewsDetailResponse:(NSDictionary *)_dict;
//end

//For ResponsibleReply Webservice Call
-(void)recievedResponsibleReplyResponse:(NSDictionary *)_dict;

//For AddReply Webservice Call
-(void)recievedAddReplyResponse:(NSDictionary *)_dict;


//For CommentList Webservice Call
-(void)recievedCommentListResponse:(NSDictionary *)_dict;

//For PostComment Webservice Call
-(void)recievedPostCommentResponse:(NSDictionary *)_dict;

//For MyPost Webservice Call
-(void)recievedMyPostResponse:(NSDictionary *)_dict;

//For Issue or article post Webservice Call
-(void)recievedIssueOrArticleResponse:(NSDictionary *)_dict;

//For Issue or news post Webservice Call
-(void)recievedNewsPostResponse:(NSDictionary *)_dict;

//For Issue or my post details Webservice Call
-(void)recievedMyPostDetailsResponse:(NSDictionary *)_dict;

//For Register devcie Webservice Call
-(void)recievedRegisterDeviceResponse:(NSDictionary *)_dict;

//For Notification service Webservice Call
-(void)recievedNotificationServiceResponse:(NSDictionary *)_dict;


@end



@protocol RequestControllerDelegateforAuthowWise <NSObject>
//For ArticleAuthorWise Webservice Call
@optional
-(void)dataReceivedTimedOutforAuthorWise;
-(void)dataReceivedFailedforAuthorWise;
-(void)recievedArticleAuthorWiseResponse:(NSDictionary *)_dict;
@end

@interface RequestController : NSObject

+(RequestController *)sharedInstance;

@property (nonatomic, assign) id<RequestControllerDelegate> requestDelegate;
@property (nonatomic, assign) id<RequestControllerDelegateforAuthowWise> requestDelegateAuthorwise;
@property(nonatomic, readwrite) int lastCategoryTblTag;

-(void)getPriorityNewsArticle:(NSString *)_soapStr;

-(void)getCategoryWiseNews:(NSString *)_soapStr LastTblTag:(int)_tblTag;

//tapash
-(void)getForgotPassword:(NSString *)_soapStr;
-(void)getRegister:(NSString *)_soapStr;
-(void)getEditProfileDetail:(NSString *)_soapStr;
-(void)getLogin:(NSString *)_soapStr;

//for Article
-(void)getArticleNameWise:(NSString *)_soapStr;
-(void)getArticleAuthorWise:(NSString *)_soapStr;

-(void)getArticleDetails:(NSString *)_soapStr;

//for Issue
-(void)getIssuesNameWise:(NSString *)_soapStr;
-(void)getissueDetails:(NSString *)_soapStr;


//newsdetails
-(void)getNewsDetail:(NSString *)_soapStr;

//newsdetails
-(void)getResponsibleReplyDetail:(NSString *)_soapStr;
// Add Reply Request
-(void)adReply:(NSString *)_soapStr;

// Add CommentList Request
-(void)getCommentListDetail:(NSString *)_soapStr;

// Add PostComment Request
-(void)getPostCommentDetail:(NSString *)_soapStr;

// my post list Request
-(void)getMyPostList:(NSString *)_soapStr;

// my post details Request
-(void)getMyPostDetails:(NSString *)_soapStr;

//issue or article post
-(void)postIssueOrArticle:(NSString *)_soapStr;

//news post
-(void)postNews:(NSString *)_soapStr;

// Register device
-(void)setRegisterDevice:(NSString *)_soapStr;

// Notificatuon service
-(void)setEnableOrDisableNotification:(NSString *)_soapStr;
@end
