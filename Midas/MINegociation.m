//
//  MINegociation.m
//  Midas
//
//  Created by Rafael Gouveia on 6/12/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "MINegociation.h"

@implementation MINegociation

- (instancetype)initWithPFObject:(PFObject *)pfobject {
    
    self = [super init];
    
    if (self) {
        _object = pfobject;
        _owner = pfobject[PF_RECENT_REQUESTOWNER];
        _giver = pfobject[PF_RECENT_REQUESTGIVER];
        _descricao = pfobject[PF_RECENT_DESCRIPTION];
        _lastMessage = pfobject[PF_RECENT_LASTMESSAGE];
        _chatId = pfobject[PF_RECENT_CHATID];
    
    }
    
    return self;
}

+ (NSArray *) recentesArrayFromPFObjectArray:(NSArray *)array {
    NSMutableArray * result = [[NSMutableArray alloc] init];
    MINegociation *temp;
    
    for (PFObject *object in array){
        temp = [[MINegociation alloc] initWithPFObject:object];
        [result addObject:temp];
    }
    
    return result;
}


@end
