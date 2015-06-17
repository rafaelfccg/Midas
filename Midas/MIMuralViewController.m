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
@property (nonatomic, strong) NSArray *doadorArray;

@property (nonatomic, strong) NSArray *pedidoArray;
@property (nonatomic, strong) NSArray *destArray;

@property (nonatomic, strong) NSArray *distArray;


@end

@implementation MIMuralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.muralTableView.delegate = self;
    self.muralTableView.dataSource = self;
    
    self.imageArray = @[@"garrafas.jpg", @"metal.jpg", @"pet.jpg"];
    self.tipoArray = @[@"VidroIcon", @"MetalIcon", @"PlasticoIcon"];
    self.usuarioArray = @[@"zecaa.jpg", @"xuxa.jpg", @"gaga.jpg"];
    
    self.pedidoArray = @[@"Preciso de 20 garrafas de vidro", @"Preciso de 40 latinhas de metal", @"Preciso de 3kg de pet"];
    self.destArray = @[@"Em troca: Tomo umas contigo", @"Em troca: Canto Ilariê", @"Em troca: Danço Poker Face"];
    self.distArray = @[@"5km", @"25km", @"45m"];
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
    
    return [self.tipoArray count];
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
    cell.tipoImage.layer.borderWidth = 2.0f;
    cell.tipoImage.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.tipoImage.layer.cornerRadius = 20.0f;
    
    NSString *usuarioString = [self.usuarioArray objectAtIndex:indexPath.row];
    cell.usuarioImage.image = [UIImage imageNamed:usuarioString];
    cell.usuarioImage.layer.cornerRadius = cell.usuarioImage.frame.size.width / 2;
    cell.usuarioImage.clipsToBounds = YES;
    cell.usuarioImage.layer.borderWidth = 2.0f;
    cell.usuarioImage.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.usuarioImage.layer.cornerRadius = 20.0f;

    
    
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
