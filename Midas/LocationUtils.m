//
//  LocationUtils.m
//  Midas
//
//  Created by Rafael Gouveia on 6/13/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "LocationUtils.h"

@implementation LocationUtils

+(void)getLocationFromAdress:(NSString*)address Error:(bool*)shit withHandler:(void(^)(CLLocation *))completion{
    CLGeocoder *_geocoder = [[CLGeocoder alloc] init];
    [_geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"entrou");
        *shit = true;
        if (placemarks.count > 0) {
            *shit = false;
            CLPlacemark *_placemark = [placemarks firstObject];
            completion(_placemark.location);
            //result = _location;// ... do whaterver you want to do with the location
        }
    }];
}


@end
