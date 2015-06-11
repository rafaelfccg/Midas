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

@interface MIMuralViewController ()

@property NSMutableArray *requests;

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
    
    PFObject *request = [_requests objectAtIndex:indexPath.row];
    
    cell.textLabel.text = request[PF_REQUEST_TITLE];
    cell.detailTextLabel.text = ((PFUser *)request[PF_REQUEST_USER])[PF_USER_FULLNAME];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_requests count];
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


//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)loadRequests
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    
    [[MIDatabase sharedInstance] getOpenRequestsWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error == nil)
         {
             [_requests removeAllObjects];
             [_requests addObjectsFromArray:objects];
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
