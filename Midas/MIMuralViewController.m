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

@interface MIMuralViewController ()

@property NSMutableArray *requests;
@property MIPedido* selectedRequest;

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
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    
    [[MIDatabase sharedInstance] getOpenRequestsFromOtherUsersWithBlock:^(NSArray *objects, NSError *error)
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
     }];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self loadRequests];
}

@end
