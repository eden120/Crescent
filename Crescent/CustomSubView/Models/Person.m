//
// Person.m
//  Crescent
//
//  Created by Debaprasad Mondal on 01/01/15.
//  Copyright (c) 2015 Debaprasad Mondal. All rights reserved.
//

#import "Person.h"

@implementation Person

#pragma mark - Object Lifecycle

- (instancetype)initWithName:(NSString *)name
                       email:(NSString *)email
                         age:(NSUInteger)age
                    location:(NSString *)location
                       about:(NSString *)about
                    imageurl:(NSString *)imageurl
                   interests:(NSArray *)interests
                  personLike:(NSInteger)islike
                heartImgLike:(NSInteger)isHeartImgLike
                          deviceName:(NSString *)deviceName deviceToken:(NSString *)deviceToken Id:(NSString *)userid; {
    self = [super init];
    if (self) {
        _name = name;
        _email = email;
        _age = age;
        _location=location;
        _about=about;
        _interests=interests;
        _imageurl=imageurl;
        _userid=userid;
        _isLike=islike;
        _isHeartImgLike=isHeartImgLike;
        _deviceName=deviceName;
        _deviceToken=deviceToken;
    }
    return self;
}

@end
