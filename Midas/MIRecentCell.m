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
#import "MIDatabase.h"

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
           
            [[MIDatabase sharedInstance] loadPFFile:giver[PF_USER_IMAGE] WithBlock:^(UIImage *PFUI_NULLABLE_S image,  NSError *PFUI_NULLABLE_S error){
                if (image){
                    imageUser.image = image;
                }
                
            }];
        }
        
    }else{
        if(owns[PF_USER_IMAGE]){
            [[MIDatabase sharedInstance] loadPFFile:owns[PF_USER_IMAGE] WithBlock:^(UIImage *PFUI_NULLABLE_S image,  NSError *PFUI_NULLABLE_S error){
                if (image){
                    imageUser.image = image;
                }
                
            }];
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
    
    self.recent = recent_;
}

# pragma mark - Acessibility
- (NSString *)accessibilityLabel
{
    
    NSString *username = @"";
    NSString *messageCount = @"";
    
    PFUser * user = [PFUser currentUser];
    PFUser * owns = recent[PF_RECENT_REQUESTOWNER];
    if ([[PFUser currentUser].objectId isEqualToString:owns.objectId]) {
        username = recent[PF_RECENT_REQUESTGIVER][PF_USER_USERNAME];
    }else{
        username = owns.username;
    }

    int counter = [recent[PF_RECENT_COUNTER] intValue];
    
    
    if (counter == 0){
        messageCount = @"Nenhuma mensagem nova.";
    } else if (counter == 1){
        messageCount = @"Uma nova mensagem.";
    } else {
        messageCount = [NSString stringWithFormat:@"%d novas mensagens.",counter];
    }
    
    NSString *content = _recent[PF_RECENT_DESCRIPTION];
    
    return [NSString stringWithFormat:@"Negociação com %@. Sobre %@. %@", username, content, messageCount];
}

@end
