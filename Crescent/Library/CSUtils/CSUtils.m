//
//  CSUtils.m
//  Crescent
//
//  Created by Debaprasad Mondal on 26/12/14.
//  Copyright (c) 2014 Debaprasad Mondal. All rights reserved.
//

#import "CSUtils.h"
//#import <Parse/Parse.h>

#define LOADING_VIEWTAG 3333


@implementation CSUtils
NSString * const kCSErrorDomain = @"com.unosinfotech.error";
+ (CSUtils *)sharedInstance
{
    static CSUtils *sharedInstance_ = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance_ = [[CSUtils alloc] init];
        sharedInstance_.appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
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

#pragma mark-
#pragma mark  iOS Types Related

-(float)getSystemVersion
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    return version;
}

-(void)ValidateEmail:(UITextField *)txtField{
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    //Valid email address
    if ([emailTest evaluateWithObject:txtField.text] == YES)
    {
    }
    else
    {
        
        txtField.text=@"";
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:ALERT_TITLE message:@"Please enter valid email address." delegate:nil cancelButtonTitle:ALT_BTN_OK otherButtonTitles:nil, nil];
        [alert show];
    }
}
#pragma mark-
#pragma mark  Show Alerts

-(void)showNormalAlert:(NSString *)_message {
    
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:ALERT_TITLE message:_message delegate:nil cancelButtonTitle:ALT_BTN_OK otherButtonTitles:nil, nil];
    
    [alert show];
    
}

-(void)showNormalAlertWithoutTitle:(NSString *)_message{
    
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"" message:_message delegate:nil cancelButtonTitle:ALT_BTN_OK otherButtonTitles:nil, nil];
    
    [alert show];
    
}
+(UIImage *)resizeImage:(UIImage *)_cutImage Width:(float)_Width Height:(float)_Height
{
    
    CGFloat oldWidth = _cutImage.size.width;
    CGFloat oldHeight = _cutImage.size.height;
    float width=_Width;
    float height=_Height;
    
    CGFloat scaleFactor;
    
    if (oldWidth > oldHeight) {
        scaleFactor = width / oldWidth;
    } else {
        scaleFactor = height / oldHeight;
    }
    
    CGFloat newHeight = oldHeight * scaleFactor;
    CGFloat newWidth = oldWidth * scaleFactor;
    if(newWidth>_Width){
        
        newWidth=_Width-5;
    }
    if (newHeight>_Height) {
        newHeight=_Height-5;
    }
    
    CGSize newsize = CGSizeMake(newWidth, newHeight);
    UIImage *destImage=[self imageWithImage:_cutImage convertToSize:newsize];
    
    
    return destImage;
    
    
}
+ (UIImage *)imageWithImage:(UIImage *)imagess convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [imagess drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize Image:(UIImage *)_cutImage
{
    UIImage *sourceImage = _cutImage;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

-(NSString *)convertNotificationDate:(NSString *)matchdate Dateformat:(NSString *)format
{
    
  /*  NSDateFormatter *inDateFormatter = [[NSDateFormatter alloc] init];
    
    inDateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"GMT"];
    
    // inDateFormatter.timeZone =[NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSDate *inDate=[inDateFormatter dateFromString:tempStr];
    
    // about output date(IST)
    NSDateFormatter *outDateFormatter = [[NSDateFormatter alloc] init];
    outDateFormatter.timeZone = [NSTimeZone systemTimeZone];
    outDateFormatter.dateFormat = COMMENT_DATE_FORMAT;
    NSString *dtStr = [outDateFormatter stringFromDate:inDate];
    NSDate *date2 =[outDateFormatter dateFromString:dtStr];
    */
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[[NSTimeZone alloc]initWithName:@"GMT"]];
    [dateFormatter setDateFormat:kDateFormat];
    NSDate *date = [dateFormatter dateFromString:matchdate];
    [dateFormatter setDateFormat:format];//@"MMM dd, yyyy"
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString * updatedString = [dateFormatter stringFromDate:date];
    return updatedString;
}

-(void)saveUserDetailsIntoPlistFile
{
    
    // getting dictionary from plist file to check and save user name
    /*
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"UserDetail.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"UserDetail" ofType:@"plist"];
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error]; // create plist file into document directory
    }
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path]; // getting dictionary from plist file
    userDict=[CSUserHelper sharedInstance].userDict;
    [userDict writeToFile:path atomically:YES]; // write dictionary into plist file.
     */
    
    [[NSUserDefaults standardUserDefaults] setObject:[CSUserHelper sharedInstance].userDict forKey:@"UserDetail"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
-(void)getUserDetailsIntoPlistFile
{
    
    
    NSDictionary * dic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"UserDetail"];
    [CSUserHelper sharedInstance].userDict=[[NSMutableDictionary alloc] initWithDictionary:dic];
    /*
    // getting dictionary from plist file to check and save user name
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"UserDetail.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"UserDetail" ofType:@"plist"];
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error]; // create plist file into document directory
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path]; // getting dictionary from plist file
    [CSUserHelper sharedInstance].userDict=dict;
     */
    
}

-(NSString *)getQBLogin{    
    return  [[[CSUserHelper sharedInstance].userDict[@"email"] stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
}

-(BOOL)hasValidUser{
    if([CSUserHelper sharedInstance].userDict){
        if([[CSUserHelper sharedInstance].userDict valueForKey:@"email"]){
            return YES;
        }
    }
    return NO;
}

-(BOOL)hasQBId{
    
    NSNumber * QBId = [[CSUserHelper sharedInstance].userDict valueForKey:@"quickblox_id"];
    if(QBId && [QBId intValue] > 0){
        return YES;
    }
    
    return NO;
}


-(NSString *)checkNullStringAndReplace:(NSString*)_inputString{
    NSString *InputString=@"";
    InputString=[NSString stringWithFormat:@"%@",_inputString];
    if((InputString == nil) ||(InputString ==(NSString *)[NSNull null])||([InputString isEqual:nil])||([InputString length] == 0)||[allTrim( InputString ) length] == 0||([InputString isEqualToString:@""])||([InputString isEqualToString:@"(NULL)"])||([InputString isEqualToString:@"<NULL>"])||([InputString isEqualToString:@"<null>"]||([InputString isEqualToString:@"(null)"])||([InputString isEqualToString:@""])))
        return @"";
    else
        return _inputString ;
    
}

-(void)showLoadingMode{
    AppDelegate *app=(AppDelegate*) [UIApplication sharedApplication].delegate;
    UIImageView *view=(UIImageView*)[app.window viewWithTag:LOADING_VIEWTAG];
    if (!view)
    {
        //if (!self.loadingCircle) {
        UIImageView *loadingCircle = [[UIImageView alloc]init];
        loadingCircle.tag=LOADING_VIEWTAG;
        loadingCircle.backgroundColor = [UIColor clearColor];
        NSArray *imageArr=[NSArray arrayWithObjects:[UIImage imageNamed:@"loading_animation1"],[UIImage imageNamed:@"loading_animation2"],[UIImage imageNamed:@"loading_animation3"],[UIImage imageNamed:@"loading_animation4"],[UIImage imageNamed:@"loading_animation5"],[UIImage imageNamed:@"loading_animation6"],[UIImage imageNamed:@"loading_animation7"], nil];
        loadingCircle.animationImages=imageArr;
        loadingCircle.animationRepeatCount=0;
        loadingCircle.animationDuration=1;
        int size = 100;
        
        CGRect frame;
        frame.size.width = size ;
        frame.size.height = size;
        frame.origin.x = app.window.frame.size.width / 2 - frame.size.width / 2;
        frame.origin.y = app.window.frame.size.height / 2 - frame.size.height / 2;
        loadingCircle.frame = frame;
        [app.window addSubview: loadingCircle];
        [loadingCircle startAnimating];
    }
}

-(void)hideLoadingMode{
    AppDelegate *app=(AppDelegate*) [UIApplication sharedApplication].delegate;
    UIImageView *view=(UIImageView *)[app.window viewWithTag:LOADING_VIEWTAG];
    if (view) {
        [view stopAnimating];
        [view removeFromSuperview];
        //self.loadingCircle = nil;
    }
}





@end
