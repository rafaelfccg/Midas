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
#define		DEFAULT_TAB							0

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
#define		PF_USER_PICTURE						@"picture"				//	File
//-----------------------------------------------------------------------
#define		PF_MESSAGE_CLASS_NAME				@"Message"				//	Class name
#define		PF_MESSAGE_USER						@"user"					//	Pointer to User Class
#define		PF_MESSAGE_CHATID					@"chatId"				//	String
#define		PF_MESSAGE_TEXT						@"text"					//	String
#define		PF_MESSAGE_PICTURE					@"picture"				//	File
#define		PF_MESSAGE_CREATEDAT				@"createdAt"			//	Date
//-----------------------------------------------------------------------
#define		PF_REQUEST_CLASS_NAME				@"Request"				//	Class name
#define		PF_REQUEST_USER						@"user"                 //	Pointer to User Class
#define		PF_REQUEST_CREATEDAT                @"createdAt"            //	Date
#define		PF_REQUEST_TITLE                    @"title"                //	String
#define		PF_REQUEST_DESCRIPTION              @"description"          //	String
#define		PF_REQUEST_REWARD                   @"reward"               //	String
#define		PF_REQUEST_QUANTITY                 @"quantity"             //	Number
#define		PF_REQUEST_IMAGE                    @"image"                //	File
#define		PF_REQUEST_STATUS                   @"status"               //	Number
#define		PF_REQUEST_FEEDBACKID               @"feedBackId"           //	String

//-----------------------------------------------------------------------
#define		PF_CHAT_CLASS_NAME                  @"Chat"                 //	Class name
#define		PF_CHAT_REQUESTOWNER				@"requestOwner"			//	Pointer to User Class
#define		PF_CHAT_REQUESTID					@"requestId"			//	String
//-----------------------------------------------------------------------
//----------------------------------------
#define		NOTIFICATION_APP_STARTED			@"NCAppStarted"
#define		NOTIFICATION_USER_LOGGED_IN			@"NCUserLoggedIn"
#define		NOTIFICATION_USER_LOGGED_OUT		@"NCUserLoggedOut"


#endif
