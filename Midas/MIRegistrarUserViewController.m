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
@implementation MIRegistrarUserViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;

}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidAppear:animated];
    [_loginTextField becomeFirstResponder];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)dismissKeyboard
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [self.view endEditing:YES];
}

#pragma mark - User actions

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionRegister
//-------------------------------------------------------------------------------------------------------------------------------------------------
{

    NSString *login     = _loginTextField.text;
    NSString *password	= _passwordTextField.text;
    NSString *passwordConfirmation	= _passwordConfirmationTextField.text;
    NSString *email		= [_emailTextField.text lowercaseString];
    
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
    
     [[MIDatabase sharedInstance] signUpWithUsernameInBackground:login password:password email:email block:^(BOOL succeeded, NSError *error)
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

- (IBAction)registerUser:(id)sender {
    [self actionRegister];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
