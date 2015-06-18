//
//  MIPedido.m
//  Midas
//
//  Created by Rafael Gouveia on 6/9/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "MIPedido.h"
#import "AppConstant.h"

@implementation MIPedido


- (instancetype)initWithPFObject:(PFObject *)pfobject {
    
    self = [super init];
    
    if (self) {
        _object = pfobject;
        _owner = pfobject[PF_REQUEST_USER];
        _forEach = pfobject[PF_REQUEST_FOREACH];
        _forEachValue = pfobject[PF_REQUEST_FOREACHVALUE];
        _willGive = pfobject[PF_REQUEST_WILLGIVE];
        _willGiveValue = pfobject[PF_REQUEST_WILLGIVEVALUE];
        _descricao = pfobject[PF_REQUEST_DESCRIPTION];
        _status = pfobject[PF_REQUEST_STATUS];
        _category = pfobject[PF_REQUEST_CATEGORY];
        _location = pfobject[PF_REQUEST_USERLOCATION];
    }
    
    return self;
}

+ (NSArray *) pedidosArrayFromPFObjectArray:(NSArray *)array {
    NSMutableArray * result = [[NSMutableArray alloc] init];
    MIPedido *temp;
    
    for (PFObject *object in array){
        temp = [[MIPedido alloc] initWithPFObject:object];
        [result addObject:temp];
    }
    
    return result;
}

@end
