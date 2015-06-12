//
//  MIChat.m
//  Midas
//
//  Created by Rafael Gouveia on 6/9/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "MIChat.h"
#import "AppConstant.h"

@implementation MIChat
- (instancetype)initWithPFObject:(PFObject *)pfobject {
    
    self = [super init];
    
    if (self) {
        _object = pfobject;
        _requestOwner  = pfobject[PF_CHAT_REQUESTOWNER];
        _requestGiver = pfobject[PF_CHAT_REQUESTGIVER];
        _requestId = pfobject[PF_CHAT_REQUESTID];
        
    }
    
    return self;
}

@end
