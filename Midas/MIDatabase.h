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
#import "MIPedido.h"
#import "MIFiltrosDeBusca.h"
#import "MINovoPedido.h"

@interface MIDatabase : NSObject

+(nonnull MIDatabase *)sharedInstance;

//authentication

- (void)logInWithUsernameInBackground:(nonnull NSString *)username password:(nonnull NSString *)password block:(PF_NULLABLE PFUserResultBlock)block;

- (void)signUpWithUsernameInBackground:(nonnull NSString *)username password:(nonnull NSString *) password email:(nonnull NSString *)email block:(PF_NULLABLE PFBooleanResultBlock)block;

//requests

- (void) getAllRequestsWithBlock:(PF_NULLABLE_S PFArrayResultBlock)block;

- (void) getOpenRequestsWithBlock:(PF_NULLABLE_S PFArrayResultBlock)block;

- (void) getRequestsWithFilters:(nonnull NSString *) filters block:(PF_NULLABLE_S PFArrayResultBlock)block;

- (void) getOpenRequestsFromOtherUsersWithBlock:(nullable MIFiltrosDeBusca*)filtro Block:(PF_NULLABLE_S PFArrayResultBlock)block;

- (void) getCurrentUserRequestsWithBlock:(PF_NULLABLE_S PFArrayResultBlock)block;

-(void) getChatOwnerToGiverFromRequest:(nonnull MIPedido *)pedido withBlock:(PF_NULLABLE_S PFArrayResultBlock)block;

- (void) finalizeRequestWithPFObject:(nonnull PFObject *)pfobject block:(nullable PFBooleanResultBlock)block;

- (void) createNewPedidoInBackGround:(nonnull MINovoPedido*)pedido block:(nullable PFBooleanResultBlock)block;

- (void) editPedidoInBackGround:(nonnull MINovoPedido*)pedido block:(nullable PFBooleanResultBlock)block;

- (void) getRecentNegotioationsWithBlock:(PF_NULLABLE_S PFArrayResultBlock)block;

@end
