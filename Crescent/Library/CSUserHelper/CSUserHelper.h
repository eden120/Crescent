//
//  CSUserHelper.h
//  Crescent
//
//  Created by Debaprasad Mondal on 27/12/14.
//  Copyright (c) 2014 Debaprasad Mondal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSUserHelper : NSObject

@property(nonatomic, strong)NSMutableDictionary *userDict;
+ (CSUserHelper *)sharedInstance;
@end
