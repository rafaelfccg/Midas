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

- (void)signUpWithUsernameInBackground:(NSString *)username password:(NSString *) password email:(NSString *)email fullName:(NSString *)fullName block:(PF_NULLABLE PFBooleanResultBlock)block{
    
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    user.email = email;
    user[PF_USER_FULLNAME] = fullName;
    [user signUpInBackgroundWithBlock:block];
}


#pragma mark - Requests


- (void) getAllRequestsWithBlock:(PF_NULLABLE_S PFArrayResultBlock)block {
    PFQuery *query = [PFQuery queryWithClassName:PF_REQUEST_CLASS_NAME];
    [query includeKey:PF_REQUEST_USER];
    [query orderByDescending:PF_REQUEST_UPDATEDACTION];
    [query findObjectsInBackgroundWithBlock:block];
}

- (void) getOpenRequestsWithBlock:(PF_NULLABLE_S PFArrayResultBlock)block {
    PFQuery *query = [PFQuery queryWithClassName:PF_REQUEST_CLASS_NAME];
    [query whereKey:PF_REQUEST_STATUS equalTo:@0];
    [query includeKey:PF_REQUEST_USER];
    [query orderByDescending:PF_REQUEST_UPDATEDACTION];
    [query findObjectsInBackgroundWithBlock:block];

}

- (void) getRequestsWithFilters:(NSString *) filters block:(PF_NULLABLE_S PFArrayResultBlock)block {

}

- (void) getOpenRequestsFromOtherUsersWithBlock:(PF_NULLABLE_S PFArrayResultBlock)block {
    PFQuery *query = [PFQuery queryWithClassName:PF_REQUEST_CLASS_NAME];
    [query whereKey:PF_REQUEST_STATUS equalTo:@0];
    [query whereKey:PF_REQUEST_USER notEqualTo:[PFUser currentUser]];
    [query includeKey:PF_REQUEST_USER];
    [query orderByDescending:PF_REQUEST_UPDATEDACTION];
    [query findObjectsInBackgroundWithBlock:block];
    
}

- (void) getCurrentUserRequestsWithBlock:(PF_NULLABLE_S PFArrayResultBlock)block {
    PFQuery *query = [PFQuery queryWithClassName:PF_REQUEST_CLASS_NAME];
    [query whereKey:PF_REQUEST_STATUS equalTo:@0];
    [query whereKey:PF_REQUEST_USER equalTo:[PFUser currentUser]];
    [query includeKey:PF_REQUEST_USER];
    [query orderByDescending:PF_REQUEST_UPDATEDACTION];
    [query findObjectsInBackgroundWithBlock:block];
    
}

- (void) finalizeRequestWithPFObject:(nonnull PFObject *)pfobject block:(nullable PFBooleanResultBlock)block
{
    pfobject[PF_REQUEST_STATUS] = @1;
    [pfobject saveInBackgroundWithBlock:block];
}

- (void) createNewPedidoInBackGrond:(NSString*)title description:(NSString*)description reward:(NSString*)reward quantity:(NSNumber*)quantity status:(NSNumber*)status block:(nullable PFBooleanResultBlock)block
{
    PFObject *request = [PFObject objectWithClassName:PF_REQUEST_CLASS_NAME];
    
    request[PF_REQUEST_USER] = [PFUser currentUser];
    //request[PF_REQUEST_CREATEDAT] = [NSDate date];
    
    request[PF_REQUEST_TITLE] = title;
    request[PF_REQUEST_DESCRIPTION] = description;
    request[PF_REQUEST_REWARD] = reward;
    request[PF_REQUEST_QUANTITY] = quantity;
    request[PF_REQUEST_STATUS] = @0;

    
    [request saveInBackgroundWithBlock:block];
}

@end
