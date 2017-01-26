//
//  CSUserHelper.m
//  Crescent
//
//  Created by Debaprasad Mondal on 27/12/14.
//  Copyright (c) 2014 Debaprasad Mondal. All rights reserved.
//

#import "CSUserHelper.h"

@implementation CSUserHelper

+ (CSUserHelper *)sharedInstance
{
    static CSUserHelper *sharedInstance_ = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance_ = [[CSUserHelper alloc] init];
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

@end
