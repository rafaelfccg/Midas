//
//  MINovoPedidoViewController.m
//  Midas
//
//  Created by Rafael Gouveia on 6/9/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "MINovoPedidoViewController.h"
#import "ProgressHUD.h"
#import "MIDatabase.h"



@interface MINovoPedidoViewController ()

@end


@implementation MINovoPedidoViewController

@synthesize titleTextField;
@synthesize descriptionTextField;
@synthesize rewardTextField;
@synthesize quantityTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *concluirButton = [[UIBarButtonItem alloc]
                                      initWithTitle:@"Concluir"
                                      style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(criarNovoPedido:)];
    self.navigationItem.rightBarButtonItem = concluirButton;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissKeyboard
//-------------------------------------------------------------------------------------------------------------------------------------------------
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




- (void) criarNovoPedido:(id)sender {
    //do here
    
    NSString *title;
    NSString *description;
    NSString *reward;
    NSNumber *quantity;

    
    title = titleTextField.text;
    description = descriptionTextField.text;
    reward = rewardTextField.text;
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    quantity = [f numberFromString:quantityTextField.text];
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    if ([title length] < 3)	{ [ProgressHUD showError:@"title is too short."]; return; }
    if ([title length] > 30)	{ [ProgressHUD showError:@"title is too long(>30)."]; return; }
    if ([description length] < 10)	{ [ProgressHUD showError:@"description is too short."]; return; }
    if ([description length] > 140)	{ [ProgressHUD showError:@"description is too long(>140)."]; return; }
    if ([quantity intValue]<=0 || [quantity intValue]>10000) { [ProgressHUD showError:@"must be over 0 or below of 1000."]; return; }
    //---------------------------------------------------------------------------------------------------------------------------------------------
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    
    
    [[MIDatabase sharedInstance]createNewPedidoInBackGrond:title description:description reward:reward quantity:quantity status:@0 block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
            [ProgressHUD showSuccess:@"Succeed."];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [ProgressHUD showError:error.userInfo[@"error"]];
            // There was a problem, check error.description
        }
    }];
    
//    PFObject *request = [PFObject objectWithClassName:PF_REQUEST_CLASS_NAME];
//    
//    request[PF_REQUEST_USER] = [PFUser currentUser];
//    //request[PF_REQUEST_CREATEDAT] = [NSDate date];
//    
//    request[PF_REQUEST_TITLE] = title;
//    request[PF_REQUEST_DESCRIPTION] = description;
//    request[PF_REQUEST_REWARD] = reward;
//    request[PF_REQUEST_QUANTITY] = quantity;
//    request[PF_REQUEST_STATUS] = @0;
//
//    [request saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            // The object has been saved.
//            [ProgressHUD showSuccess:@"Succeed."];
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        } else {
//            [ProgressHUD showError:error.userInfo[@"error"]];
//            // There was a problem, check error.description
//        }
//    }];
    
    
    
}


@end
