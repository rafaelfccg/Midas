//
//  MIPedidoDetalhadoViewController.h
//  Midas
//
//  Created by Rafael Gouveia on 6/9/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIPedido.h"

@interface MIPedidoDetalhadoViewController : UIViewController

@property MIPedido * currentRequest;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *forEachLabel;
@property (weak, nonatomic) IBOutlet UILabel *willGiveLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;
@property (weak, nonatomic) IBOutlet UIButton *closeRequestButton;

@end
