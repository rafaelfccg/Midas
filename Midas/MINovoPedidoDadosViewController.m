//
//  MINovoPedidoDadosViewController.m
//  Midas
//
//  Created by Marcel de Siqueira Campos Rebouças on 6/13/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "MINovoPedidoDadosViewController.h"
#import "MINovoPedidoViewController.h"
#import "AppConstant.h"
#import "ProgressHUD.h"

@implementation MINovoPedidoDadosViewController


-(void) viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *concluirButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Próximo"
                                       style:UIBarButtonItemStylePlain
                                       target:self
                                       action:@selector(passo3:)];
    self.navigationItem.rightBarButtonItem = concluirButton;
    
    self.navigationItem.title = @"Passo 2";
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [self.rewardSwitch addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];
}

-(void) viewWillAppear:(BOOL)animated {
    
    switch ([self.novoPedido.category intValue]) {
        case RequestCategoryVidro:
            self.categoryValueLabel.text = @"Vidro";
            self.categoryImageView.image = [UIImage imageNamed:@"VidroIcon"];
            self.titleTextField.placeholder = @"Ex.:Garrafas de cerveja vazias";
            self.rewardFirstTextField.placeholder = @"Ex.: 5 garrafas vazias";
            self.rewardSecondTextField.placeholder = @"Ex.: 1 cerveja cheia";
            
            break;
        case RequestCategoryPlastico:
            self.categoryValueLabel.text = @"Plástico";
            self.categoryImageView.image = [UIImage imageNamed:@"PlasticoIcon"];
            self.titleTextField.placeholder = @"Ex.: Garrafas PET";
            self.rewardFirstTextField.placeholder = @"Ex.: 5 garrafas";
            self.rewardSecondTextField.placeholder = @"Ex.: ";
            break;
        case RequestCategoryMetal:
            self.categoryValueLabel.text = @"Metal";
            self.categoryImageView.image = [UIImage imageNamed:@"MetalIcon"];
            self.titleTextField.placeholder = @"Ex.: Latinhas de cerveja";
            self.rewardFirstTextField.placeholder = @"Ex.: 5 garrafas";
            self.rewardSecondTextField.placeholder = @"Ex.: 1 cerveja cheia";
            break;
        case RequestCategoryPapel:
            self.categoryValueLabel.text = @"Papel";
            self.categoryImageView.image = [UIImage imageNamed:@"PapelIcon"];
            self.titleTextField.placeholder = @"Ex.: Jornais velhos";
            self.rewardFirstTextField.placeholder = @"Ex.: 5 garrafas";
            self.rewardSecondTextField.placeholder = @"Ex.: 1 cerveja cheia";
            break;
        case RequestCategoryOutros:
            self.categoryValueLabel.text = @"Outros";
            self.categoryImageView.image = [UIImage imageNamed:@"OutrosIcon"];
            self.titleTextField.placeholder = @"Ex.: Azulejos quebrados";
            self.rewardFirstTextField.placeholder = @"Ex.: 5 garrafas";
            self.rewardSecondTextField.placeholder = @"Ex.: 1 cerveja cheia";
            break;
        default:
            break;
    }
    
    self.quantityTextField.placeholder = @"Ex.: 10";
    

}

- (void)dismissKeyboard
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [self.view endEditing:YES];
}


- (void) passo3:(id)sender {
    
    NSString *title = self.titleTextField.text;
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *quantity = [f numberFromString:self.quantityTextField.text];
    
    BOOL willReward = self.rewardSwitch.on;
    
    NSString *reward1 = self.rewardFirstTextField.text;
    NSString *reward2 = self.rewardSecondTextField.text;
    
    if ([title length] < 3)	{ [ProgressHUD showError:@"Campo 'Preciso de' obrigatório."];return;}
    if ([title length] > 25)	{ [ProgressHUD showError:@"Campo 'Preciso de' muito longo (>25)."]; return; }
    if ([quantity intValue]<=0 || [quantity intValue]>10000) { [ProgressHUD showError:@"Quantidade deve ser um valor entre 0 e 1000"]; return; }
    
    if(willReward){
        if ([reward1 length] < 3)	{ [ProgressHUD showError:@"Campo 'A cada' é obrigatório."];return;}
        if ([reward1 length] > 25)	{ [ProgressHUD showError:@"Campo 'A cada' muito longo (>25)."]; return; }
        if ([reward2 length] < 3)	{ [ProgressHUD showError:@"Campo 'Dou' é obrigatório."];return;}
        if ([reward2 length] > 25)	{ [ProgressHUD showError:@"Campo 'Dou' muito longo (>25)."]; return; }
    }
    
    self.novoPedido.title = title;
    self.novoPedido.quantity = quantity;
    if(self.rewardSwitch.isOn){
        self.novoPedido.reward = [NSString stringWithFormat:@"A cada %@, dou %@",reward1, reward2];
    }
    
    [self performSegueWithIdentifier:@"FromNovoPedidoDadosToNovoPedido" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"FromNovoPedidoDadosToNovoPedido"])
    {
        // Get reference to the destination view controller
        MINovoPedidoViewController *vc = [segue destinationViewController];
        vc.novoPedido = self.novoPedido;
    }
}

- (void)setState:(id)sender
{
    BOOL willReward = [sender isOn];
    
    if(willReward){
        self.rewardFirstTextField.enabled = YES;
        self.rewardSecondTextField.enabled = YES;
    } else {
        self.rewardFirstTextField.enabled = NO;
        self.rewardSecondTextField.enabled = NO;
    }
}

@end
