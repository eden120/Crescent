//
//  TKRTextView.h
//  Tickr
//
//  Created by Alex Don on 17/09/2014.
//  Copyright (c) 2014 Fast Fwd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSTextView : UITextView

@property (copy, nonatomic) NSString *placeholder;
@property (strong, nonatomic) UIColor *placeholderTextColor UI_APPEARANCE_SELECTOR;

@end
