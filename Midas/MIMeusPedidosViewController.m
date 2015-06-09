//
//  MeusPedidosViewController.m
//  Midas
//
//  Created by Rafael Gouveia on 6/9/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "MIMeusPedidosViewController.h"
#import "MIChatViewController.h"
#import "MIMeuPedidoDetalhadoViewController.h"

@interface MIMeusPedidosViewController ()

@end

@implementation MIMeusPedidosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pedidosTableView.delegate = self;
    self.pedidosTableView.dataSource = self;
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


#pragma mark - Table View

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"muralCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = @"teste";
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pedidosSegmentedControl.selectedSegmentIndex == 0){
        [self performSegueWithIdentifier:@"FromPedidosToPedidoSegue" sender:self];
    }else if (self.pedidosSegmentedControl.selectedSegmentIndex == 1){
        [self performSegueWithIdentifier:@"FromMeusPedidosToChatSegue" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"FromPedidosToPedidoSegue"])
    {
        // Get reference to the destination view controller
        MIMeuPedidoDetalhadoViewController *vc = [segue destinationViewController];
        
    } else if ([[segue identifier] isEqualToString:@"FromMeusPedidosToChatSegue"]){
        MIChatViewController *vc = [segue destinationViewController];
    }
}

@end
