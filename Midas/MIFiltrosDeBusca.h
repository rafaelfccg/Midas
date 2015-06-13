//
//  MIFiltrosDeBusca.h
//  Midas
//
//  Created by Rafael Gouveia on 6/9/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIFiltrosDeBusca : NSObject

@property bool Vidro;
@property bool Metal;
@property bool Papel;
@property bool Todos;
@property bool Outros;
@property bool Plastico;

-(id)initWithFilters: (bool)vidro Metal:(bool)metal Papel:(bool)papel Todos:(bool)todos Outros:(bool)outros Plastico:(bool)plastico;

-(id)init;
@end
