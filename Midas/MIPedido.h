//
//  MIPedido.h
//  Midas
//
//  Created by Rafael Gouveia on 6/9/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface MIPedido : NSObject

@property (readonly) PFObject *object;
@property (readonly) PFUser *owner;
@property (readonly) NSString *title;
@property (readonly) NSString *descricao;
@property (readonly) NSString *reward;
@property (readonly) NSNumber *status;
@property (readonly) NSNumber *quantity;
@property (readonly) NSNumber *category;

- (instancetype) initWithPFObject:(PFObject *)object;

+ (NSArray *) pedidosArrayFromPFObjectArray:(NSArray *)array;
@end
