//
//  MIPedidoDetalhadoViewController.m
//  Midas
//
//  Created by Rafael Gouveia on 6/9/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "MIPedidoDetalhadoViewController.h"
#import "MINovoPedidoDadosViewController.h"
#import "MIChatViewController.h"
#import "MIDatabase.h"
#import "ProgressHUD.h"
#import "recent.h"
#import "general.h"
#import "MINegociation.h"
#import "MINovoPedido.h"


@interface MIPedidoDetalhadoViewController (){
    BOOL _goToChat;
}

@property NSString *temporaryObjectID;
@property  MINegociation * chat ;
@property (weak, nonatomic) IBOutlet UIView *containerViewVoceRecebe;
@property (weak, nonatomic) IBOutlet UIView *containerViewPor;
@property (weak, nonatomic) IBOutlet UILabel *voceRecebeNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *porNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *whyExchangeWithMeLabel;
@property (weak, nonatomic) IBOutlet UILabel *voceRecebeLabel;
@property (weak, nonatomic) IBOutlet UILabel *porLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@end

@implementation MIPedidoDetalhadoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _goToChat = NO;
    [self.closeRequestButton.layer setCornerRadius:self.closeRequestButton.bounds.size.height/2];
    [self.closeRequestButton.layer setMasksToBounds:YES];
    
    _userImage.clipsToBounds = YES;
    _userImage.layer.cornerRadius = 40.0f;
    _userImage.layer.borderColor = [UIColor whiteColor].CGColor;
    _userImage.layer.borderWidth = 3;
  
  

    
    [self.containerViewVoceRecebe.layer setCornerRadius:self.containerViewVoceRecebe.bounds.size.height/2];
    [self.containerViewVoceRecebe.layer setMasksToBounds:YES];
    
    [self.containerViewPor.layer setCornerRadius:self.containerViewPor.bounds.size.height/2];
    [self.containerViewPor.layer setMasksToBounds:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    
    if ([self.currentRequest.owner.objectId isEqualToString:[PFUser currentUser].objectId]) {
        UIBarButtonItem *editarButton = [[UIBarButtonItem alloc]
                                         initWithTitle:NSLocalizedString(@"Editar", @"Editar Button")
                                         style:UIBarButtonItemStylePlain
                                         target:self
                                         action:@selector(editarPedido:)];
        self.navigationItem.rightBarButtonItem = editarButton;
        
        self.heightConstraint.constant = 700;
        
        self.flagAsInappropriateButton.hidden = YES;
    
    } else {
        UIBarButtonItem *euTenhoButton = [[UIBarButtonItem alloc]
                                          initWithTitle:NSLocalizedString(@"Eu tenho!", @"Eu tenho! Button")
                                          style:UIBarButtonItemStylePlain
                                          target:self
                                          action:@selector(iniciarNegociacao:)];
        self.navigationItem.rightBarButtonItem = euTenhoButton;
        
        self.closeRequestButton.hidden = YES;
        
        self.heightConstraint.constant = 650;
    }
    
//    NSLog(@"A cada %@, dou %@.", _currentRequest.forEach, _currentRequest.willGive);
    self.userName.text = self.currentRequest.owner.username;
    self.porNumberLabel.text = [NSString stringWithFormat:@"%@", self.currentRequest.forEachValue];
    self.forEachLabel.text = self.currentRequest.forEach;
    
    self.voceRecebeNumberLabel.text = [NSString stringWithFormat:@"%@", self.currentRequest.willGiveValue];
    self.willGiveLabel.text = self.currentRequest.willGive;
    self.whyExchangeWithMeLabel.text = self.currentRequest.descricao;
    
    self.categoryImage.image = getCategoryIcon(self.currentRequest.category);
    self.categoryLabel.text = getCategoryName(self.currentRequest.category);
    
    [self.backgorundCategoryImage.layer setMasksToBounds:YES];
    [self.backgorundCategoryImage.layer setCornerRadius:self.backgorundCategoryImage.frame.size.height/2];
    
    self.backgroundImage.image = self.currentRequest.image;
    
    self.voceRecebeLabel.text = NSLocalizedString(@"Você recebe", @"Você recebe");
    self.porLabel.text = NSLocalizedString(@"Por", @"Por");
    
    //CARREGA A IMAGEM DO USUARIO
    if (self.currentRequest.owner[PF_USER_IMAGE]) {
        [[MIDatabase sharedInstance] loadPFFile:self.currentRequest.owner[PF_USER_IMAGE] WithBlock:^(UIImage *PFUI_NULLABLE_S image,  NSError *PFUI_NULLABLE_S error){
            
            _userImage.image = image;
            
        }];
    }

}

-(void) viewDidAppear:(BOOL)animated {
    _goToChat = NO;
}

- (void) iniciarNegociacao:(id)sender {
     [[MIDatabase sharedInstance] getChatOwnerToGiverFromRequest:_currentRequest withBlock:^(NSArray *objects, NSError *error)
     {
         if (error == nil)
         {
             PFObject *object = [PFObject objectWithClassName:PF_CHAT_CLASS_NAME];
             if (!_goToChat && (objects == nil || [objects count] ==0) ) {
                 _goToChat = YES;
                 object[PF_CHAT_REQUESTOWNER] = _currentRequest.owner;
                 object[PF_CHAT_REQUESTGIVER] = [PFUser currentUser];
                 object[PF_CHAT_REQUESTID] = _currentRequest.object.objectId;
                 [object saveInBackgroundWithBlock:^(BOOL success, NSError * error){
                     if(success){
                         _temporaryObjectID = object.objectId;
                         _chat = [[MINegociation alloc]initWithPFObject:object];
                         CreateRecentItem([PFUser currentUser], _temporaryObjectID, _currentRequest, [NSString stringWithFormat:@"%@ %@",_currentRequest.forEachValue,_currentRequest.forEach]);
                         [self performSegueWithIdentifier:@"FromInfoToChatSegue" sender:self];

                     
                     } else {
                         NSLog(@"%@", error.userInfo[@"error"]);
                         NSString *errorMessage = localizeErrorMessage(error);
                         [ProgressHUD showError:errorMessage];
                     }
                 }];
    
             }else if(!_goToChat && [objects count] ==1){
                 PFObject* chat=  [objects objectAtIndex:0];
                 _temporaryObjectID = chat.objectId;
                 _chat = [[MINegociation alloc]initWithPFObject:chat];
                 _goToChat = YES;
                 
                 [self performSegueWithIdentifier:@"FromInfoToChatSegue" sender:self];
             }else{
                 NSLog (@"%ld",[objects count]);
             }
         }
         else {
             NSLog(@"%@", error.userInfo[@"error"]);
             NSString *errorMessage = localizeErrorMessage(error);
             [ProgressHUD showError:errorMessage];
         }
         
     }];
    }

- (void) editarPedido:(id)sender {
    MINovoPedidoDadosViewController *epvc = (MINovoPedidoDadosViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"novoPedidoScreen"];
    epvc.novoPedido = [[MINovoPedido alloc ] initWithMIPedido:self.currentRequest];
    [self.navigationController showViewController:epvc sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"FromInfoToChatSegue"])
    {
        MIChatViewController *vc = [segue destinationViewController];
        vc.chatId = _temporaryObjectID;
        vc.neg  = _chat;
    }

}

-(IBAction)finalizarPedido:(id)sender {
    
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:NSLocalizedString(@"Finalizar Pedido", @"Finalizar Pedido Title")
                                          message:NSLocalizedString(@"Deseja realmente finalizar o pedido?", @"Confirmação Finalizar Pedido")                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancelar", @"Cancelar Action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"Sim", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [[MIDatabase sharedInstance] finalizeRequestWithPFObject:self.currentRequest.object
                                                                                      block:^(BOOL succeeded, NSError *error) {
                                                                                          
                                                                                          if(succeeded) {
                                                                                              [ProgressHUD showSuccess:[NSString stringWithFormat:NSLocalizedString(@"Pedido finalizado com sucesso!", @"Finalizar Pedido Sucesso")]];
                                                                                              [self.navigationController popToRootViewControllerAnimated:YES];
                                                                                          } else{
                                                                                              [ProgressHUD showError:error.userInfo[@"error"]];
                                                                                          }
                                                                                      }];

                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
   }


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UITextView *txtview = object;
    CGFloat topoffset = ([txtview bounds].size.height - [txtview contentSize].height * [txtview zoomScale])/2.0;
    topoffset = ( topoffset < 0.0 ? 0.0 : topoffset );
    txtview.contentOffset = (CGPoint){.x = 0, .y = -topoffset};
}

- (IBAction)flagAsInappropriate:(id)sender {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:NSLocalizedString(@"Denunciar conteúdo", @"Denunciar conteúdo Title")
                                          message:NSLocalizedString(@"Deseja denunciar o conteúdo desse pedido?", @"Deseja denunciar o conteúdo desse pedido?")                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancelar", @"Cancelar Action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"Denunciar", @"Denunciar action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   
                                   //first, check if already flagged
                                   [[MIDatabase sharedInstance] checkIfContentIsFlaggedAsInappropriateFromRequest:self.currentRequest withBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                                       
                                       NSLog(@"Count: %lu",objects.count);
                                       
                                       if (error) {
                                           [ProgressHUD showError:error.userInfo[@"error"]];
                                       } else if ([objects count] > 0) {
                                           [ProgressHUD showSuccess:[NSString stringWithFormat:NSLocalizedString(@"Você já denunciou esse post.", @"Você já denunciou esse post.")]];
                                       } else {
                                       
                                           //FLAG AS INAPPROPRIATE
                                           [[MIDatabase sharedInstance] markContentAsInappropriateFromRequest:self.currentRequest withBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                               if(succeeded) {
                                                   [ProgressHUD showSuccess:[NSString stringWithFormat:NSLocalizedString(@"Conteúdo enviado para análise. Obrigado.", @"Conteúdo denunciado. Obrigado por fazer o Midas melhor.")]];
                                               } else{
                                                   [ProgressHUD showError:error.userInfo[@"error"]];
                                               }
                                           }];
                                       
                                       }
                                       
                                   }];
                                 
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
