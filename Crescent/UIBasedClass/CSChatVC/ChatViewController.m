//
//  ChatVCViewController.m
//  GameApp
//
//  Created by Apple on 07/02/15.
//  Copyright (c) 2015 Unos2. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatMessageTableViewCell.h"
#import <Quickblox/Quickblox.h>
#import "LocalStorageService.h"
#import "ChatService.h"
#import "CharactersEscapeService.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <QuartzCore/QuartzCore.h>
#import "CSUtils.h"
#import "EXPhotoViewer.h"
#import "CSFriendProfileViewController.h"

#define kOFFSET_FOR_KEYBOARD 215.0

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource, QBActionStatusDelegate>

@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, weak) IBOutlet UITextField *messageTextField;
@property (nonatomic, weak) IBOutlet UIButton *sendMessageButton;
@property (nonatomic, weak) IBOutlet UITableView *messagesTableView;
@property (nonatomic, strong) QBChatRoom *chatRoom;
@property (strong, nonatomic) IBOutlet UILabel *lblChatName;
@property (strong, nonatomic) IBOutlet UIView *viewBG,*txtBGView;
@property (weak, nonatomic) IBOutlet UIView *navigateView;

- (IBAction)sendMessage:(id)sender;

@end

@implementation ChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    //[self.messageTextField becomeFirstResponder];
    self.lblChatName.text=self.chatUserName;
    self.lblHeader.text=self.chatUserName;
    self.messageTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    [[self.sendMessageButton layer] setBorderWidth:2.0f];
    [[self.sendMessageButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    // Do any additional setup after loading the view.
    
    self.messages = [NSMutableArray array];
    
    self.messagesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Set keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    // Set chat notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatDidReceiveMessageNotification:)
                                                 name:kNotificationDidReceiveNewMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatRoomDidReceiveMessageNotification:)
                                                 name:kNotificationDidReceiveNewMessageFromRoom object:nil];
    
    // Set title
    if(self.dialog.type == QBChatDialogTypePrivate){
        QBUUser *recipient = [LocalStorageService shared].usersAsDictionary[@(self.dialog.recipientID)];
        //self.title = recipient.login == nil ? recipient.email : recipient.login;
        self.title = @"Tanumoy";
    }else{
        self.title = self.dialog.name;
    }
    
    // Join room
    if(self.dialog.type != QBChatDialogTypePrivate){
        self.chatRoom = [self.dialog chatRoom];
        [[ChatService instance] joinRoom:self.chatRoom completionBlock:^(QBChatRoom *joinedChatRoom) {
            // joined
        }];
    }
    
    // get messages history
    [QBChat messagesWithDialogID:self.dialog.ID extendedRequest:nil delegate:self];
}
- (IBAction)btnBack:(id)sender {
    [self.chatRoom leaveRoom];
    self.chatRoom = nil;
    [[QBChat instance] logout];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
 
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
   
 
}

-(BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

-(IBAction)sendPhoto{
    [self.messageTextField resignFirstResponder];
    UIActionSheet *ImageAction;
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        ImageAction =[[UIActionSheet alloc]initWithTitle:@"Upload Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a photo",@"Choose from library", nil];
    }
    else
        ImageAction =[[UIActionSheet alloc]initWithTitle:@"Upload Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose from library", nil];
    
    
    ImageAction.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [ImageAction showInView:self.view];
}

#pragma mark
#pragma mark Actionsheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
 
        switch(buttonIndex)
        {
            case 0:
            {
                if ([UIImagePickerController isSourceTypeAvailable:
                     UIImagePickerControllerSourceTypeCamera])
                {
                    UIImagePickerController *imagePicker =[[UIImagePickerController alloc]init];
                    imagePicker.delegate=self;
                    imagePicker.sourceType =UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:imagePicker animated:YES completion:nil];
                }
                else
                {
                    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
                    {
                        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
                        picker.delegate=self;
                        picker.sourceType =UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                        [self presentViewController:picker animated:YES completion:nil];
                    }
                    
                }
                break;
                
            }
            case 1:
            {
                if (buttonIndex==actionSheet.cancelButtonIndex) {
                    return;
                }
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
                {
                    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
                    picker.delegate=self;
                    picker.sourceType =UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                    [self presentViewController:picker animated:YES completion:nil];
                }
                break;
            }
            default:
            {
                break;
            }
        }

}

#pragma mark-
#pragma mark-ImagePicker delegate


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self dismissModalViewControllerAnimated:YES];
    [[CSUtils sharedInstance]showLoadingMode];
    CGFloat maxSize = 1000.;
    CGFloat initWidth = image.size.width;
    CGFloat initHeight = image.size.height;
    CGFloat ratio = 1;
    CGFloat newWidth = image.size.width;
    CGFloat newHeight = image.size.height;
    if(initWidth > initHeight){
        if(initWidth > maxSize){
            newWidth = maxSize;
            ratio = initHeight / initWidth;
            newHeight = newWidth * ratio;
        }
    } else {
        if(initHeight > maxSize){
            newHeight = maxSize;
            ratio = initWidth / initHeight;
            newWidth = newHeight * ratio;
        }
    }
    
    
    image=[CSUtils imageWithImage:image convertToSize:CGSizeMake(newWidth , newHeight)];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    
    [QBRequest TUploadFile:imageData fileName:@"image.png" contentType:@"image/png" isPublic:YES successBlock:^(QBResponse *response, QBCBlob *uploadedBlob) {
        NSUInteger uploadedFileID = uploadedBlob.ID;
        
        // Create chat message with attach
        // create a message
        QBChatMessage *message = [[QBChatMessage alloc] init];
        message.text = @"null";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"save_to_history"] = @YES;
        [message setCustomParameters:params];

            // send message
        message.recipientID = [self.dialog recipientID];
        message.senderID = [LocalStorageService shared].currentUser.ID;
            
      
        
        QBChatAttachment *attachment = QBChatAttachment.new;
        attachment.type = @"image";
        attachment.url = uploadedBlob.publicUrl;
        attachment.ID = [NSString stringWithFormat:@"%lu", (unsigned long)uploadedFileID]; // use 'ID' property to store an ID of a file in Content or CustomObjects modules
        [message setAttachments:@[attachment]];
        [[ChatService instance] sendMessage:message];
        // save message
        [self.messages addObject:message];
        // Reload table
        [self.messagesTableView reloadData];
        if(self.messages.count > 0){
            [self.messagesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        
        // Clean text field
        [self.messageTextField setText:nil];
        [[CSUtils sharedInstance] hideLoadingMode];
    } statusBlock:^(QBRequest *request, QBRequestStatus *status) {
        // handle progress
        
    } errorBlock:^(QBResponse *response) {
          [[CSUtils sharedInstance] hideLoadingMode];
        NSLog(@"error: %@", response.error);
    }];

}


-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark
#pragma mark Actions

- (IBAction)sendMessage:(id)sender{
    if(self.messageTextField.text.length == 0){
        return;
    }
    
    // create a message
    QBChatMessage *message = [[QBChatMessage alloc] init];
    message.text = self.messageTextField.text;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"save_to_history"] = @YES;
    [message setCustomParameters:params];
    
    // 1-1 Chat
    if(self.dialog.type == QBChatDialogTypePrivate){
        // send message
        message.recipientID = [self.dialog recipientID];
        message.senderID = [LocalStorageService shared].currentUser.ID;
        
        [[ChatService instance] sendMessage:message];
        
        // save message
        [self.messages addObject:message];
        
        // Group Chat
    }else {
        [[ChatService instance] sendMessage:message toRoom:self.chatRoom];
    }
    
    // Reload table
    [self.messagesTableView reloadData];
    if(self.messages.count > 0){
        [self.messagesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    // Clean text field
    [self.messageTextField setText:nil];
    [self.messageTextField resignFirstResponder];
}

- (IBAction)tapProfileImage:(UITapGestureRecognizer *)sender
{
    UIImageView *userImageView = (UIImageView *)sender.view;
    QBChatAbstractMessage * message = self.messages[userImageView.tag];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    CSFriendProfileViewController *mfriendcontroller = [storyboard instantiateViewControllerWithIdentifier:@"CSFriendProfileViewController"];
    
    if ([LocalStorageService shared].currentUser.ID == message.senderID) {
        
        Person *mperson=[[Person alloc]init];
        
        mperson.name = [CSUserHelper sharedInstance].userDict[@"name"];
        mperson.imageurl = [[CSUserHelper sharedInstance].userDict[@"userimage"] firstObject][@"image"];
        mperson.userid = [CSUserHelper sharedInstance].userDict[@"user_id"];
        mperson.email = [CSUserHelper sharedInstance].userDict[@"email"];
        
        mfriendcontroller.mperson = mperson;
        
    } else {
        mfriendcontroller.mperson = self.mPerson;

    }
    
    
    [self.navigationController pushViewController:mfriendcontroller animated:YES];
    
}

#pragma mark
#pragma mark Chat Notifications

- (void)chatDidReceiveMessageNotification:(NSNotification *)notification{
    
    QBChatMessage *message = notification.userInfo[kMessage];
    if(message.senderID != self.dialog.recipientID){
        return;
    }
    
    // save message
    [self.messages addObject:message];
    
    // Reload table
    [self.messagesTableView reloadData];
    if(self.messages.count > 0){
        [self.messagesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messages count]-1 inSection:0]
                                      atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)chatRoomDidReceiveMessageNotification:(NSNotification *)notification{
    QBChatMessage *message = notification.userInfo[kMessage];
    NSString *roomJID = notification.userInfo[kRoomJID];
    
    if(![self.chatRoom.JID isEqualToString:roomJID]){
        return;
    }
    
    // save message
    [self.messages addObject:message];
    
    // Reload table
    [self.messagesTableView reloadData];
    if(self.messages.count > 0){
        [self.messagesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messages count]-1 inSection:0]
                                      atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

-(IBAction)openImage:(UITapGestureRecognizer *) tap{
    [EXPhotoViewer showImageFrom:(UIImageView*)tap.view];
}

#pragma mark
#pragma mark UITableViewDelegate & UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    QBChatAbstractMessage * message = self.messages[indexPath.row];
    static NSString *ChatMessageCellIdentifier = @"";
    if ([LocalStorageService shared].currentUser.ID == message.senderID) {
        if([[message.text lowercaseString] isEqualToString:@"null"]){
            ChatMessageCellIdentifier = @"LeftPhotoCell";
        } else {
            ChatMessageCellIdentifier = @"LeftCell";
        }
        
    } else {
        if([[message.text lowercaseString] isEqualToString:@"null"]){
            ChatMessageCellIdentifier = @"RightPhotoCell";
        } else {
            ChatMessageCellIdentifier = @"RightCell";
        }
        
    }
    
    
    ChatMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatMessageCellIdentifier];
    cell.imgUser.tag = indexPath.row;
    cell.delegate = self;
    [cell configureCellWithMessage:message oppImage:self.chatOpponentImg];
    
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    QBChatAbstractMessage *chatMessage = [self.messages objectAtIndex:indexPath.row];
    CGFloat cellHeight = [ChatMessageTableViewCell heightForCellWithMessage:chatMessage];
    return cellHeight;
}


#pragma mark
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark
#pragma mark Keyboard notifications

- (void)keyboardWillShow:(NSNotification *)note
{
    [self setViewMovedUp:YES];
    
    /*
     CGSize screenSize=[[UIScreen mainScreen]bounds].size;
        
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            if(screenSize.height==480)
            {
                self.messageTextField.transform = CGAffineTransformMakeTranslation(0, -250);
                self.sendMessageButton.transform = CGAffineTransformMakeTranslation(0, -250);
                self.messagesTableView.frame = CGRectMake(self.messagesTableView.frame.origin.x,
                                                          self.messagesTableView.frame.origin.y-270,
                                                          self.messagesTableView.frame.size.width,
                                                          self.messagesTableView.frame.size.height);
                [self.messagesTableView setContentInset:UIEdgeInsetsMake(270, 0, 0, 0)];
                
            }
            if(screenSize.height==568)
            {
                if (self.view.frame.origin.y >= 0)
                {
                    [self setViewMovedUp:YES];
                }
                else if (self.view.frame.origin.y < 0)
                {
                    [self setViewMovedUp:NO];
                }
            }
        }
        else{
            self.messageTextField.transform = CGAffineTransformMakeTranslation(0, -1 * kOFFSET_FOR_KEYBOARD);
            self.sendMessageButton.transform = CGAffineTransformMakeTranslation(0, -1 * kOFFSET_FOR_KEYBOARD);
            self.messagesTableView.frame = CGRectMake(self.messagesTableView.frame.origin.x,
                                                      self.messagesTableView.frame.origin.y,
                                                      self.messagesTableView.frame.size.width,
                                                      self.messagesTableView.frame.size.height-kOFFSET_FOR_KEYBOARD);
            [self.messagesTableView setContentInset:UIEdgeInsetsMake(kOFFSET_FOR_KEYBOARD, 0, 0, 0)];
            
        }*/
        
        
}

- (void)keyboardWillHide:(NSNotification *)note
{

            [self setViewMovedUp:NO];
    
        
        /*
        CGSize screenSize=[[UIScreen mainScreen]bounds].size;
        
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            if(screenSize.height==480)
            {
                self.messageTextField.transform = CGAffineTransformIdentity;
                self.sendMessageButton.transform = CGAffineTransformIdentity;
                self.messagesTableView.frame = CGRectMake(self.messagesTableView.frame.origin.x,
                                                          self.messagesTableView.frame.origin.y,
                                                          self.messagesTableView.frame.size.width,
                                                          self.messagesTableView.frame.size.height+250);
                [self.messagesTableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
                
            }
            if(screenSize.height==568)
            {
                if (self.view.frame.origin.y >= 0)
                {
                    [self setViewMovedUp:YES];
                }
                else if (self.view.frame.origin.y < 0)
                {
                    [self setViewMovedUp:NO];
                }
            }
        }
        else{
            self.messageTextField.transform = CGAffineTransformMakeTranslation(0, -1 * kOFFSET_FOR_KEYBOARD);
            self.sendMessageButton.transform = CGAffineTransformMakeTranslation(0, -1 * kOFFSET_FOR_KEYBOARD);
            self.messagesTableView.frame = CGRectMake(self.messagesTableView.frame.origin.x,
                                                      self.messagesTableView.frame.origin.y,
                                                      self.messagesTableView.frame.size.width,
                                                      self.messagesTableView.frame.size.height-kOFFSET_FOR_KEYBOARD);
            [self.messagesTableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
            
        }
     */
        
        
}
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    if (movedUp)
    {
        [self.messagesTableView setContentInset:UIEdgeInsetsMake(0, 0, kOFFSET_FOR_KEYBOARD, 0)];
        self.viewBG.transform = CGAffineTransformMakeTranslation(0, -1 * kOFFSET_FOR_KEYBOARD);
        
    }
    else
    {
        [self.messagesTableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        self.viewBG.transform = CGAffineTransformMakeTranslation(0, 0);

    }
   
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark QBActionStatusDelegate

- (void)completedWithResult:(QBResult *)result
{
    if (result.success && [result isKindOfClass:QBChatHistoryMessageResult.class]) {
        QBChatHistoryMessageResult *res = (QBChatHistoryMessageResult *)result;
        NSArray *messages = res.messages;
        [self.messages addObjectsFromArray:[messages mutableCopy]];
        //
        [self.messagesTableView reloadData];
        if (self.messages.count!=0) {
            [self.messagesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
        
    }
}

@end
