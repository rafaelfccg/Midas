//
//  MIChatViewController.h
//  Midas
//
//  Created by Rafael Gouveia on 6/9/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JSQMessages.h"
#import "RNGridMenu.h"

@interface MIChatViewController : JSQMessagesViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, RNGridMenuDelegate>
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property NSString *chatId;
- (id)initWith:(NSString *)groupId_;

@end
