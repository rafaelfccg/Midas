//
//  MIFiltrosDeBusca.m
//  Midas
//
//  Created by Rafael Gouveia on 6/9/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "MIFiltrosDeBusca.h"

@implementation MIFiltrosDeBusca

@synthesize Vidro;
@synthesize Metal;
@synthesize Papel;
@synthesize Todos;
@synthesize Outros;
@synthesize Plastico;

-(id)init {
    if ( self = [super init] ) {
        self.Vidro = false;
        self.Metal = false;
        self.Papel = false;
        self.Todos = false;
        self.Outros = false;
        self.Plastico = false;
    }
    return self;
}

-(id)initWithFilters:(bool)vidro Metal:(bool)metal Papel:(bool)papel Todos:(bool)todos Outros:(bool)outros Plastico:(bool)plastico
{
    if ( self = [super init] ) {
        self.Vidro = vidro;
        self.Metal = metal;
        self.Papel = papel;
        self.Todos = todos;
        self.Outros = outros;
        self.Plastico = plastico;
    }
    return self;
}

@end
