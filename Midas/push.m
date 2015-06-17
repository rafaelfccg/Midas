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

#import "AppConstant.h"

#import "push.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
void ParsePushUserAssign(void)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	PFInstallation *installation = [PFInstallation currentInstallation];
	installation[PF_INSTALLATION_USER] = [PFUser currentUser];
	[installation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
	{
		if (error != nil)
		{
			NSLog(@"ParsePushUserAssign save error.");
		}
	}];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
void ParsePushUserResign(void)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	PFInstallation *installation = [PFInstallation currentInstallation];
	[installation removeObjectForKey:PF_INSTALLATION_USER];
	[installation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
	{
		if (error != nil)
		{
			NSLog(@"ParsePushUserResign save error.");
		}
	}];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
void SendPushNotification(NSString *chatId, MINegociation * chat, NSString *text)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	PFUser *user = [PFUser currentUser];
	NSString *message = [NSString stringWithFormat:@"%@: %@", user.username, text];

	PFQuery *query1 = [PFQuery queryWithClassName:PF_RECENT_CLASS_NAME];
	[query1 whereKey:PF_RECENT_CHATID equalTo:chatId];
    PFQuery *queryInstallation = [PFInstallation query];
    
    if([user.objectId isEqualToString:chat.owner.objectId]){
        //[query1 whereKey:PF_RECENT_REQUESTOWNER equalTo:user];
        [queryInstallation whereKey:PF_INSTALLATION_USER matchesKey:PF_RECENT_REQUESTGIVER inQuery:query1];
    }else{
        //[query1 whereKey:PF_RECENT_REQUESTGIVER equalTo:user];
        [queryInstallation whereKey:PF_INSTALLATION_USER matchesKey:PF_RECENT_REQUESTOWNER inQuery:query1];
    }
	PFPush *push = [[PFPush alloc] init];
	[push setQuery:queryInstallation];
	[push setMessage:message];
	[push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
	{
		if (error != nil)
		{
			NSLog(@"SendPushNotification send error.,%@",error);
		}
	}];
}
