//
//  YTViewController.m
//  YTBloothChat
//
//  Created by 黄 伟华 on 3/31/14.
//  Copyright (c) 2014 黄伟华. All rights reserved.
//

#import "YTViewController.h"
#import <GameKit/GameKit.h>
#import "YTPickerManager.h"
#import "YTSessionInstance.h"
#import "YTChatListController.h"
#import "AWCollectionViewDialLayout.h"

#import <AVFoundation/AVFoundation.h>
#import "YTPhotoViewController.h"

#import "YTDataCut.h"
#import "SevenSwitch.h"
@interface YTViewController () <GKPeerPickerDelegate,UIAlertViewDelegate>
{
    YTChatListController    * _chatListController;
    YTPhotoViewController   * _photoPickerController;
}
@property (nonatomic, strong) YTPickerManager * pickerManager;
@end



@implementation YTViewController
{

}

/**
 *  设置 navigationbar 语音开关按钮
 */
-(void)configVoiceSwitchBar
{
    
    SevenSwitch *mySwitch2 = [[SevenSwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    mySwitch2.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.5 - 80);
    [mySwitch2 addTarget:self action:@selector(voiceStateChange:) forControlEvents:UIControlEventValueChanged];
    mySwitch2.offImage = [UIImage imageNamed:@"cross.png"];
    mySwitch2.onImage = [UIImage imageNamed:@"check-1.png"];
    mySwitch2.onColor = [UIColor colorWithHue:0.08f saturation:0.74f brightness:1.00f alpha:1.00f];
    mySwitch2.isRounded = YES;
    mySwitch2.on = NO;
    _switch = mySwitch2;
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:_switch];
    UINavigationItem * naviItem = self.navigationItem;
    [naviItem setRightBarButtonItem:item];
    return;

}
//- (void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    
//    NSString * chatImage = NSLocalizedString(@"Chat_Button_Normal", nil);
//    
//    [_chatButton setBackgroundImage:LoadImageFromBundle(chatImage, @"png") forState:UIControlStateNormal];
//    
//    NSString * photoImage = NSLocalizedString(@"File_Button_Normal", nil);
//    
//    [_photoButton setBackgroundImage:LoadImageFromBundle(photoImage, @"png") forState:UIControlStateNormal];
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"UnMatch_Name",nil);
    self.screenName = kGaHomeScreenName;
    
    
    
    //设置语音开关按钮
    [self configVoiceSwitchBar];
    
    [_switch setOn:NO];
    
    if(YT_NEED_ADMOB)
    {
        // add adMob View
        
        
        _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        float bottom = CGRectGetMaxY(self.view.bounds);
        
        float space = 0.f;
        if (!IOS7) {
            space = 44.f;
        }
        _bannerView.frame = CGRectMake(0, bottom-kGADAdSizeBanner.size.height-space, kGADAdSizeBanner.size.width, kGADAdSizeBanner.size.height);
        _bannerView.adUnitID = GA_ADMOB_AdID;
        _bannerView.rootViewController = self;
        [self.view addSubview:_bannerView];
        
        // 启动一般性请求并在其中加载广告。
        GADRequest * request = [GADRequest request];
#ifdef DEBUG

        [request setTestDevices:@[GAD_SIMULATOR_ID]];
#endif
        
        [_bannerView loadRequest:request];
        
        
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
#pragma mark - 


/**
 *  开始连接蓝牙
 *
 *  @param sender void
 */
-(IBAction)startConnect:(id)sender
{
    
    if ([[YTPickerManager shareInstance] isConnecting])
    {
        
        NSString * content = NSLocalizedString(@"Disconnect_Alert", nil);
        NSString * cancel = NSLocalizedString(@"Cancel", nil);
        NSString * ok = NSLocalizedString(@"OK", nil);
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:content delegate:self cancelButtonTitle:cancel otherButtonTitles:ok, nil];
        [alert show];
        return;

    }
    
    
    kGaSendEvent(self.screenName,self.screenName,@"touch",@"连接蓝牙");
    

    
    if (!self.pickerManager) {
        YTPickerManager * manager = [YTPickerManager shareInstance];
        manager.delegate = self;

        self.pickerManager = manager;
    }
    
    //初始化 图片接收
    [YTDataCut shareInstance];
    
    
    [self.pickerManager startPicker];

}
-(IBAction)enterChat:(id)sender
{
 #ifndef DEBUG  //去除这个限制
//    if (![[YTPickerManager shareInstance] isConnecting]) {
//        NSString * content = NSLocalizedString(@"First_Connect", nil);
//        
//        AlertWithMessage(content);
//        return;
//    }
#endif
    

    
    kGaSendEvent(self.screenName,self.screenName,@"touch",@"进入聊天");

    
    if (!_chatListController) {
        _chatListController = [[YTChatListController alloc] init];

    }
    [self.navigationController pushViewController:_chatListController animated:YES];
    
    
}
-(IBAction)enterPhotoPicker:(id)sender
{
    
#ifndef DEBUG  //去除这个限制

//    if (![[YTPickerManager shareInstance] isConnecting]) {
//        
//        NSString * content = NSLocalizedString(@"First_Connect", nil);
//
//        AlertWithMessage(content);
//        return;
//    }
#endif
    kGaSendEvent(self.screenName,self.screenName,@"touch",@"进入图片");

    
    if (!_photoPickerController) {
        _photoPickerController = [[YTPhotoViewController alloc] initWithNibName:@"YTPhotoViewController" bundle:nil];
    }
    
    [self.navigationController pushViewController:_photoPickerController animated:YES];
}
#pragma mark - GKPeerPickerDelegate -
-(void)peerPick:(YTPickerManager *)peerManager infoInstance:(id<YTSessionProtocol>)instance state:(YTConnectState)state
{
    id<YTSessionProtocol>retainInstance = instance;
    
    NSLog(@"%s %d",__FUNCTION__,state);

    NSString * content = NSLocalizedString(@"Click_To_Match", nil);
    
    switch (state) {
        case YTConnectStateConnected:
        {
            [self checkVoiceState];
            
            [self setDisplayName:[retainInstance name]];
        }
            
            
            break;
        case YTConnectStateDisconnect:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:YT_DISCONNECTION_NOTIFICATION object:self];
            
             [self setDisplayName:content];
        }
           
            break;
        case YTConnectStateAvailable:
            
            [self setDisplayName:content];

            break;
        case YTConnectStateUnAvailable:
            
            [self setDisplayName:content];

            break;
        case YTConnectStateCancel:
            [self setDisplayName:content];
            break;

        default:
            [self setDisplayName:@"未知错误，赶紧处理"];
            break;
    }
}



#pragma mark - other
-(void)setDisplayName:(NSString *)title
{
    self.title = title;
    
    
    if ([[YTPickerManager shareInstance] isConnecting]) {
        
        NSString * content  = NSLocalizedString(@"Click_To_Disconnect", nil);
        [_stateButton setTitle:content forState:UIControlStateNormal];
        
    }else
    {
        NSString * content = NSLocalizedString(@"Click_To_Match", nil);
        [_stateButton setTitle:content forState:UIControlStateNormal];
    }
    
}

-(void)checkVoiceState
{
    BOOL isOn = _switch.isOn;
    BOOL isMirco = !isOn;
    [GKVoiceChatService defaultVoiceChatService].microphoneMuted = isMirco;

}

#pragma mark - events
-(void)voiceStateChange:(SevenSwitch *)changeSwitch
{
    
    NSString * action;
    action = changeSwitch.isOn?@"语音打开":@"语音关闭";
    kGaSendEvent(self.screenName,self.screenName,@"touch",action);

    
    if (changeSwitch.isOn)
    {
        NSLog(@"语音打开");
        [GKVoiceChatService defaultVoiceChatService].microphoneMuted = NO;
        
    }
    else
    {
        NSLog(@"语音关闭");
        [GKVoiceChatService defaultVoiceChatService].microphoneMuted = YES;
        
    }
}
#pragma mark - alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        
    }else{
        
        kGaSendEvent(self.screenName,self.screenName,@"touch",@"断开连接");

        [[YTPickerManager shareInstance] cancelConnnect];

    }
}
@end
