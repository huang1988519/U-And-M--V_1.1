//
//  YTChatListController.h
//  YTBloothChat
//
//  Created by 黄 伟华 on 3/31/14.
//  Copyright (c) 2014 黄伟华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSMessagesViewController.h"
#import "YTMessageInstance.h"
#import "GADInterstitial.h"
@interface YTChatListController : JSMessagesViewController
{
    GADInterstitial * _interstitialAd;
}
@end
