//
//  MeusPedidosViewController.h
//  Midas
//
//  Created by Rafael Gouveia on 6/9/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIMeusPedidosViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *pedidosTableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *pedidosSegmentedControl;
@property (nonatomic,retain) UIRefreshControl *refreshControl NS_AVAILABLE_IOS(6_0);
- (void)loadRecents;

@end
