//
//  MINovoPedidoDadosViewController.m
//  Midas
//
//  Created by Marcel de Siqueira Campos Rebouças on 6/13/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "MINovoPedidoDadosViewController.h"
#import "AppConstant.h"
#import "ProgressHUD.h"
#import "MINovoPedido.h"
#import "MIDatabase.h"
#import "camera.h"
#import "image.h"

@interface MINovoPedidoDadosViewController () <UIImagePickerControllerDelegate>

@end

@implementation MINovoPedidoDadosViewController


-(void) viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *concluirButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Concluir"
                                       style:UIBarButtonItemStylePlain
                                       target:self
                                       action:@selector(concluir:)];
    self.navigationItem.rightBarButtonItem = concluirButton;
    
    self.navigationItem.title = @"Passo 2";
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [[self.descriptionTextView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.descriptionTextView layer] setBorderWidth:0.25];
    [[self.descriptionTextView layer] setCornerRadius:15];
    
    UITapGestureRecognizer *imageTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedGallery:)];
    [self.imageView setUserInteractionEnabled:YES];
    [self.imageView addGestureRecognizer:imageTapRecognizer];
}

-(void) viewWillAppear:(BOOL)animated {
    
    switch ([self.novoPedido.category intValue]) {
        case RequestCategoryVidro:
            self.categoryValueLabel.text = @"Vidro";
            self.categoryImageView.image = [UIImage imageNamed:@"VidroIcon"];
            self.rewardFirstTextField.placeholder = @"Ex.: garrafas vazias";
            self.forEachValueTextField.placeholder = @"10";
            self.rewardSecondTextField.placeholder = @"Ex.: cerveja cheia";
            self.willGiveValueTextField.placeholder = @"1";
            break;
        case RequestCategoryPlastico:
            self.categoryValueLabel.text = @"Plástico";
            self.categoryImageView.image = [UIImage imageNamed:@"PlasticoIcon"];
            self.rewardFirstTextField.placeholder = @"Ex.: garrafas vazias";
            self.forEachValueTextField.placeholder = @"10";
            self.rewardSecondTextField.placeholder = @"Ex.: cerveja cheia";
            self.willGiveValueTextField.placeholder = @"1";

            break;
        case RequestCategoryMetal:
            self.categoryValueLabel.text = @"Metal";
            self.categoryImageView.image = [UIImage imageNamed:@"MetalIcon"];
            self.rewardFirstTextField.placeholder = @"Ex.: garrafas vazias";
            self.forEachValueTextField.placeholder = @"10";
            self.rewardSecondTextField.placeholder = @"Ex.: cerveja cheia";
            self.willGiveValueTextField.placeholder = @"1";

            break;
        case RequestCategoryPapel:
            self.categoryValueLabel.text = @"Papel";
            self.categoryImageView.image = [UIImage imageNamed:@"PapelIcon"];
            self.rewardFirstTextField.placeholder = @"Ex.: garrafas vazias";
            self.forEachValueTextField.placeholder = @"10";
            self.rewardSecondTextField.placeholder = @"Ex.: cerveja cheia";
            self.willGiveValueTextField.placeholder = @"1";

            break;
        case RequestCategoryOutros:
            self.categoryValueLabel.text = @"Outros";
            self.categoryImageView.image = [UIImage imageNamed:@"OutrosIcon"];
            self.rewardFirstTextField.placeholder = @"Ex.: garrafas vazias";
            self.forEachValueTextField.placeholder = @"10";
            self.rewardSecondTextField.placeholder = @"Ex.: cerveja cheia";
            self.willGiveValueTextField.placeholder = @"1";

            break;
        default:
            break;
    }
    
    

}

- (void)dismissKeyboard
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [self.view endEditing:YES];
}


- (void) concluir:(id)sender {
    
    NSInteger forEachValue = [self.forEachValueTextField.text intValue];
    NSString *foreach = self.rewardFirstTextField.text;
    NSInteger willGiveValue = [self.willGiveValueTextField.text intValue];
    NSString *willgive = self.rewardSecondTextField.text;
    NSString *description = self.descriptionTextView.text;
 
    if ([foreach length] < 1)	{ [ProgressHUD showError:@"Campo 'A cada' é obrigatório."];return;}
    if ([foreach length] > 25)	{ [ProgressHUD showError:@"Campo 'A cada' muito longo (>25)."]; return; }
    if ([willgive length] < 1)	{ [ProgressHUD showError:@"Campo 'Dou' é obrigatório."];return;}
    if ([willgive length] > 25)	{ [ProgressHUD showError:@"Campo 'Dou' muito longo (>25)."]; return; }
    if ([description length] < 1)	{ [ProgressHUD showError:@"A descrição é um campo obrigatório."]; return; }
    if ([description length] > 140)	{ [ProgressHUD showError:@"Descrição muito longa (>140)."]; return; }
    if (forEachValue < 1)	{ [ProgressHUD showError:@"Campo 'A cada' deve ter um valor."]; return; }
    if (willGiveValue < 1)	{ [ProgressHUD showError:@"Campo 'Dou' deve ter um valor."]; return; }

    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    
    self.novoPedido.foreachValue = [NSNumber numberWithInteger:forEachValue];
    self.novoPedido.foreach = foreach;
    self.novoPedido.willgiveValue = [NSNumber numberWithInteger:willGiveValue];
    self.novoPedido.willgive = willgive;
    self.novoPedido.descricao = description;

    if(self.imageView.image) {
        self.novoPedido.image = CreateThumbnail(self.imageView.image, 600.f);
        self.novoPedido.thumbnail = CreateThumbnail(self.imageView.image, 150.f);
    }
    
    [[MIDatabase sharedInstance]createNewPedidoInBackGround:self.novoPedido
                                                      block:^(BOOL succeeded, NSError *error) {
                                                          if (succeeded) {
                                                              // The object has been saved.
                                                              [ProgressHUD showSuccess:@"Sucesso."];
                                                              [self.navigationController popToRootViewControllerAnimated:YES];
                                                          } else {
                                                              [ProgressHUD showError:error.userInfo[@"error"]];
                                                              // There was a problem, check error.description
                                                          }
                                                      }];
    
    
}

- (IBAction)pressedCamera:(id)sender {
    PresentPhotoCamera(self, YES);
}

- (void)pressedGallery:(id)sender {
    PresentPhotoLibrary(self, YES);
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *picture = info[UIImagePickerControllerEditedImage];
    self.imageView.image = picture;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
