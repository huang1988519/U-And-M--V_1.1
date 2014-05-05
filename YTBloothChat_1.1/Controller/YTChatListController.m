//
//  YTChatListController.m
//  YTBloothChat
//
//  Created by 黄 伟华 on 3/31/14.
//  Copyright (c) 2014 黄伟华. All rights reserved.
//

#import "YTChatListController.h"
#import "YFInputBar.h"
#import "YTPickerManager.h"
#import "YTAppDelegate.h"
@interface YTChatListController () <JSMessagesViewDelegate,JSMessagesViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,GADInterstitialDelegate>

@property (nonatomic, strong) NSMutableArray * messages;
@property (nonatomic, strong) NSMutableArray * sendTamps;
@end

@implementation YTChatListController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)popAdView
{
    if (YT_NEED_ADMOB) {
        
        
        _interstitialAd = [[GADInterstitial alloc] init];
        _interstitialAd.adUnitID = GA_ADMOB_AdID;
        _interstitialAd.delegate = self;
        [_interstitialAd loadRequest:[GADRequest request]];
    }
}
#pragma mark - menu bar

#pragma mark -  view controller cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [[YTPickerManager shareInstance] remoteName];
    
    self.screenName = kGaChatScreenName;
    
    if (IOS7) {
        [self.tableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
    }
    else
    {
    }
    
    [self setBackgroundImage:LoadImageFromBundle(@"YT_Back_Image", @"png")];
    
    self.title = [[[YTPickerManager shareInstance] gkSection] displayName];
    
    _messages  = [NSMutableArray array];
    _sendTamps = [NSMutableArray array];
    
    //聊天文本 源和 代理
    self.delegate = self;
    self.dataSource = self;
    

    //默认关闭 语音
//    [GKVoiceChatService defaultVoiceChatService].microphoneMuted = YES;

    
    

    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    [[YTPickerManager shareInstance] reciveMessage:^(NSData *reciveData,NSDictionary * info)
     {
         if (!reciveData) {
             return ;
         }
         NSDictionary * messageDic = [reciveData messageWithLongTamp];
         
         
         NSString * stampStr = messageDic[@"stamp"];
         NSTimeInterval time = [stampStr doubleValue];
         
         NSDate * date = [NSDate dateWithTimeIntervalSince1970:time];
         
         YTMessageInstance * instance = [[YTMessageInstance alloc]
                                         initWithMessage:messageDic[@"message"]
                                         date:date
                                         type:YTMessageTypeReceive
                                         sendImage:nil];
         [self.messages addObject:instance];
         
         [JSMessageSoundEffect playMessageReceivedSound];
         
         [self finishRecieved];
     }];
    
    NSLog(@"display Ad %d count",enterCount);
    if (enterCount%runloop==0)
    {
        [self popAdView];
    }
    enterCount++;

}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [YTPickerManager shareInstance].recevieBolck = nil;
}
- (UIButton *)sendButton
{
    return [UIButton defaultSendButton];
}

#pragma mark - tableiview

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_messages count];
}

#pragma mark - delegate
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    kGaSendEvent(self.screenName,self.screenName,@"touch",@"message");

    YTMessageInstance * instance = [[YTMessageInstance alloc] initWithMessage:text date:[NSDate date] type:YTMessageTypeSend
                                    sendImage:nil];
    [self.messages addObject:instance];
    
    
    [[YTPickerManager shareInstance] sendMessage:text dateTamp:[[NSDate date] timeIntervalSince1970]];
    
    [JSMessageSoundEffect playMessageSentSound];
    
    [self finishSend];
}
- (void)cameraPressed:(id)sender{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}
//消息来源
- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YTMessageInstance * instance = _messages[indexPath.row];
    
    YTMessageType messageType = [instance messageType];
    
    switch (messageType) {
        case YTMessageTypeReceive:
                return JSBubbleMessageTypeIncoming;
            break;
        case YTMessageTypeSend:
            return JSBubbleMessageTypeOutgoing;
            break;
        default:
            
            break;
    }
    
    return JSBubbleMessageTypeOutgoing;
}
/**
 *  
 JSBubbleMessageStyleDefault = 0,
 JSBubbleMessageStyleSquare,
 JSBubbleMessageStyleDefaultGreen,
 JSBubbleMessageStyleFlat
 消息样式
 *
 *  @param indexPath indexPath
 *
 *  @return 样式
 */
- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return JSBubbleMessageStyleSquare;
}
//显示时间戳方式
- (JSMessagesViewTimestampPolicy)timestampPolicy
{
    return JSMessagesViewTimestampPolicyEveryThree;
}

//显示头像策略
- (JSMessagesViewAvatarPolicy)avatarPolicy
{
    return JSMessagesViewAvatarPolicyBoth;
}
//头像类型
- (JSAvatarStyle)avatarStyle
{
    return JSAvatarStyleSquare;
}
- (JSBubbleMediaType)messageMediaTypeForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YTMessageInstance * instance = _messages[indexPath.row];
    
    if ([instance sendImage])
    {
        return JSBubbleMediaTypeImage;
    }
    
    
    return JSBubbleMediaTypeText;
}
#pragma mark -  datasource -
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    YTMessageInstance * instance = _messages[indexPath.row];
    
    return [instance message];
}
- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YTMessageInstance * instance = _messages[indexPath.row];
    
    return [instance date];
}
- (id)dataForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YTMessageInstance * instance = _messages[indexPath.row];
    
    return [instance sendImage];
    
}
- (UIImage *)avatarImageForIncomingMessage
{
    return LoadImageFromBundle(@"YT_Chat_You", @".png");
}
- (UIImage *)avatarImageForOutgoingMessage
{
    return LoadImageFromBundle(@"YT_Chat_Me", @".png");
}

#pragma mark - Image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	NSLog(@"Chose image!  Details:  %@", info);
    
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    
    YTMessageInstance * instance = [[YTMessageInstance alloc]
                                    initWithMessage:nil
                                    date:[NSDate date]
                                    type:YTMessageTypeSend
                                    sendImage:image];
    
    [self.messages addObject:instance];
    [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}
#pragma mark - admob  delegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    kGaSendEvent(self.screenName,self.screenName,@"Ad_Full_Display",@"Display");
    NSLog(@"%s",__FUNCTION__);
    [_interstitialAd presentFromRootViewController:self];
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    kGaSendEvent(self.screenName,self.screenName,@"Ad_Full_Display",@"Failed");

    NSLog(@"%s",__FUNCTION__);
}
- (void)interstitialWillLeaveApplication:(GADInterstitial *)interstitial
{
    kGaSendEvent(self.screenName,self.screenName,@"Ad_Full_Display",@"Click");
    NSLog(@"%s",__FUNCTION__);
}
@end
