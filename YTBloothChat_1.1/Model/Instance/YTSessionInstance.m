//
//  YTSessionInstance.m
//  YTBloothChat
//
//  Created by 黄 伟华 on 3/31/14.
//  Copyright (c) 2014 黄伟华. All rights reserved.
//

#import "YTSessionInstance.h"

@implementation YTSessionInstance

-(instancetype)initWithGKSession:(GKSession *)session withRemotePeer:(NSString *)remotePeer
{
    self = [super init];
    if (self) {
        if (session) {
            _session = session;
            _remotePeer = remotePeer;
        }
    }
    return self;
}
#pragma mark - protocol -
-(NSString *)name
{
    return [_session displayNameForPeer:_remotePeer];
}
@end
