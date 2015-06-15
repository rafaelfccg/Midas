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
#import "LocationUtils.h"

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
   
    [[self navigationController]popToRootViewControllerAnimated:YES];
}

- (void)actionRegister
{
    NSString *cidade = self.cidadeTextField.text;
    NSString *bairro = self.bairroTextField.text;
    NSString *rua = self.ruaTextField.text;
    NSNumber *numero = [NSNumber numberWithInt:[self.numeroTextField.text intValue]];
    
    if ([cidade length] < 4)	{ [ProgressHUD showError:@"City name is too short."]; return; }
    if ([cidade length] > 50)	{ [ProgressHUD showError:@"City name is too long(>30)."]; return; }
    if ([bairro length] < 4)		{ [ProgressHUD showError:@"Bairro is too short."]; return; }
    if ([bairro length] > 50)	{ [ProgressHUD showError:@"Bairro is too long(>20)."]; return; }
    if ([rua length] < 4)		{ [ProgressHUD showError:@"Bairro is too short."]; return; }
    if ([rua length] > 50)	{ [ProgressHUD showError:@"Bairro is too long(>20)."]; return; }
    
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
