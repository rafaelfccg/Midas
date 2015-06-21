//
//  MILoginViewController.m
//  Midas
//
//  Created by vinicius emanuel on 10/06/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "MILoginViewController.h"
#import "MIDatabase.h"

@interface MILoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *fieldUsername;
@property (weak, nonatomic) IBOutlet UITextField *fieldPassword;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation MILoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Midas";
    
    [self.loginButton.layer setCornerRadius:7.0f];
    [self.loginButton.layer setMasksToBounds:YES];
    
    [self.registerButton.layer setCornerRadius:7.0f];
    [self.registerButton.layer setMasksToBounds:YES];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    //if already logged in
    
    NSLog(@"%@",[PFUser currentUser]);
    
    if ([PFUser currentUser] != nil)
    {
        [self performSegueWithIdentifier:@"loginToMuralSegue" sender:self];
    }
}

- (IBAction)loginAction:(id)sender {
    [self actionLogin];
}

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}


- (void)actionLogin
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    NSString *username = [_fieldUsername.text lowercaseString];
    NSString *password = _fieldPassword.text;
    //---------------------------------------------------------------------------------------------------------------------------------------------
    if ([username length] == 0)	{ [ProgressHUD showError:@"Login é um campo obrigatório."]; return; }
    if ([password length] == 0)	{ [ProgressHUD showError:@"Senha é um campo obrigatório."]; return; }
    //---------------------------------------------------------------------------------------------------------------------------------------------
    [ProgressHUD show:@"Signing in..." Interaction:NO];
    [[MIDatabase sharedInstance] logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error)
     {
         if (user != nil)
         {
             ParsePushUserAssign();
             [ProgressHUD showSuccess:[NSString stringWithFormat:@"Bem-vindo, %@!", user.username]];
             [self performSegueWithIdentifier:@"loginToMuralSegue" sender:self];
            }
             else [ProgressHUD showError:error.userInfo[@"error"]];
     }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)registrarAction:(id)sender {
     [self performSegueWithIdentifier:@"FromLoginToRegistrar" sender:self];
}

@end
