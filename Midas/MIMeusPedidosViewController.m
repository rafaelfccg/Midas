//
//  MeusPedidosViewController.m
//  Midas
//
//  Created by Rafael Gouveia on 6/9/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "MIMeusPedidosViewController.h"
#import "MIChatViewController.h"
#import "MIPedidoDetalhadoViewController.h"
#import "MINovoPedidoCategoriaViewController.h"
#import "MIDatabase.h"
#import "MIPedido.h"
#import "MINegociation.h"
#import "ProgressHUD.h"
#import "MIMeusPedidosTableViewCell.h"

@interface MIMeusPedidosViewController ()

@property NSMutableArray *requests;
@property NSMutableArray *recents;
@property MIPedido* selectedRequest;
@property MINegociation * selectedChat;



@end

@implementation MIMeusPedidosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pedidosTableView.delegate = self;
    self.pedidosTableView.dataSource = self;
    
    self.requests = [[NSMutableArray alloc] init];
    self.recents = [[NSMutableArray alloc] init];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.pedidosTableView addSubview:self.refreshControl];
    
    UINib *nib = [UINib nibWithNibName:@"MIMeusPedidosTableViewCell" bundle:nil];
    [self.pedidosTableView registerNib:nib forCellReuseIdentifier:@"pedidosCell"];
    UINib *nibRecent = [UINib nibWithNibName:@"MIRecentCell" bundle:nil];
    [self.pedidosTableView registerNib:nibRecent forCellReuseIdentifier:@"recentCell"];
    [_pedidosTableView setSeparatorColor:COLOR_TABBAR];
    [_pedidosTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //[_pedidosTableView setSeparatorInset:UIEdgeInsetsMake(10, 0, 10, 0)];
    
    [self.pedidosSegmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents: UIControlEventValueChanged];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated {
    [self.refreshControl beginRefreshing];
    [self loadRequests];
}

#pragma mark - Table View

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"pedidoCell";
    MIMeusPedidosTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (self.pedidosSegmentedControl.selectedSegmentIndex == 0){
        
        MIMeusPedidosTableViewCell* cell;
        cell = [tableView dequeueReusableCellWithIdentifier:identifierRequest];
        if (cell == nil) {
            
            cell = [[MIMeusPedidosTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifierRequest];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        MIPedido *request = [_requests objectAtIndex:indexPath.row];
        
        //cell.textLabel.text = [NSString stringWithFormat:@"A cada %@ %@, dou %@ %@.", request.forEachValue, request.forEach,request.willGiveValue, request.willGive];
        //cell.detailTextLabel.text = request.owner.username;
        
        cell.meuPedidoLabel.text = [NSString stringWithFormat:@"%@ %@", request.forEachValue,request.forEach];
        cell.trocaLabel.text = [NSString stringWithFormat:@"%@ %@", request.willGiveValue, request.willGive];
        cell.categoriaIcon.image = [self getCategoryIcon:request.category];
        
        cell = [[MIMeusPedidosTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
        //[cell setLayoutMargins:UIEdgeInsetsMake(10, 0, 10, 0)];
        
        return cell;
    }else{
        MIRecentCell* cell;
        cell = [tableView dequeueReusableCellWithIdentifier:identifierRecent];
        if (cell == nil) {
            
            cell = [[MIRecentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifierRecent];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        MINegociation* recent = [_recents objectAtIndex:indexPath.row];
        [cell bindData:recent.object];
        return  cell;
    }
    

}

- (UIImage *) getCategoryIcon:(NSNumber *)categoryNumber
{
    UIImage *image;
    
    switch ([categoryNumber intValue]) {
        case RequestCategoryVidro:
            image = [UIImage imageNamed:@"VidroIcon"];
            break;
        case RequestCategoryMetal:
            image = [UIImage imageNamed:@"MetalIcon"];
            break;
        case RequestCategoryPapel:
            image = [UIImage imageNamed:@"PapelIcon"];
            break;
        case RequestCategoryPlastico:
            image = [UIImage imageNamed:@"PlasticoIcon"];
            break;
        case RequestCategoryOutros:
            image = [UIImage imageNamed:@"OutrosIcon"];
            break;
        default:
            image = [UIImage imageNamed:@"OutrosIcon"];
            break;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger value = 0;
    
    if (self.pedidosSegmentedControl.selectedSegmentIndex == 0){
        value = _requests.count;
    }else{
        value = _recents.count;
    }
    return value;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pedidosSegmentedControl.selectedSegmentIndex == 0){
        _selectedRequest = _requests[indexPath.row];
        [self performSegueWithIdentifier:@"FromPedidosToPedidoSegue" sender:self];
    }else if (self.pedidosSegmentedControl.selectedSegmentIndex == 1){
        _selectedChat = _recents[indexPath.row];
        [self performSegueWithIdentifier:@"FromMeusPedidosToChatSegue" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"FromPedidosToPedidoSegue"])
    {
        // Get reference to the destination view controller
        MIPedidoDetalhadoViewController *vc = [segue destinationViewController];
        vc.currentRequest = _selectedRequest;
    } else if ([[segue identifier] isEqualToString:@"FromMeusPedidosToChatSegue"]){
        MIChatViewController *vc = [segue destinationViewController];
        vc.chatId = _selectedChat.chatId;
        vc.neg = _selectedChat;
    } else if ([[segue identifier] isEqualToString:@"FromMeusPedidosToNovoPedidoCategoria"]){
        MINovoPedidoCategoriaViewController *vc = [segue destinationViewController];
        vc.novoPedido = [[MINovoPedido alloc] init];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.pedidosSegmentedControl.selectedSegmentIndex ==0){
        return 222;
    }
    return 70;

}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)loadRequests
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    
    [[MIDatabase sharedInstance] getCurrentUserRequestsWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error == nil)
         {
             [_requests removeAllObjects];
             NSArray *pedidos = [MIPedido pedidosArrayFromPFObjectArray:objects];
             [_requests addObjectsFromArray:pedidos];
             [self.pedidosTableView reloadData];
             
         }
         else [ProgressHUD showError:@"Network error."];
         [self.refreshControl endRefreshing];
     }];
}
- (void)loadRecents
{
    
    [[MIDatabase sharedInstance] getRecentNegotioationsWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error == nil)
         {
             [_recents removeAllObjects];
             NSArray* recents =[MINegociation recentesArrayFromPFObjectArray:objects];
             [_recents addObjectsFromArray:recents];
             [self.pedidosTableView reloadData];

         }
         else [ProgressHUD showError:@"Network error."];
         [self.refreshControl endRefreshing];
     }];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    if(self.pedidosSegmentedControl.selectedSegmentIndex == 0)[self loadRequests];
    else [self loadRecents];}


- (void) valueChanged:(UISegmentedControl *)control {
    if(control.selectedSegmentIndex == 0){
        [self loadRequests];
        [_pedidosTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    else {
        [self loadRecents];
        [_pedidosTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        
    }
}

-(IBAction) criarNovoPedido:(id)sender {
    [self performSegueWithIdentifier:@"FromMeusPedidosToNovoPedidoCategoria" sender:self];
}
@end

