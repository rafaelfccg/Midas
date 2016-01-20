//
//  MIStickerContainerView.m
//  Midas
//
//  Created by Luis Barroso on 20/01/16.
//  Copyright © 2016 rfccg. All rights reserved.
//

#import "MIStickerContainerView.h"


@interface MIStickerContainerView()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation MIStickerContainerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithFrame:(CGRect)frame
{
  
  self = [super initWithFrame:frame];
  
  NSArray * nib = [[NSBundle mainBundle]
                   loadNibNamed: @"MIStickerContainerView"
                   owner: self
                   options: nil];
  
  self = [nib objectAtIndex:0];
  
  return self;
  
  
  
}

@end
