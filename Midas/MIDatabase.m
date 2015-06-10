//
//  MIDatabase.m
//  Midas
//
//  Created by Marcel de Siqueira Campos Rebouças on 6/10/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "MIDatabase.h"

@implementation MIDatabase


+(MIDatabase *)sharedInstance
{
    static MIDatabase *sharedInstance = nil;
    static dispatch_once_t pred;
    
    if (sharedInstance) return sharedInstance;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[MIDatabase alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Registering and Authentication

-(void)logInWithUsernameInBackground:(NSString *)username password:(NSString *)password block:(PF_NULLABLE PFUserResultBlock)block {
    
    [PFUser logInWithUsernameInBackground:username password:password block:block];
}
@end
