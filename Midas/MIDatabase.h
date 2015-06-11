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

+(nonnull MIDatabase *)sharedInstance;

//authentication

-(void)logInWithUsernameInBackground:(nonnull NSString *)username password:(nonnull NSString *)password block:(PF_NULLABLE PFUserResultBlock)block;

- (void)signUpWithUsernameInBackground:(nonnull NSString *)username password:(nonnull NSString *) password email:(nonnull NSString *)email fullName:(nonnull NSString *)fullName block:(PF_NULLABLE PFBooleanResultBlock)block;

@end
