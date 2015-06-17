//
//  LocationUtils.h
//  Midas
//
//  Created by Rafael Gouveia on 6/13/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationUtils : NSObject

+(void)getLocationFromAdress:(NSString*)address Error:(bool*)shit withHandler:(void(^)(CLLocation *))completion;

@end
