//
//  MIMuralCellControllerTableViewCell.h
//  Midas
//
//  Created by Frederica Teixeira on 10/06/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIMuralCellControllerTableViewCell : UITableViewCell


@property (nonatomic, weak) IBOutlet UIImageView *pedidoImage;
@property (nonatomic, weak) IBOutlet UIImageView *tipoImage;
@property (nonatomic, weak) IBOutlet UIImageView *usuarioImage;
@property (weak, nonatomic) IBOutlet UIImageView *doadorImage;


@property (nonatomic, weak) IBOutlet UILabel *pedidoLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantidadeLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinoLabel;
@property (nonatomic, weak) IBOutlet UILabel *distLabel;

@end
