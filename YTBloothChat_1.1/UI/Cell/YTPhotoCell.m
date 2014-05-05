//
//  YTPhotoCell.m
//  YTBloothChat
//
//  Created by 黄 伟华 on 4/15/14.
//  Copyright (c) 2014 黄伟华. All rights reserved.
//

#import "YTPhotoCell.h"
#import "YTDataCut.h"
@implementation YTPhotoCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSString * content = NSLocalizedString(@"Send_Button_Title", nil);
    [_sendBtn setTitle:content forState:UIControlStateNormal];
}



-(IBAction)sendPhoto:(id)sender
{
    UIImage * image = self.headerImageView.image;
    if (!image) {
        
        NSLog(@"no 图片");
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.cutData sendPhotoData:UIImageJPEGRepresentation(image, 1.0)];
    });
    
}
@end
