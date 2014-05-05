//
//  YTViewController.h
//  YTBloothChat
//
//  Created by 黄 伟华 on 3/31/14.
//  Copyright (c) 2014 黄伟华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"
@class GKPeerPickerController,SevenSwitch;
@interface YTViewController : GAITrackedViewController
{
    IBOutlet UIButton         * _stateButton;
    IBOutlet UIButton         * _chatButton;
    IBOutlet UIButton         * _photoButton;
    
    
    SevenSwitch * _switch;
    
    // adMob 广告
    GADBannerView *_bannerView;
}
-(IBAction)startConnect:(id)sender;
-(IBAction)enterChat:(id)sender;
-(IBAction)enterPhotoPicker:(id)sender;
@end
