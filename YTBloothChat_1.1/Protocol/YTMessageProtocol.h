//
//  YTMessageProtocol.h
//  YTBloothChat
//
//  Created by 黄 伟华 on 4/1/14.
//  Copyright (c) 2014 黄伟华. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    YTMessageTypeSend,
    YTMessageTypeReceive,
    YTMessageTypeOther,
} YTMessageType;

@protocol YTMessageProtocol <NSObject>

@required
-(NSString *)    message;
-(NSDate *)      date;
-(YTMessageType) messageType;
-(UIImage *)     sendImage;
@end
