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
#import "MIDatabase.h"
#import "MIPedido.h"
#import "PhotoMediaItem.h"
#import "general.h"


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
//@property MINegociation * chat;

@property float keyboardHeight;
@property BOOL isUp;
@property UIActionSheet *openMoreSheet;

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
    self.title = NSLocalizedString(@"Chat", @"Chat Title");
    //---------------------------------------------------------------------------------------------------------------------------------------------
    users = [[NSMutableArray alloc] init];
    messages = [[NSMutableArray alloc] init];
    avatars = [[NSMutableDictionary alloc] init];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    PFUser *user = [PFUser currentUser];
    self.senderId = user.objectId;
    self.senderDisplayName = user[PF_USER_USERNAME];
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
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    //informacao do user -- esta no xib JSQMessagesViewController
    self.userImageView.layer.cornerRadius =  self.userImageView.bounds.size.width/2;
    self.userImageView.clipsToBounds = YES;
    [self loadRequestInfo];
    
    [self loadMessages];
    
    _isUp = NO;
    
    // Do any additional setup after loading the view.
    
    //    UIBarButtonItem *editarButton = [[UIBarButtonItem alloc]
    //                                     initWithTitle:nil
    //                                     style:UIBarButtonItemStylePlain
    //                                     target:self
    //                                     action:@selector(openMoreSheet:)];
    //    [editarButton setBackButtonBackgroundImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal barMetrics:0];
    //    self.navigationItem.rightBarButtonItem = editarButton;
    
    UIButton* customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [customButton setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [customButton setTitle:@"" forState:UIControlStateNormal];
    [customButton setBounds:CGRectMake(0, 0, 20, 20)];
    [customButton addTarget:self action:@selector(openMoreSheet:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* customBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    self.navigationItem.rightBarButtonItem = customBarButtonItem;
}

- (void)openMoreSheet:(id)sender {
    /*
     self.openMoreSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancelar", @"Cancelar Button")
     destructiveButtonTitle:NSLocalizedString(@"Apenas Denunciar", @"Apenas Denunciar") otherButtonTitles:@[NSLocalizedString(@"Apenas Bloquear", @"Apenas Bloquear"),NSLocalizedString(@"Denunciar e Bloquear", @"Denunciar e Bloquear")]];
     [self.openMoreSheet showFromTabBar:[[self tabBarController] tabBar]];
     */
    
    self.openMoreSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancelar", @"Cancelar Button")
                                       destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Apenas Denunciar", @"Apenas Denunciar"),NSLocalizedString(@"Apenas Bloquear", @"Apenas Bloquear"), NSLocalizedString(@"Denunciar e Bloquear", @"Denunciar e Bloquear"),nil];
    [self.openMoreSheet showFromTabBar:[[self tabBarController] tabBar]];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    if(actionSheet==self.openMoreSheet)
    {
        
        //aqui
        if (buttonIndex == 0)
        {
            
            [[MIDatabase sharedInstance]checkIfContentIsFlaggedAsInappropriateFromMessage:_neg.owner withBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                if(error){
                    [ProgressHUD showError:error.userInfo[@"error"]];
                }
                else if ([objects count] > 0) {
                    [ProgressHUD showSuccess:[NSString stringWithFormat:NSLocalizedString(@"Você já denunciou esse usuário.", @"Você já denunciou esse post.")]];
                } else{
                    [[MIDatabase sharedInstance]markContentAsInappropriateFromMessage:_neg.owner withBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        if(!succeeded){
                            [ProgressHUD showError:error.userInfo[@"error"]];
                        }
                        else{
                            [ProgressHUD showSuccess:[NSString stringWithFormat:NSLocalizedString(@"Denuncia enviada para análise. Obrigado.", @"Usuário denunciado. Obrigado por fazer o Midas melhor.")]];
                        }
                    }];
                }
            }];
            
        NSLog(@"Apertou Apenas Denunciar!");
            
        } else if (buttonIndex == 1)
        {
            [[MIDatabase sharedInstance]checkIfUserIsBlocked:_neg.owner withBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                if(error){
                    [ProgressHUD showError:error.userInfo[@"error"]];
                }
                else if ([objects count] > 0){
                    [ProgressHUD showSuccess:[NSString stringWithFormat:NSLocalizedString(@"Você já bloqueou esse usuário.", @"Você já bloqueou esse post.")]];
                }
                else{
                    [[MIDatabase sharedInstance]blokAUser:_neg.owner withBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        if(!succeeded){
                            [ProgressHUD showError:error.userInfo[@"error"]];
                        }
                        else{
                            [ProgressHUD showSuccess:[NSString stringWithFormat:NSLocalizedString(@"Usuário bloqueado.", @"Usuário bloqueado")]];
                        }
                    }];
                }
            }];
            
            NSLog(@"Apertou Apenas Bloquear!");
        } else if (buttonIndex == 2)
        {
            [[MIDatabase sharedInstance]checkIfContentIsFlaggedAsInappropriateFromMessage:_neg.owner withBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                if(error){
                    [ProgressHUD showError:error.userInfo[@"error"]];
                }
                else if ([objects count] > 0) {
                    [ProgressHUD showSuccess:[NSString stringWithFormat:NSLocalizedString(@"Você já denunciou esse usuário.", @"Você já denunciou esse post.")]];
                } else{
                    [[MIDatabase sharedInstance]markContentAsInappropriateFromMessage:_neg.owner withBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        if(!succeeded){
                            [ProgressHUD showError:error.userInfo[@"error"]];
                        }
                    }];
                }
            }];
            
            
            [[MIDatabase sharedInstance]checkIfUserIsBlocked:_neg.owner withBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                if(error){
                    [ProgressHUD showError:error.userInfo[@"error"]];
                }
                else if ([objects count] > 0){
                    [ProgressHUD showSuccess:[NSString stringWithFormat:NSLocalizedString(@"Você já bloqueou esse usuário.", @"Você já bloqueou esse post.")]];
                }
                else{
                    [[MIDatabase sharedInstance]blokAUser:_neg.owner withBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        if(!succeeded){
                            [ProgressHUD showError:error.userInfo[@"error"]];
                        }
                        else{
                            [ProgressHUD showSuccess:[NSString stringWithFormat:NSLocalizedString(@"Usuário bloqueado e reportado.", @"Usuário bloqueado")]];
                        }
                    }];
                }
            }];
            
            NSLog(@"Apertou Bloquear e Denunciar!");
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

- (UIImage *)imageFromSystemBarButton:(UIBarButtonSystemItem)systemItem {
    // Holding onto the oldItem (if any) to set it back later
    // could use left or right, doesn't matter
    UIBarButtonItem *oldItem = self.navigationItem.rightBarButtonItem;
    
    UIBarButtonItem *tempItem = [[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:systemItem
                                 target:nil
                                 action:nil];
    
    // Setting as our right bar button item so we can traverse its subviews
    self.navigationItem.rightBarButtonItem = tempItem;
    
    // Don't know whether this is considered as PRIVATE API or not
    UIView *itemView = (UIView *)[self.navigationItem.rightBarButtonItem performSelector:@selector(view)];
    
    UIImage *image = nil;
    // Traversing the subviews to find the ImageView and getting its image
    for (UIView *subView in itemView.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            image = ((UIImageView *)subView).image;
            break;
        }
    }
    
    // Setting our oldItem back since we have the image now
    self.navigationItem.rightBarButtonItem = oldItem;
    
    return image;
}

- (void)viewDidAppear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidAppear:animated];
    self.collectionView.collectionViewLayout.springinessEnabled = YES;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(loadMessages) userInfo:nil repeats:YES];
    
}
-(void)viewWillAppear:(BOOL)animated{
    PFUser * user = [PFUser currentUser];
    if([user.objectId isEqualToString:_neg.owner.objectId] ){
        self.title = _neg.giver.username;
    }else{
        self.title = _neg.owner.username;
    }
    self.tabBarController.tabBar.hidden = YES;
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
             else {
                 NSLog(@"%@", error.userInfo[@"error"]);
                 NSString *errorMessage = localizeErrorMessage(error);
                 [ProgressHUD showError:errorMessage];
             }
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
    NSString *name = user[PF_USER_USERNAME];
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
    PFFile *file = user[PF_USER_IMAGE];
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
             if (error != nil) [ProgressHUD showError:NSLocalizedString(@"Erro ao salvar imagem.", @"Picture save error.")];
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
         else {
             NSLog(@"%@", error.userInfo[@"error"]);
             NSString *errorMessage = localizeErrorMessage(error);
             [ProgressHUD showError:errorMessage];
         }
     }];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    SendPushNotification(_chatId, _neg, text);
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
    NSArray *menuItems = @[[[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"CameraIcon"] title:NSLocalizedString(@"Camera", @"Camera Button")],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"GalleryIcon"] title:NSLocalizedString(@"Galeria", @"Galeria Button")]];
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
    if ([item.title isEqualToString:NSLocalizedString(@"Camera", @"Camera Button")]){
        PresentPhotoCamera(self, YES);
    }
    if ([item.title isEqualToString:NSLocalizedString(@"Galeria", @"Galeria Button")]){
        PresentPhotoLibrary(self, YES);
    }
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

- (void) loadRequestInfo {
    
    //REDO:: TÁ HORRÍVEL ISSO AQUI
    
    
    //PEGA O REQUEST
    [[MIDatabase sharedInstance] getRequestWithObjectId:self.neg.object[PF_RECENT_REQUESTID] withBlock:^(NSArray *objects, NSError *error)
     {
         if ([objects count]>0) {
             MIPedido *pedido = [[MIPedido alloc] initWithPFObject:[objects firstObject]];
             
             self.willGiveLabel.text = [NSString stringWithFormat:@"%@ %@", pedido.willGiveValue, pedido.willGive];
             self.forEachLabel.text = [NSString stringWithFormat:@"%@ %@", pedido.forEachValue, pedido.forEach];
         }
     }];
    
    
    
    //PEGA A IMAGEM DO USER
    PFFile *userImage = self.neg.owner[PF_USER_IMAGE];
    if (userImage) {
        [[MIDatabase sharedInstance] loadPFFile:userImage WithBlock:^(UIImage *PFUI_NULLABLE_S image,  NSError *PFUI_NULLABLE_S error){
            self.userImageView.image = image;
        }];
    }
    
    
    
    
}

#pragma mark - Keyboard Notifications
-(void)keyboardWillShow:(NSNotification *)notification {
    
    if([notification userInfo]){
        NSValue * keyboardSize = [notification userInfo][UIKeyboardFrameBeginUserInfoKey];
        
        
        if (!_isUp) {
            _keyboardHeight = keyboardSize.CGRectValue.size.height;
            [self animateView:YES];
            _isUp = YES;
        }
    }
}

-(void)keyboardWillHide:(NSNotification *)notification {
    
    if (_isUp) {
        [self animateView:NO];
        _isUp = NO;
    }
}

-(void) animateView:(BOOL)up {
    
    float movement = up ? -_keyboardHeight : _keyboardHeight;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    
    [UIView commitAnimations];
}



@end
