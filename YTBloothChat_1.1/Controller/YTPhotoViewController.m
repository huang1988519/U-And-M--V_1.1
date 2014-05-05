//
//  YTPhotoViewController.m
//  YTBloothChat
//
//  Created by 黄 伟华 on 4/15/14.
//  Copyright (c) 2014 黄伟华. All rights reserved.
//

#import "YTPhotoViewController.h"

#import "DoImagePickerController.h"
#import "YTPhotoCell.h"
#import "YTDataCut.h"
#import "YTPickerManager.h"
//ad
#import "GADBannerView.h"
@interface YTPhotoViewController () <UITableViewDataSource,UITableViewDelegate>
{
    YTDataCut * _dataCut;
    
    GADBannerView * _bannerView;
}
@property (nonatomic, strong) NSMutableArray * images;
@end

@implementation YTPhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = kGaPhotoScreenName;
    
    if (IOS7) {
        [_tableView setContentInset:UIEdgeInsetsMake(44+20, 0, 0, 0)];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}
#pragma mark - ad
-(GADBannerView *)addAdmob
{
    if(YT_NEED_ADMOB)
    {
        // add adMob View
        
        
        _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];

        _bannerView.adUnitID = GA_ADMOB_AdID;
        _bannerView.rootViewController = self;
        
        // 启动一般性请求并在其中加载广告。
        GADRequest * request = [GADRequest request];
        
#ifdef DEBUG
        [request setTestDevices:@[GAD_SIMULATOR_ID]];
#endif
        [_bannerView loadRequest:request];
        
    }
    
    return _bannerView;
}
#pragma mark - set
-(void)setImages:(NSMutableArray *)images
{
    _images = images;
}
#pragma mark -

-(IBAction)picker:(id)sender
{
    kGaSendEvent(self.screenName,self.screenName,@"touch",@"选择图片");

    
    DoImagePickerController * picker = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
    picker.delegate = self;
    picker.nMaxCount = 3;
    picker.nResultType = DO_PICKER_RESULT_UIIMAGE;
    picker.nColumnCount = 3;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}
#pragma mark - DoImagePickerControllerDelegate
- (void)didCancelDoImagePickerController
{
    kGaSendEvent(self.screenName,self.screenName,@"touch",@"取消选择图片");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected
{

    kGaSendEvent(self.screenName,self.screenName,@"touch",[NSString stringWithFormat:@"选择了%d张图片",(int)aSelected.count]);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (picker.nResultType == DO_PICKER_RESULT_UIIMAGE)
    {
        self.images = [NSMutableArray arrayWithArray:aSelected];
    }
    
    [_tableView reloadData];
}
#pragma mark - tableview delegate
-(YTPhotoCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"Cell";
    
    YTPhotoCell * cell;
   
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
         UINib *nib = [UINib nibWithNibName:NSStringFromClass([YTPhotoCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        
    });
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    
    if (!_dataCut) {
        _dataCut = [YTDataCut shareInstance];
    }
    cell.cutData = [YTDataCut shareInstance];
    
    cell.headerImageView.image = _images[indexPath.row];
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_images) {
        return 0;
    }
    return _images.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [self addAdmob];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50.f;
}
#pragma mark -  

@end
