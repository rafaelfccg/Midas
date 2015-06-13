//
//  MINegociation.h
//  Midas
//
//  Created by Rafael Gouveia on 6/12/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "AppConstant.h"

@interface MINegociation : NSObject

@property (readonly) PFObject *object;
@property (readonly) PFUser *owner;
@property (readonly) PFUser *giver;
@property (readonly) NSString *descricao;
@property (readonly) NSString *lastMessage;
@property (readonly) NSString *chatId;


- (instancetype) initWithPFObject:(PFObject *)object;

+ (NSArray *) recentesArrayFromPFObjectArray:(NSArray *)array;


@end
