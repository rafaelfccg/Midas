//
//  MIMuralCellControllerTableViewCell.m
//  Midas
//
//  Created by Frederica Teixeira on 10/06/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "MIMuralCellControllerTableViewCell.h"
#import "general.h"

@implementation MIMuralCellControllerTableViewCell


- (void)awakeFromNib {
    // Initialization code
    [self.layer setCornerRadius:7.0f];
    [self.layer setMasksToBounds:YES];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindData:(MIPedido *)request
{
    _pedidoLabel.text = [NSString stringWithFormat:@"%@ %@", request.forEachValue,request.forEach];
    _destinoLabel.text = [NSString stringWithFormat:@"%@ %@", request.willGiveValue, request.willGive];
    PFUser * user = [PFUser currentUser];
    PFGeoPoint * point =  user[PF_USER_LOCATION];
    
    if(point && request.location){
        double val = [point distanceInKilometersTo:request.location];
        _distLabel.text = [NSString stringWithFormat:@"%.0lfkm",val];
    }else{
       _distLabel.text = [NSString stringWithFormat:@"--"];
    }
    
    _tipoImage.image = getCategoryIcon(request.category);
    
    _usuarioImage.clipsToBounds = YES;
    _usuarioImage.layer.cornerRadius = 22.5f;
    
    //CARREGA A IMAGEM DO PEDIDO
    if (request.imageFile) {
        [[MIDatabase sharedInstance] loadPFFile:request.imageFile WithBlock:^(UIImage *PFUI_NULLABLE_S image,  NSError *PFUI_NULLABLE_S error){
            
            request.image = image;
            _pedidoImage.image = image;
            
        }];
    }
    
    //CARREGA A IMAGEM DO DONO DO PEDIDO
    if (request.owner[PF_USER_IMAGE]) {
        [[MIDatabase sharedInstance] loadPFFile:request.owner[PF_USER_IMAGE] WithBlock:^(UIImage *PFUI_NULLABLE_S image,  NSError *PFUI_NULLABLE_S error){
            
            _usuarioImage.image = image;
            
        }];
    }
    
    _request = request;
}

# pragma mark - Acessibility
- (NSString *)accessibilityLabel
{

    NSString *ownerName = _request.owner.username;
    NSNumber *willGiveValue = _request.willGiveValue;
    NSString *willGive = _request.willGive;
    NSNumber *forEachValue = _request.forEachValue;
    NSString *forEach = _request.forEach;
    NSString *category = getCategoryName(_request.category);
   
    NSString *distancia = @"";
    PFGeoPoint * point =  [PFUser currentUser][PF_USER_LOCATION];
    if(point && _request.location){
        double val = [point distanceInKilometersTo:_request.location];
        distancia = [NSString stringWithFormat:@"%.0lfkm",val];
    }else{
        distancia = [NSString stringWithFormat:@"--"];
    }
    
    return [NSString stringWithFormat:@"O usuário %@ está dando %@ %@, a cada %@ %@. Categoria: %@. Distância: %@", ownerName, willGiveValue, willGive, forEachValue, forEach, category, distancia];
}


@end
