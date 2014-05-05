//
//  YTMessageInstance.m
//  YTBloothChat
//
//  Created by 黄 伟华 on 4/1/14.
//  Copyright (c) 2014 黄伟华. All rights reserved.
//

#import "YTMessageInstance.h"

@implementation YTMessageInstance
{
    NSString * _message;
    NSDate   * _date;
    YTMessageType _type;
    UIImage  * _sendImage;
}
-(instancetype)initWithMessage:(NSString *)message
                          date:(NSDate *)date
                          type:(YTMessageType)type
                     sendImage:(UIImage *)sendImage
{
    self = [super init];
    if (self)
    {
        _message = message;
        _date    = date;
        _type    = type;
        _sendImage = sendImage;
    }
    
    return self;
}

-(NSString *)message
{
    return _message;
}

-(NSDate *)date
{
    return _date;
}

-(YTMessageType)messageType
{
    return _type;
}
-(UIImage *)sendImage
{
    return _sendImage;
}
@end
