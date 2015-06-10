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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void) editarPedido:(id)sender {
    [self performSegueWithIdentifier:@"FromMeuPedidoToEditSegue" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"FromMeuPedidoToEditSegue"])
    {
        // Get reference to the destination view controller
        MIEditarPedidoViewController *vc = [segue destinationViewController];
        
    } else if ([[segue identifier] isEqualToString:@"FromMeuPedidoToFinalizarSegue"])
    {
        // Get reference to the destination view controller
        MIFinalizarPedidoViewController *vc = [segue destinationViewController];
        
    }
}

-(IBAction)finalizarPedido:(id)sender {
    [self performSegueWithIdentifier:@"FromMeuPedidoToFinalizarSegue" sender:self];
}

@end
