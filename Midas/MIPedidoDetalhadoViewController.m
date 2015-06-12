//
//  MIPedidoDetalhadoViewController.m
//  Midas
//
//  Created by Rafael Gouveia on 6/9/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "MIPedidoDetalhadoViewController.h"
#import "MIChatViewController.h"

@interface MIPedidoDetalhadoViewController ()

@end

@implementation MIPedidoDetalhadoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *euTenhoButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Eu tenho!"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(iniciarNegociacao:)];
    self.navigationItem.rightBarButtonItem = euTenhoButton;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    NSLog(@"%@", self.currentRequest.title);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void) iniciarNegociacao:(id)sender {
    [self performSegueWithIdentifier:@"FromInfoToChatSegue" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"FromInfoToChatSegue"])
    {
        // Get reference to the destination view controller
        MIChatViewController *vc = [segue destinationViewController];
        
    }
}



@end
