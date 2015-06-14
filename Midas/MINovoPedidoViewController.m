//
//  MINovoPedidoViewController.m
//  Midas
//
//  Created by Rafael Gouveia on 6/9/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "MINovoPedidoViewController.h"
#import "ProgressHUD.h"
#import "MIDatabase.h"
#import "camera.h"
#import "image.h"

@interface MINovoPedidoViewController () <UIImagePickerControllerDelegate>

@end


@implementation MINovoPedidoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *concluirButton = [[UIBarButtonItem alloc]
                                      initWithTitle:@"Concluir"
                                      style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(criarNovoPedido:)];
    self.navigationItem.rightBarButtonItem = concluirButton;
    
    self.navigationItem.title = @"Passo 3";
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [[self.descriptionTextView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.descriptionTextView layer] setBorderWidth:0.25];
    [[self.descriptionTextView layer] setCornerRadius:15];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissKeyboard
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [self.view endEditing:YES];
}


- (void) criarNovoPedido:(id)sender {
    //do here
    
    NSString *description = self.descriptionTextView.text;
    
    if ([description length] < 1)	{ [ProgressHUD showError:@"A descrição é um campo obrigatório."]; return; }
    if ([description length] > 140)	{ [ProgressHUD showError:@"Descrição muito longa (>140)."]; return; }
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    
    self.novoPedido.descricao = description;
    
    if(self.imageView.image) {
        self.novoPedido.image = CreateThumbnail(self.imageView.image, 400.f);
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

- (IBAction)pressedGallery:(id)sender {
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
