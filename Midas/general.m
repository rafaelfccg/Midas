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
            name = NSLocalizedString(@"Vidro", @"Vidro Categoria");
            break;
        case RequestCategoryMetal:
            name = NSLocalizedString(@"Metal", @"Metal Categoria");
            break;
        case RequestCategoryPapel:
            name = NSLocalizedString(@"Papel", @"Papel Categoria");
            break;
        case RequestCategoryPlastico:
            name = NSLocalizedString(@"Plástico", @"Plástico Categoria");
            break;
        case RequestCategoryOutros:
            name = NSLocalizedString(@"Outros", @"Outros Categoria");
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
            errorMessage = NSLocalizedString(@"Login ou senha inválidos.", @"Login ou senha inválidos Error Message");
            break;
        case 125:
            errorMessage = NSLocalizedString(@"Email inválido.", @"Email inválido Error Message");
            break;
        case 202:
            errorMessage = NSLocalizedString(@"Nome de usuário já está em uso.", @"Nome do Usuário em Uso Error Message");
            break;
        case 203:
            errorMessage = NSLocalizedString(@"O email já está em uso.", @"Email em Uso Error Message");
            break;
        case 100:
            errorMessage = NSLocalizedString(@"Erro na conexão.", @"Erro na Conexao Error Message");;
            break;
        default:
            errorMessage = error.userInfo[@"error"];
            break;
    }
    
    return errorMessage;
}