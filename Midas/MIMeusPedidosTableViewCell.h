//
//  MIMeusPedidosTableViewCell.h
//  Midas
//
//  Created by Frederica Teixeira on 17/06/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIPedido.h"

@interface MIMeusPedidosTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *meuPedidoImage;
@property (weak, nonatomic) IBOutlet UIImageView *categoriaIcon;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundTipoImage;
@property (weak, nonatomic) IBOutlet UIImageView *minhaImage;

@property (weak, nonatomic) IBOutlet UILabel *trocaLabel;
@property (weak, nonatomic) IBOutlet UILabel *meuPedidoLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipoLabel;


@property (weak, nonatomic) IBOutlet UIView *pedidoView;

@property (weak, nonatomic) MIPedido *request;

- (void)bindData:(MIPedido *)request;
@end
