//
//  TestAdressController.m
//  Midas
//
//  Created by Rafael Gouveia on 6/13/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "TestAdressController.h"
#import "LocationUtils.h"
@interface TestAdressController ()
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UIButton *search;
@property (weak, nonatomic) IBOutlet MKMapView *mapview;

@end

@implementation TestAdressController




- (IBAction)searchAddress:(id)sender {
    [LocationUtils getLocationFromAdress:_address.text withHandler:^(CLLocation* location){
        NSLog(@"%lf , %lf",location.coordinate.latitude,location.coordinate.longitude);
        
        dispatch_async(dispatch_get_main_queue(),^(void){;
            MKCoordinateRegion adjustedRegion = [_mapview regionThatFits:MKCoordinateRegionMakeWithDistance(location.coordinate, 200, 200)];
            [_mapview setRegion:adjustedRegion animated:YES];
            
            
        });
    }];
    
}

@end
