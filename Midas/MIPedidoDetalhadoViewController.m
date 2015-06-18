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
#import "recent.h"
#import "MINegociation.h"


@interface MIPedidoDetalhadoViewController (){
   
}

@property NSString *temporaryObjectID;
@property  MINegociation * chat ;

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
    NSLog(@"A cada %@, dou %@.", _currentRequest.forEach, _currentRequest.willGive);
}

- (void) iniciarNegociacao:(id)sender {
     [[MIDatabase sharedInstance] getChatOwnerToGiverFromRequest:_currentRequest withBlock:^(NSArray *objects, NSError *error)
     {
         if (error == nil)
         {
             PFObject *object = [PFObject objectWithClassName:PF_CHAT_CLASS_NAME];
             if (objects == nil | [objects count] ==0) {
                 
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
    
             }else if([objects count] ==1){
                 PFObject* chat=  [objects objectAtIndex:0];
                 _temporaryObjectID = chat.objectId;
                 _chat = [[MINegociation alloc]initWithPFObject:chat];

                 
                 [self performSegueWithIdentifier:@"FromInfoToChatSegue" sender:self];
             }else{
                 NSLog (@"%ld",[objects count]);
             }
             
             
             
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
        vc.neg  = _chat;
        
    }
}



@end
