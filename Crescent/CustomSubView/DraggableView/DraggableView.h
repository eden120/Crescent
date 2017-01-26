//
//  DraggableView.h
//  Crescent
//
//  Created by Debaprasad Mondal on 25/12/14.
//  Copyright (c) 2015 Debaprasad Mondal. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface DraggableView : UIView {
    CGPoint offset;
}

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *yesLabel;
@property (nonatomic, strong) UILabel *noLabel;

- (id)initWithFrame:(CGRect)frame image:(UIImage*)aImage;

@end
