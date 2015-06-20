//
//  MINovoPedidoDadosViewController.h
//  Midas
//
//  Created by Marcel de Siqueira Campos Rebouças on 6/13/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MINovoPedido.h"
#import <Parse/Parse.h>

@interface MINovoPedidoDadosViewController : UIViewController<UIActionSheetDelegate>

@property MINovoPedido *novoPedido;
@property (weak, nonatomic) IBOutlet UILabel *categoryValueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;
@property (weak, nonatomic) IBOutlet UITextField *rewardFirstTextField;
@property (weak, nonatomic) IBOutlet UITextField *forEachValueTextField;
@property (weak, nonatomic) IBOutlet UITextField *rewardSecondTextField;
@property (weak, nonatomic) IBOutlet UITextField *willGiveValueTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property PFGeoPoint * location;

@end
