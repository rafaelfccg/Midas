//
//  MIRecuperarSenhaViewController.m
//  Midas
//
//  Created by Marcel de Siqueira Campos Rebouças on 1/20/16.
//  Copyright © 2016 rfccg. All rights reserved.
//

#import "MIRecuperarSenhaViewController.h"
#import "MIDatabase.h"
#import "ProgressHUD.h"
#import "general.h"

@interface MIRecuperarSenhaViewController ()

@property (weak, nonatomic) IBOutlet UIButton *recuperarButton;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UILabel *recuperarSenhaLabel;

@end

@implementation MIRecuperarSenhaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.recuperarButton setTitle:NSLocalizedString(@"Recuperar", @"Recuperar") forState:UIControlStateNormal];
    [self.recuperarSenhaLabel setText:NSLocalizedString(@"Recuperar Senha", @"RecuperarSenha")];
    
    
    [self.recuperarButton.layer setCornerRadius:7.0f];
    [self.recuperarButton.layer setMasksToBounds:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)recuperarSenha:(id)sender {
    
    NSString* email = self.emailField.text;
    
    if (email == nil) {
        email = @"";
    }
    
    
    [PFUser requestPasswordResetForEmailInBackground: email block:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded)
        {
            [ProgressHUD showSuccess:[NSString stringWithFormat:NSLocalizedString(@"E-mail de confirmação enviado com sucesso!", @"E-mail de confirmação enviado com sucesso")]];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            NSLog(@"%@", error.userInfo[@"error"]);
            NSString *errorMessage = localizeErrorMessage(error);
            [ProgressHUD showError:errorMessage];
        }
    }];
    
   
}

@end
