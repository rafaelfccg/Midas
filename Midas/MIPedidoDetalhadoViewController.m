//
//  MIPedidoDetalhadoViewController.m
//  Midas
//
//  Created by Rafael Gouveia on 6/9/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "MIPedidoDetalhadoViewController.h"
#import "MIChatViewController.h"
#import "MIDatabase.h"
#import "ProgressHUD.h"


@interface MIPedidoDetalhadoViewController ()

@property NSString *temporaryObjectID;

@end

@implementation MIPedidoDetalhadoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *euTenhoButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Eu tenho!"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(iniciarNegociacao:)];
    self.navigationItem.rightBarButtonItem = euTenhoButton;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    NSLog(@"Pedido detalhado: %@", self.currentRequest.title);
}

- (void) iniciarNegociacao:(id)sender {
     [[MIDatabase sharedInstance] getChatOwnerToGiverFromRequest:_currentRequest withBlock:^(NSArray *objects, NSError *error)
     {
         if (error == nil)
         {
             if (objects == nil | [objects count] ==0) {
                 PFObject *object = [PFObject objectWithClassName:PF_CHAT_CLASS_NAME];
                 object[PF_CHAT_REQUESTOWNER] = _currentRequest.owner;
                 object[PF_CHAT_REQUESTGIVER] = [PFUser currentUser];
                 object[PF_CHAT_REQUESTID] = _currentRequest.object.objectId;
                 if ([object save]) {
                     _temporaryObjectID = object.objectId;
                 }else{
                     [ProgressHUD showError:@"Network error."];
                     return ;
                 }
                 
    
             }else if([objects count] ==1){
                 PFObject* chat=  [objects objectAtIndex:0];
                 _temporaryObjectID = chat.objectId;
             }else{
                 NSLog (@"%ld",[objects count]);
             }
             [self performSegueWithIdentifier:@"FromInfoToChatSegue" sender:self];
            
             
         }
         else [ProgressHUD showError:@"Network error."];
         
     }];
    }


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"FromInfoToChatSegue"])
    {
        
        
        // Get reference to the destination view controller
        MIChatViewController *vc = [segue destinationViewController];
        vc.chatId = _temporaryObjectID;
        
    }
}



@end
