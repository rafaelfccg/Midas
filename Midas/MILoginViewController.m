//
//  MILoginViewController.m
//  Midas
//
//  Created by vinicius emanuel on 10/06/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "MILoginViewController.h"
#import "MIDatabase.h"
#import "general.h"

@interface MILoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *fieldUsername;
@property (weak, nonatomic) IBOutlet UITextField *fieldPassword;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property float keyboardHeight;
@property BOOL isUp;
@end

@implementation MILoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"Midas", @"App Name");
    
    self.fieldUsername.autocorrectionType = UITextAutocorrectionTypeNo;
    
    [self.loginButton.layer setCornerRadius:7.0f];
    [self.loginButton.layer setMasksToBounds:YES];
    
    [self.registerButton.layer setCornerRadius:7.0f];
    [self.registerButton.layer setMasksToBounds:YES];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;

    _isUp = NO;
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
    if ([username length] == 0)	{ [ProgressHUD showError:NSLocalizedString(@"Login é um campo obrigatório.", @"Login Obrigatorio")]; return; }
    if ([password length] == 0)	{ [ProgressHUD showError:NSLocalizedString(@"Senha é um campo obrigatório.", @"senha obrigatória")]; return; }
    //---------------------------------------------------------------------------------------------------------------------------------------------
    [ProgressHUD show:NSLocalizedString(@"Logando...", @"Logando Message") Interaction:NO];
    [[MIDatabase sharedInstance] logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error)
     {
         if (user != nil)
         {
             ParsePushUserAssign();
             [ProgressHUD showSuccess:[NSString stringWithFormat:NSLocalizedString(@"Bem-vindo, %@!", @"Bem-vindo Message"), user.username]];
             [self performSegueWithIdentifier:@"loginToMuralSegue" sender:self];
            }
         else{
             NSLog(@"%@", error.userInfo[@"error"]);
             NSString *errorMessage = localizeErrorMessage(error);
            [ProgressHUD showError:errorMessage];
         }
     }];
}



-(void) viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)registrarAction:(id)sender {
     [self performSegueWithIdentifier:@"FromLoginToRegistrar" sender:self];
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
@end
