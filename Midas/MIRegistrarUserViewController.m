//
//  MIRegistrarUserViewController.m
//  Midas
//
//  Created by Marcel de Siqueira Campos Rebouças on 6/10/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "MIRegistrarUserViewController.h"
#import "ProgressHUD.h"
#import "MIDatabase.h"
#import "camera.h"
#import "general.h"
#import "MITermosDeUsoViewController.h"
#import "PopOverViewController.h"


@interface MIRegistrarUserViewController()

@property BOOL isUp;
@property float keyboardHeight;
@property (weak, nonatomic) IBOutlet UIButton *termosButton;
@property (weak, nonatomic) IBOutlet UILabel *termosLabel;
@property(nonatomic,retain)UIPopoverPresentationController *dateTimePopover8;

@end

@implementation MIRegistrarUserViewController
@synthesize picture;
@synthesize imageView;

- (void) viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    self.picture = nil;
    
    UITapGestureRecognizer *imageTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedGallery:)];
    [self.imageView setUserInteractionEnabled:YES];
    [self.imageView addGestureRecognizer:imageTapRecognizer];

    [self.registrarButton.layer setCornerRadius:7.0f];
    [self.registrarButton.layer setMasksToBounds:YES];
  
    self.termosButton.titleLabel.numberOfLines = 0;
  
    [self.termosButton setTitle:NSLocalizedString(@"Termos de Uso", @"Titulo Termos de Uso") forState:UIControlStateNormal];
    [self.termosLabel setText:NSLocalizedString(@"Ao se registrar você aceita os", @"Ao se registrar você aceita os")];
  
    self.imageView.layer.cornerRadius = 10.0f;
}

#pragma mark - UIActionSheetDelegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex

{
    if (buttonIndex == 0){
        PresentPhotoLibrary(self, YES);
    }else if(buttonIndex ==1){
        PresentPhotoCamera(self, YES);
    }
}

- (void)pressedGallery:(id)sender {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancelar", @"Cancelar Button")
                                          destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Galeria", @"Galeria Button"),NSLocalizedString(@"Camera", @"Camera Button"), nil];
    [action showFromTabBar:[[self tabBarController] tabBar]];
    
}
//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidAppear:animated];
    [_loginTextField becomeFirstResponder];
}

-(void) viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
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
//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}


- (IBAction)actionRegister:(id)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{

    NSString *login     = _loginTextField.text;
    NSString *password	= _passwordTextField.text;
    NSString *passwordConfirmation	= _passwordConfirmationTextField.text;
    NSString *email		= [_emailTextField.text lowercaseString];
    PFFile * file = nil;
    
    if(self.picture != nil)
       file = [PFFile fileWithData:UIImagePNGRepresentation(self.picture)];
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    if ([login length] < 4)		{ [ProgressHUD showError:NSLocalizedString(@"O login deve ter pelo menos 4 caracteres.", @"Login - Poucos Caracteres Message")]; return; }
    if ([login length] > 20)	{ [ProgressHUD showError:NSLocalizedString(@"O login deve ter menos de 20 caracteres.", @"Login - Muitos Caracteres Message")]; return; }
    if ([email length] == 0)	{ [ProgressHUD showError:NSLocalizedString(@"Email é obrigatório.", @"Email Obrigatorio Message")]; return; }
    if ([password length] < 6)	{ [ProgressHUD showError:NSLocalizedString(@"A senha deve ter pelo menos 6 caracteres.", @"Senha - Poucos Caracteres Message")]; return; }
    if ([password length] > 30)	{ [ProgressHUD showError:NSLocalizedString(@"A senha deve ter menos de 30 caracteres.", @"Senha - muitos caracteres message")]; return; }
    if (![password isEqualToString:passwordConfirmation]) { [ProgressHUD showError:NSLocalizedString(@"As senhas devem ser iguais.", @"Senhas devem ser iguais Message")]; return; }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    [ProgressHUD show:NSLocalizedString(@"Registrando...", @"Registrando Message") Interaction:NO];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    
     [[MIDatabase sharedInstance] signUpWithUsernameInBackground:login password:password email:email ProfileImage:file block:^(BOOL succeeded, NSError *error)
     {
         if (error == nil)
         {
             ParsePushUserAssign();
             [ProgressHUD showSuccess:NSLocalizedString(@"Sucesso", @"Sucesso Message")];
             [self.navigationController popToRootViewControllerAnimated:YES];
         }
         else {
             NSLog(@"%@", error.userInfo[@"error"]);
             NSString *errorMessage = localizeErrorMessage(error);
             [ProgressHUD showError:errorMessage];
         }
        
     }];
}

- (IBAction)cancel:(id)sender {
   [self.navigationController popToRootViewControllerAnimated:YES];
}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    picture = info[UIImagePickerControllerEditedImage];

    if([picture size].width>200 || [picture size].height>200)
    picture = [self imageWithImage:picture scaledToSize:CGSizeMake([picture size].width*(200/[picture size].width), [picture size].height*(200/[picture size].height))];
    
    self.imageView.image = self.picture;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(UIImage*)imageWithImage:(UIImage*)image
scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - Keyboard Notifications
-(void)keyboardWillShow:(NSNotification *)notification {
    
    if([notification userInfo]){
        NSValue * keyboardSize = [notification userInfo][UIKeyboardFrameBeginUserInfoKey];
        
        
        if (!_isUp) {
            _keyboardHeight = keyboardSize.CGRectValue.size.height;
            [self animateView:YES];
            _isUp = YES;
        }
    }
}

-(void)keyboardWillHide:(NSNotification *)notification {
    
    if (_isUp) {
        [self animateView:NO];
        _isUp = NO;
    }
}

-(void) animateView:(BOOL)up {
    
    float movement = up ? -_keyboardHeight : _keyboardHeight;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    
    [UIView commitAnimations];
}

- (IBAction)termosDeUso:(id)sender {
  MITermosDeUsoViewController* termosVC = [[MITermosDeUsoViewController alloc] init];
  termosVC.titleText = NSLocalizedString(@"Termos de Uso", @"Titulo Termos de Uso");
  termosVC.contentText = NSLocalizedString(@"Conteudo Termos de Uso", @"Conteudo Termos de Uso");
  
  UINavigationController *destNav = [[UINavigationController alloc] initWithRootViewController:termosVC];/*Here dateVC is controller you want to show in popover*/
  termosVC.preferredContentSize = CGSizeMake(self.view.bounds.size.width*0.8,self.view.bounds.size.height*0.7);
  destNav.modalPresentationStyle = UIModalPresentationPopover;
  _dateTimePopover8 = destNav.popoverPresentationController;
  _dateTimePopover8.delegate = self;
  _dateTimePopover8.sourceView = self.view;
  _dateTimePopover8.sourceRect = [sender frame];
  
  destNav.modalPresentationStyle = UIModalPresentationPopover;
  destNav.navigationBarHidden = YES;
  [self presentViewController:destNav animated:YES completion:nil];

}
- (UIModalPresentationStyle) adaptivePresentationStyleForPresentationController: (UIPresentationController * ) controller {
  return UIModalPresentationNone;
}
-(void)hideIOS8PopOver
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
