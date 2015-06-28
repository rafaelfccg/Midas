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
@property BOOL isUp;
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
    if ([username length] == 0)	{ [ProgressHUD showError:@"Login é um campo obrigatório."]; return; }
    if ([password length] == 0)	{ [ProgressHUD showError:@"Senha é um campo obrigatório."]; return; }
    //---------------------------------------------------------------------------------------------------------------------------------------------
    [ProgressHUD show:@"Logando..." Interaction:NO];
    [[MIDatabase sharedInstance] logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error)
     {
         if (user != nil)
         {
             ParsePushUserAssign();
             [ProgressHUD showSuccess:[NSString stringWithFormat:@"Bem-vindo, %@!", user.username]];
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
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
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

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        if (!_isUp) {
            [self setViewMovedUp:YES];
            _isUp = YES;
        };
    }
    else if (self.view.frame.origin.y < 0)
    {
//        if (_isUp){
//            [self setViewMovedUp:NO];
//            _isUp = NO;
//        }
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
//        if (!_isUp)
//        {
//            [self setViewMovedUp:YES];
//            _isUp = true;
//        }
    }
    else if (self.view.frame.origin.y < 0)
    {
        if (_isUp)
        {
            [self setViewMovedUp:NO];
            _isUp = false;
        }
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    //if ([sender isEqual:_descriptionTextView])
    //{
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    //}
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
