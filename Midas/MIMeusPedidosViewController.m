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
#import "MIRecentCell.h"
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
    //_pedidosTableView setSe
    //[_pedidosTableView setSeparatorInset:UIEdgeInsetsMake(10, 0, 10, 0)];
    [self.pedidosTableView setBackgroundColor:COLOR_BACKGROUND];
    [self.pedidosSegmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents: UIControlEventValueChanged];
    self.pedidosTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
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
    NSString *identifierRequest = @"pedidosCell";
    NSString *identifierRecent = @"recentCell";
    
    if (self.pedidosSegmentedControl.selectedSegmentIndex == 0){
        
        MIMeusPedidosTableViewCell* cell;
        cell = [tableView dequeueReusableCellWithIdentifier:identifierRequest];
        if (cell == nil) {
            
            cell = [[MIMeusPedidosTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifierRequest];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        MIPedido *request = [_requests objectAtIndex:indexPath.row];
        [cell bindData:request];
        
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger value = 0;
    
    if (self.pedidosSegmentedControl.selectedSegmentIndex == 0){
        value = _requests.count;
    }else{
        value = _recents.count;
    }
    
    if(value==0)
    {
        self.pedidosTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"david_TabBar"]];
        
    }
    else
    {
        self.pedidosTableView.backgroundView = nil;
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
        [self.pedidosTableView setBackgroundColor:COLOR_BACKGROUND];
    }
    else {
        [self loadRecents];
        [_pedidosTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [self.pedidosTableView setBackgroundColor:[UIColor whiteColor]];
        
    }
}

-(IBAction) criarNovoPedido:(id)sender {
    [self performSegueWithIdentifier:@"FromMeusPedidosToNovoPedidoCategoria" sender:self];
}
@end

