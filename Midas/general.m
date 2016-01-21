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
            image = [UIImage imageNamed:@"glass"];
            break;
        case RequestCategoryMetal:
            image = [UIImage imageNamed:@"metal"];
            break;
        case RequestCategoryPapel:
            image = [UIImage imageNamed:@"paper"];
            break;
        case RequestCategoryPlastico:
            image = [UIImage imageNamed:@"plastic"];
            break;
        case RequestCategoryOutros:
            image = [UIImage imageNamed:@"other"];
            break;
        default:
            image = [UIImage imageNamed:@"other"];
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

NSString *getTermosDeUso() {

    NSString *termos = @"1. O Midas não é fornecedor de quaisquer produtos ou serviços anunciados nem se responsabiliza pelas trocas oferecidas pelos usuários. O Midas presta um serviço consistente na oferta de uma plataforma que fornece espaços para que usuários anunciem e possam negociar direta e exclusivamente entre si; \n\n 2. Os usuários só poderão oferecer serviços/produtos como recompensa que possam cumprir diretamente com os termos do anúncio e todas as suas características; \n\n 3. Para utilizar os serviços do Midas, o usuário deverá efetuar um cadastro único, criando um login e senha que são pessoais e intransferíveis. O Midas não se responsabiliza pelo uso inadequado e divulgação destes dados para terceiros. O Midas, nem quaisquer de seus empregados ou prepostos solicitará, por qualquer meio, físico ou eletrônico, que seja informada sua senha; \n\n 4. O Midas, em razão de violação à legislação em vigor ou aos termos gerais de uso do M.das, conforme a situação, poderá, sem prejuízo de outras medidas, recusar qualquer solicitação de cadastro, advertir, suspender, temporária ou definitivamente, a conta de um usuário e seus anúncios; \n\n 5. Não é permitido anunciar produtos expressamente proibidos pela legislação vigente ou pelos Termos e condições gerais de uso do app, que não possuam a devida autorização específica de órgãos reguladores competentes, ou que violem direitos de terceiros;";
    
    return termos;

}