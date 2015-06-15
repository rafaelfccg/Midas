//
//  MIEditarEnderecoViewController.h
//  Midas
//
//  Created by vinicius emanuel on 15/06/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationUtils.h"

@interface MIEditarEnderecoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *cidadeTextField;
@property (weak, nonatomic) IBOutlet UITextField *bairroTextField;
@property (weak, nonatomic) IBOutlet UITextField *ruaTextField;
@property (weak, nonatomic) IBOutlet UITextField *numeroTextField;

@end
