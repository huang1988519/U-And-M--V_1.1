//
//  YTPickerManager.m
//  YTBloothChat
//
//  Created by 黄 伟华 on 3/31/14.
//  Copyright (c) 2014 黄伟华. All rights reserved.
//

#import "YTPickerManager.h"
#import "YTSessionInstance.h"

#import <AVFoundation/AVFoundation.h>
#define SESSION_ID @"amiphdp2p2" //蓝牙协议

@interface YTPickerManager ()<GKPeerPickerControllerDelegate,GKSessionDelegate,GKVoiceChatClient>
{
}

@end
@implementation YTPickerManager {
    
}


-(id)init
{
    self = [super init];
    if (self)
    {
        self.unReadMsgs = [NSMutableArray array];
        _isConnecting = NO;
    }
    return self;
}

static YTPickerManager * pickerManager = nil;

+(instancetype)shareInstance
{
    
    @synchronized(self)
    {
        if (!pickerManager) {
            pickerManager = [[[YTPickerManager class] alloc] init];
        }
        return pickerManager;
    }
    return nil;
}

#pragma mark -
-(void)configAudio
{
    NSError * error;
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    
    if (![audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error]) {
        NSLog(@"设置播放记录错误:%@",[error localizedDescription]);
        return;
    }
    if (![audioSession setActive:YES error:&error]) {
        NSLog(@"激活失败:%@",[error localizedDescription]);
        return;
    }

}
-(NSString *)remoteName
{
    return [_gkSection displayNameForPeer:self.peerID];
}
#pragma mark -
-(void)startPicker
{
    if (self.gkSection) {
        [self.gkSection disconnectFromAllPeers];
    }
    
    
    
    self.peerPicker = [[GKPeerPickerController alloc] init];
    self.peerPicker.delegate = self;
    self.peerPicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    [self.peerPicker show];
    
    
    [GKVoiceChatService defaultVoiceChatService].client = pickerManager;


}
-(void)cancelConnnect
{
    [self.gkSection disconnectFromAllPeers];
}
-(BOOL)isAvalable
{
    if (!self.gkSection) {
        return YES;
    }
    return [self.gkSection isAvailable];
}
-(BOOL)isConnecting
{
    return _isConnecting;

}
#pragma mark - peer picker delegate

- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type
{
    NSString *sessionId = SESSION_ID;
    _gkSection = [[GKSession alloc] initWithSessionID:sessionId
                                                   displayName:nil
                                                   sessionMode:GKSessionModePeer];
    return _gkSection;
}
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session
{
    NSLog(@"%s",__FUNCTION__);
    
    
    //connected
    _isConnecting = YES;


    
    [_peerPicker dismiss];
    _peerPicker.delegate= nil;
    
    
    //配置语音
    [self configAudio];
    

    self.peerID = peerID;
    
    _gkSection.delegate = self;
    
    if (_gkSection) {
        [_gkSection setDataReceiveHandler:pickerManager withContext:nil];

    }
    
    
    
    
    [[GKVoiceChatService defaultVoiceChatService] startVoiceChatWithParticipantID:peerID error:nil];
    [GKVoiceChatService defaultVoiceChatService].microphoneMuted = YES;
    
    
    
    YTSessionInstance * instance = [[YTSessionInstance alloc] initWithGKSession:session withRemotePeer:self.peerID];
    [_delegate peerPick:self infoInstance:instance state:YTConnectStateConnected];
}


- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{
    NSLog(@"%s",__FUNCTION__);
    
    
    __strong YTSessionInstance * instance = [[YTSessionInstance alloc] initWithGKSession:nil withRemotePeer:self.peerID];
    [_delegate peerPick:self infoInstance:instance state:YTConnectStateCancel];
    
    instance = nil;
     
}
#pragma mark - 
- (void)session:(GKSession *)session
didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
     NSLog(@"%s",__FUNCTION__);
}
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
    NSLog(@"%s",__FUNCTION__);
    
    _state = state;
    
    YTSessionInstance * instance = [[YTSessionInstance alloc] initWithGKSession:session withRemotePeer:self.peerID];

    
    _isConnecting = NO;

    switch (state) {
            
            
        case GKPeerStateConnected:
            
            _isConnecting = YES;
            
            [_delegate peerPick:self infoInstance:instance state:YTConnectStateConnected];
            break;
        case GKPeerStateDisconnected:
        {
            
            
            [[GKVoiceChatService defaultVoiceChatService] stopVoiceChatWithParticipantID:self.peerID];
            
            [_delegate peerPick:self infoInstance:instance state:YTConnectStateDisconnect];
            
        }
            
            break;
        case GKPeerStateAvailable:
            [_delegate peerPick:self infoInstance:instance state:YTConnectStateAvailable];

            break;

        case YTConnectStateUnAvailable:
            [_delegate peerPick:self infoInstance:instance state:YTConnectStateUnAvailable];
            
            break;
        default:
            break;
    }
}
#pragma mark - 接受数据
- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
    
    //解析头部信息
    int sizeOfInt = sizeof(int);
    
    NSData * typeData = [data subdataWithRange:NSMakeRange(0, sizeOfInt)];
    NSData * contentData = [data subdataWithRange:NSMakeRange(sizeOfInt, data.length - sizeOfInt)];
    
    
    YTDataType type;
    [typeData getBytes:&type length:sizeof(int)];
    if (type == YTDataTypePhoto) {
        NSLog(@"收到图片二进制数据 length %d",(YTUInt)data.length);
        _recievePhotoBlock(contentData,@{@"peer": peer});
        return;
    }
    
    
    
    if (_recevieBolck)
    {
        _recevieBolck(contentData,@{@"peer": peer});
        return;
    }else
    {
        if (type == YTDataTypeMessage)
        {
            
            NSString * content = NSLocalizedString(@"Un_Read_Message", nil);
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@ %d ",content,(int)_unReadMsgs.count+1]];
            [_unReadMsgs addObject:contentData];
        }
    }
    
    [[GKVoiceChatService defaultVoiceChatService] receivedData:contentData
                                             fromParticipantID:peer];
}
-(void)reciveMessage:(GKSessionRecive)recevieBolck
{
    _recevieBolck = [recevieBolck copy];
    
    if (_unReadMsgs.count >0) {
        for (NSData * data in _unReadMsgs) {
            _recevieBolck(data,nil);
        }
        [_unReadMsgs removeAllObjects];
    }
}

-(void)recivePhotoData:(GKSessionRecive)recieveBlock
{
    _recievePhotoBlock = [recieveBlock copy];
}

-(void)sendMessage:(id)message  dateTamp:(NSTimeInterval)dateTamp
{
    if (!message) {
        return;
    }

    NSMutableData * totalData = [NSMutableData data];
    
    NSData * messageData  = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSData * stampData = [[NSString stringWithFormat:@"%f",dateTamp] dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"\nmessage length:%d\nstamp length:%d",(int)[message length],(int)[stampData length]);
    
    [totalData appendData:messageData];
    [totalData appendData:stampData];
    
    [self sendData:totalData type:YTDataTypeMessage];
    
}
-(BOOL)sendData:(NSData *)data
{
    
    return  [_gkSection sendDataToAllPeers:data withDataMode:GKSendDataReliable error:nil];
}


/**
 *  添加 头部信息
 *
 *  @param data 发送数据
 *  @param type 发送数据类型
 *
 *  @return 发送是否成功
 */
- (BOOL)sendData:(NSData *)data type:(YTDataType)type
{
    NSMutableData * totalData = [NSMutableData data];
    NSData *typeData = [NSData dataWithBytes:&type length: sizeof(int)];
    
    [totalData appendData:typeData];
    [totalData appendData:data];
    
    
    return [self sendData:totalData];
}
#pragma mark -  GKVoiceChatService Delegate
- (void)voiceChatService:(GKVoiceChatService *)voiceChatService sendData:(NSData *)data toParticipantID:(NSString *)participantID
{
    NSError * error=nil;
    
    [self sendData:data type:YTDataTypeAudio];
    
    NSAssert(!error, @"发送消息出错");
    
}
- (NSString *)participantID
{
    return self.gkSection.peerID;
}
@end
