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

@property (nonnull) NSCache *imageCache;

+(nonnull MIDatabase *)sharedInstance;

//authentication

- (void)logInWithUsernameInBackground:(nonnull NSString *)username password:(nonnull NSString *)password block:(PF_NULLABLE PFUserResultBlock)block;

- (void)signUpWithUsernameInBackground:(nonnull NSString *)username password:(nonnull NSString *) password email:(nonnull NSString *)email ProfileImage:(PF_NULLABLE PFFile*)file block:(PF_NULLABLE PFBooleanResultBlock)block;

//requests

- (void) getAllRequestsWithBlock:(PF_NULLABLE_S PFArrayResultBlock)block;

- (void) getOpenRequestsWithBlock:(PF_NULLABLE_S PFArrayResultBlock)block;

- (void) getRequestsWithFilters:(nonnull NSString *) filters block:(PF_NULLABLE_S PFArrayResultBlock)block;

- (void) getOpenRequestsFromOtherUsersWithBlock:(nullable MIFiltrosDeBusca*)filtro andSkip:(NSInteger)skip Block:(PF_NULLABLE_S PFArrayResultBlock)block;

- (void) getCurrentUserRequestsWithBlock:(PF_NULLABLE_S PFArrayResultBlock)block;

- (void) getChatOwnerToGiverFromRequest:(nonnull MIPedido *)pedido withBlock:(PF_NULLABLE_S PFArrayResultBlock)block;

- (void) finalizeRequestWithPFObject:(nonnull PFObject *)pfobject block:(nullable PFBooleanResultBlock)block;

- (void) createNewPedidoInBackGround:(nonnull MINovoPedido*)pedido block:(nullable PFBooleanResultBlock)block;

- (void) editPedidoInBackGround:(nonnull MINovoPedido*)pedido block:(nullable PFBooleanResultBlock)block;

- (void) getRecentNegotioationsWithBlock:(PF_NULLABLE_S PFArrayResultBlock)block;

- (void) loadPFFile:(nonnull PFFile *)file WithBlock:(nullable PFImageViewImageResultBlock)completion;

- (void) getChatWithObjectId:(nonnull NSString *)chatId withBlock:(PF_NULLABLE_S PFArrayResultBlock)block;

- (void) getRequestWithObjectId:(nonnull NSString *)requestId withBlock:(PF_NULLABLE_S PFArrayResultBlock)block;

- (void) markContentAsInappropriateFromRequest:(nonnull MIPedido *)pedido withBlock:(nullable PFBooleanResultBlock)block;

- (void) checkIfContentIsFlaggedAsInappropriateFromRequest:(nonnull MIPedido *)pedido withBlock:(nullable PFArrayResultBlock)block;

- (void) markContentAsInappropriateFromMessage:(nonnull PFUser *)owner withBlock:(nullable PFBooleanResultBlock)block;

- (void) checkIfContentIsFlaggedAsInappropriateFromMessage:(nonnull PFUser *)owner withBlock:(nullable PFArrayResultBlock)block;

- (void) checkIfUserAreReported:(nonnull PFUser *)owner withBlock:(nullable PFArrayResultBlock)block;

- (void) reportAUser:(nonnull PFUser *)owner withBlock:(nullable PFBooleanResultBlock)block;

- (void) loadChatInBackGroundWithBlock:(nonnull NSString*)chatID withBlock:(nullable PFArrayResultBlock)block;
                             
@end
