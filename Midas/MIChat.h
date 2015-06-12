//
//  MIChat.h
//  Midas
//
//  Created by Rafael Gouveia on 6/9/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface MIChat : NSObject
    @property (readonly) PFUser *requestOwner;
    @property (readonly) PFUser *requestGiver;
    @property (readonly) NSString * requestId;
    @property (readonly) PFObject * object;




@end
