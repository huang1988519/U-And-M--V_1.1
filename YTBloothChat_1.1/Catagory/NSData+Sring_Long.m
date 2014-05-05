//
//  NSData+Sring_Long.m
//  YTBloothChat
//
//  Created by 黄 伟华 on 4/1/14.
//  Copyright (c) 2014 黄伟华. All rights reserved.
//

#import "NSData+Sring_Long.h"

@implementation NSData (Sring_Long)
-(NSDictionary *)messageWithLongTamp
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];

    
    NSUInteger totalLength = [self length];
    NSUInteger stampLength = [[[NSString stringWithFormat:@"%f",time] dataUsingEncoding:NSUTF8StringEncoding] length];
    
    NSData * messageData = [self subdataWithRange:NSMakeRange(0, totalLength-stampLength)];
    NSData * stampData   = [self subdataWithRange:NSMakeRange(totalLength-stampLength, stampLength)];
    
    NSString * message = [[NSString alloc] initWithData:messageData encoding:NSUTF8StringEncoding];
    NSString * stamp   = [[NSString alloc] initWithData:stampData encoding:NSUTF8StringEncoding];
    
    if (!message || !stamp) {
        return  nil;
    }
    return @{@"message": message, @"stamp":stamp};
}
@end
