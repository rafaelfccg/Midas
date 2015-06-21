//
//  MIEditarEnderecoViewController.m
//  Midas
//
//  Created by vinicius emanuel on 15/06/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "MIEditarEnderecoViewController.h"
#import "ProgressHUD.h"
#import "MIDatabase.h"
#import <Parse/Parse.h>

@interface MIEditarEnderecoViewController ()

@end


@implementation MIEditarEnderecoViewController

@synthesize cidadeTextField;
@synthesize ruaTextField;
@synthesize bairroTextField;
@synthesize numeroTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerUser:(id)sender {
    [self actionRegister];
}

- (void)actionRegister
{
    NSString *cidade = self.cidadeTextField.text;
    NSString *bairro = self.bairroTextField.text;
    NSString *rua = self.ruaTextField.text;
    
    if ([cidade length] < 4)	{ [ProgressHUD showError:@"City name is too short."]; return; }
    if ([bairro length] < 4)		{ [ProgressHUD showError:@"Bairro is too short."]; return; }
    if ([rua length] < 4)		{ [ProgressHUD showError:@"Bairro is too short."]; return; }
    
    NSString *alladdress = [cidade stringByAppendingString:@", "];
    alladdress = [alladdress stringByAppendingString:rua];
    
    [LocationUtils getLocationFromAdress:alladdress withHandler:^(CLLocation* location){
        
        NSLog(@"%lf , %lf",location.coordinate.latitude,location.coordinate.longitude);
        
        if(location!=nil)
        {
        
        PFGeoPoint *geoPoint = [[PFGeoPoint alloc]init];
        //[geoPoint setLatitude:location.coordinate.latitude];
        //[geoPoint setLongitude:location.coordinate.longitude];
        geoPoint = [PFGeoPoint geoPointWithLocation:location];
        
        PFUser *user = [PFUser currentUser];
        
        [user setObject:geoPoint forKey:PF_USER_LOCATION];
        [user setObject:alladdress forKey:PF_USER_ADDRESS];
        
        [user save];
        
        [[self navigationController]popToRootViewControllerAnimated:YES];
        }
        else
        {
            [ProgressHUD showError:@"endereço invalido"];
        }
    }];
}


- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
