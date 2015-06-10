//
//  MIDatabase.h
//  Midas
//
//  Created by Marcel de Siqueira Campos Rebouças on 6/10/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "push.h"
#import "AppConstant.h"

@interface MIDatabase : NSObject

+(MIDatabase *)sharedInstance;

#pragma mark - Registering and Authentication

-(void)logInWithUsernameInBackground:(NSString *)username password:(NSString *)password block:(PF_NULLABLE PFUserResultBlock)block;

@end
