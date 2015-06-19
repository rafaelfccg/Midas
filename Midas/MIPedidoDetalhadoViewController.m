//
//  MIPedidoDetalhadoViewController.m
//  Midas
//
//  Created by Rafael Gouveia on 6/9/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "MIPedidoDetalhadoViewController.h"
#import "MINovoPedidoDadosViewController.h"
#import "MIFinalizarPedidoViewController.h"
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

@end

@implementation MIPedidoDetalhadoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _goToChat = NO;
    [self.closeRequestButton.layer setCornerRadius:7.0f];
    [self.closeRequestButton.layer setMasksToBounds:YES];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    
    if ([self.currentRequest.owner.objectId isEqualToString:[PFUser currentUser].objectId]) {
        UIBarButtonItem *editarButton = [[UIBarButtonItem alloc]
                                         initWithTitle:@"Editar"
                                         style:UIBarButtonItemStylePlain
                                         target:self
                                         action:@selector(editarPedido:)];
        self.navigationItem.rightBarButtonItem = editarButton;
        
    
    } else {
        UIBarButtonItem *euTenhoButton = [[UIBarButtonItem alloc]
                                          initWithTitle:@"Eu tenho!"
                                          style:UIBarButtonItemStylePlain
                                          target:self
                                          action:@selector(iniciarNegociacao:)];
        self.navigationItem.rightBarButtonItem = euTenhoButton;
        
        self.closeRequestButton.hidden = YES;
    }
    
    NSLog(@"A cada %@, dou %@.", _currentRequest.forEach, _currentRequest.willGive);
    self.userName.text = self.currentRequest.owner.username;
    self.forEachLabel.text = [NSString stringWithFormat:@"%@ %@", self.currentRequest.forEachValue, self.currentRequest.forEach];
    self.willGiveLabel.text = [NSString stringWithFormat:@"%@ %@", self.currentRequest.willGiveValue, self.currentRequest.willGive];
    self.descricaoLabel.text = self.currentRequest.descricao;
    
    [self.descricaoLabel addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
    
    self.categoryImage.image = getCategoryIcon(self.currentRequest.category);

}

-(void) viewWillDisappear:(BOOL)animated{
    [self.descricaoLabel removeObserver:self forKeyPath:@"contentSize"];
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
                         CreateRecentItem([PFUser currentUser], _temporaryObjectID, _currentRequest, _currentRequest.forEach);
                         [self performSegueWithIdentifier:@"FromInfoToChatSegue" sender:self];

                     
                     }else{
                         [ProgressHUD showError:@"Network error."];
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
         else [ProgressHUD showError:@"Network error."];
         
     }];
    }

- (void) editarPedido:(id)sender {
    MINovoPedidoDadosViewController *epvc = (MINovoPedidoDadosViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"novoPedidoScreen"];
    epvc.novoPedido = [[MINovoPedido alloc ] initWithMIPedido:self.currentRequest];
    [self.navigationController showViewController:epvc sender:self];
}

-(IBAction)finalizarPedido:(id)sender {
    [self performSegueWithIdentifier:@"FromMeuPedidoToFinalizarSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"FromInfoToChatSegue"])
    {
        MIChatViewController *vc = [segue destinationViewController];
        vc.chatId = _temporaryObjectID;
        vc.neg  = _chat;
    } else if ([[segue identifier] isEqualToString:@"FromMeuPedidoToFinalizarSegue"])
    {
        MIFinalizarPedidoViewController *vc = [segue destinationViewController];
        vc.currentRequest = self.currentRequest;
        
    }

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UITextView *txtview = object;
    CGFloat topoffset = ([txtview bounds].size.height - [txtview contentSize].height * [txtview zoomScale])/2.0;
    topoffset = ( topoffset < 0.0 ? 0.0 : topoffset );
    txtview.contentOffset = (CGPoint){.x = 0, .y = -topoffset};
}


@end
