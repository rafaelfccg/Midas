//
//  MIFinalizarPedidoViewController.m
//  Midas
//
//  Created by Rafael Gouveia on 6/9/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "MIFinalizarPedidoViewController.h"
#import "MIDatabase.h"
#import "ProgressHUD.h"
@interface MIFinalizarPedidoViewController ()

@end

@implementation MIFinalizarPedidoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    NSLog(@"A cada %@, dou %@.", _currentRequest.forEach, _currentRequest.willGive);
}

-(IBAction)finalizarPedido:(id)sender {
    
    [[MIDatabase sharedInstance] finalizeRequestWithPFObject:self.currentRequest.object
     block:^(BOOL succeeded, NSError *error) {
         
         if(succeeded) {
             [ProgressHUD showSuccess:[NSString stringWithFormat:@"Pedido finalizado com sucesso!"]];
             [self.navigationController popToRootViewControllerAnimated:YES];
         } else{
             [ProgressHUD showError:error.userInfo[@"error"]];
         }
    }];
}

@end
