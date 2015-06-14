//
//  MINovoPedidoDadosViewController.h
//  Midas
//
//  Created by Marcel de Siqueira Campos Rebouças on 6/13/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MINovoPedido.h"

@interface MINovoPedidoDadosViewController : UIViewController

@property MINovoPedido *novoPedido;
@property (weak, nonatomic) IBOutlet UILabel *categoryValueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;
@property (weak, nonatomic) IBOutlet UISwitch *rewardSwitch;
@property (weak, nonatomic) IBOutlet UITextField *rewardFirstTextField;
@property (weak, nonatomic) IBOutlet UITextField *rewardSecondTextField;
@end
