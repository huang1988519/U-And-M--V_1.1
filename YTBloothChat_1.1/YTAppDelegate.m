//
//  YTAppDelegate.m
//  YTBloothChat
//
//  Created by 黄 伟华 on 3/31/14.
//  Copyright (c) 2014 黄伟华. All rights reserved.
//

#import "YTAppDelegate.h"


@implementation YTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    
    [self initializeGoogleAnalytics];

    

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    kGaSendEvent(kGaApplicationName, kGaApplicationName, @"App Cycle", @"applicationDidEnterBackground");

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    kGaSendEvent(kGaApplicationName, kGaApplicationName, @"App Cycle", @"applicationDidBecomeActive");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
        kGaSendEvent(kGaApplicationName, kGaApplicationName, @"App Cycle", @"applicationWillTerminate");
}
#pragma mark - config GA
- (void)initializeGoogleAnalytics{
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelError];
    
    [[GAI sharedInstance] setDispatchInterval:30];
    //默认发送数据
    [[GAI sharedInstance] setDryRun:NO];
    self.tracker = [[GAI sharedInstance] trackerWithTrackingId:kGaPropertyId];
}
@end
