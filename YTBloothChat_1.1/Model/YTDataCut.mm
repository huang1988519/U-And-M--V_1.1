//
//  YTDataCut.m
//  YTBloothChat
//
//  Created by 黄 伟华 on 4/15/14.
//  Copyright (c) 2014 黄伟华. All rights reserved.
//

#import "YTDataCut.h"
#import "YTPickerManager.h"
#define BufferSize   1024*100

int count = 0;

@implementation YTDataCut
{
    BOOL stop;
    
    NSMutableArray * sendQueue;
}

-(id)init
{
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelSend) name:YT_DISCONNECTION_NOTIFICATION object:nil];
        
        
        sendQueue = [NSMutableArray array];
        
        __block NSMutableData * tempReciveData;
        
        __block BOOL isStart = NO;
        
        [[YTPickerManager shareInstance] recivePhotoData:^(NSData *reciveData, NSDictionary *info) {
            NSLog(@"recive data length = %d",(int)reciveData.length);
            
            NSString * convertString = [[NSString alloc] initWithData:reciveData encoding:NSUTF8StringEncoding];
            
            //start to recive image data
            if ([convertString isEqualToString:@"start"])
            {
                tempReciveData = [NSMutableData data];
                isStart = YES;
                
                NSString * content = NSLocalizedString(@"Reciving_Alert", nil);

                [SVProgressHUD showWithStatus:content maskType:SVProgressHUDMaskTypeGradient];

                return;
            }
            
            
            //over , and create image
            if ([convertString isEqualToString:@"end"]) {
                
                UIImage * image = [UIImage imageWithData:tempReciveData];
                
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
                
                NSString * content = NSLocalizedString(@"Reciving_Completed_Alert", nil);
                [SVProgressHUD showSuccessWithStatus:content];

                
                isStart = NO;
                
                
                return ;
                
            }
            
            //append image data
            if (isStart) {
                [tempReciveData appendData:reciveData];
            }
        }];
        
    }
    
    return self;
}

static YTDataCut * _ytDataCutInstance;
+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _ytDataCutInstance = [[YTDataCut alloc] init];
    });
    
    return _ytDataCutInstance;
}


-(void)sendPhotoData:(NSData *)photoData
{
    if (sendQueue.count>1) {
        
        NSString * content = NSLocalizedString(@"UnCompleted", nil);
        dispatch_async(dispatch_get_main_queue(), ^{
            AlertWithMessage(content);
        });
        return;
    }
    [sendQueue addObject:photoData];

    
    stop = NO;
    totolData = photoData;
    count = 0;
    
    
    NSString * start = @"start";
    
    //发送开始信号
    if (![[YTPickerManager shareInstance] sendData:[start dataUsingEncoding:NSUTF8StringEncoding] type:YTDataTypePhoto])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString * content = NSLocalizedString(@"Check_Connect_State", nil);
            AlertWithMessage(content);
        });
        [sendQueue removeAllObjects];
        return;
    }
    [self send];
}
-(void)send{
    

        NSInteger startPoint = count * BufferSize;
        
        NSInteger distance = BufferSize;
        if ([totolData length] <=(startPoint+BufferSize)) {
            
            distance = [totolData length]- startPoint;
            stop = YES;
        }
        
        NSData * subData = [totolData subdataWithRange:NSMakeRange(startPoint, distance)];
        
        count++;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if ([[YTPickerManager shareInstance] sendData:subData type:YTDataTypePhoto])
            {
                if (!stop) {
                    [self send];
                }else{
                    
                    [sendQueue removeAllObjects];
                    
                    NSString * state = @"end";
                    NSData * endData = [state dataUsingEncoding:NSUTF8StringEncoding];
                    [[YTPickerManager shareInstance] sendData:endData type:YTDataTypePhoto];
                    
                    NSString * content  =[NSString stringWithFormat:@"Completed"];
                    
                    NSLog(@"%@%d次成功",content,count);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD showSuccessWithStatus:content];
                        
                    });
                }
            }
            else
            {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString * content = NSLocalizedString(@"Check_Connect_State", nil);
                    AlertWithMessage(content);
                    
                    [sendQueue removeAllObjects];

                });

            }
        });

    
    
    
}
-(void)cancelSend
{
    [SVProgressHUD dismiss];
    [sendQueue removeAllObjects];
}
@end
