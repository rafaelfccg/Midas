//
//  MIFinalizarPedidoViewController.m
//  Midas
//
//  Created by Rafael Gouveia on 6/9/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "MIFinalizarPedidoViewController.h"

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
    NSLog(@"Finalizar pedido: %@", self.currentRequest.title);
}

-(IBAction)finalizarPedido:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
