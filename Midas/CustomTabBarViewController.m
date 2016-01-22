//
//  CustomTabBarViewController.m
//  Midas
//
//  Created by Marcel de Siqueira Campos Rebouças on 6/25/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "CustomTabBarViewController.h"

@interface CustomTabBarViewController ()
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

@end

@implementation CustomTabBarViewController

@synthesize tabBar;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UITabBarItem *item0 = [[self.tabBar items] objectAtIndex:0];
    item0.accessibilityLabel = @"Mural";
    UITabBarItem *item1 = [[self.tabBar items] objectAtIndex:1];
    item1.accessibilityLabel = @"Meus Pedidos";
    UITabBarItem *item2 = [[self.tabBar items] objectAtIndex:2];
    item2.accessibilityLabel = @"Perfil";
    // Do any additional setup after loading the view.
    
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
        vc.title = nil;
        vc.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
