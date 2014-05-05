//
//  YTMessageInstance.h
//  YTBloothChat
//
//  Created by 黄 伟华 on 4/1/14.
//  Copyright (c) 2014 黄伟华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTMessageProtocol.h"
@interface YTMessageInstance : NSObject <YTMessageProtocol>

-(instancetype)initWithMessage:(NSString *)message
                          date:(NSDate *)date
                          type:(YTMessageType)type
                     sendImage:(UIImage *)sendImage;

@end
