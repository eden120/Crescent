//
// Person.h
//  Crescent
//
//  Created by Debaprasad Mondal on 01/01/15.
//  Copyright (c) 2015 Debaprasad Mondal. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *about;
@property (nonatomic, copy) NSString *imageurl;
@property (nonatomic, copy) NSArray *interests;
@property (nonatomic, assign) NSUInteger age;
@property (nonatomic, copy)NSString *userid;
@property (nonatomic, readwrite)NSInteger isLike;
@property (nonatomic, readwrite)NSInteger isHeartImgLike;
@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, copy) NSString *deviceToken;
/*@property (nonatomic, assign) NSUInteger numberOfSharedFriends;
@property (nonatomic, assign) NSUInteger numberOfSharedInterests;
@property (nonatomic, assign) NSUInteger numberOfPhotos;*/

- (instancetype)initWithName:(NSString *)name
                       email:(NSString *)email
                         age:(NSUInteger)age
                    location:(NSString *)location
                       about:(NSString *)about
                    imageurl:(NSString *)imageurl
                   interests:(NSArray *)interests
                  personLike:(NSInteger)islike
                  heartImgLike:(NSInteger)isHeartImgLike
                deviceName:(NSString *)deviceName
                deviceToken:(NSString *)deviceToken
                          Id:(NSString *)userid;

@end
