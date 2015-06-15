//
//  MIMuralViewController.m
//  Midas
//
//  Created by Rafael Gouveia on 6/9/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "MIMuralViewController.h"
#import "MIPedidoDetalhadoViewController.h"
#import "MIDatabase.h"
#import "ProgressHUD.h"
#import "MIPedido.h"
#import "RNGridMenu.h"
#import "MIFiltrosDeBusca.h"

@interface MIMuralViewController () <RNGridMenuDelegate>

@property NSMutableArray *requests;
@property MIPedido* selectedRequest;
@property MIFiltrosDeBusca* filtros;

@end

@implementation MIMuralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.muralTableView.delegate = self;
    self.muralTableView.dataSource = self;
    // Do any additional setup after loading the view.
    self.requests = [[NSMutableArray alloc] init];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    
    [self.muralTableView addSubview:self.refreshControl];
    
    self.filtros = [[MIFiltrosDeBusca alloc]init];
}

-(void) viewWillAppear:(BOOL)animated {
    [self.refreshControl beginRefreshing];
    [self loadRequests];
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
    
    MIPedido *request = [_requests objectAtIndex:indexPath.row];
    
    cell.textLabel.text = request.title;
    cell.detailTextLabel.text = request.owner.username;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_requests count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRequest = _requests[indexPath.row];
    [self performSegueWithIdentifier:@"PedidoInfoSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"PedidoInfoSegue"])
    {
        // Get reference to the destination view controller
        MIPedidoDetalhadoViewController *vc = [segue destinationViewController];
        vc.currentRequest = _selectedRequest;
    }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)loadRequests
{
    
    [[MIDatabase sharedInstance] getOpenRequestsFromOtherUsersWithBlock:self.filtros Block:^(NSArray *objects, NSError *error)
     {
         if (error == nil)
         {
             [_requests removeAllObjects];
             NSArray *pedidos = [MIPedido pedidosArrayFromPFObjectArray:objects];
             [_requests addObjectsFromArray:pedidos];
             [self.muralTableView reloadData];
             
         }
         else [ProgressHUD showError:@"Network error."];
         [self.refreshControl endRefreshing];
     }/* filtro:self.filtros*/];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self loadRequests];
}

#pragma mark - RNGridDelegate
//-------------------------------------------------------------------------------------------------------------------------------------------------

- (IBAction)didPressSearchButton:(id)sender {
    [self.view endEditing:YES];
    NSArray *menuItems = @[[[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"GPSIcon"] title:@"Todos"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"VidroIcon"] title:@"Vidro"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"PlasticoIcon"] title:@"Plástico"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"MetalIcon"] title:@"Metal"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"PapelIcon"] title:@"Papel"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"OutrosIcon"] title:@"Outros"]];
    RNGridMenu *gridMenu = [[RNGridMenu alloc] initWithItems:menuItems];
    gridMenu.delegate = self;
    gridMenu.highlightColor = [UIColor darkGrayColor];
    gridMenu.menuStyle = RNGridMenuStyleGrid;
    [gridMenu showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/(2.f))];
}



- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex
{
    
    self.filtros.Vidro = false;
    self.filtros.Metal = false;
    self.filtros.Papel = false;
    self.filtros.Outros = false;
    self.filtros.Plastico = false;
    
    self.filtros.Todos = true;
    
    
    [gridMenu dismissAnimated:NO];
    if ([item.title isEqualToString:@"Todos"])
    {
        self.filtros.Todos = true;
        NSLog(@"Todos");
    }
    if ([item.title isEqualToString:@"Vidro"])
    {
        self.filtros.Vidro = true;
        self.filtros.Todos = false;
        NSLog(@"Vidro");
    }
    if ([item.title isEqualToString:@"Plástico"])
    {
        self.filtros.Plastico = true;
        self.filtros.Todos = false;
        NSLog(@"Plástico");
    }
    if ([item.title isEqualToString:@"Metal"])
    {
        self.filtros.Metal = true;
        self.filtros.Todos = false;
        NSLog(@"Metal");
    }
    if ([item.title isEqualToString:@"Papel"])
    {
        self.filtros.Papel = true;
        self.filtros.Todos = false;
        NSLog(@"Papel");
    }
    if ([item.title isEqualToString:@"Outros"])
    {
        self.filtros.Outros = true;
        self.filtros.Todos = false;
        NSLog(@"Outros");
    }
    
    [self loadRequests];
}

@end
