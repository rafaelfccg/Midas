//
//  MIConfiguracoesViewController.m
//  Midas
//
//  Created by Rafael Gouveia on 6/9/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#import "MIConfiguracoesViewController.h"
#import "MIDatabase.h"
#import "common.h"
#import "camera.h"


@interface MIConfiguracoesViewController (){

    MKPointAnnotation * addressPoint;
}

@property UIActionSheet *logoutSheet;
@property UIActionSheet *selectImageSheet;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MIConfiguracoesViewController
@synthesize picture;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.mapView.zoomEnabled = NO;
    self.mapView.scrollEnabled = NO;
    self.mapView.userInteractionEnabled = NO;
        //[MIDatabase sharedInstance]
    //imageView.image
    
    
    UITapGestureRecognizer *imageTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedGallery:)];
    [self.imageView setUserInteractionEnabled:YES];
    [self.imageView addGestureRecognizer:imageTapRecognizer];
}

-(void)viewDidAppear:(BOOL)animated{
    [self.mapView removeAnnotation:addressPoint];
    PFUser* user = [PFUser currentUser];
    PFGeoPoint * point = user[PF_USER_LOCATION];
    
    CLLocationCoordinate2D localeAt = {point.latitude,point.longitude};
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(localeAt, 400, 400);
    
    [self.mapView setRegion:viewRegion animated:NO];
    addressPoint = [[MKPointAnnotation alloc]init];
    addressPoint.coordinate = localeAt;
    [self.mapView addAnnotation:addressPoint];
    
    PFFile * image = user[PF_USER_IMAGE];
    
    if (image) {
        [[MIDatabase sharedInstance] loadPFFile:image WithBlock:^(UIImage *PFUI_NULLABLE_S uiimage,  NSError *PFUI_NULLABLE_S error){
            
            self.imageView.image = uiimage;
            
        }];
    }
    self.imageView.layer.cornerRadius = self.imageView.bounds.size.width/2;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imageView.layer.borderWidth = 3;
    
    self.nome.text = user[PF_USER_USERNAME];
    self.Address.text = user[PF_USER_ADDRESS];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(id)sender {
    [self actionLogout];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)actionLogout
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    self.logoutSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel"
                                     destructiveButtonTitle:@"Log out" otherButtonTitles:nil];
    [self.logoutSheet showFromTabBar:[[self tabBarController] tabBar]];
}

#pragma mark - UIActionSheetDelegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    if(actionSheet==self.logoutSheet)
    {
        if (buttonIndex != actionSheet.cancelButtonIndex)
        {
            [PFUser logOut];
            ParsePushUserResign();
            PostNotification(NOTIFICATION_USER_LOGGED_OUT);
            LoginUser(self);
        }
    }
    
    if(actionSheet == self.selectImageSheet)
    {
        if (buttonIndex == 0){
            PresentPhotoLibrary(self, YES);
        }else if(buttonIndex ==1){
            PresentPhotoCamera(self, YES);
        }
    }
}

- (void)pressedGallery:(id)sender {
    self.selectImageSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:nil otherButtonTitles:@"Foto da Galeria",@"Foto da Camera", nil];
    [self.selectImageSheet showFromTabBar:[[self tabBarController] tabBar]];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    if(self.picture != nil)
    {
        //upload image of user
        
        PFUser *user = [PFUser currentUser];
        PFFile * file = nil;
        
        file = [PFFile fileWithData:UIImagePNGRepresentation(self.picture)];
        
        user[PF_USER_IMAGE] = file;
        //[user setObject:file forKey:PF_USER_IMAGE];
        
        [user saveInBackground];
        NSLog(@"salvando");
        //[user save];
        //[[self navigationController]popToRootViewControllerAnimated:YES];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.picture = info[UIImagePickerControllerEditedImage];
    
    if([picture size].width>600 || [picture size].height>600)
        picture = [self imageWithImage:picture scaledToSize:CGSizeMake([picture size].width*(600/[picture size].width), [picture size].height*(600/[picture size].height))];
    
    self.imageView.image = self.picture;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(UIImage*)imageWithImage:(UIImage*)image
             scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If the annotation is the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKPinAnnotationView*    pinView = (MKPinAnnotationView*)[mapView
                                                           dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = YES;
            
        }else
            pinView.annotation = annotation;
        
        //pinView.image = [UIImage imageNamed:@"GPSIcon"];
        return pinView;
    }
    return nil;
}


@end
