//
//  MITermosDeUsoViewController.m
//  Midas
//
//  Created by Marcel de Siqueira Campos Rebouças on 7/17/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "MITermosDeUsoViewController.h"

@interface MITermosDeUsoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation MITermosDeUsoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _titleLabel.text = _titleText;
    _contentTextView.text = _contentText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    //scroll to top
    [self.contentTextView setContentOffset:CGPointZero animated:NO];
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
