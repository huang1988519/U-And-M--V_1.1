//
//  YTSessionInstance.h
//  YTBloothChat
//
//  Created by 黄 伟华 on 3/31/14.
//  Copyright (c) 2014 黄伟华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "YTSession.h"
@interface YTSessionInstance : NSObject <YTSessionProtocol>
{
    __strong GKSession * _session;
    
    __strong NSString  * _remotePeer;
}
-(instancetype)initWithGKSession:(GKSession *)session withRemotePeer:(NSString *)remotePeer;
@end
