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
#import "PFUser+Util.h"

#import "AppConstant.h"

#import "recent.h"
#import "MIPedido.h"

//------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------//-------------------------------------------------------------------------------------------------------------------------------------------------
void CreateRecentItem(PFUser *user, NSString *groupId, MIPedido * pedido, NSString *description)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	PFQuery *query = [PFQuery queryWithClassName:PF_RECENT_CLASS_NAME];
	[query whereKey:PF_RECENT_REQUESTOWNER equalTo:user];
	[query whereKey:PF_RECENT_CHATID equalTo:groupId];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
	{
		if (error == nil)
		{
			if ([objects count] == 0)
			{
				PFObject *recent = [PFObject objectWithClassName:PF_RECENT_CLASS_NAME];
				recent[PF_RECENT_RECENTUSER] = user;
				recent[PF_RECENT_CHATID] = groupId;
				recent[PF_RECENT_REQUESTOWNER] = pedido.owner;
				recent[PF_RECENT_DESCRIPTION] = description;
				recent[PF_RECENT_REQUESTGIVER] = [PFUser currentUser];
				recent[PF_RECENT_LASTMESSAGE] = @"";
				recent[PF_RECENT_COUNTER] = @0;
				recent[PF_RECENT_UPDATEDACTION] = [NSDate date];
                recent[PF_RECENT_REQUESTID] = pedido.object.objectId;
                
				[recent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
				{
					if (error != nil) NSLog(@"CreateRecentItem save error.");
				}];
			}
		}
		else NSLog(@"CreateRecentItem query error.");
	}];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
void UpdateRecentCounter(NSString *groupId, NSInteger amount, NSString *lastMessage)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	PFQuery *query = [PFQuery queryWithClassName:PF_RECENT_CLASS_NAME];
	[query whereKey:PF_RECENT_CHATID equalTo:groupId];
	[query includeKey:PF_RECENT_REQUESTOWNER];
	[query setLimit:1000];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
	{
		if (error == nil)
		{
			for (PFObject *recent in objects)
			{
				if ([recent[PF_RECENT_REQUESTOWNER] isEqualTo:[PFUser currentUser]] == NO)
					[recent incrementKey:PF_RECENT_COUNTER byAmount:[NSNumber numberWithInteger:amount]];
				//---------------------------------------------------------------------------------------------------------------------------------
				recent[PF_RECENT_REQUESTGIVER] = [PFUser currentUser];
				recent[PF_RECENT_LASTMESSAGE] = lastMessage;
				recent[PF_RECENT_UPDATEDACTION] = [NSDate date];
				[recent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
				{
					if (error != nil) NSLog(@"UpdateRecentCounter save error.");
				}];
			}
		}
		else NSLog(@"UpdateRecentCounter query error.");
	}];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
void ClearRecentCounter(NSString *groupId)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	PFQuery *query = [PFQuery queryWithClassName:PF_RECENT_CLASS_NAME];
	[query whereKey:PF_RECENT_CHATID equalTo:groupId];
	[query whereKey:PF_RECENT_REQUESTOWNER equalTo:[PFUser currentUser]];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
	{
		if (error == nil)
		{
			for (PFObject *recent in objects)
			{
				recent[PF_RECENT_COUNTER] = @0;
				[recent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
				{
					if (error != nil) NSLog(@"ClearRecentCounter save error.");
				}];
			}
		}
		else NSLog(@"ClearRecentCounter query error.");
	}];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
void DeleteRecentItems(PFUser *user1, PFUser *user2)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	PFQuery *query = [PFQuery queryWithClassName:PF_RECENT_CLASS_NAME];
	[query whereKey:PF_RECENT_REQUESTOWNER equalTo:user1];
	[query whereKey:PF_RECENT_MEMBERS equalTo:user2.objectId];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
	{
		if (error == nil)
		{
			for (PFObject *recent in objects)
			{
				[recent deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
				{
					if (error != nil) NSLog(@"DeleteMessageItem delete error.");
				}];
			}
		}
		else NSLog(@"DeleteMessages query error.");
	}];
}
