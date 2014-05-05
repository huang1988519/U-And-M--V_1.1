//
//  YTPickerManager.h
//  YTBloothChat
//
//  Created by 黄 伟华 on 3/31/14.
//  Copyright (c) 2014 黄伟华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTSession.h"
#import <GameKit/GameKit.h>

typedef enum {
    YTConnectStateConnected = 0,
    YTConnectStateDisconnect,
    YTConnectStateCancel,
    YTConnectStateAvailable,
    YTConnectStateUnAvailable,
    YTConnectStateOther,
    
} YTConnectState;

typedef enum {
    YTDataTypeMessage = 0,
    YTDataTypeAudio=1,
    YTDataTypePhoto=2
} YTDataType;

typedef void(^GKSessionRecive)(NSData * reciveData,NSDictionary * info);


@protocol GKPeerPickerDelegate;

@class GKPeerPickerController,GKSession;


@interface YTPickerManager : NSObject
{
    BOOL _isConnecting; 
}

@property (nonatomic, strong)GKPeerPickerController * peerPicker;

@property (nonatomic, strong)GKSession * gkSection;
@property (nonatomic, strong)NSString  * peerID;
@property (nonatomic, strong)NSString  * remoteName;
@property (nonatomic, assign) id <GKPeerPickerDelegate> delegate;

//block
@property (nonatomic, copy) GKSessionRecive recevieBolck;
@property (nonatomic, copy) GKSessionRecive recievePhotoBlock;

@property (nonatomic, assign)GKPeerConnectionState state;

@property (nonatomic, retain)NSMutableArray * unReadMsgs;
+(instancetype)shareInstance;

-(void)startPicker;
-(void)cancelConnnect;

-(BOOL)isAvalable;
-(BOOL)isConnecting;

-(void)reciveMessage:(GKSessionRecive)recevieBolck;
-(void)recivePhotoData:(GKSessionRecive)recieveBlock;
-(void)sendMessage:(id)message  dateTamp:(NSTimeInterval)dateTamp;
- (BOOL)sendData:(NSData *)data type:(YTDataType)type;
@end



@protocol GKPeerPickerDelegate

@required
-(void)peerPick:(YTPickerManager *)peerManager infoInstance:(id<YTSessionProtocol>)instance state:(YTConnectState)state;
@end