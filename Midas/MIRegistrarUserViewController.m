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
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
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

    if([picture size].width>600 || [picture size].height>600)
    picture = [self imageWithImage:picture scaledToSize:CGSizeMake([picture size].width*(600/[picture size].width), [picture size].height*(600/[picture size].height))];
    
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
    if ([sender isEqual:_passwordConfirmationTextField])
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
