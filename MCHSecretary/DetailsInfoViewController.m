//
//  DetailsInfoViewController.m
//  MCHSecretary
//
//  Created by 朱进 on 16/8/13.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "DetailsInfoViewController.h"

#import "DetailInfoRequest.h"
#import "Share.h"

#import "WebImage.h"
#import "StringUtils.h"
#import "InstallAppRequest.h"
#import "CurrentAppUtils.h"
#import "InstallAppInfo.h"
#import "PreferencesUtils.h"

#define TopViewH 65
#define BarWIDTH 30
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define GetColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define LineColor GetColor(230,230,230,1.0)
#define TextColor GetColor(102,102,102,1.0)
#define ButtonBackColor GetColor(0,122,255,1.0)
#define TopBackColor GetColor(18,205,176,1.0)

#define GetFont(s) [UIFont systemFontOfSize:s]
#define TitleFont GetFont(18)
#define ContentTextSize 13
#define TextFont GetFont(ContentTextSize)

@interface DetailsInfoViewController (){
//    DetailSegmentView *detailSegmentView;
    
    float segmentTopY;
    BOOL segmentIsShow;
    
    AppPacketInfo *info;
    
    DetailDescribeView *descView;
    DetailCommentView *commentView;
    
    CGFloat descConH;
}

@end

@implementation DetailsInfoViewController

@synthesize appSmallIcon, appName, detailScrollView, infoView, appId;
//@synthesize lblDescribe, lblVerision, lblUpdateRecord, txtDescribe, txtVerision, txtUpdateList;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
    
    [self addTopView];
    
    [self addDownButton];
    
    [self initData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
//    [super.navigationController setToolbarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = YES;
    [super viewWillAppear:animated];
}

-(void) initView{
    segmentTopY = 1000;
    segmentIsShow = NO;
    
    CGFloat segmentY = CGRectGetMaxY(infoView.frame) - 40;
    segmentTopY = segmentY;
    
    detailScrollView.delegate = self;
    
    appSmallIcon.layer.cornerRadius = 15;
    appSmallIcon.layer.masksToBounds = YES;
    
//    detailSegmentView = [[DetailSegmentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 39)];
//    detailSegmentView.delegate = self;
    
}

-(void) addTopView{
    topview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopViewH)];
    [topview setBackgroundColor:TopBackColor];
    [self.view addSubview:topview];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(20, 25, BarWIDTH*2, BarWIDTH);
    [leftBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    leftBtn.tag = 1;
    [leftBtn addTarget:self action:@selector(barbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [topview addSubview:leftBtn];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kScreenWidth -20-BarWIDTH, 25, BarWIDTH, BarWIDTH);
    [button setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(barbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 2;
    [topview addSubview:button];
}

-(void)barbuttonClick:(UIButton *)button
{
    if (button.tag == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (button.tag == 2)
    {
        if (info) {
            NSString *promoreid = [PreferencesUtils getPromoteId];

            NSString *urlstr = [NSString stringWithFormat:@"https://www.tym1.com/media.php/index/game_download/gid/%@/pid/%@",self.appId,promoreid];
            
            [Share shareWithTitle:info.gameName ImageUrl:info.gameIconUrl Message:info.introduction URL:urlstr ViewControl:self];
        }
    }
    if (button.tag == 3)
    {
        
        if (info){
            if (self.open)
            {
            [CurrentAppUtils openAPPWithBundleID:self.bundleId];
            }
            else
            {
            [self requestDownloadUrl];
                
                InstallAppInfo *appInfo = [[InstallAppInfo alloc] init];
                appInfo.appid = info.gameID;
                appInfo.iconUrl = info.gameIconUrl;
                appInfo.gameName = info.gameName;
                appInfo.gameSize = info.packetSize;
                appInfo.gameType = info.game_type_name;
                appInfo.gameDescribe = info.introduction;
                appInfo.gameDiscount = info.appDiscount;
                appInfo.gameBundleId = info.gameBundleID;
                NSLog(@"BundleId: %@", appInfo.gameBundleId);
                if([@"" isEqualToString:appInfo.gameBundleId]){
                    NSLog(@"BundleId is null");
                    return;
                }
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSArray *allInstalled = [InstallAppInfo findAll];
                    BOOL isHave = false;
                    for (int i = 0; i < allInstalled.count; i++) {
                        InstallAppInfo *appinfo = allInstalled[i];
                        if([appInfo.gameBundleId isEqualToString:appinfo.gameBundleId]){
                            isHave = true;
                            break;
                        }
                    }
                    if(!isHave){
                        [appInfo save];
                    }
                });

            }
        }
    }
}
-(void) requestDownloadUrl{
    InstallAppRequest *installapprequest = [[InstallAppRequest alloc] init];
    [installapprequest setGameAppId:appId];
    [installapprequest getAppList:^(NSString *resultStr) {
        
        if (![@"" isEqualToString:resultStr]) {
            NSString *url = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",resultStr];
            NSLog(@"InstallAppView-----url:%@",url);
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
        
    } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@", [dic objectForKey:@"return_msg"]];
        NSLog(@"fun# errorMsg:%@", errorMsg);
    }];
}

-(void)addDownButton
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 50, kScreenWidth, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    UIButton *btnDownload = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDownload.layer.cornerRadius = 5;
    [btnDownload setFrame:CGRectMake(50, 10, kScreenWidth - 100, 30)];
    [btnDownload addTarget:self action:@selector(barbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnDownload setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    btnDownload.tag = 3;
    btnDownload.titleLabel.font = [UIFont systemFontOfSize:15];
    
    if (self.open)
    {
        [btnDownload setTitle:@"立即打开" forState:UIControlStateNormal];
    }else
    {
        [btnDownload setTitle:NSLocalizedString(@"AppDetailDownload", @"") forState:UIControlStateNormal];
    }
    [btnDownload setBackgroundColor:TopBackColor];
    [bgView addSubview:btnDownload];
    [self.view addSubview:bgView];
}

-(void) initData{
    info = nil;
    
    DetailInfoRequest *detail = [[DetailInfoRequest alloc] init];
    [detail setAppId:appId];
    
    [detail request:^(AppPacketInfo *appinfo) {
        info = appinfo;
//        NSLog(@"%@", appinfo.describeImages);
        [self initAppInfo];
        
        [self initAppDetail];
    } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
        
    }];
}

-(void) initAppInfo{
    if(nil == info){
        return;
    }
    [appSmallIcon sd_setImageWithURL:[NSURL URLWithString:info.gameIconUrl] placeholderImage:[UIImage imageNamed:@"load_fail"]];
    [appName setText:info.gameName];
    [_descriptLab setText:info.introduction];
    
    if ([StringUtils isBlankString:info.appDiscount])
    {
        [_zhekouBtn setHidden:YES];
    }
    else if ([info.appDiscount floatValue] > 0 || [info.appDiscount floatValue]<10)
    {
        NSString *leftdiscountStr = [NSString stringWithFormat:@"%@%@", info.appDiscount, NSLocalizedString(@"AppDiscount", @"")];
        [_zhekouBtn setTitle:leftdiscountStr forState:UIControlStateNormal];
    }
    else{
        [_zhekouBtn setHidden:YES];
    }
    
    CGSize nameSize = [StringUtils sizeWithString:info.gameName font:[UIFont systemFontOfSize:18] maxSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 160, 42)];
    CGRect nameRect = appName.frame;
    nameRect.size = nameSize;
    appName.frame = nameRect;
    
//    [appStarValue initStarConfig:StarStyle_Yellow numberOfStars:3];
//    
//    NSString *commnetStr = [NSString stringWithFormat:@"(%@%@)", info.commentNumber, NSLocalizedString(@"AppComment", @"")];
//    [appCommentNum setText:commnetStr];
//    
//    NSString *packetDown = [NSString stringWithFormat:@"%@%@", info.appDownloadNum, NSLocalizedString(@"AppDownNumber", @"")];
//    NSString *packetSize = [NSString stringWithFormat:@"%@MB", info.packetSize];
//    [appDownAndSize setText:[NSString stringWithFormat:@"%@ · %@", packetSize, packetDown]];
}

-(void)initAppDetail{
    if(nil == info){
        return;
    }
    if(descView && [descView isHidden]){
        [descView setHidden:NO];
        detailScrollView.contentSize = CGSizeMake(kScreenWidth, descConH);
        return;
    }
    
    CGFloat ivScrollY = CGRectGetMaxY(infoView.frame);
//    NSLog(@"%f", ivScrollY);
    descView = [[DetailDescribeView alloc] initWithFrame:CGRectMake(0, ivScrollY, kScreenWidth, 500) appInfo:info];
    [detailScrollView addSubview:descView];
    
    descConH = CGRectGetMaxY(descView.frame);
    detailScrollView.contentSize = CGSizeMake(kScreenWidth, descConH);
}

-(void) changeSegmentItem:(NSInteger)index{
//    NSLog(@"changeSegmentItem:%ld", (long)index);
//    if(detailSegmentView){
//        [detailSegmentView setSelectSegement:index];
//    }
//    if(segmentView){
//        [segmentView setSelectSegement:index];
//    }
    
    if(descView){
        [descView setHidden:YES];
    }
    if(commentView){
        [commentView setHidden:YES];
    }

    if(index == 0){
        [self initAppDetail];
    }else if(index == 1){
//        NSLog(@"2-initCommentView");
        [self initCommentView];
    }else if(index == 2){
        NSLog(@"init tuijian");
        
    }
}

-(void) initCommentView{
    if(nil == info){
        return;
    }
    if(commentView && [commentView isHidden]){
        [commentView setHidden:NO];
        return;
    }
    
    CGFloat ivScrollY = CGRectGetMaxY(infoView.frame);
    commentView = [[DetailCommentView alloc] initWithFrame:CGRectMake(0, ivScrollY, kScreenWidth, 500)];
    [detailScrollView addSubview:commentView];
    [commentView requestAppComment];
    
    descConH = CGRectGetMaxY(commentView.frame);
    detailScrollView.contentSize = CGSizeMake(kScreenWidth, descConH);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    NSLog(@"%f", scrollView.contentOffset.y);
//    if(detailSegmentView){
//        if (scrollView.contentOffset.y <= segmentTopY && scrollView.contentOffset.y >= 0) {
//            if(segmentIsShow){
//                segmentIsShow = NO;
//                [detailSegmentView removeFromSuperview];
//            }
//        } else if (scrollView.contentOffset.y >= segmentTopY) {
//            if(!segmentIsShow){
//                segmentIsShow = YES;
//                [self.view addSubview:detailSegmentView];
//            }
//        }
//    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
