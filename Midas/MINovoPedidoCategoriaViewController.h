//
//  MINovoPedidoCategoriaViewController.h
//  Midas
//
//  Created by Marcel de Siqueira Campos Rebouças on 6/13/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MINovoPedido.h"

@interface MINovoPedidoCategoriaViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property MINovoPedido *novoPedido;
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@end
