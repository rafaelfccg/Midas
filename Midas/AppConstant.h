//
//  AppConstant.h
//  Midas
//
//  Created by Rafael Gouveia on 6/10/15.
//  Copyright (c) 2015 rfccg. All rights reserved.
//

#ifndef Midas_AppConstant_h
#define Midas_AppConstant_h


//-------------------------------------------------------------------------------------------------------------------------------------------------
#define HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0]

#define		DEFAULT_TAB							0
#define kOFFSET_FOR_KEYBOARD 216.0

#define		COLOR_OUTGOING						HEXCOLOR(0xF7A46BFF)
#define		COLOR_INCOMING						HEXCOLOR(0xC6C6C6FF)
#define		COLOR_TABBAR						HEXCOLOR(0xE58B48FF)
#define		COLOR_BACKGROUND					HEXCOLOR(0xE8E8E8FF)
//-------------------------------------------------------------------------------------------------------------------------------------------------
#define		PF_INSTALLATION_CLASS_NAME			@"_Installation"		//	Class name
#define		PF_INSTALLATION_OBJECTID			@"objectId"				//	String
#define		PF_INSTALLATION_USER				@"user"					//	Pointer to User Class
//-----------------------------------------------------------------------
#define		PF_USER_CLASS_NAME					@"_User"				//	Class name
#define		PF_USER_OBJECTID					@"objectId"				//	String
#define		PF_USER_USERNAME					@"username"				//	String
#define		PF_USER_PASSWORD					@"password"				//	String
#define     PF_USER_AUTH_DATA                   @"authData"             //  authData
#define		PF_USER_EMAIL						@"email"				//	String
#define		PF_USER_EMAILVERIFIED				@"emailVerified"		//	Boolean
#define		PF_USER_FULLNAME					@"fullName"				//	String
#define		PF_USER_LOCATION					@"location"             //	GeoPoint
#define		PF_USER_FACEBOOKID					@"facebookId"			//	String
#define		PF_USER_IMAGE						@"image"				//	File
#define     PF_USER_THUMBNAIL                   @"thumbnail"            //  File
#define     PF_USER_ADDRESS                     @"Address"              //  string
//-----------------------------------------------------------------------
#define		PF_MESSAGE_CLASS_NAME				@"Message"				//	Class name
#define		PF_MESSAGE_USER						@"user"					//	Pointer to User Class
#define		PF_MESSAGE_CHATID					@"chatId"				//	String
#define		PF_MESSAGE_TEXT						@"text"					//	String
#define		PF_MESSAGE_IMAGE					@"image"				//	File
#define		PF_MESSAGE_CREATEDAT				@"createdAt"			//	Date
//-----------------------------------------------------------------------
#define		PF_REQUEST_CLASS_NAME				@"Request"				//	Class name
#define		PF_REQUEST_OBJECTID					@"objectId"				//	String
#define		PF_REQUEST_USER						@"user"                 //	Pointer to User Class
#define		PF_REQUEST_CREATEDAT                @"createdAt"            //	Date
#define		PF_REQUEST_DESCRIPTION              @"description"          //	String
#define     PF_REQUEST_CATEGORY                 @"category"             //  Number
#define		PF_REQUEST_IMAGE                    @"image"                //	File
#define		PF_REQUEST_THUMBNAIL                @"thumbnail"            //	File
#define		PF_REQUEST_STATUS                   @"status"               //	Number
#define		PF_REQUEST_FEEDBACKID               @"feedBackId"           //	String
#define		PF_REQUEST_UPDATEDACTION			@"updatedAt"            //	Date
#define		PF_REQUEST_FOREACH                  @"foreach"              //	String
#define		PF_REQUEST_WILLGIVE                 @"willgive"             //	String
#define		PF_REQUEST_FOREACHVALUE             @"foreachValue"         //	Number
#define		PF_REQUEST_WILLGIVEVALUE            @"willgiveValue"        //	Number
#define		PF_REQUEST_USERLOCATION             @"userLocation"         //	GeoPoint
#define     PF_REQUEST_OBJECTID                 @"objectId"             //  string

//-----------------------------------------------------------------------
#define		PF_CHAT_CLASS_NAME                  @"Chat"                 //	Class name
#define		PF_CHAT_REQUESTOWNER				@"requestOwner"			//	Pointer to User Class
#define		PF_CHAT_REQUESTID					@"requestId"			//	String
#define		PF_CHAT_REQUESTGIVER				@"requestGiver"			//	String
#define     PF_CHAT_OBJECTID                    @"objectId"             //  String

//-----------------------------------------------------------------------
#define		PF_RECENT_CLASS_NAME				@"Recent"				//	Class name
#define		PF_RECENT_REQUESTOWNER				@"requestOwner"			//	Pointer to User Class
#define		PF_RECENT_CHATID					@"chatId"				//	String
#define		PF_RECENT_MEMBERS					@"members"				//	Array
#define		PF_RECENT_DESCRIPTION				@"description"			//	String
#define		PF_RECENT_REQUESTGIVER				@"requestGiver"			//	Pointer to User Class
#define		PF_RECENT_LASTMESSAGE				@"lastMessage"			//	String
#define		PF_RECENT_COUNTER					@"counter"				//	Number
#define		PF_RECENT_UPDATEDACTION				@"updatedAction"		//	Date
#define     PF_RECENT_RECENTUSER                @"recentUser"           // Pointer
#define     PF_RECENT_REQUESTID                 @"requestId"            // Pointer

//-----------------------------------------------------------------------
#define		PF_INAPPROPRIATE_CONTENT_CLASS_NAME                 @"InappropriateContent"				//	Class name
#define		PF_INAPPROPRIATE_CONTENT_OBJECTID                   @"objectId"                         //  String
#define		PF_INAPPROPRIATE_CONTENT_REQUEST                    @"Request"                          //	Pointer to Request Class
#define		PF_INAPPROPRIATE_CONTENT_USER_WHO_FLAGGED_CONTENT	@"UserWhoFlaggedContent"			//	Pointer to User Class
#define		PF_INAPPROPRIATE_CONTENT_STATUS                     @"Status"                           //	Number
#define		PF_INAPPROPRIATE_CONTENT_REQUESTID                     @"requestId"                           //	Request

#define     ENUM_INAPPROPRIATE_CONTENT_STATUS_OPEN                                  @0
#define     ENUM_INAPPROPRIATE_CONTENT_STATUS_MARKED_AS_INAPPROPRIATE               @1
#define     ENUM_INAPPROPRIATE_CONTENT_STATUS_MARKED_AS_NOT_INAPPROPRIATE		    @2

//-----------------------------------------------------------------------
#define		PF_INAPPROPRIATE_USER_CLASS_NAME                 @"InappropriateUser"                   //	Class name
#define		PF_INAPPROPRIATE_USER_OBJECTID                   @"objectId"                            //  String
#define		PF_INAPPROPRIATE_USER_WHO_FLAGGED_CONTENT        @"UserWhoFlaggedReported"              //	Pointer to User Class
#define		PF_INAPPROPRIATE_USER_WHO_RECIVE_CONTENT         @"UserWhoRecivereported"               //	Pointer to User Class
#define		PF_INAPPROPRIATE_USER_STATUS                     @"Status"                              //	Number

#define     ENUM_INAPPROPRIATE_USER_STATUS_OPEN                                     @0
#define     ENUM_INAPPROPRIATE_USER_STATUS_MARKED_AS_INAPPROPRIATE                  @1
#define     ENUM_INAPPROPRIATE_USER_STATUS_MARKED_AS_NOT_INAPPROPRIATE              @2

//----------------------------------------
#define     PF_BLOCKED_USER_RELATION                                  @"BlockedUserRelation"         //	Class name
#define     PF_BLOCKED_USER_RELATION_USER1                            @"User1"                       //	Pointer to User Class
#define     PF_BLOCKED_USER_RELATION_USER2                            @"User2"                       //	Pointer to User Class
//----------------------------------------
#define		NOTIFICATION_APP_STARTED			@"NCAppStarted"
#define		NOTIFICATION_USER_LOGGED_IN			@"NCUserLoggedIn"
#define		NOTIFICATION_USER_LOGGED_OUT		@"NCUserLoggedOut"
//----------------------------------------
#define     ENUM_REQUEST_STATUS_OPEN		    @0
#define     ENUM_REQUEST_STATUS_FINALIZED		@1
#define     ENUM_REQUEST_STATUS_HIDDEN		    @2

//----------------------------------------
#define     ENUM_REQUEST_CATEGORY_VIDRO		    @0
#define     ENUM_REQUEST_CATEGORY_PLASTICO	    @1
#define     ENUM_REQUEST_CATEGORY_PAPEL		    @2
#define     ENUM_REQUEST_CATEGORY_METAL         @3
#define     ENUM_REQUEST_CATEGORY_OUTROS	    @4

typedef enum {
    RequestCategoryVidro,
    RequestCategoryPlastico,
    RequestCategoryPapel,
    RequestCategoryMetal,
    RequestCategoryOutros
}RequestCategory;

#endif
