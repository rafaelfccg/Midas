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

@interface MIConfiguracoesViewController ()

@end

@implementation MIConfiguracoesViewController
@synthesize picture;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:@"Log out" otherButtonTitles:nil];
    [action showFromTabBar:[[self tabBarController] tabBar]];
}

#pragma mark - UIActionSheetDelegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        [PFUser logOut];
        ParsePushUserResign();
        PostNotification(NOTIFICATION_USER_LOGGED_OUT);
        LoginUser(self);
    }
}

- (IBAction)galeryButton:(id)sender {
    self.picture = nil;
    PresentPhotoLibrary(self, YES);
}

- (IBAction)cameraButton:(id)sender {
    self.picture = nil;
    PresentPhotoCamera(self, YES);
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


@end
