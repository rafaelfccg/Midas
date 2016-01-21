//
//  MIMuralCellControllerTableViewCell.h
//  Midas
//
//  Created by Frederica Teixeira on 10/06/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import "MIPedido.h"
#import "MIDatabase.h"
#import "general.h"

@interface MIMuralCellControllerTableViewCell : UITableViewCell


@property (nonatomic, weak) IBOutlet UIImageView *pedidoImage;
@property (nonatomic, weak) IBOutlet UIImageView *tipoImage;
@property (nonatomic, weak) IBOutlet UIImageView *usuarioImage;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundLocaleImage;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundTipoImage;
@property (weak, nonatomic) IBOutlet UIImageView *localeImage;
@property (weak, nonatomic) IBOutlet UIImageView *localNoImage;


@property (nonatomic, weak) IBOutlet UILabel *pedidoLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinoLabel;
@property (nonatomic, weak) IBOutlet UILabel *distLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipoLabel;


@property (weak, nonatomic) IBOutlet UIView *pedidoView;

@property (nonatomic) MIPedido *request;

- (void)bindData:(MIPedido *)request;

@end
