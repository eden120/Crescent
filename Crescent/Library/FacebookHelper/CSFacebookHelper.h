//
//  CSFacebookHelper.h
//  Crescent
//
//  Created by Debaprasad Mondal on 25/12/14.
//  Copyright (c) 2015 Debaprasad Mondal. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    eFRIEND_LIST,
    eUPLOAD_PHOTO_FB,
    eSELF_DETAILS,
    eSHARE_ON_WALL
} FBRequestType;

@protocol FacebookInteractionDelegate <NSObject>

@optional

-(void)requestLoadError;
-(void)successfulLogin:(id)dict;
-(void)postToWallSuccessful;
-(void)retrievedFriendList:(id)dict;

@end

@interface CSFacebookHelper : NSObject

@property(nonatomic,weak) id<FacebookInteractionDelegate>fbDelegate;

+(CSFacebookHelper *)sharedFacebook;

- (void)loginThroughFacebookAllowLoginUI:(BOOL)allowLoginUI;
- (void)closeFBSession;

-(void)initiatePublishInWall;
-(void)getFriendList;

@end
