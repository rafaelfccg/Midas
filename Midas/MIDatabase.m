//
//  MIDatabase.m
//  Midas
//
//  Created by Marcel de Siqueira Campos Rebouças on 6/10/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "MIDatabase.h"
#import "MIPedido.h"
#import "MINovoPedido.h"


@implementation MIDatabase


+(MIDatabase *)sharedInstance
{
    static MIDatabase *sharedInstance = nil;
    static dispatch_once_t pred;
    
    if (sharedInstance) return sharedInstance;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[MIDatabase alloc] init];
        sharedInstance.imageCache = [[NSCache alloc] init];
        [sharedInstance.imageCache setCountLimit:50];
    });
    
    return sharedInstance;
}

#pragma mark - Registering and Authentication

-(void)logInWithUsernameInBackground:(NSString *)username password:(NSString *)password block:(PF_NULLABLE PFUserResultBlock)block {
    
    [PFUser logInWithUsernameInBackground:username password:password block:block];
}

- (void)signUpWithUsernameInBackground:(nonnull NSString *)username password:(nonnull NSString *) password email:(nonnull NSString *)email ProfileImage:(PF_NULLABLE PFFile*)file block:(PF_NULLABLE PFBooleanResultBlock)block{
    //implementar
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    user.email = email;
    if(file!=nil)
    user[PF_USER_IMAGE] = file;
    user[PF_USER_ADDRESS] = @"";
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
    [query whereKey:PF_REQUEST_STATUS equalTo:ENUM_REQUEST_STATUS_OPEN];
    [query includeKey:PF_REQUEST_USER];
    [query orderByDescending:PF_REQUEST_UPDATEDACTION];
    [query findObjectsInBackgroundWithBlock:block];

}

- (void) getRequestsWithFilters:(NSString *) filters block:(PF_NULLABLE_S PFArrayResultBlock)block {

}

- (void) getOpenRequestsFromOtherUsersWithBlock:(nullable MIFiltrosDeBusca*)filtro andSkip:(NSInteger)skip Block:(PF_NULLABLE_S PFArrayResultBlock)block{
    
    
    PFQuery *MetalQuery = [PFQuery queryWithClassName:PF_REQUEST_CLASS_NAME];
    PFQuery *PlasticoQuery = [PFQuery queryWithClassName:PF_REQUEST_CLASS_NAME];
    PFQuery *PapelQuery = [PFQuery queryWithClassName:PF_REQUEST_CLASS_NAME];
    PFQuery *VidroQuery = [PFQuery queryWithClassName:PF_REQUEST_CLASS_NAME];
    PFQuery *OutrosQuery = [PFQuery queryWithClassName:PF_REQUEST_CLASS_NAME];
    //PFUser* current = [PFUser currentUser];
    
    
    [MetalQuery whereKey:PF_REQUEST_CATEGORY equalTo:@-1];
    [VidroQuery whereKey:PF_REQUEST_CATEGORY equalTo:@-1];
    [PapelQuery whereKey:PF_REQUEST_CATEGORY equalTo:@-1];
    [PlasticoQuery whereKey:PF_REQUEST_CATEGORY equalTo:@-1];
    [OutrosQuery whereKey:PF_REQUEST_CATEGORY equalTo:@-1];
    
    
    PFQuery *Allquery=nil;
    
    if(filtro.Metal || filtro.Todos)
    {
        // category 3
        //MetalQuery = [PFQuery queryWithClassName:PF_REQUEST_CLASS_NAME];
        [MetalQuery whereKey:PF_REQUEST_STATUS equalTo:ENUM_REQUEST_STATUS_OPEN];
        [MetalQuery whereKey:PF_REQUEST_USER notEqualTo:[PFUser currentUser]];
        [MetalQuery whereKey:PF_REQUEST_CATEGORY equalTo:ENUM_REQUEST_CATEGORY_METAL];
    }
    
    if(filtro.Vidro || filtro.Todos)
    {
        // category 0
        //VidroQuery = [PFQuery queryWithClassName:PF_REQUEST_CLASS_NAME];
        [VidroQuery whereKey:PF_REQUEST_STATUS equalTo:ENUM_REQUEST_STATUS_OPEN];
        [VidroQuery whereKey:PF_REQUEST_USER notEqualTo:[PFUser currentUser]];
        [VidroQuery whereKey:PF_REQUEST_CATEGORY equalTo:ENUM_REQUEST_CATEGORY_VIDRO];
    }
    
    if(filtro.Papel || filtro.Todos)
    {
        // category 2
        //PapelQuery = [PFQuery queryWithClassName:PF_REQUEST_CLASS_NAME];
        [PapelQuery whereKey:PF_REQUEST_STATUS equalTo:ENUM_REQUEST_STATUS_OPEN];
        [PapelQuery whereKey:PF_REQUEST_USER notEqualTo:[PFUser currentUser]];
        [PapelQuery whereKey:PF_REQUEST_CATEGORY equalTo:ENUM_REQUEST_CATEGORY_PAPEL];
    }
    
    if(filtro.Plastico || filtro.Todos)
    {
        // category 1
        //PlasticoQuery = [PFQuery queryWithClassName:PF_REQUEST_CLASS_NAME];
        [PlasticoQuery whereKey:PF_REQUEST_STATUS equalTo:ENUM_REQUEST_STATUS_OPEN];
        [PlasticoQuery whereKey:PF_REQUEST_USER notEqualTo:[PFUser currentUser]];
        [PlasticoQuery whereKey:PF_REQUEST_CATEGORY equalTo:ENUM_REQUEST_CATEGORY_PLASTICO];
    }
    
    if(filtro.Outros || filtro.Todos)
    {
        // category 4
        //OutrosQuery = [PFQuery queryWithClassName:PF_REQUEST_CLASS_NAME];
        [OutrosQuery whereKey:PF_REQUEST_STATUS equalTo:ENUM_REQUEST_STATUS_OPEN];
        [OutrosQuery whereKey:PF_REQUEST_USER notEqualTo:[PFUser currentUser]];
        [OutrosQuery whereKey:PF_REQUEST_CATEGORY equalTo:ENUM_REQUEST_CATEGORY_OUTROS];
    }
    
    Allquery = [PFQuery orQueryWithSubqueries:@[MetalQuery,PlasticoQuery,PapelQuery,VidroQuery,OutrosQuery]];
    //PFGeoPoint * point = current[PF_USER_LOCATION];
    //NSLog(@"%lf %lf",point.latitude,point.longitude);
    
//    PFQuery *orderDistance = [PFQuery queryWithClassName:PF_REQUEST_CLASS_NAME];
//    [orderDistance whereKey:@"objectId" matchesKey:@"objectId" inQuery:Allquery];
//    if(point){
//        [orderDistance whereKey:PF_REQUEST_USERLOCATION nearGeoPoint:point];
//    }
//    [orderDistance includeKey:PF_REQUEST_USER];
//    //
    [Allquery includeKey:PF_REQUEST_USER];
    [Allquery setLimit:100];
    [Allquery setSkip:skip];
    [Allquery orderByDescending:PF_REQUEST_UPDATEDACTION];
    [Allquery findObjectsInBackgroundWithBlock:block];
}

- (void) getCurrentUserRequestsWithBlock:(PF_NULLABLE_S PFArrayResultBlock)block {
    PFQuery *query = [PFQuery queryWithClassName:PF_REQUEST_CLASS_NAME];
    [query whereKey:PF_REQUEST_STATUS equalTo:ENUM_REQUEST_STATUS_OPEN];
    [query whereKey:PF_REQUEST_USER equalTo:[PFUser currentUser]];
    [query includeKey:PF_REQUEST_USER];
    [query orderByDescending:PF_REQUEST_UPDATEDACTION];
    [query findObjectsInBackgroundWithBlock:block];
    
}

-(void) getChatOwnerToGiverFromRequest:(MIPedido *)pedido withBlock:(PF_NULLABLE_S PFArrayResultBlock)block{
    PFObject* pfo = pedido.object;
    PFUser* owner = pedido.owner;
    PFQuery* query = [PFQuery queryWithClassName:PF_CHAT_CLASS_NAME ];
    [query whereKey:PF_CHAT_REQUESTOWNER equalTo:owner];
    [query whereKey:PF_CHAT_REQUESTGIVER equalTo:[PFUser currentUser]];
    [query whereKey:PF_CHAT_REQUESTID equalTo:pfo.objectId];
    [query includeKey:PF_CHAT_REQUESTOWNER];
    [query includeKey:PF_CHAT_REQUESTGIVER];
    [query findObjectsInBackgroundWithBlock:block];
}

- (void)getRecentNegotioationsWithBlock:(PF_NULLABLE_S PFArrayResultBlock)block{
    PFQuery *queryOwns = [PFQuery queryWithClassName:PF_RECENT_CLASS_NAME];
    PFQuery *queryGiver = [PFQuery queryWithClassName:PF_RECENT_CLASS_NAME];
    [queryOwns whereKey:PF_RECENT_REQUESTOWNER equalTo:[PFUser currentUser]];
    [queryGiver whereKey:PF_RECENT_REQUESTGIVER equalTo:[PFUser currentUser]];
    
    PFQuery* openRequests = [PFQuery queryWithClassName:PF_REQUEST_CLASS_NAME];
    [openRequests whereKey:PF_REQUEST_STATUS equalTo:ENUM_REQUEST_STATUS_OPEN];
    
    
    PFQuery * orQuery = [PFQuery orQueryWithSubqueries:@[queryOwns,queryGiver]];
    [orQuery whereKey:PF_RECENT_REQUESTID matchesKey:PF_REQUEST_OBJECTID inQuery:openRequests];
    [orQuery whereKey:PF_RECENT_LASTMESSAGE notEqualTo:@""];
    
    [orQuery includeKey:PF_RECENT_REQUESTOWNER];
    [orQuery includeKey:PF_RECENT_REQUESTGIVER];
    [orQuery orderByDescending:PF_RECENT_UPDATEDACTION];
    [orQuery findObjectsInBackgroundWithBlock:block];
  
}

- (void) finalizeRequestWithPFObject:(nonnull PFObject *)pfobject block:(nullable PFBooleanResultBlock)block
{
    pfobject[PF_REQUEST_STATUS] = ENUM_REQUEST_STATUS_FINALIZED;
    [pfobject saveInBackgroundWithBlock:block];
}

#pragma mark - Save
- (void) createNewPedidoInBackGround:(nonnull MINovoPedido*)pedido block:(nullable PFBooleanResultBlock)block
{
    PFObject *request = [PFObject objectWithClassName:PF_REQUEST_CLASS_NAME];
    
    request[PF_REQUEST_USER] = [PFUser currentUser];
    request[PF_REQUEST_DESCRIPTION] = pedido.descricao;
    request[PF_REQUEST_FOREACHVALUE] = pedido.foreachValue;
    request[PF_REQUEST_FOREACH] = pedido.foreach;
    request[PF_REQUEST_WILLGIVEVALUE] = pedido.willgiveValue;
    request[PF_REQUEST_WILLGIVE] = pedido.willgive;
    request[PF_REQUEST_CATEGORY] = pedido.category;
    request[PF_REQUEST_STATUS] = ENUM_REQUEST_STATUS_OPEN;
    
    if(pedido.location != nil)
    request[PF_REQUEST_USERLOCATION] = pedido.location;
    
    if(pedido.image) {
        request[PF_REQUEST_IMAGE] = [PFFile fileWithData:UIImagePNGRepresentation(pedido.image)];
        request[PF_REQUEST_THUMBNAIL] = [PFFile fileWithData:UIImagePNGRepresentation(pedido.thumbnail)];
    }
    
    [request saveInBackgroundWithBlock:block];
}

- (void) editPedidoInBackGround:(nonnull MINovoPedido*)pedido block:(nullable PFBooleanResultBlock)block
{
    PFObject *request = pedido.editRequest.object;
    
    request[PF_REQUEST_USER] = [PFUser currentUser];
    request[PF_REQUEST_DESCRIPTION] = pedido.descricao;
    request[PF_REQUEST_FOREACHVALUE] = pedido.foreachValue;
    request[PF_REQUEST_FOREACH] = pedido.foreach;
    request[PF_REQUEST_WILLGIVEVALUE] = pedido.willgiveValue;
    request[PF_REQUEST_WILLGIVE] = pedido.willgive;
    request[PF_REQUEST_CATEGORY] = pedido.category;
    
    if(pedido.location != nil)
    request[PF_REQUEST_USERLOCATION] = pedido.location;
    
    if(pedido.image) {
        request[PF_REQUEST_IMAGE] = [PFFile fileWithData:UIImagePNGRepresentation(pedido.image)];
        request[PF_REQUEST_THUMBNAIL] = [PFFile fileWithData:UIImagePNGRepresentation(pedido.thumbnail)];
    }
    
    [request saveInBackgroundWithBlock:block];
}

- (void) loadPFFile:(nonnull PFFile *)file WithBlock:(nullable PFImageViewImageResultBlock)completion
{
    
    if ([_imageCache objectForKey:file]){
    
        UIImage *cachedImage = [_imageCache objectForKey:file];
        completion(cachedImage, nil);
        //NSLog(@"Pegou image do cache.");
        
    } else{
        
        PFImageView * pfImageView = [[PFImageView alloc] init];
        pfImageView.file = file;
        
        [file getDataInBackgroundWithBlock:^(NSData* das, NSError* err){
            
            if(!das){
                //NSLog(@"%@", err);
            }
            
            UIImage* image =  [[UIImage alloc]initWithData:das];
            if(image){
                [_imageCache setObject:image forKey:file];
            }
            completion(image, err);
        }];
        //        [pfImageView loadInBackground:^(UIImage *PFUI_NULLABLE_S image,  NSError *PFUI_NULLABLE_S error){
        //
        //            if(image){
        //                [_imageCache setObject:image forKey:file];
        //            }
        //            completion(image, error);
        //            
        //        }];
        
    }
    //NSLog(@"aqui");
}

-(void) getChatWithObjectId:(NSString *)chatId withBlock:(PF_NULLABLE_S PFArrayResultBlock)block{
  
    PFQuery* query = [PFQuery queryWithClassName:PF_CHAT_CLASS_NAME ];
    [query whereKey:PF_CHAT_OBJECTID equalTo:chatId];
    [query includeKey:PF_CHAT_REQUESTOWNER];
    [query includeKey:PF_CHAT_REQUESTGIVER];
    [query findObjectsInBackgroundWithBlock:block];
}

-(void) getRequestWithObjectId:(NSString *)requestId withBlock:(PF_NULLABLE_S PFArrayResultBlock)block{
    
    PFQuery* query = [PFQuery queryWithClassName:PF_REQUEST_CLASS_NAME ];
    [query whereKey:PF_REQUEST_OBJECTID equalTo:requestId];
    [query includeKey:PF_REQUEST_USER];
    [query findObjectsInBackgroundWithBlock:block];
    
}

- (void) markContentAsInappropriateFromRequest:(nonnull MIPedido *)pedido withBlock:(nullable PFBooleanResultBlock)block {
    
    
    PFObject *request = [PFObject objectWithClassName:PF_INAPPROPRIATE_CONTENT_CLASS_NAME];
    
    request[PF_INAPPROPRIATE_CONTENT_USER_WHO_FLAGGED_CONTENT] = [PFUser currentUser];
    request[PF_INAPPROPRIATE_CONTENT_REQUEST] = pedido.object;
    request[PF_INAPPROPRIATE_CONTENT_STATUS] = ENUM_INAPPROPRIATE_CONTENT_STATUS_OPEN;

    [request saveInBackgroundWithBlock:block];
}

- (void) checkIfContentIsFlaggedAsInappropriateFromRequest:(nonnull MIPedido *)pedido withBlock:(nullable PFArrayResultBlock)block {
    
    PFQuery *query = [PFQuery queryWithClassName:PF_INAPPROPRIATE_CONTENT_CLASS_NAME];
    [query whereKey:PF_INAPPROPRIATE_CONTENT_REQUEST equalTo:pedido.object];
    [query whereKey:PF_INAPPROPRIATE_CONTENT_USER_WHO_FLAGGED_CONTENT equalTo:[PFUser currentUser]];
    [query whereKey:PF_INAPPROPRIATE_CONTENT_STATUS equalTo:ENUM_INAPPROPRIATE_CONTENT_STATUS_OPEN];
    
    [query findObjectsInBackgroundWithBlock:block];
}

- (void) markContentAsInappropriateFromMessage:(nonnull PFUser *)owner withBlock:(nullable PFBooleanResultBlock)block {
    PFObject *request = [PFObject objectWithClassName:PF_INAPPROPRIATE_USER_CLASS_NAME];
    
    request[PF_INAPPROPRIATE_USER_WHO_FLAGGED_CONTENT] = [PFUser currentUser];
    request[PF_INAPPROPRIATE_USER_WHO_RECIVE_CONTENT] = owner;
    request[PF_INAPPROPRIATE_USER_STATUS] = ENUM_INAPPROPRIATE_USER_STATUS_OPEN;
    
    [request saveInBackgroundWithBlock:block];
}

- (void) checkIfContentIsFlaggedAsInappropriateFromMessage:(nonnull PFUser *)owner withBlock:(nullable PFArrayResultBlock)block {

    if(owner == [PFUser currentUser]){
        NSLog(@"aqui");
    }
    
    PFQuery *query = [PFQuery queryWithClassName:PF_INAPPROPRIATE_USER_CLASS_NAME];
    [query whereKey:PF_INAPPROPRIATE_USER_WHO_RECIVE_CONTENT equalTo:owner];
    [query whereKey:PF_INAPPROPRIATE_USER_WHO_FLAGGED_CONTENT equalTo:[PFUser currentUser]];
    [query whereKey:PF_INAPPROPRIATE_USER_STATUS equalTo:ENUM_INAPPROPRIATE_USER_STATUS_OPEN];
    
    [query findObjectsInBackgroundWithBlock:block];
}

- (void) checkIfUserAreReported:(nonnull PFUser *)owner withBlock:(nullable PFArrayResultBlock)block {
    PFQuery *query = [PFQuery queryWithClassName:PF_REPORTED_USER];
    [query whereKey:PF_USER1 equalTo:owner];
    [query whereKey:PF_USER2 equalTo:[PFUser currentUser]];
    
    [query findObjectsInBackgroundWithBlock:block];
}

- (void) reportAUser:(nonnull PFUser *)owner withBlock:(nullable PFBooleanResultBlock)block {
    PFObject *request = [PFObject objectWithClassName:PF_REPORTED_USER];
    
    request[PF_USER1] = [PFUser currentUser];
    request[PF_USER2] = owner;
    
    [request saveInBackgroundWithBlock:block];
}

- (void) loadChatInBackGroundWithBlock:(nonnull NSString*)chatID withBlock:(nullable PFArrayResultBlock)block{
    PFQuery *query = [PFQuery queryWithClassName:PF_CHAT_CLASS_NAME];
    
    [query whereKey:PF_CHAT_OBJECTID equalTo:chatID];
    
    [query findObjectsInBackgroundWithBlock:block];
}




@end
