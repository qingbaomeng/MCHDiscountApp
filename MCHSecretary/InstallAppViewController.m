//
//  InstallAppViewController.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/30.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "InstallAppViewController.h"
#import "StringUtils.h"
#import "TopSearchView.h"
#import "MJRefresh.h"

//#import "NomalFrame.h"
//#import "AppPacketInfo.h"
//#import "ChoiceListItem.h"
//#import "ChoiceCycleAppRequest.h"

#import "DetailsInfoViewController.h"

#import "InstallAppInfo.h"
#import "InstallAppFrame.h"

#import "CurrentAppUtils.h"
#import "DeviceAppInfo.h"
#import "InstallAppRequest.h"

#define TopViewH 65
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

#define GetColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define TopBackColor GetColor(18,205,176,1.0)
#define GetFont(s) [UIFont systemFontOfSize:s]
#define TitleFont GetFont(18)

@interface InstallAppViewController (){
    UIView *topview;
    UITableView *appInfoTable;
    
    NSMutableArray *allIDarray;//手机安装所有软件的BundleID
    
    dispatch_group_t group;
}

@end

@implementation InstallAppViewController

@synthesize listItemArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    listItemArray = [[NSMutableArray alloc] init];
    allIDarray = [[NSMutableArray alloc] init];
    
    group = dispatch_group_create();
    [self queryAllBundleId];
    
    [self addTopView];
    
    [self addScrollView];
}
//通过包名打开应用
//-(void)openAPPWithBundleID:(NSString *)bundleID
//{
//    Class lsawsc = objc_getClass("LSApplicationWorkspace");
//    NSObject* workspace = [lsawsc performSelector:NSSelectorFromString(@"defaultWorkspace")];
//    // iOS6 没有defaultWorkspace
//    if ([workspace respondsToSelector:NSSelectorFromString(@"openApplicationWithBundleID:")])
//    {
//        [workspace performSelector:NSSelectorFromString(@"openApplicationWithBundleID:") withObject:bundleID];
//    }
//}

-(void) viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [super.navigationController setToolbarHidden:YES animated:TRUE];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) queryAllBundleId{
    
    
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        allIDarray = [[DeviceAppInfo findAll] mutableCopy];
    });
}


-(void) addTopView{
    topview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopViewH)];
    [topview setBackgroundColor:TopBackColor];
    [self.view addSubview:topview];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, TopViewH - 20)];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [lblTitle setText:NSLocalizedString(@"InstallTitle", @"")];
    [lblTitle setFont:TitleFont];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    
    [topview addSubview:lblTitle];
}

-(void) addScrollView{
    CGFloat posy = CGRectGetMaxY(topview.frame);
    CGFloat tableH = kScreenHeight - posy - 49;
    appInfoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, posy, kScreenWidth, tableH)];
    appInfoTable.separatorStyle = UITableViewCellSelectionStyleNone;
    appInfoTable.delegate = self;
    appInfoTable.dataSource = self;
    
    // 下拉刷新
    appInfoTable.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self requestAppInfo];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    appInfoTable.mj_header.automaticallyChangeAlpha = YES;
    
    [self.view addSubview:appInfoTable];
    
    [self requestAppInfo];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"count:%ld", listItemArray.count);
    return listItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InstallAppCell *cell = [InstallAppCell cellWithTableView:tableView];
    InstallAppFrame *infoFrame = listItemArray[indexPath.row];
    [cell setFrame:infoFrame pos:indexPath.row];
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    InstallAppFrame *frame = listItemArray[indexPath.row];
    return frame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InstallAppFrame *infoFrame = listItemArray[indexPath.row];
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    DetailsInfoViewController *detailsView = [mainStoryboard instantiateViewControllerWithIdentifier:@"detailsinfo"];
    detailsView.appId = [NSString stringWithFormat:@"%d",infoFrame.installAppInfo.appid];
    detailsView.open = YES;
    detailsView.bundleId = infoFrame.installAppInfo.gameBundleId;
    [self.navigationController pushViewController:detailsView animated:YES];
}

-(void) requestAppInfo{
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        [listItemArray removeAllObjects];
        NSArray *infoArray =  [InstallAppInfo findAll];
//        NSLog(@"infos:%ld", (unsigned long)infoArray.count);
        for (int i = 0; i < infoArray.count; i++) {
            InstallAppInfo *info = infoArray[i];
//            NSLog(@"info.gameBundleId:%@", info.gameBundleId);
            
            
            if([CurrentAppUtils isContainBundle:allIDarray bundleid:info.gameBundleId]){
                InstallAppFrame *infoFrame = [[InstallAppFrame alloc] init];
                [infoFrame setInstallAppInfo:info];
                
                [listItemArray addObject:infoFrame];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [appInfoTable reloadData];
            [appInfoTable.mj_header endRefreshing];
        });
        
    });
}

#pragma mark - DownloadAppDelegate

-(void) repairApp:(NSInteger)index{
    if(index < listItemArray.count){
        InstallAppFrame *frame = listItemArray[index];

        [self requestDownloadUrl:frame.installAppInfo.appid];
    } 
}

-(void) requestDownloadUrl:(int)appid{
    InstallAppRequest *installapprequest = [[InstallAppRequest alloc] init];
    [installapprequest setGameAppId:[NSString stringWithFormat:@"%d", appid]];
    [installapprequest getAppList:^(NSString *resultStr) {
        NSLog(@"resultStr : %@", resultStr);
        if (![@"" isEqualToString:@""]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:resultStr]];
        }
        
    } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@", [dic objectForKey:@"return_msg"]];
        NSLog(@"errorMsg:%@", errorMsg);
    }];
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
