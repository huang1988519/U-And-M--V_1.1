//
//  YTDataCut.h
//  YTBloothChat
//
//  Created by 黄 伟华 on 4/15/14.
//  Copyright (c) 2014 黄伟华. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YTResourceType) {
    YTResourceTypePhoto = 0,
    YTResourceTypeVedio
};

@interface YTDataCut : NSObject
{
    
    NSData  * totolData;
}

+(instancetype)shareInstance;

-(void)sendPhotoData:(NSData *)photoData;
-(void)cancelSend;
@end
