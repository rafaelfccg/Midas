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
#import "MIMuralCellControllerTableViewCell.h"
#import "general.h"
#import "PopOverViewController.h"
#import "MITermosDeUsoViewController.h"
#import "common.h"

@interface MIMuralViewController () <RNGridMenuDelegate>

@property NSMutableArray *requests;
@property MIPedido* selectedRequest;
@property MIFiltrosDeBusca* filtros;

@property (atomic) BOOL isDownloadingMoreRequests;

@property UIActionSheet *selectImageSheet;

@property(nonatomic,retain)UIPopoverPresentationController *dateTimePopover8;

@end

@implementation MIMuralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.muralTableView.delegate = self;
    self.muralTableView.dataSource = self;
    self.muralTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
  // Do any additional setup after loading the view.
    self.requests = [[NSMutableArray alloc] init];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    
    [self.muralTableView addSubview:self.refreshControl];
    
    UINib *nib = [UINib nibWithNibName:@"MIMuralCellControllerTableViewCell" bundle:nil];
    [self.muralTableView registerNib:nib forCellReuseIdentifier:@"MuralCell"];
    
    self.filtros = [[MIFiltrosDeBusca alloc]init];
    [self.muralTableView setBackgroundColor:COLOR_BACKGROUND];
    self.muralTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  
    if ([PFUser currentUser].isNew && [PFUser currentUser][@"facebookId"] != nil) {
       [self showTermsOfService];
    }
  
}

-(void) viewWillAppear:(BOOL)animated {
    [self.refreshControl beginRefreshing];
    [self loadRequests];
    _isDownloadingMoreRequests = false;
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
    NSString *identifier = @"MuralCell";
    MIMuralCellControllerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [[MIMuralCellControllerTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    MIPedido *request = [_requests objectAtIndex:indexPath.row];
    [cell bindData:request];
    
    if(indexPath.row > _requests.count-5 && !_isDownloadingMoreRequests){
        _isDownloadingMoreRequests = true;
        [self loadMoreRequests];
    }
    
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
//"HEi-u6-9SP", "Wgy-nW-QXw", and "v2O-54-529"
//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)loadRequests
{
    
    [[MIDatabase sharedInstance] getOpenRequestsFromOtherUsersWithBlock:self.filtros andSkip:0 Block:^(NSArray *objects, NSError *error)
     {
         if (error == nil)
         {
             [_requests removeAllObjects];
             NSArray *pedidos = [MIPedido pedidosArrayFromPFObjectArray:objects];
             [_requests addObjectsFromArray:pedidos];
             [self.muralTableView reloadData];
             
             if([_requests count]==0){
                 
                UIImageView* background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Nosso mural"]];
                background.contentMode = UIViewContentModeScaleAspectFit;
                background.backgroundColor = [UIColor whiteColor];
                self.muralTableView.backgroundView = background;
             }
             
             else{
                 self.muralTableView.backgroundView = nil;
             }
         }
         else {
             NSLog(@"%@", error.userInfo[@"error"]);
             NSString *errorMessage = localizeErrorMessage(error);
             [ProgressHUD showError:errorMessage];
         }
         [self.refreshControl endRefreshing];
     }/* filtro:self.filtros*/];
}

-(void) loadMoreRequests {

     NSInteger skip = (NSInteger) _requests.count;
    
    [[MIDatabase sharedInstance] getOpenRequestsFromOtherUsersWithBlock:self.filtros andSkip:skip Block:^(NSArray *objects, NSError *error)
     {
         if (error == nil)
         {
             
             NSArray *pedidos = [MIPedido pedidosArrayFromPFObjectArray:objects];
             [_requests addObjectsFromArray:pedidos];
             [self.muralTableView reloadData];
         }
         else {
             NSLog(@"%@", error.userInfo[@"error"]);
             NSString *errorMessage = localizeErrorMessage(error);
             [ProgressHUD showError:errorMessage];
         }
          _isDownloadingMoreRequests = false;
     }];

}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self loadRequests];
}

#pragma mark - RNGridDelegate
//-------------------------------------------------------------------------------------------------------------------------------------------------

- (IBAction)didPressSearchButton:(id)sender {
    if(UIAccessibilityIsVoiceOverRunning())
    {
        NSLog(@"this is a gambiarra");
        
        [self pressedGallery];
    }
    else
    {
        [self.view endEditing:YES];
        NSArray *menuItems = @[[[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"GPSIcon"] title:NSLocalizedString(@"Todos", @"Filtro Todos.")],
                               [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"VidroIcon"] title:NSLocalizedString(@"Vidro", @"Categoria Vidro")],
                               [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"PlasticoIcon"] title:NSLocalizedString(@"Plástico", @"Categoria Plástico")],
                               [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"MetalIcon"] title:@"Metal"],
                               [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"PapelIcon"] title:@"Papel"],
                               [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"OutrosIcon"] title:@"Outros"]];
        RNGridMenu *gridMenu = [[RNGridMenu alloc] initWithItems:menuItems];
        gridMenu.delegate = self;
        gridMenu.highlightColor = [UIColor darkGrayColor];
        gridMenu.menuStyle = RNGridMenuStyleGrid;
        [gridMenu showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/(2.f))];
    }
}

- (void)pressedGallery {
    self.selectImageSheet = [[UIActionSheet alloc] initWithTitle:@"Qual tipo de material?"
                                                        delegate:self
                                               cancelButtonTitle:nil
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"Vidro", @"Plástico", @"Metal",@"Papel",@"Outros",@"Todos",nil];
    
    //[self.selectImageSheet showInView:self.view];
    [self.selectImageSheet showFromTabBar:[[self tabBarController] tabBar]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(actionSheet == self.selectImageSheet)
    {
        self.filtros.Vidro = false;
        self.filtros.Metal = false;
        self.filtros.Papel = false;
        self.filtros.Outros = false;
        self.filtros.Plastico = false;
        
        self.filtros.Todos = true;
        
        
        if (buttonIndex == 0)
        {
            self.filtros.Vidro = true;
            self.filtros.Todos = false;
            NSLog(@"Vidro");
        }
        
        if (buttonIndex == 1)
        {
            self.filtros.Plastico = true;
            self.filtros.Todos = false;
            NSLog(@"Plástico");
        }
        
        if (buttonIndex == 2)
        {
            self.filtros.Metal = true;
            self.filtros.Todos = false;
            NSLog(@"Metal");
        }
        
        if (buttonIndex == 3)
        {
            self.filtros.Papel = true;
            self.filtros.Todos = false;
            NSLog(@"Papel");
        }
        
        if (buttonIndex == 4)
        {
            self.filtros.Outros = true;
            self.filtros.Todos = false;
            NSLog(@"Outros");
        }
        
        if (buttonIndex == 5)
        {
            self.filtros.Todos = true;
            NSLog(@"Todos");
        }
        
        [self loadRequests];
    }
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

-(void)showTermsOfService{

  UIAlertController* termsOfServiceAlert = [UIAlertController
                              alertControllerWithTitle:NSLocalizedString(@"Termos de Uso", @"Titulo Termos de Uso")
                              message:NSLocalizedString(@"Conteudo Termos de Uso", @"Conteudo Termos de Uso")
                              preferredStyle:UIAlertControllerStyleActionSheet];
  
  UIAlertAction* acceptAction = [UIAlertAction
                                  actionWithTitle:NSLocalizedString(@"Aceitar termos", @"Aceitar") style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action) {}];
 
  UIAlertAction* refuseAction = [UIAlertAction
                                 actionWithTitle:NSLocalizedString(@"Recusar termos", @"Recusar") style:UIAlertActionStyleDestructive
                                 handler:^(UIAlertAction * action) {
                                   [[PFUser currentUser] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                                   {
                                     if (succeeded)
                                     {
                                       [PFUser logOut];
                                       ParsePushUserResign();
                                       PostNotification(NOTIFICATION_USER_LOGGED_OUT);
                                       LoginUser(self);
                                     }
                                   }
                                    ];
                                 }];
  
  [termsOfServiceAlert addAction:acceptAction];
  [termsOfServiceAlert addAction:refuseAction];
  [self presentViewController:termsOfServiceAlert animated:YES completion:nil];
  
}

@end
