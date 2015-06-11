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
    [_nameTextField becomeFirstResponder];
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
    NSString *email		= [_emailTextField.text lowercaseString];
    NSString *fullname		= _nameTextField.text;
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    if ([fullname length] < 3)	{ [ProgressHUD showError:@"Name is too short."]; return; }
    if ([login length] < 4)		{ [ProgressHUD showError:@"Login is too short."]; return; }
    if ([password length] == 0)	{ [ProgressHUD showError:@"Password must be set."]; return; }
    if ([email length] == 0)	{ [ProgressHUD showError:@"Email must be set."]; return; }
    //---------------------------------------------------------------------------------------------------------------------------------------------
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    
     [[MIDatabase sharedInstance] signUpWithUsernameInBackground:login password:password email:email fullName:fullname block:^(BOOL succeeded, NSError *error)
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
