//
//  MIPedido.h
//  Midas
//
//  Created by Rafael Gouveia on 6/9/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>


@interface MIPedido : NSObject

@property (readonly) PFObject *object;
@property (readonly) PFUser *owner;
@property (readonly) NSString *descricao;
@property (readonly) NSNumber *forEachValue;
@property (readonly) NSString *forEach;
@property (readonly) NSNumber *willGiveValue;
@property (readonly) NSString *willGive;
@property (readonly) NSNumber *status;
@property (readonly) NSNumber *category;
@property (readonly) PFGeoPoint* location;
@property (readonly) PFFile* imageFile;
@property (readonly) PFFile* thumbnailFile;
@property UIImage* image;

- (instancetype) initWithPFObject:(PFObject *)object;

+ (NSArray *) pedidosArrayFromPFObjectArray:(NSArray *)array;
@end
