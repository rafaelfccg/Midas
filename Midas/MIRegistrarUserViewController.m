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
    
    UIBarButtonItem *concluir = [[UIBarButtonItem alloc]
                                      initWithTitle:@"Registrar!"
                                      style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(actionRegister:)];
    self.navigationItem.rightBarButtonItem = concluir;


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
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:nil otherButtonTitles:@"Foto da Galeria",@"Foto da Camera", nil];
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


- (void)actionRegister:(id)sender
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
    if ([login length] < 4)		{ [ProgressHUD showError:@"O login deve ter pelo menos 4 caracteres."]; return; }
    if ([login length] > 20)	{ [ProgressHUD showError:@"O login deve ter menos de 20 caracteres."]; return; }
    if ([email length] == 0)	{ [ProgressHUD showError:@"Email é obrigatório."]; return; }
    if ([password length] < 6)	{ [ProgressHUD showError:@"A senha deve ter pelo menos 6 caracteres."]; return; }
    if ([password length] > 30)	{ [ProgressHUD showError:@"A senha deve ter menos de 30 caracteres."]; return; }
    if (![password isEqualToString:passwordConfirmation]) { [ProgressHUD showError:@"As senhas devem ser iguais."]; return; }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    
     [[MIDatabase sharedInstance] signUpWithUsernameInBackground:login password:password email:email ProfileImage:file block:^(BOOL succeeded, NSError *error)
     {
         if (error == nil)
         {
             ParsePushUserAssign();
             [ProgressHUD showSuccess:@"Succeed."];
             [self dismissViewControllerAnimated:YES completion:nil];
         }
         else [ProgressHUD showError:error.userInfo[@"error"]];
     }];
}

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    picture = info[UIImagePickerControllerEditedImage];

    if([picture size].width>600 || [picture size].height>600)
    picture = [self imageWithImage:picture scaledToSize:CGSizeMake([picture size].width*(600/[picture size].width), [picture size].height*(600/[picture size].height))];
    
    self.imageView.image = self.picture;
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
