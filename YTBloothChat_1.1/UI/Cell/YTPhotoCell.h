//
//  YTPhotoCell.h
//  YTBloothChat
//
//  Created by 黄 伟华 on 4/15/14.
//  Copyright (c) 2014 黄伟华. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YTDataCut;
@interface YTPhotoCell : UITableViewCell
{
}
@property (nonatomic, weak)  IBOutlet UIImageView * headerImageView;
@property (nonatomic, weak)  IBOutlet UIButton   * sendBtn;
@property (nonatomic, weak)  YTDataCut  * cutData;
-(IBAction)sendPhoto:(id)sender;
@end
