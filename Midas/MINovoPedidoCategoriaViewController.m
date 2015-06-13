//
//  MINovoPedidoCategoriaViewController.m
//  Midas
//
//  Created by Marcel de Siqueira Campos Rebouças on 6/13/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "MINovoPedidoCategoriaViewController.h"
#import "MINovoPedidoDadosViewController.h"
#import "AppConstant.h"
@interface MINovoPedidoCategoriaViewController()

@property NSArray *categories;
@property NSArray *categoryIcons;
@property NSArray *categoryEnum;

@end

@implementation MINovoPedidoCategoriaViewController

-(void) viewDidLoad {
    [super viewDidLoad];
   
    self.categoryTableView.delegate = self;
    self.categoryTableView.dataSource = self;
    self.categoryTableView.tableFooterView = [[UIView alloc] initWithFrame : CGRectZero];
    
    self.navigationItem.title = @"Passo 1";
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    self.categories = @[@"Vidro", @"Plástico", @"Papel", @"Metal", @"Outros"];
    self.categoryIcons = @[@"VidroIcon", @"PlasticoIcon", @"PapelIcon", @"MetalIcon", @"OutrosIcon"];
    self.categoryEnum = @[[NSNumber numberWithInteger:RequestCategoryVidro], [NSNumber numberWithInteger:RequestCategoryPlastico], [NSNumber numberWithInteger:RequestCategoryPapel], [NSNumber numberWithInteger:RequestCategoryMetal], [NSNumber numberWithInteger:RequestCategoryOutros]];
}

-(void) viewWillAppear:(BOOL)animated {
    
}

- (void)dismissKeyboard
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [self.view endEditing:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"categoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
   
    
    cell.textLabel.text = _categories[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:_categoryIcons[indexPath.row]];
    
    return cell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.categories.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.novoPedido.category = _categoryEnum[indexPath.row];
    [self performSegueWithIdentifier:@"FromNovoPedidoCategoriaToDados" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"FromNovoPedidoCategoriaToDados"])
    {
        // Get reference to the destination view controller
        MINovoPedidoDadosViewController *vc = [segue destinationViewController];
        vc.novoPedido = self.novoPedido;
    }
}
@end
