//
//  MIMuralCellControllerTableViewCell.m
//  Midas
//
//  Created by Frederica Teixeira on 10/06/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "MIMuralCellControllerTableViewCell.h"

@implementation MIMuralCellControllerTableViewCell


- (void)awakeFromNib {
    // Initialization code
    [self.layer setCornerRadius:7.0f];
    [self.layer setMasksToBounds:YES];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
