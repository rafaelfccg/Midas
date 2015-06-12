//
//  MIChatViewController.m
//  Midas
//
//  Created by Rafael Gouveia on 6/9/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "MIChatViewController.h"
#import <Parse/Parse.h>
#import "ProgressHUD.h"
#import "IDMPhotoBrowser.h"
#import "RNGridMenu.h"
#import "AppConstant.h"

#import "common.h"
#import "image.h"
#import "push.h"
#import "recent.h"
#import "ProfileView.h"
#import "camera.h"

#import "PhotoMediaItem.h"


@interface MIChatViewController (){
    NSTimer *timer;
    BOOL isLoading;
    BOOL initialized;
    
    NSMutableArray *users;
    NSMutableArray *messages;
    NSMutableDictionary *avatars;
    
    JSQMessagesBubbleImage *bubbleImageOutgoing;
    JSQMessagesBubbleImage *bubbleImageIncoming;
    JSQMessagesAvatarImage *avatarImageBlank;
}
@end

@implementation MIChatViewController
- (id)initWith:(NSString *)chatId_
{
    self = [super init];
    _chatId = chatId_;
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    self.title = @"Chat";
    //---------------------------------------------------------------------------------------------------------------------------------------------
    users = [[NSMutableArray alloc] init];
    messages = [[NSMutableArray alloc] init];
    avatars = [[NSMutableDictionary alloc] init];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    PFUser *user = [PFUser currentUser];
    self.senderId = user.objectId;
    self.senderDisplayName = user[PF_USER_FULLNAME];
    //_chatId = @"hhBo727u17";
    //---------------------------------------------------------------------------------------------------------------------------------------------
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    bubbleImageOutgoing = [bubbleFactory outgoingMessagesBubbleImageWithColor:COLOR_OUTGOING];
    bubbleImageIncoming = [bubbleFactory incomingMessagesBubbleImageWithColor:COLOR_INCOMING];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    avatarImageBlank = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"chat_blank"] diameter:30.0];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    //[self hidesBottomBarWhenPushed];
    isLoading = NO;
    initialized = NO;
    [self loadMessages];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidAppear:animated];
    self.collectionView.collectionViewLayout.springinessEnabled = YES;
    self.tabBarController.tabBar.hidden = YES;
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(loadMessages) userInfo:nil repeats:YES];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)viewWillDisappear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [super viewWillDisappear:animated];
    ClearRecentCounter(_chatId);
    self.tabBarController.tabBar.hidden = NO;
    [timer invalidate];
}

#pragma mark - Backend methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)loadMessages
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    if (isLoading == NO)
    {
        isLoading = YES;
        JSQMessage *message_last = [messages lastObject];
        
        PFQuery *query = [PFQuery queryWithClassName:PF_MESSAGE_CLASS_NAME];
        [query whereKey:PF_MESSAGE_CHATID equalTo:_chatId];
        if (message_last != nil) [query whereKey:PF_MESSAGE_CREATEDAT greaterThan:message_last.date];
        [query includeKey:PF_MESSAGE_USER];
        [query orderByDescending:PF_MESSAGE_CREATEDAT];
        [query setLimit:50];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             if (error == nil)
             {
                 BOOL incoming = NO;
                 self.automaticallyScrollsToMostRecentMessage = NO;
                 for (PFObject *object in [objects reverseObjectEnumerator])
                 {
                     JSQMessage *message = [self addMessage:object];
                     if ([self incoming:message]) incoming = YES;
                 }
                 if ([objects count] != 0)
                 {
                     if (initialized && incoming)
                         [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
                     [self finishReceivingMessage];
                     [self scrollToBottomAnimated:NO];
                 }
                 self.automaticallyScrollsToMostRecentMessage = YES;
                 initialized = YES;
             }
             else [ProgressHUD showError:@"Network error."];
             isLoading = NO;
         }];
    }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (JSQMessage *)addMessage:(PFObject *)object
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    JSQMessage *message;
    //---------------------------------------------------------------------------------------------------------------------------------------------
    PFUser *user = object[PF_MESSAGE_USER];
    NSString *name = user[PF_USER_FULLNAME];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    PFFile *filePicture = object[PF_MESSAGE_IMAGE];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    if (filePicture == nil)
    {
        message = [[JSQMessage alloc] initWithSenderId:user.objectId senderDisplayName:name date:object.createdAt text:object[PF_MESSAGE_TEXT]];
    }
    //---------------------------------------------------------------------------------------------------------------------------------------------
    
    if (filePicture != nil)
    {
        JSQPhotoMediaItem *mediaItem = [[JSQPhotoMediaItem alloc] initWithImage:nil];
        mediaItem.appliesMediaViewMaskAsOutgoing = [user.objectId isEqualToString:self.senderId];
        message = [[JSQMessage alloc] initWithSenderId:user.objectId senderDisplayName:name date:object.createdAt media:mediaItem];
        //-----------------------------------------------------------------------------------------------------------------------------------------
        [filePicture getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
         {
             if (error == nil)
             {
                 mediaItem.image = [UIImage imageWithData:imageData];
                 [self.collectionView reloadData];
             }
         }];
    }
    //---------------------------------------------------------------------------------------------------------------------------------------------
    [users addObject:user];
    [messages addObject:message];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    return message;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)loadAvatar:(PFUser *)user
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    PFFile *file = user[PF_USER_THUMBNAIL];
    [file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
     {
         if (error == nil)
         {
             avatars[user.objectId] = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageWithData:imageData] diameter:30.0];
             [self.collectionView reloadData];
         }
     }];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)sendMessage:(NSString *)text Video:(NSURL *)video Picture:(UIImage *)picture
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    
    PFFile *filePicture = nil;
    //---------------------------------------------------------------------------------------------------------------------------------------------
    if (picture != nil)
    {
        text = @"[Picture message]";
        filePicture = [PFFile fileWithName:@"picture.jpg" data:UIImageJPEGRepresentation(picture, 0.6)];
        [filePicture saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             if (error != nil) [ProgressHUD showError:@"Picture save error."];
         }];
    }
    //---------------------------------------------------------------------------------------------------------------------------------------------
    PFObject *object = [PFObject objectWithClassName:PF_MESSAGE_CLASS_NAME];
    object[PF_MESSAGE_USER] = [PFUser currentUser];
    object[PF_MESSAGE_CHATID] = _chatId;
    object[PF_MESSAGE_TEXT] = text;
    if (filePicture != nil) object[PF_MESSAGE_IMAGE] = filePicture;
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error == nil)
         {
             [JSQSystemSoundPlayer jsq_playMessageSentSound];
             [self loadMessages];
         }
         else [ProgressHUD showError:@"Network error."];;
     }];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    SendPushNotification(_chatId, text);
    UpdateRecentCounter(_chatId, 1, text);
    //---------------------------------------------------------------------------------------------------------------------------------------------
    [self finishSendingMessage];
}

#pragma mark - JSQMessagesViewController method overrides

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [self sendMessage:text Video:nil Picture:nil];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)didPressAccessoryButton:(UIButton *)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [self.view endEditing:YES];
    NSArray *menuItems = @[[[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"chat_camera"] title:@"Camera"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"chat_audio"] title:@"Audio"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"chat_pictures"] title:@"Pictures"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"chat_videos"] title:@"Videos"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"chat_location"] title:@"Location"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"chat_stickers"] title:@"Stickers"]];
    RNGridMenu *gridMenu = [[RNGridMenu alloc] initWithItems:menuItems];
    gridMenu.delegate = self;
    [gridMenu showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}

#pragma mark - JSQMessages CollectionView DataSource

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    return messages[indexPath.item];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView
             messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    if ([self outgoing:messages[indexPath.item]])
    {
        return bubbleImageOutgoing;
    }
    else return bubbleImageIncoming;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView
                    avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    PFUser *user = users[indexPath.item];
    if (avatars[user.objectId] == nil)
    {
        [self loadAvatar:user];
        return avatarImageBlank;
    }
    else return avatars[user.objectId];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    if (indexPath.item % 3 == 0)
    {
        JSQMessage *message = messages[indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    else return nil;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    JSQMessage *message = messages[indexPath.item];
    if ([self incoming:message])
    {
        if (indexPath.item > 0)
        {
            JSQMessage *previous = messages[indexPath.item-1];
            if ([previous.senderId isEqualToString:message.senderId])
            {
                return nil;
            }
        }
        return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
    }
    else return nil;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    return nil;
}

#pragma mark - UICollectionView DataSource

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    return [messages count];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    if ([self outgoing:messages[indexPath.item]])
    {
        cell.textView.textColor = [UIColor whiteColor];
    }
    else
    {
        cell.textView.textColor = [UIColor blackColor];
    }
    return cell;
}

#pragma mark - JSQMessages collection view flow layout delegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    if (indexPath.item % 3 == 0)
    {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    else return 0;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    JSQMessage *message = messages[indexPath.item];
    if ([self incoming:message])
    {
        if (indexPath.item > 0)
        {
            JSQMessage *previous = messages[indexPath.item-1];
            if ([previous.senderId isEqualToString:message.senderId])
            {
                return 0;
            }
        }
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    else return 0;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    return 0;
}

#pragma mark - Responding to collection view tap events

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    NSLog(@"didTapLoadEarlierMessagesButton");
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView
           atIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    JSQMessage *message = messages[indexPath.item];
    if ([self incoming:message])
    {
        ProfileView *profileView = [[ProfileView alloc] initWith:message.senderId];
        [self.navigationController pushViewController:profileView animated:YES];
    }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    JSQMessage *message = messages[indexPath.item];
    if (message.isMediaMessage)
    {
        if ([message.media isKindOfClass:[PhotoMediaItem class]])
        {
            PhotoMediaItem *mediaItem = (PhotoMediaItem *)message.media;
            NSArray *photos = [IDMPhoto photosWithImages:@[mediaItem.image]];
            IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
            [self presentViewController:browser animated:YES completion:nil];
        }
    }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    NSLog(@"didTapCellAtIndexPath %@", NSStringFromCGPoint(touchLocation));
}

#pragma mark - RNGridMenuDelegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [gridMenu dismissAnimated:NO];
    //if ([item.title isEqualToString:@"Camera"])		PresentMultiCamera(self, YES);
    if ([item.title isEqualToString:@"Pictures"])	PresentPhotoLibrary(self, YES);
    }

#pragma mark - UIImagePickerControllerDelegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    NSURL *video = info[UIImagePickerControllerMediaURL];
    UIImage *picture = info[UIImagePickerControllerEditedImage];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    [self sendMessage:nil Video:video Picture:picture];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helper methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)incoming:(JSQMessage *)message
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    return ([message.senderId isEqualToString:self.senderId] == NO);
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)outgoing:(JSQMessage *)message
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    return ([message.senderId isEqualToString:self.senderId] == YES);
}

@end
