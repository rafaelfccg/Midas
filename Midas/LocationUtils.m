//
//  LocationUtils.m
//  Midas
//
//  Created by Rafael Gouveia on 6/13/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "LocationUtils.h"

@implementation LocationUtils

+(void)getLocationFromAdress:(NSString*)address withHandler:(void(^)(CLLocation *))completion{
    CLGeocoder *_geocoder = [[CLGeocoder alloc] init];
    [_geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count > 0) {
            CLPlacemark *_placemark = [placemarks firstObject];
            completion(_placemark.location);
            //result = _location;// ... do whaterver you want to do with the location
        }
    }];
}


@end
