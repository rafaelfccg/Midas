//
//  general.m
//  Midas
//
//  Created by Marcel de Siqueira Campos Rebouças on 6/18/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "general.h"


UIImage * getCategoryIcon(NSNumber *categoryNumber)
{
    UIImage *image;
    
    switch ([categoryNumber intValue]) {
        case RequestCategoryVidro:
            image = [UIImage imageNamed:@"VidroIcon"];
            break;
        case RequestCategoryMetal:
            image = [UIImage imageNamed:@"MetalIcon"];
            break;
        case RequestCategoryPapel:
            image = [UIImage imageNamed:@"PapelIcon"];
            break;
        case RequestCategoryPlastico:
            image = [UIImage imageNamed:@"PlasticoIcon"];
            break;
        case RequestCategoryOutros:
            image = [UIImage imageNamed:@"OutrosIcon"];
            break;
        default:
            image = [UIImage imageNamed:@"OutrosIcon"];
            break;
    }
    return image;
}

NSString * getCategoryName(NSNumber *categoryNumber)
{
    NSString *name;
    
    switch ([categoryNumber intValue]) {
        case RequestCategoryVidro:
            name = @"Vidro";
            break;
        case RequestCategoryMetal:
            name = @"Metal";
            break;
        case RequestCategoryPapel:
            name = @"Papel";
            break;
        case RequestCategoryPlastico:
            name = @"Plástico";
            break;
        case RequestCategoryOutros:
            name = @"Outros";
            break;
        default:
            name = @"";
            break;
    }
    return name;
}


NSString *localizeErrorMessage(NSError *error) {
    
    NSString *errorMessage;
    switch (error.code) {
        case 101:
            errorMessage = @"Login ou senha inválidos.";
            break;
        case 125:
            errorMessage = @"Email inválido.";
            break;
        case 202:
            errorMessage = @"Nome de usuário já está em uso.";
            break;
        case 203:
            errorMessage = @"O email já está em uso.";
            break;
        case 100:
            errorMessage = @"Erro na conexão.";
            break;
        default:
            errorMessage = error.userInfo[@"error"];
            break;
    }
    
    return errorMessage;
}