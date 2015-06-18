//
//  MINovoPedido.m
//  Midas
//
//  Created by Marcel de Siqueira Campos Rebouças on 6/13/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "MINovoPedido.h"

@implementation MINovoPedido

-(instancetype) initWithMIPedido:(MIPedido *)editRequest{
    
    self = [super init];
    
    if(self){
        _editRequest = editRequest;
        _foreachValue = editRequest.forEachValue;
        _foreach = editRequest.forEach;
        _willgiveValue = editRequest.willGiveValue;
        _willgive = editRequest.willGive;
        _descricao = editRequest.descricao;
        //_image = editRequest.;
        //_thumbnail;
        _category = editRequest.category;
        _location = editRequest.location;
    }
    
    return self;
}

-(BOOL) isEditing {
    return (_editRequest != nil);
}

@end
