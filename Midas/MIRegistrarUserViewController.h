//
//  MIRegistrarUserViewController.h
//  Midas
//
//  Created by Marcel de Siqueira Campos Rebouças on 6/10/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIRegistrarUserViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmationTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end
