//
//  UIImage+YTColor.m
//  YTBloothChat
//
//  Created by 黄 伟华 on 4/16/14.
//  Copyright (c) 2014 黄伟华. All rights reserved.
//

#import "UIImage+YTColor.h"

@implementation UIImage (YTColor)
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
