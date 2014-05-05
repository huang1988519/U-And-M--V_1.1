//
//  YTAppDelegate.h
//  YTBloothChat
//
//  Created by 黄 伟华 on 3/31/14.
//  Copyright (c) 2014 黄伟华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"

@class GAI;
@interface YTAppDelegate : UIResponder <UIApplicationDelegate>
{
    GADBannerView* _bannerView;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) id<GAITracker> tracker;
@end
