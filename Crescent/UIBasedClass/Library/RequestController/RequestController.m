//
//  RequestController.m
//  PartyGorilla
//
//  Created by Pradipta Ghosh on 11/11/13.
//  Copyright (c) 2013 Indusnet. All rights reserved.
//

#import "RequestController.h"

@implementation RequestController

@synthesize requestDelegate;
@synthesize lastCategoryTblTag;
@synthesize requestDelegateAuthorwise;

+(RequestController *)sharedInstance
{
    static RequestController *sharedInstance_ = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance_ = [[RequestController alloc] init];
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

#pragma mark- Get Priority News Article

-(void)getPriorityNewsArticle:(NSString *)_soapStr
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setTimeoutInterval:REQUEST_TIMEOUT_INTERVAL];
    [request setURL:[NSURL URLWithString:PARENT_URL]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[_soapStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:
     request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
         if ([data length] > 0 && error == nil)
         {
             [self performSelectorOnMainThread:@selector(handleDataForPriorityNews:) withObject:data waitUntilDone:YES];
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Empty Reply");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil && error.code == -1001)
         {
             NSLog(@"Timed Out");
             [self performSelectorOnMainThread:@selector(handleTimeOut) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil)
         {
             NSLog(@"Error");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
     }];
}



#pragma mark- Handle Response for Priority News Article

-(void)handleDataForPriorityNews:(NSData *)data
{
    __block Parser *obj_CreateRouteParser;
    __block NSDictionary *responseDict;
    
    dispatch_queue_t priorityNewsQueue = dispatch_queue_create("priorityNews", NULL);
    dispatch_async(priorityNewsQueue, ^{
        
        obj_CreateRouteParser = [[Parser alloc] init];
        [obj_CreateRouteParser parseXMLFillAtData:data];
        
        responseDict = [[NSDictionary alloc] initWithDictionary:[[[Common sharedInstance]GetOriginalString:obj_CreateRouteParser.xmlResponse] JSONValue]];
        
        if (self.requestDelegate && [self.requestDelegate respondsToSelector:@selector(recievedPriorityNewsResponse:)])
        {
            [self.requestDelegate recievedPriorityNewsResponse:responseDict];
        }
    });
}


#pragma mark- Get News CategoryWise

-(void)getCategoryWiseNews:(NSString *)_soapStr LastTblTag:(int)_tblTag
{
    lastCategoryTblTag = _tblTag;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setTimeoutInterval:REQUEST_TIMEOUT_INTERVAL];
    [request setURL:[NSURL URLWithString:PARENT_URL]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[_soapStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:
     request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
         if ([data length] > 0 && error == nil)
         {
             [self performSelectorOnMainThread:@selector(handleDataForCategoryWiseNews:) withObject:data waitUntilDone:YES];
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Empty Reply");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil && error.code == -1001)
         {
             NSLog(@"Timed Out");
             [self performSelectorOnMainThread:@selector(handleTimeOut) withObject:nil waitUntilDone:YES];
            
         }
         else if (error != nil)
         {
             NSLog(@"Error");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
     }];
}

-(void)handleFailure{
    if (self.requestDelegate && [self.requestDelegate respondsToSelector:@selector(dataReceivedFailed)])
    {
        [self.requestDelegate dataReceivedFailed];
    }
}

-(void)handleTimeOut{
    if (self.requestDelegate && [self.requestDelegate respondsToSelector:@selector(dataReceivedTimedOut)])
    {
        [self.requestDelegate dataReceivedTimedOut];
    }
}

-(void)handleFailure4AuthorWise{
    if (self.requestDelegateAuthorwise && [self.requestDelegateAuthorwise respondsToSelector:@selector(dataReceivedFailedforAuthorWise)])
    {
        [self.requestDelegateAuthorwise dataReceivedFailedforAuthorWise];
    }
}

-(void)handleTimeOut4AuthorWise{
    if (self.requestDelegateAuthorwise && [self.requestDelegateAuthorwise respondsToSelector:@selector(dataReceivedTimedOutforAuthorWise)])
    {
        [self.requestDelegateAuthorwise dataReceivedTimedOutforAuthorWise];
    }
}


#pragma mark- Handle Response for Categorywise News

-(void)handleDataForCategoryWiseNews:(NSData *)data
{
    __block Parser *obj_CreateRouteParser;
    __block NSDictionary *responseDict;
    
    dispatch_queue_t categoryWiseNewsQueue = dispatch_queue_create("categoryWiseNews", NULL);
    dispatch_async(categoryWiseNewsQueue, ^{
        
        obj_CreateRouteParser = [[Parser alloc] init];
        [obj_CreateRouteParser parseXMLFillAtData:data];
        
        responseDict = [[NSDictionary alloc] initWithDictionary:[[[Common sharedInstance]GetOriginalString:obj_CreateRouteParser.xmlResponse] JSONValue]];
        
        if (self.requestDelegate && [self.requestDelegate respondsToSelector:@selector(recievedCategoryWiseNews:LastTblTag:)])
        {
            [self.requestDelegate recievedCategoryWiseNews:responseDict LastTblTag:lastCategoryTblTag];
        }
    });
}


//tapash
#pragma mark for ForgotPassword

-(void)getForgotPassword:(NSString *)_soapStr{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setTimeoutInterval:REQUEST_TIMEOUT_INTERVAL];
    [request setURL:[NSURL URLWithString:PARENT_URL]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[_soapStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:
     request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
         if ([data length] > 0 && error == nil)
         {
             [self performSelectorOnMainThread:@selector(handleDataForForgotPassword:) withObject:data waitUntilDone:YES];
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Empty Reply");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
         }
         else if (error != nil && error.code == -1001)
         {
             NSLog(@"Timed Out");
             [self performSelectorOnMainThread:@selector(handleTimeOut) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil)
         {
             NSLog(@"Error");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
     }];
}


#pragma mark- Handle Response for ForgotPassword

-(void)handleDataForForgotPassword:(NSData *)data
{
    __block Parser *obj_CreateRouteParser;
    __block NSDictionary *responseDict;
    
    dispatch_queue_t priorityNewsQueue = dispatch_queue_create("priorityNews", NULL);
    dispatch_async(priorityNewsQueue, ^{
        
        obj_CreateRouteParser = [[Parser alloc] init];
        [obj_CreateRouteParser parseXMLFillAtData:data];
        
        responseDict = [[NSDictionary alloc] initWithDictionary:[obj_CreateRouteParser.xmlResponse JSONValue]];
        
        if (self.requestDelegate && [self.requestDelegate respondsToSelector:@selector(recievedForgotPasswordResponse:)])
        {
            [self.requestDelegate recievedForgotPasswordResponse:responseDict];
        }
    });
}


#pragma mark for Register
-(void)getRegister:(NSString *)_soapStr{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setTimeoutInterval:REQUEST_TIMEOUT_INTERVAL];
    [request setURL:[NSURL URLWithString:PARENT_URL]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[_soapStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:
     request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
         if ([data length] > 0 && error == nil)
         {
             [self performSelectorOnMainThread:@selector(handleDataForRegister:) withObject:data waitUntilDone:YES];
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Empty Reply");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil && error.code == -1001)
         {
             NSLog(@"Timed Out");
             [self performSelectorOnMainThread:@selector(handleTimeOut) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil)
         {
             NSLog(@"Error");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
     }];
}

#pragma mark- Handle Response for Register

-(void)handleDataForRegister:(NSData *)data
{
    __block Parser *obj_CreateRouteParser;
    __block NSDictionary *responseDict;
    
    dispatch_queue_t priorityNewsQueue = dispatch_queue_create("Register", NULL);
    dispatch_async(priorityNewsQueue, ^{
        
        obj_CreateRouteParser = [[Parser alloc] init];
        [obj_CreateRouteParser parseXMLFillAtData:data];
        
        responseDict = [[NSDictionary alloc] initWithDictionary:[obj_CreateRouteParser.xmlResponse JSONValue]];
        
        if (self.requestDelegate && [self.requestDelegate respondsToSelector:@selector(recievedRegisterResponse:)])
        {
            [self.requestDelegate recievedRegisterResponse:responseDict];
        }
    });
}

//
#pragma mark for Register
-(void)getEditProfileDetail:(NSString *)_soapStr{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setTimeoutInterval:REQUEST_TIMEOUT_INTERVAL];
    [request setURL:[NSURL URLWithString:PARENT_URL]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[_soapStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:
     request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
         if ([data length] > 0 && error == nil)
         {
             [self performSelectorOnMainThread:@selector(handleDataForProfileDetails:) withObject:data waitUntilDone:YES];
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Empty Reply");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil && error.code == -1001)
         {
             NSLog(@"Timed Out");
             [self performSelectorOnMainThread:@selector(handleTimeOut) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil)
         {
             NSLog(@"Error");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
     }];
}

#pragma mark- Handle Response for Register

-(void)handleDataForProfileDetails:(NSData *)data
{
    __block Parser *obj_CreateRouteParser;
    __block NSDictionary *responseDict;
    
    dispatch_queue_t priorityNewsQueue = dispatch_queue_create("ProfileDetail", NULL);
    dispatch_async(priorityNewsQueue, ^{
        
        obj_CreateRouteParser = [[Parser alloc] init];
        [obj_CreateRouteParser parseXMLFillAtData:data];
        
        responseDict = [[NSDictionary alloc] initWithDictionary:[obj_CreateRouteParser.xmlResponse JSONValue]];
        
        if (self.requestDelegate && [self.requestDelegate respondsToSelector:@selector(recievedEditProfileResponse:)])
        {
            [self.requestDelegate recievedEditProfileResponse:responseDict];
        }
    });
}


//end of edit profile


#pragma mark for Login
-(void)getLogin:(NSString *)_soapStr{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setTimeoutInterval:REQUEST_TIMEOUT_INTERVAL];
    [request setURL:[NSURL URLWithString:PARENT_URL]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[_soapStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:
     request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
         if ([data length] > 0 && error == nil)
         {
             [self performSelectorOnMainThread:@selector(handleDataForLogin:) withObject:data waitUntilDone:YES];
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Empty Reply");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil && error.code == -1001)
         {
             NSLog(@"Timed Out");
             [self performSelectorOnMainThread:@selector(handleTimeOut) withObject:nil waitUntilDone:YES];
            
         }
         else if (error != nil)
         {
             NSLog(@"Error");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
            
         }
     }];
}

#pragma mark- Handle Response for Login

-(void)handleDataForLogin:(NSData *)data
{
    __block Parser *obj_CreateRouteParser;
    __block NSDictionary *responseDict;
    
    dispatch_queue_t priorityNewsQueue = dispatch_queue_create("priorityNews", NULL);
    dispatch_async(priorityNewsQueue, ^{
        
        obj_CreateRouteParser = [[Parser alloc] init];
        [obj_CreateRouteParser parseXMLFillAtData:data];
        
        responseDict = [[NSDictionary alloc] initWithDictionary:[obj_CreateRouteParser.xmlResponse JSONValue]];
        
        if (self.requestDelegate && [self.requestDelegate respondsToSelector:@selector(recievedLoginResponse:)])
        {
            [self.requestDelegate recievedLoginResponse:responseDict];
        }
    });
}

#pragma mark- Handle Response for ArticleNameWise

-(void)getArticleNameWise:(NSString *)_soapStr{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setTimeoutInterval:REQUEST_TIMEOUT_INTERVAL];
    [request setURL:[NSURL URLWithString:PARENT_URL]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[_soapStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:
     request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
         if ([data length] > 0 && error == nil)
         {
             [self performSelectorOnMainThread:@selector(handleDataForArticleNameWise:) withObject:data waitUntilDone:YES];
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Empty Reply");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil && error.code == -1001)
         {
             NSLog(@"Timed Out");
             [self performSelectorOnMainThread:@selector(handleTimeOut) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil)
         {
             NSLog(@"Error");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
     }];
}

#pragma mark- Handle Response for ArticleNameWise

-(void)handleDataForArticleNameWise:(NSData *)data
{
    __block Parser *obj_CreateRouteParser;
    __block NSDictionary *responseDict;
    
    dispatch_queue_t priorityNewsQueue = dispatch_queue_create("ArticleNameWise", NULL);
    dispatch_async(priorityNewsQueue, ^{
        // dispatch_sync(priorityNewsQueue,^{
        obj_CreateRouteParser = [[Parser alloc] init];
        [obj_CreateRouteParser parseXMLFillAtData:data];
        
        responseDict = [[NSDictionary alloc] initWithDictionary:[[[Common sharedInstance]GetOriginalString:obj_CreateRouteParser.xmlResponse] JSONValue]];
        
        if (self.requestDelegate)
        {
            if( [self.requestDelegate respondsToSelector:@selector(recievedArticleNameWiseResponse:)])
            {
                [self.requestDelegate recievedArticleNameWiseResponse:responseDict];
            }
        }
    });
}



#pragma mark- Handle Response for ArticleAuthorWise
-(void)getArticleAuthorWise:(NSString *)_soapStr{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setTimeoutInterval:REQUEST_TIMEOUT_INTERVAL];
    [request setURL:[NSURL URLWithString:PARENT_URL]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[_soapStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:
     request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
         if ([data length] > 0 && error == nil)
         {
             [self performSelectorOnMainThread:@selector(handleDataForArticleAuthorWise:) withObject:data waitUntilDone:YES];
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Empty Reply");
             [self performSelectorOnMainThread:@selector(handleFailure4AuthorWise) withObject:nil waitUntilDone:YES];
            
         }
         else if (error != nil && error.code == -1001)
         {
             NSLog(@"Timed Out");
             [self performSelectorOnMainThread:@selector(handleTimeOut4AuthorWise) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil)
         {
             NSLog(@"Error");
             [self performSelectorOnMainThread:@selector(handleFailure4AuthorWise) withObject:nil waitUntilDone:YES];
             
         }
     }];
}

#pragma mark- Handle Response for ArticleAuthorWise

-(void)handleDataForArticleAuthorWise:(NSData *)data
{
    __block Parser *obj_CreateRouteParser;
    __block NSDictionary *responseDict;
    
    dispatch_queue_t priorityNewsQueue = dispatch_queue_create("ArticleAuthorWise", NULL);
    dispatch_async(priorityNewsQueue, ^{
        
        obj_CreateRouteParser = [[Parser alloc] init];
        [obj_CreateRouteParser parseXMLFillAtData:data];
        
        responseDict = [[NSDictionary alloc] initWithDictionary:[[[Common sharedInstance]GetOriginalString:obj_CreateRouteParser.xmlResponse] JSONValue]];
        
        if (self.requestDelegateAuthorwise && [self.requestDelegateAuthorwise respondsToSelector:@selector(recievedArticleAuthorWiseResponse:)])
        {
            [self.requestDelegateAuthorwise recievedArticleAuthorWiseResponse:responseDict];
        }
    });
}

#pragma mark- Handle Response for ArticleDetails
-(void)getArticleDetails:(NSString *)_soapStr{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setTimeoutInterval:REQUEST_TIMEOUT_INTERVAL];
    [request setURL:[NSURL URLWithString:PARENT_URL]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[_soapStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:
     request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
         if ([data length] > 0 && error == nil)
         {
             [self performSelectorOnMainThread:@selector(handleDataForArticleDetails:) withObject:data waitUntilDone:YES];
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Empty Reply");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil && error.code == -1001)
         {
             NSLog(@"Timed Out");
             [self performSelectorOnMainThread:@selector(handleTimeOut) withObject:nil waitUntilDone:YES];
                      }
         else if (error != nil)
         {
             NSLog(@"Error");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
            
         }
     }];
}

#pragma mark- Handle Response for ArticleDetails

-(void)handleDataForArticleDetails:(NSData *)data
{
    __block Parser *obj_CreateRouteParser;
    __block NSDictionary *responseDict;
    
    dispatch_queue_t priorityNewsQueue = dispatch_queue_create("ArticleDetails", NULL);
    dispatch_async(priorityNewsQueue, ^{
        
        obj_CreateRouteParser = [[Parser alloc] init];
        [obj_CreateRouteParser parseXMLFillAtData:data];
        
        responseDict = [[NSDictionary alloc] initWithDictionary:[[[Common sharedInstance]GetOriginalString:obj_CreateRouteParser.xmlResponse] JSONValue]];
        
        if (self.requestDelegate && [self.requestDelegate respondsToSelector:@selector(recievedArticleDetailsResponse:)])
        {
            [self.requestDelegate recievedArticleDetailsResponse:responseDict];
        }
    });
}

#pragma mark- Handle Response for IssuesNameWise
-(void)getIssuesNameWise:(NSString *)_soapStr{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setTimeoutInterval:REQUEST_TIMEOUT_INTERVAL];
    [request setURL:[NSURL URLWithString:PARENT_URL]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[_soapStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:
     request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
         if ([data length] > 0 && error == nil)
         {
             [self performSelectorOnMainThread:@selector(handleDataForIssuesNameWise:) withObject:data waitUntilDone:YES];
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Empty Reply");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil && error.code == -1001)
         {
             NSLog(@"Timed Out");
             [self performSelectorOnMainThread:@selector(handleTimeOut) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil)
         {
             NSLog(@"Error");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
     }];
}

#pragma mark- Handle Response for IssuesNameWise

-(void)handleDataForIssuesNameWise:(NSData *)data
{
    __block Parser *obj_CreateRouteParser;
    __block NSDictionary *responseDict;
    
    
    
    dispatch_queue_t priorityIssueQueue = dispatch_queue_create("IssuesNameWise", NULL);
    dispatch_async(priorityIssueQueue, ^{
        
        obj_CreateRouteParser = [[Parser alloc] init];
        [obj_CreateRouteParser parseXMLFillAtData:data];
        
        responseDict = [[NSDictionary alloc] initWithDictionary:[[[Common sharedInstance]GetOriginalString:obj_CreateRouteParser.xmlResponse] JSONValue]];
        
        if (self.requestDelegate && [self.requestDelegate respondsToSelector:@selector(recievedIssueNameWiseResponse:)])
        {
            [self.requestDelegate recievedIssueNameWiseResponse:responseDict];
        }
    });
}

#pragma mark- Handle Response for issueDetails
-(void)getissueDetails:(NSString *)_soapStr{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setTimeoutInterval:REQUEST_TIMEOUT_INTERVAL];
    [request setURL:[NSURL URLWithString:PARENT_URL]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[_soapStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:
     request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
         if ([data length] > 0 && error == nil)
         {
             [self performSelectorOnMainThread:@selector(handleDataForissueDetails:) withObject:data waitUntilDone:YES];
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Empty Reply");
             
             if (self.requestDelegate && [self.requestDelegate respondsToSelector:@selector(dataReceivedFailed)])
             {
                 [self.requestDelegate dataReceivedFailed];
             }
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Empty Reply");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil && error.code == -1001)
         {
             NSLog(@"Timed Out");
             [self performSelectorOnMainThread:@selector(handleTimeOut) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil)
         {
             NSLog(@"Error");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
     }];
}

#pragma mark- Handle Response for issueDetails

-(void)handleDataForissueDetails:(NSData *)data
{
    __block Parser *obj_CreateRouteParser;
    __block NSDictionary *responseDict;
    
    dispatch_queue_t priorityNewsQueue = dispatch_queue_create("issueDetails", NULL);
    dispatch_async(priorityNewsQueue, ^{
        
        obj_CreateRouteParser = [[Parser alloc] init];
        [obj_CreateRouteParser parseXMLFillAtData:data];
        
        responseDict = [[NSDictionary alloc] initWithDictionary:[[[Common sharedInstance]GetOriginalString:obj_CreateRouteParser.xmlResponse] JSONValue]];
        
        if (self.requestDelegate && [self.requestDelegate respondsToSelector:@selector(recievedIssueDetailsResponse:)])
        {
            [self.requestDelegate recievedIssueDetailsResponse:responseDict];
        }
    });
}


#pragma mark- Handle Response for NewsDetail

-(void)getNewsDetail:(NSString *)_soapStr{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setTimeoutInterval:REQUEST_TIMEOUT_INTERVAL];
    [request setURL:[NSURL URLWithString:PARENT_URL]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[_soapStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:
     request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
         if ([data length] > 0 && error == nil)
         {
             [self performSelectorOnMainThread:@selector(handleDataForNewsDetail:) withObject:data waitUntilDone:YES];
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Empty Reply");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil && error.code == -1001)
         {
             NSLog(@"Timed Out");
             [self performSelectorOnMainThread:@selector(handleTimeOut) withObject:nil waitUntilDone:YES];
            
         }
         else if (error != nil)
         {
             NSLog(@"Error");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
     }];
}

#pragma mark- Handle Response for NewsDetail

-(void)handleDataForNewsDetail:(NSData *)data
{
    __block Parser *obj_CreateRouteParser;
    __block NSDictionary *responseDict;
    
    dispatch_queue_t priorityNewsQueue = dispatch_queue_create("priorityNews", NULL);
    dispatch_async(priorityNewsQueue, ^{
        
        obj_CreateRouteParser = [[Parser alloc] init];
        [obj_CreateRouteParser parseXMLFillAtData:data];
        
        responseDict = [[NSDictionary alloc] initWithDictionary:[[[Common sharedInstance]GetOriginalString:obj_CreateRouteParser.xmlResponse] JSONValue]];
        
        if (self.requestDelegate && [self.requestDelegate respondsToSelector:@selector(recievedNewsDetailResponse:)])
        {
            [self.requestDelegate recievedNewsDetailResponse:responseDict];
        }
    });
}

#pragma mark- Handle Response for ResponsibleReply

-(void)getResponsibleReplyDetail:(NSString *)_soapStr{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setTimeoutInterval:REQUEST_TIMEOUT_INTERVAL];
    [request setURL:[NSURL URLWithString:PARENT_URL]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[_soapStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:
     request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
         if ([data length] > 0 && error == nil)
         {
             [self performSelectorOnMainThread:@selector(handleDataForResponsibleReply:) withObject:data waitUntilDone:YES];
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Empty Reply");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil && error.code == -1001)
         {
             NSLog(@"Timed Out");
             [self performSelectorOnMainThread:@selector(handleTimeOut) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil)
         {
             NSLog(@"Error");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
     }];
}

#pragma mark- Handle Response for ResponsibleReply

-(void)handleDataForResponsibleReply:(NSData *)data
{
    __block Parser *obj_CreateRouteParser;
    __block NSDictionary *responseDict;
    
    dispatch_queue_t priorityNewsQueue = dispatch_queue_create("ResponsibleReply", NULL);
    dispatch_async(priorityNewsQueue, ^{
        
        obj_CreateRouteParser = [[Parser alloc] init];
        [obj_CreateRouteParser parseXMLFillAtData:data];
        if ([[Common sharedInstance]getNibName:obj_CreateRouteParser.xmlResponse]) {
            obj_CreateRouteParser.xmlResponse=[obj_CreateRouteParser.xmlResponse stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        }
        
        responseDict = [[NSDictionary alloc] initWithDictionary:[[[Common sharedInstance]GetOriginalString:obj_CreateRouteParser.xmlResponse] JSONValue]];
        
        if (self.requestDelegate) {
            if ( [self.requestDelegate respondsToSelector:@selector(recievedResponsibleReplyResponse:)])
            {
                [self.requestDelegate recievedResponsibleReplyResponse:responseDict];
            }
        }
    });
}



#pragma mark- ----------------------------- New --------------------------

#pragma mark- Add Reply Request
-(void)adReply:(NSString *)_soapStr{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setTimeoutInterval:REQUEST_TIMEOUT_INTERVAL];
    [request setURL:[NSURL URLWithString:PARENT_URL]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[_soapStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:
     request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
         if ([data length] > 0 && error == nil)
         {
             [self performSelectorOnMainThread:@selector(handleDataForAddReply:) withObject:data waitUntilDone:YES];
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Empty Reply");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil && error.code == -1001)
         {
             
             NSLog(@"Timed Out");
             [self performSelectorOnMainThread:@selector(handleTimeOut) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil)
         {
             NSLog(@"Error");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
     }];
}

#pragma mark- Handle Response for AddReply

-(void)handleDataForAddReply:(NSData *)data
{
    __block Parser *obj_CreateRouteParser;
    __block NSDictionary *responseDict;
    
    dispatch_queue_t priorityNewsQueue = dispatch_queue_create("AddReply", NULL);
    dispatch_async(priorityNewsQueue, ^{
        
        obj_CreateRouteParser = [[Parser alloc] init];
        [obj_CreateRouteParser parseXMLFillAtData:data];
        
        responseDict = [[NSDictionary alloc] initWithDictionary:[obj_CreateRouteParser.xmlResponse JSONValue]];
        
        if (self.requestDelegate && [self.requestDelegate respondsToSelector:@selector(recievedAddReplyResponse:)])
        {
            [self.requestDelegate recievedAddReplyResponse:responseDict];
        }
    });
}



#pragma mark- call webservice for CommentList

-(void)getCommentListDetail:(NSString *)_soapStr{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setTimeoutInterval:REQUEST_TIMEOUT_INTERVAL];
    [request setURL:[NSURL URLWithString:PARENT_URL]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[_soapStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:
     request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
         if ([data length] > 0 && error == nil)
         {
             [self performSelectorOnMainThread:@selector(handleDataForCommentList:) withObject:data waitUntilDone:YES];
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Empty Reply");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil && error.code == -1001)
         {
             NSLog(@"Timed Out");
             [self performSelectorOnMainThread:@selector(handleTimeOut) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil)
         {
             NSLog(@"Error");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
     }];
}

#pragma mark- Handle Response for CommentList

-(void)handleDataForCommentList:(NSData *)data
{
    __block Parser *obj_CreateRouteParser;
    __block NSDictionary *responseDict;
    
    dispatch_queue_t priorityNewsQueue = dispatch_queue_create("CommentList", NULL);
    dispatch_async(priorityNewsQueue, ^{
        
        obj_CreateRouteParser = [[Parser alloc] init];
        [obj_CreateRouteParser parseXMLFillAtData:data];
        if ( obj_CreateRouteParser.xmlResponse.length>0) {
            obj_CreateRouteParser.xmlResponse =[obj_CreateRouteParser.xmlResponse  stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        }
        responseDict = [[NSDictionary alloc] initWithDictionary:[[[Common sharedInstance]GetOriginalString:obj_CreateRouteParser.xmlResponse] JSONValue]];
        
        if (self.requestDelegate && [self.requestDelegate respondsToSelector:@selector(recievedCommentListResponse:)])
        {
            [self.requestDelegate recievedCommentListResponse:responseDict];
        }
    });
}







#pragma mark- call webservice for CommentList

-(void)getPostCommentDetail:(NSString *)_soapStr{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setTimeoutInterval:REQUEST_TIMEOUT_INTERVAL];
    [request setURL:[NSURL URLWithString:PARENT_URL]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[_soapStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:
     request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
         if ([data length] > 0 && error == nil)
         {
             [self performSelectorOnMainThread:@selector(handleDataForPostComment:) withObject:data waitUntilDone:YES];
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Empty Reply");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil && error.code == -1001)
         {
             NSLog(@"Timed Out");
             [self performSelectorOnMainThread:@selector(handleTimeOut) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil)
         {
             NSLog(@"Error");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
     }];
}

#pragma mark- Handle Response for CommentList

-(void)handleDataForPostComment:(NSData *)data
{
    __block Parser *obj_CreateRouteParser;
    __block NSDictionary *responseDict;
    
    dispatch_queue_t priorityNewsQueue = dispatch_queue_create("PostComment", NULL);
    dispatch_async(priorityNewsQueue, ^{
        
        obj_CreateRouteParser = [[Parser alloc] init];
        [obj_CreateRouteParser parseXMLFillAtData:data];
        
        responseDict = [[NSDictionary alloc] initWithDictionary:[[[Common sharedInstance]GetOriginalString:obj_CreateRouteParser.xmlResponse] JSONValue]];
        
        if (self.requestDelegate && [self.requestDelegate respondsToSelector:@selector(recievedPostCommentResponse:)])
        {
            [self.requestDelegate recievedPostCommentResponse:responseDict];
        }
    });
}


#pragma mark- call webservice for MyPost

-(void)getMyPostList:(NSString *)_soapStr{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setTimeoutInterval:REQUEST_TIMEOUT_INTERVAL];
    [request setURL:[NSURL URLWithString:PARENT_URL]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[_soapStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:
     request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
         if ([data length] > 0 && error == nil)
         {
             [self performSelectorOnMainThread:@selector(handleDataForMyPost:) withObject:data waitUntilDone:YES];
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Empty Reply");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil && error.code == -1001)
         {
             NSLog(@"Timed Out");
             [self performSelectorOnMainThread:@selector(handleTimeOut) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil)
         {
             NSLog(@"Error");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
     }];
}

#pragma mark- Handle Response for CommentList

-(void)handleDataForMyPost:(NSData *)data
{
    __block Parser *obj_CreateRouteParser;
    __block NSDictionary *responseDict;
    
    dispatch_queue_t priorityNewsQueue = dispatch_queue_create("MyPost", NULL);
    dispatch_async(priorityNewsQueue, ^{
        
        obj_CreateRouteParser = [[Parser alloc] init];
        [obj_CreateRouteParser parseXMLFillAtData:data];
        
        NSString *responseString=[[Common sharedInstance]GetOriginalString:obj_CreateRouteParser.xmlResponse];
        responseDict = [[NSDictionary alloc] initWithDictionary:[responseString JSONValue]];
        if (self.requestDelegate && [self.requestDelegate respondsToSelector:@selector(recievedMyPostResponse:)])
        {
            [self.requestDelegate recievedMyPostResponse:responseDict];
        }
    });
}

#pragma mark- call webservice for Post Issues or article

-(void)postIssueOrArticle:(NSString *)_soapStr{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setTimeoutInterval:REQUEST_TIMEOUT_INTERVAL];
    [request setURL:[NSURL URLWithString:PARENT_URL]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[_soapStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:
     request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
         if ([data length] > 0 && error == nil)
         {
             [self performSelectorOnMainThread:@selector(handleDataForIssuesOrArticlePost:) withObject:data waitUntilDone:YES];
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Empty Reply");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil && error.code == -1001)
         {
             NSLog(@"Timed Out");
             [self performSelectorOnMainThread:@selector(handleTimeOut) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil)
         {
             NSLog(@"Error");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
     }];
}

#pragma mark- Handle Response for issues or artcle post

-(void)handleDataForIssuesOrArticlePost:(NSData *)data
{
    __block Parser *obj_CreateRouteParser;
    __block NSDictionary *responseDict;
    
    dispatch_queue_t priorityNewsQueue = dispatch_queue_create("IssuesOrArticlePost", NULL);
    dispatch_async(priorityNewsQueue, ^{
        
        obj_CreateRouteParser = [[Parser alloc] init];
        [obj_CreateRouteParser parseXMLFillAtData:data];
        
        NSString *responseString=[[Common sharedInstance]GetOriginalString:obj_CreateRouteParser.xmlResponse];
        responseDict = [[NSDictionary alloc] initWithDictionary:[responseString JSONValue]];
        if (self.requestDelegate && [self.requestDelegate respondsToSelector:@selector(recievedIssueOrArticleResponse:)])
        {
            [self.requestDelegate recievedIssueOrArticleResponse:responseDict];
        }
    });
}

#pragma mark- call webservice for post news

-(void)postNews:(NSString *)_soapStr{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setTimeoutInterval:REQUEST_TIMEOUT_INTERVAL];
    [request setURL:[NSURL URLWithString:PARENT_URL]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[_soapStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:
     request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
         if ([data length] > 0 && error == nil)
         {
             [self performSelectorOnMainThread:@selector(handleDataForNewsPost:) withObject:data waitUntilDone:YES];
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Empty Reply");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil && error.code == -1001)
         {
             NSLog(@"Timed Out");
             [self performSelectorOnMainThread:@selector(handleTimeOut) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil)
         {
             NSLog(@"Error");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
     }];
}

#pragma mark- Handle Response for News post

-(void)handleDataForNewsPost:(NSData *)data
{
    __block Parser *obj_CreateRouteParser;
    __block NSDictionary *responseDict;
    
    dispatch_queue_t priorityNewsQueue = dispatch_queue_create("newsPost", NULL);
    dispatch_async(priorityNewsQueue, ^{
        
        obj_CreateRouteParser = [[Parser alloc] init];
        [obj_CreateRouteParser parseXMLFillAtData:data];
        
        NSString *responseString=[[Common sharedInstance]GetOriginalString:obj_CreateRouteParser.xmlResponse];
        responseDict = [[NSDictionary alloc] initWithDictionary:[responseString JSONValue]];
        if (self.requestDelegate)
        {
            if([self.requestDelegate respondsToSelector:@selector(recievedNewsPostResponse:)])
            {
                [self.requestDelegate recievedNewsPostResponse:responseDict];
            }
        }
    });
}

#pragma mark- call webservice for post news

-(void)getMyPostDetails:(NSString *)_soapStr{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setTimeoutInterval:REQUEST_TIMEOUT_INTERVAL];
    [request setURL:[NSURL URLWithString:PARENT_URL]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[_soapStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:
     request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
         if ([data length] > 0 && error == nil)
         {
             [self performSelectorOnMainThread:@selector(handleDataForMyPostDetails:) withObject:data waitUntilDone:YES];
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Empty Reply");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil && error.code == -1001)
         {
             NSLog(@"Timed Out");
             [self performSelectorOnMainThread:@selector(handleTimeOut) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil)
         {
             NSLog(@"Error");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
     }];
}

#pragma mark- Handle Response for News post

-(void)handleDataForMyPostDetails:(NSData *)data
{
    __block Parser *obj_CreateRouteParser;
    __block NSDictionary *responseDict;
    
    dispatch_queue_t priorityNewsQueue = dispatch_queue_create("MyPostDetails", NULL);
    dispatch_async(priorityNewsQueue, ^{
        
        obj_CreateRouteParser = [[Parser alloc] init];
        [obj_CreateRouteParser parseXMLFillAtData:data];
        
        NSString *responseString=[[Common sharedInstance]GetOriginalString:obj_CreateRouteParser.xmlResponse];
        responseDict = [[NSDictionary alloc] initWithDictionary:[responseString JSONValue]];
        if (self.requestDelegate)
        {
            if([self.requestDelegate respondsToSelector:@selector(recievedMyPostDetailsResponse:)])
            {
                [self.requestDelegate recievedMyPostDetailsResponse:responseDict];
            }
        }
    });
}

#pragma mark- call webservice for register device

-(void)setRegisterDevice:(NSString *)_soapStr{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setTimeoutInterval:REQUEST_TIMEOUT_INTERVAL];
    [request setURL:[NSURL URLWithString:PARENT_URL]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[_soapStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:
     request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
         if ([data length] > 0 && error == nil)
         {
             [self performSelectorOnMainThread:@selector(handleDataForRegisterDevice:) withObject:data waitUntilDone:YES];
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Empty Reply");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil && error.code == -1001)
         {
             NSLog(@"Timed Out");
             [self performSelectorOnMainThread:@selector(handleTimeOut) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil)
         {
             NSLog(@"Error");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
     }];
}

#pragma mark- Handle Response for News post

-(void)handleDataForRegisterDevice:(NSData *)data
{
    __block Parser *obj_CreateRouteParser;
    __block NSDictionary *responseDict;
    
    dispatch_queue_t priorityNewsQueue = dispatch_queue_create("registerdevice", NULL);
    dispatch_async(priorityNewsQueue, ^{
        
        obj_CreateRouteParser = [[Parser alloc] init];
        [obj_CreateRouteParser parseXMLFillAtData:data];
        
        NSString *responseString=[[Common sharedInstance]GetOriginalString:obj_CreateRouteParser.xmlResponse];
        responseDict = [[NSDictionary alloc] initWithDictionary:[responseString JSONValue]];
        if (self.requestDelegate)
        {
            if([self.requestDelegate respondsToSelector:@selector(recievedRegisterDeviceResponse:)])
            {
                [self.requestDelegate recievedRegisterDeviceResponse:responseDict];
            }
        }
    });
}

#pragma mark- call webservice for post news

-(void)setEnableOrDisableNotification:(NSString *)_soapStr{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setTimeoutInterval:REQUEST_TIMEOUT_INTERVAL];
    [request setURL:[NSURL URLWithString:PARENT_URL]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[_soapStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:
     request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
         if ([data length] > 0 && error == nil)
         {
             [self performSelectorOnMainThread:@selector(handleDataForNotificationService:) withObject:data waitUntilDone:YES];
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Empty Reply");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil && error.code == -1001)
         {
             NSLog(@"Timed Out");
             [self performSelectorOnMainThread:@selector(handleTimeOut) withObject:nil waitUntilDone:YES];
             
         }
         else if (error != nil)
         {
             NSLog(@"Error");
             [self performSelectorOnMainThread:@selector(handleFailure) withObject:nil waitUntilDone:YES];
             
         }
     }];
}

#pragma mark- Handle Response for News post

-(void)handleDataForNotificationService:(NSData *)data
{
    __block Parser *obj_CreateRouteParser;
    __block NSDictionary *responseDict;
    
    dispatch_queue_t priorityNewsQueue = dispatch_queue_create("registerdevice", NULL);
    dispatch_async(priorityNewsQueue, ^{
        
        obj_CreateRouteParser = [[Parser alloc] init];
        [obj_CreateRouteParser parseXMLFillAtData:data];
        
        NSString *responseString=[[Common sharedInstance]GetOriginalString:obj_CreateRouteParser.xmlResponse];
        responseDict = [[NSDictionary alloc] initWithDictionary:[responseString JSONValue]];
        if (self.requestDelegate)
        {
            if([self.requestDelegate respondsToSelector:@selector(recievedNotificationServiceResponse:)])
            {
                [self.requestDelegate recievedNotificationServiceResponse:responseDict];
            }
        }
    });
}
@end
