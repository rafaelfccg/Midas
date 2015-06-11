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

@property (readonly) PFObject *_object;
@property (readonly) PFUser *_owner;
@property (readonly) NSString *_title;
@property (readonly) NSString *_description;
@property (readonly) NSString *_reward;
@property (readonly) NSNumber *_status;
@property (readonly) NSNumber *_quantity;

@end
