//
//  MIMeuPedidoDetalhadoViewController.m
//  Midas
//
//  Created by Rafael Gouveia on 6/9/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "MIMeuPedidoDetalhadoViewController.h"
#import "MIEditarPedidoViewController.h"
#import "MIFinalizarPedidoViewController.h"

@interface MIMeuPedidoDetalhadoViewController ()

@end

@implementation MIMeuPedidoDetalhadoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *editarButton = [[UIBarButtonItem alloc]
                                      initWithTitle:@"Editar"
                                      style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(editarPedido:)];
    self.navigationItem.rightBarButtonItem = editarButton;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    NSLog(@"Meu Pedido detalhado: %@", self.currentRequest.title);
}

- (void) editarPedido:(id)sender {
    [self performSegueWithIdentifier:@"FromMeuPedidoToEditSegue" sender:self];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"FromMeuPedidoToEditSegue"])
    {
        // Get reference to the destination view controller
        MIEditarPedidoViewController *vc = [segue destinationViewController];
        vc.currentRequest = self.currentRequest;
        
    } else if ([[segue identifier] isEqualToString:@"FromMeuPedidoToFinalizarSegue"])
    {
        // Get reference to the destination view controller
        MIFinalizarPedidoViewController *vc = [segue destinationViewController];
        vc.currentRequest = self.currentRequest;
        
    }
}

-(IBAction)finalizarPedido:(id)sender {
    [self performSegueWithIdentifier:@"FromMeuPedidoToFinalizarSegue" sender:self];
}

@end
