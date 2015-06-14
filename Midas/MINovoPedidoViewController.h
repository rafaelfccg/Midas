//
//  MINovoPedidoViewController.h
//  Midas
//
//  Created by Rafael Gouveia on 6/9/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MINovoPedido.h"

@interface MINovoPedidoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *galleryButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property MINovoPedido *novoPedido;
@end
