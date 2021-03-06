//
//  MIRegistrarUserViewController.h
//  Midas
//
//  Created by Marcel de Siqueira Campos Rebouças on 6/10/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIRegistrarUserViewController : UIViewController <UIImagePickerControllerDelegate,UIActionSheetDelegate,UIPopoverPresentationControllerDelegate >

@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmationTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *registrarButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property UIImage *picture;
@end
