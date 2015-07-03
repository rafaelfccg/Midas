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
#import "general.h"

@interface MINovoPedidoDadosViewController () <UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic) BOOL alreadyUpdatedViewWithEditingInformation;
@property BOOL didChangeImage;


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
    
    if ([self.novoPedido isEditing]){
        self.navigationItem.title = @"Editando";
    } else {
        self.navigationItem.title = @"Passo 2";
    }
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, _scrollView.contentSize.height);
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [[self.descriptionTextView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.descriptionTextView layer] setBorderWidth:0.25];
    [[self.descriptionTextView layer] setCornerRadius:15];
    
    UITapGestureRecognizer *imageTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedGallery:)];
    [self.imageView setUserInteractionEnabled:YES];
    [self.imageView addGestureRecognizer:imageTapRecognizer];
    
    self.alreadyUpdatedViewWithEditingInformation = false;
    self.tableView.allowsSelection= NO;
    self.imageView.layer.cornerRadius = 10.0f;
}

-(void) viewWillAppear:(BOOL)animated {
    
    self.categoryImageView.image = getCategoryIcon(self.novoPedido.category);
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.categoryValueLabel.text = getCategoryName(self.novoPedido.category);
    
    if (!self.alreadyUpdatedViewWithEditingInformation) {
        _alreadyUpdatedViewWithEditingInformation = YES;
        [self updatePlaceholders];
        
        if(self.novoPedido.isEditing){
         [self fillFieldsWithInformation];
        }
    }

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void) setNovoPedido:(MINovoPedido *)novoPedido {
    _novoPedido = novoPedido;
    _alreadyUpdatedViewWithEditingInformation = false;
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

    
    [ProgressHUD show:@"Aguarde..." Interaction:NO];
    PFUser * user = [PFUser currentUser];
    self.novoPedido.foreachValue = [NSNumber numberWithInteger:forEachValue];
    self.novoPedido.foreach = foreach;
    self.novoPedido.willgiveValue = [NSNumber numberWithInteger:willGiveValue];
    self.novoPedido.willgive = willgive;
    self.novoPedido.descricao = description;
    self.novoPedido.location = user[PF_USER_LOCATION];
    
    if(!_didChangeImage){
        self.imageView.image = self.categoryImageView.image;
    }
    
    if(self.imageView.image) {
        self.novoPedido.image = CreateThumbnail(self.imageView.image, 600.f);
        self.novoPedido.thumbnail = CreateThumbnail(self.imageView.image, 150.f);
    }
    
    //se editando
    if(self.novoPedido.isEditing) {
        [[MIDatabase sharedInstance]editPedidoInBackGround:self.novoPedido
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

    }else {
        //se é um novo pedido
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
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex

{
    if (buttonIndex == 0){
        PresentPhotoLibrary(self, YES);
        

       
    }else if(buttonIndex ==1){
        PresentPhotoCamera(self, YES);
        
    }
}

- (void)pressedGallery:(id)sender {
    
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:nil otherButtonTitles:@"Foto da Galeria",@"Foto da Camera", nil];
    [action showFromTabBar:[[self tabBarController] tabBar]];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *picture = info[UIImagePickerControllerEditedImage];
    self.imageView.image = picture;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _didChangeImage = YES;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void) updatePlaceholders {
    self.didChangeImage = false;
    switch ([self.novoPedido.category intValue]) {
        case RequestCategoryVidro:
            self.rewardFirstTextField.placeholder = @"Ex.: garrafas vazias";
            self.forEachValueTextField.placeholder = @"10";
            self.rewardSecondTextField.placeholder = @"Ex.: cerveja cheia";
            self.willGiveValueTextField.placeholder = @"1";
            //self.imageView.image = [UIImage imageNamed:@"VidroIcon" ];

            break;
        case RequestCategoryPlastico:
            self.rewardFirstTextField.placeholder = @"Ex.: garrafas PET 2L";
            self.forEachValueTextField.placeholder = @"20";
            self.rewardSecondTextField.placeholder = @"Ex.: carrinho de plástico";
            self.willGiveValueTextField.placeholder = @"1";
            //self.imageView.image = [UIImage imageNamed:@"PlasticoIcon" ];

            break;
        case RequestCategoryMetal:
            self.rewardFirstTextField.placeholder = @"Ex.: latinhas de coca-cola vazias";
            self.forEachValueTextField.placeholder = @"10";
            self.rewardSecondTextField.placeholder = @"Ex.: coca-cola";
            self.willGiveValueTextField.placeholder = @"1";
            //self.imageView.image = [UIImage imageNamed:@"MetalIcon" ];
            
            break;
        case RequestCategoryPapel:
            self.rewardFirstTextField.placeholder = @"Ex.: jornais velhos";
            self.forEachValueTextField.placeholder = @"10";
            self.rewardSecondTextField.placeholder = @"Ex.: 1 origami";
            self.willGiveValueTextField.placeholder = @"1";
            //self.imageView.image = [UIImage imageNamed:@"PapelIcon" ];

            break;
        case RequestCategoryOutros:
            self.rewardFirstTextField.placeholder = @"Ex.: azujelos coloridos";
            self.forEachValueTextField.placeholder = @"5";
            self.rewardSecondTextField.placeholder = @"Ex.: mini-mosaico";
            self.willGiveValueTextField.placeholder = @"1";
            //self.imageView.image = [UIImage imageNamed:@"OutrosIcon" ];

            break;
        default:
            break;
    }
}

-(void) fillFieldsWithInformation {
    self.forEachValueTextField.text = [NSString stringWithFormat:@"%@",self.novoPedido.foreachValue];
    self.rewardFirstTextField.text = self.novoPedido.foreach;
    self.willGiveValueTextField.text = [NSString stringWithFormat:@"%@",self.novoPedido.willgiveValue];
    self.rewardSecondTextField.text = self.novoPedido.willgive;
    self.descriptionTextView.text = self.novoPedido.descricao;
    self.imageView.image = self.novoPedido.image;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
}

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:_descriptionTextView])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}
@end
