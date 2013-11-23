//
//  SMJSONKeys.h
//  SinaMBlog
//
//  Created by Lee jimney on 7/31/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#ifndef SinaMBlog_SMJSONKeys_h
#define SinaMBlog_SMJSONKeys_h

//==========================================================================
// 每条微博信息
#define JSON_STATUS_LIST           @"statuses"
#define JSON_STATUS @"status"
#define JSON_STATUS_CREATED_AT @"created_at"
#define JSON_STATUS_ID @"id"
#define JSON_STATUS_MID @"mid"
#define JSON_STATUS_IDSTR @"idstr"
#define JSON_STATUS_TEXT @"text"
#define JSON_STATUS_SOURCE @"source"
#define JSON_STATUS_FAVORITED @"favorited"
#define JSON_STATUS_TRUNCATED @"truncated"
#define JSON_STATUS_IN_REPLY_TO_STATUS_ID @"in_reply_to_status_id"
#define JSON_STATUS_IN_REPLY_TO_USER_ID @"in_reply_to_user_id"
#define JSON_STATUS_IN_REPLY_TO_SCREEN_NAME @"in_reply_to_screen_name"
#define JSON_STATUS_THUMBNAIL_PIC @"thumbnail_pic"
#define JSON_STATUS_BMIDDLE_PIC @"bmiddle_pic"
#define JSON_STATUS_ORIGINAL_PIC @"original_pic"
#define JSON_STATUS_GEO @"geo"
#define JSON_STATUS_USER @"user"
#define JSON_STATUS_RETWEEDTED_STATUS @"retweeted_status"
#define JSON_STATUS_REPOSTS_COUNT @"rt"
#define JSON_STATUS_COMMENTS_COUNT @"comments"
#define JSON_STATUS_ATTITUDES_COUNT @"attitudes_count"
#define JSON_STATUS_MLEVEL @"mlevel"
#define JSON_STATUS_VISIBLE @"visible"

//==========================================================================
// 用户信息
#define JSON_USERINFO_USERID @"uid"
#define JSON_USERINFO_IDSTR @"idstr"
#define JSON_USERINFO_SCREEN_NAME @"screen_name"
#define JSON_USERINFO_NAME @"name"
#define JSON_USERINFO_GENDER @"gender"
#define JSON_USERINFO_PROVINCE @"province"
#define JSON_USERINFO_LOCATION @"location"
#define JSON_USERINFO_DESCRIPTION @"description"
#define JSON_USERINFO_URL @"url"
#define JSON_USERINFO_PROFILE_IMAGE_URL @"profile_image_url"
#define JSON_USERINFO_PROFILE_URL @"profile_url"
#define JSON_USERINFO_FOLLOWERS_COUNT @"followers_count"
#define JSON_USERINFO_FRIENDS_COUNT @"friends_count"
#define JSON_USERINFO_STATUSES_COUNT @"statuses_count"
#define JSON_USERINFO_FAVOURITES_COUNT @"favourites_count"
#define JSON_USERINFO_FOLLOWING @"following"
#define JSON_USERINFO_FOLLOW_ME @"follow_me"

//==========================================================================
// 话题信息
#define JSON_TREND_LIST @"trends"

#endif
