//
//  MIConfiguracoesViewController.h
//  Midas
//
//  Created by Rafael Gouveia on 6/9/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface MIConfiguracoesViewController : UIViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate,MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property UIImage *picture;
@property (weak, nonatomic) IBOutlet UILabel *nome;
@property (weak, nonatomic) IBOutlet UILabel *Address;

@end
