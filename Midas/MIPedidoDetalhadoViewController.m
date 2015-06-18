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
#import "general.h"


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
                         CreateRecentItem([PFUser currentUser], _temporaryObjectID, _currentRequest, @"Negocia");
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

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UITextView *txtview = object;
    CGFloat topoffset = ([txtview bounds].size.height - [txtview contentSize].height * [txtview zoomScale])/2.0;
    topoffset = ( topoffset < 0.0 ? 0.0 : topoffset );
    txtview.contentOffset = (CGPoint){.x = 0, .y = -topoffset};
}


@end
