//
//  GA_Config.h
//  YTBloothChat
//
//  Created by 黄 伟华 on 4/18/14.
//  Copyright (c) 2014 黄伟华. All rights reserved.
//

#ifndef YTBloothChat_GA_Config_h
#define YTBloothChat_GA_Config_h

typedef double YTDouble;
typedef  unsigned int   YTUInt;

#define YT_NEED_ADMOB YES

static int enterCount = 0;//进入聊天界面次数， runloop =3次弹出一次广告
static int const runloop = 3;


#define ScreenSize      [[UIScreen mainScreen] bounds].size

#define LoadImageFromBundle(name , extension) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:extension]]
#define AlertWithMessage(msg) [[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show]

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define YT_COLOR_BLUE [UIColor colorWithRed:44/255.f green:153/255.f blue:227/255.f alpha:1]
#define IOS7 ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)





#import "GAIDictionaryBuilder.h"
// GA Id
static NSString *const kGaPropertyId = @"UA-50115377-1";
static NSString *const GA_ADMOB_AdID = @"a15354ea725253d";

static NSString *const kGaApplicationName = @"U And Me";
//screen name
static NSString *const kGaHomeScreenName = @"首页";
static NSString *const kGaPhotoScreenName = @"图片";
static NSString *const kGaChatScreenName = @"聊天";


//notification
static NSString * const YT_DISCONNECTION_NOTIFICATION = @"YT_DISCONNECTION_NOTIFICATION";






static void kGaSendEvent(NSString * category, NSString * screen,NSString * action,NSString * label)
{

    id tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:action value:label];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category action:action label:label value:nil] build]];
    [tracker set:action value:nil];
}
#endif
