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
@property (weak, nonatomic) IBOutlet UIButton *alteraEndereco;

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
    [self.alteraEndereco.layer setCornerRadius:7.0f];
    [self.alteraEndereco.layer setMasksToBounds:YES];

    
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
    
    if ([cidade length] < 1)	{ [ProgressHUD showError:NSLocalizedString(@"Cidade é um campo obrigatório.", @"Cidade - Campo obrigatório Message")]; return; }
    if ([bairro length] < 1)		{ [ProgressHUD showError:NSLocalizedString(@"Bairro é um campo obrigatório.", @"Bairro - Campo obrigatório Message")]; return; }
    if ([rua length] < 1)		{ [ProgressHUD showError:NSLocalizedString(@"Rua é um campo obrigatório.", @"Rua - Campo obrigatório Message")]; return; }
    
    NSString *alladdress = [rua stringByAppendingString:@", "];
    alladdress = [alladdress stringByAppendingString:bairro];
    alladdress = [alladdress stringByAppendingString:@" - "];
    alladdress = [alladdress stringByAppendingString:cidade];
    
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
            [ProgressHUD showError:NSLocalizedString(@"Endereço Inválido",@"Endereço Inválido Message")];
        }
    }];
}


- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}


@end
