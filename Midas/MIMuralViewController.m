//
//  MIMuralViewController.m
//  Midas
//
//  Created by Rafael Gouveia on 6/9/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "MIMuralViewController.h"
#import "MIPedidoDetalhadoViewController.h"
#import "MIMuralCellControllerTableViewCell.h"

@interface MIMuralViewController ()

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *tipoArray;
@property (nonatomic, strong) NSArray *usuarioArray;
@property (nonatomic, strong) NSArray *distImageArray;

@property (nonatomic, strong) NSArray *pedidoArray;
@property (nonatomic, strong) NSArray *trocaArray;
@property (nonatomic, strong) NSArray *distArray;


@end

@implementation MIMuralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.muralTableView.delegate = self;
    self.muralTableView.dataSource = self;
    
    self.imageArray = @[@"garrafas.jpg", @"latas.jpg", @"pet.jpg"];
    self.tipoArray = @[@"garrafas.jpg", @"latas.jpg", @"pet.jpg"];
    self.usuarioArray = @[@"garrafas.jpg", @"latas.jpg", @"pet.jpg"];
    self.distImageArray = @[@"garrafas.jpg", @"latas.jpg", @"pet.jpg"];
    
    self.pedidoArray = @[@"Preciso de 20 garrafas de vinho", @"Preciso de 40 latinhas de metal", @"Peciso de 3kg de pet"];
    self.trocaArray = @[@"Dou 2 garrafas de bebida", @"Dou uma arte", @"Pagamento à combinar"];
    self.distArray = @[@"5km", @"25km", @"50m"];
    // Do any additional setup after loading the view.
    
    UINib *nib = [UINib nibWithNibName:@"MIMuralCellControllerTableViewCell" bundle:nil];
    [self.muralTableView registerNib:nib forCellReuseIdentifier:@"MuralCell"];
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

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.imageArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //NSString *identifier = @"muralCell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    //if (cell == nil) {
        
      //  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //}
    
        //cell.textLabel.text = @"teste";
    
    MIMuralCellControllerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MuralCell" forIndexPath:indexPath];
    
    NSString *imageString = [self.imageArray objectAtIndex:indexPath.row];
    cell.pedidoImage.image = [UIImage imageNamed:imageString];
    
    NSString *tipoString = [self.tipoArray objectAtIndex:indexPath.row];
    cell.tipoImage.image = [UIImage imageNamed:tipoString];
    
    NSString *usuarioString = [self.usuarioArray objectAtIndex:indexPath.row];
    cell.usuarioImage.image = [UIImage imageNamed:usuarioString];
    
    NSString *distImageString = [self.distImageArray objectAtIndex:indexPath.row];
    cell.distImage.image = [UIImage imageNamed:distImageString];
    
    
    
    NSString *pedidoString = [self.pedidoArray objectAtIndex:indexPath.row];
    cell.pedidoLabel.text = pedidoString;
    
    NSString *distString = [self.distArray objectAtIndex:indexPath.row];
    cell.distLabel.text = distString;
    
    NSString *trocaString = [self.trocaArray objectAtIndex:indexPath.row];
    cell.trocaLabel.text = trocaString;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"PedidoInfoSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"PedidoInfoSegue"])
    {
        // Get reference to the destination view controller
        MIPedidoDetalhadoViewController *vc = [segue destinationViewController];
    
    }
}
@end
