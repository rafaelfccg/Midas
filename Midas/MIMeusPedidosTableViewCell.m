  //
  //  MIMeusPedidosTableViewCell.m
  //  Midas
  //
  //  Created by Frederica Teixeira on 17/06/15.
  //  Copyright (c) 2015 rfccg. All rights reserved.
  //

  #import "MIMeusPedidosTableViewCell.h"
  #import "MIDatabase.h"
  #import "general.h"
  @implementation MIMeusPedidosTableViewCell

  - (void)awakeFromNib {
    // Initialization code
    [self.layer setCornerRadius:7.0f];
    [self.layer setMasksToBounds:YES];
    self.layer.borderColor = [UIColor orangeColor].CGColor;
    self.layer.borderWidth = 1.5;
    
    [_pedidoView.layer setCornerRadius:10.f];
    [_pedidoView.layer setMasksToBounds:YES];
    _pedidoView.layer.borderColor = [UIColor orangeColor].CGColor;
    _pedidoView.layer.borderWidth = 1.5;
    
    
  }

  - (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
  }

  - (void) bindData:(MIPedido *)request {
    _meuPedidoLabel.text = [NSString stringWithFormat:@"%@ %@", request.forEachValue,request.forEach];
    _trocaLabel.text = [NSString stringWithFormat:@"%@ %@", request.willGiveValue, request.willGive];
    _categoriaIcon.image = getCategoryIcon(request.category);
    _tipoLabel.text = getCategoryName(request.category);
    
    _minhaImage.clipsToBounds = YES;
    _minhaImage.layer.cornerRadius = _minhaImage.frame.size.width/2.0f;
    
    [_backgroundTipoImage.layer setMasksToBounds:YES];
    [_backgroundTipoImage.layer setCornerRadius:_backgroundTipoImage.frame.size.height/2];
    
    //CARREGA A IMAGEM DO PEDIDO
    if (request.imageFile) {
      [[MIDatabase sharedInstance] loadPFFile:request.imageFile WithBlock:^(UIImage *PFUI_NULLABLE_S image,  NSError *PFUI_NULLABLE_S error){
        
        request.image = image;
        _meuPedidoImage.image = image;
        
      }];
    }
    
    //CARREGA A IMAGEM DO USUARIO ATUAL
    if ([PFUser currentUser][PF_USER_IMAGE]) {
      [[MIDatabase sharedInstance] loadPFFile:([PFUser currentUser][PF_USER_IMAGE]) WithBlock:^(UIImage *PFUI_NULLABLE_S image,  NSError *PFUI_NULLABLE_S error){
        
        _minhaImage.image = image;
        
      }];
    }
    
    _request = request;
    
  }

  # pragma mark - Acessibility
  - (NSString *)accessibilityLabel
  {
    NSNumber *willGiveValue = _request.willGiveValue;
    NSString *willGive = _request.willGive;
    NSNumber *forEachValue = _request.forEachValue;
    NSString *forEach = _request.forEach;
    NSString *category = getCategoryName(_request.category);
    
    return [NSString stringWithFormat:@"Você está dando %@ %@, a cada %@ %@. Categoria: %@.", willGiveValue, willGive, forEachValue, forEach, category];
  }
  @end
