//
//  MINovoPedido.h
//  Midas
//
//  Created by Marcel de Siqueira Campos Rebouças on 6/13/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MINovoPedido : NSObject

@property NSNumber *foreachValue;
@property NSString *foreach;
@property NSNumber *willgiveValue;
@property NSString *willgive;
@property NSString *descricao;
@property UIImage *image;
@property UIImage *thumbnail;
@property NSNumber *category;
@property PFGeoPoint *location;

@end
