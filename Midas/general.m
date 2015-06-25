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
