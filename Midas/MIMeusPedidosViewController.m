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
#import "MINovoPedidoCategoriaViewController.h"
#import "MIDatabase.h"
#import "MIPedido.h"
#import "MINegociation.h"
#import "ProgressHUD.h"

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
    NSString *identifier = @"muralCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (self.pedidosSegmentedControl.selectedSegmentIndex == 0){
        MIPedido *request = _requests[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"A cada %@ %@, dou %@ %@.", request.forEachValue, request.forEach,request.willGiveValue, request.willGive];
        cell.detailTextLabel.text = request.owner.username;
        
    }else if (self.pedidosSegmentedControl.selectedSegmentIndex == 1){
        MINegociation *recent = _recents[indexPath.row];
        cell.textLabel.text = recent.owner.username;
        cell.detailTextLabel.text = recent.lastMessage;
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
        MIMeuPedidoDetalhadoViewController *vc = [segue destinationViewController];
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
    if(control.selectedSegmentIndex == 0)[self loadRequests];
    else [self loadRecents];
}

-(IBAction) criarNovoPedido:(id)sender {
    [self performSegueWithIdentifier:@"FromMeusPedidosToNovoPedidoCategoria" sender:self];
}
@end

