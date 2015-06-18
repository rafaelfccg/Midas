//
// Copyright (c) 2015 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

#import "AppConstant.h"
#import "converter.h"

#import "MIRecentCell.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface MIRecentCell()
{
	PFObject *recent;
}

@property (strong, nonatomic) IBOutlet PFImageView *imageUser;
@property (strong, nonatomic) IBOutlet UILabel *labelDescription;
@property (strong, nonatomic) IBOutlet UILabel *labelLastMessage;
@property (strong, nonatomic) IBOutlet UILabel *labelElapsed;
@property (strong, nonatomic) IBOutlet UILabel *labelCounter;

@end
//-------------------------------------------------------------------------------------------------------------------------------------------------

@implementation MIRecentCell

@synthesize imageUser;
@synthesize labelDescription, labelLastMessage;
@synthesize labelElapsed, labelCounter;

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)bindData:(PFObject *)recent_
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	recent = recent_;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	imageUser.layer.cornerRadius = imageUser.frame.size.width/2;
	imageUser.layer.masksToBounds = YES;
	//---------------------------------------------------------------------------------------------------------------------------------------------
    PFUser * user = [PFUser currentUser];
    PFUser * owns = recent[PF_RECENT_REQUESTOWNER];
    if ([user.objectId isEqualToString:owns.objectId]) {
        PFUser* giver = recent[PF_RECENT_REQUESTGIVER];
        if(giver[PF_USER_IMAGE]){
           
            [imageUser setFile:giver[PF_USER_IMAGE]];
            [imageUser loadInBackground];
        }
        
    }else{
        if(owns[PF_USER_IMAGE]){
            [imageUser setFile:owns[PF_USER_IMAGE]];
            [imageUser loadInBackground];
        }
    
    }
	//PFUser *lastUser = recent[PF_RECENT_RECENTUSER];
	
	//---------------------------------------------------------------------------------------------------------------------------------------------
	labelDescription.text = recent[PF_RECENT_DESCRIPTION];
	labelLastMessage.text = recent[PF_RECENT_LASTMESSAGE];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	NSTimeInterval seconds = [[NSDate date] timeIntervalSinceDate:recent[PF_RECENT_UPDATEDACTION]];
	labelElapsed.text = TimeElapsed(seconds);
	//---------------------------------------------------------------------------------------------------------------------------------------------
	int counter = [recent[PF_RECENT_COUNTER] intValue];
	labelCounter.text = (counter == 0) ? @"" : [NSString stringWithFormat:@"%d new", counter];
}

@end
