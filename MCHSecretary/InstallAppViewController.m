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

#import "NomalFrame.h"
#import "AppPacketInfo.h"
#import "ChoiceListItem.h"
#import "ChoiceCycleAppRequest.h"

#import "DetailsInfoViewController.h"

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
}

@end

@implementation InstallAppViewController

@synthesize listItemArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTopView];
    
    [self addScrollView];
    [self gainAPPInformationFromPhone];
    [self whetherDownLoad];
}
#pragma mark 获取手机内安装的程序
-(void)gainAPPInformationFromPhone
{
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
//    NSLog(@"apps: %@", [workspace performSelector:@selector(allApplications)]);
   NSArray *array = [workspace performSelector:@selector(allApplications)];
    for (NSString *app in array)
    {
        //获取BundleID
        NSString *bundleid = [self getParseBundleIDString:app];
        NSLog(@"%@",bundleid);
        allIDarray = [NSMutableArray array];
        [allIDarray addObject:bundleid];
    }
}
-(NSString *)getParseBundleIDString:(NSString *)description
{
    NSString *ret = @"";
    NSString *target = [description description];
    // iOS8.0 "LSApplicationProxy: com.apple.videos",
    // iOS8.1 "<LSApplicationProxy: 0x898787998> com.apple.videos",
    // iOS9.0 "<LSApplicationProxy: 0x145efbb0> com.apple.PhotosViewService <file:///Applications/PhotosViewService.app>"
    if (target == nil)
    {
        return ret;
    }
    NSArray *arrObj = [target componentsSeparatedByString:@" "];
    switch ([arrObj count])
    {
        case 2:// [iOS7.0 ~ iOS8.1)
         case 3:// [iOS8.1 ~ iOS9.0)
        {
            ret = [arrObj lastObject];
        }
            break;
            case 4:
        {
            ret = [arrObj objectAtIndex:2];
        }
            
        default:
            break;
    }
    return ret;
}
//通过包名打开应用
-(void)openAPPWithBundleID:(NSString *)bundleID
{
    Class lsawsc = objc_getClass("LSApplicationWorkspace");
    NSObject* workspace = [lsawsc performSelector:NSSelectorFromString(@"defaultWorkspace")];
    // iOS6 没有defaultWorkspace
    if ([workspace respondsToSelector:NSSelectorFromString(@"openApplicationWithBundleID:")])
    {
        [workspace performSelector:NSSelectorFromString(@"openApplicationWithBundleID:") withObject:bundleID];
    }
}
#pragma mark 判断是否下载某个游戏
-(void)whetherDownLoad
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *tapArr = [userDefaults objectForKey:@"BundleIDARR"];
    
    if (tapArr)
    {
        for (NSString *bundle in tapArr)
        {
            NSLog(@"%@",bundle);
            
            if ([allIDarray containsObject:bundle])
            {
                NSLog(@"软件已经下载，可以展示");
            }
            else
            {
                NSLog(@"点击过但是没有下载");
            }
        }
    }
    else
    {
        NSLog(@"数组不存在，还没有下载过");
    }
}
-(void) viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [super.navigationController setToolbarHidden:YES animated:TRUE];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return listItemArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ChoiceListItem *listitem = listItemArray[section];
    //    NSLog(@"%ld, %ld", (long)section, (long)listitem.itemNumber);
    if(listitem.cellType == CellStyle_Cycle){
        return 1;
    }
    return listitem.appInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChoiceListItem *listitem = listItemArray[indexPath.section];
    NomalCell *appcell = [NomalCell cellWithTableView:tableView];
    NomalFrame *frame = listitem.appInfoArray[indexPath.row];
    [appcell setNomalFrame:frame section:indexPath.section pos:indexPath.row];
    appcell.delegate = self;
    return appcell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChoiceListItem *listitem = listItemArray[indexPath.section];
    NomalFrame *frame = listitem.appInfoArray[indexPath.row];
    return frame.cellHeight;
}

-(CGFloat)tableView:(UITableView *) tableView heightForHeaderInSection:(NSInteger)section{
    //    return 0.01;
    //    ChoiceListItem *listitem = listItemArray[section];
    //    if(listitem.cellType == CellStyle_Nomal){
    //        return FloatingViewHeight;
    //    }else if (listitem.cellType == CellStyle_Other){
    //        return 20;
    //    } else {
    //        return 0.1;
    //    }
    
    return 0.1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    DetailsInfoViewController *detailsView = [mainStoryboard instantiateViewControllerWithIdentifier:@"detailsinfo"];
    [self.navigationController pushViewController:detailsView animated:YES];
}

-(void) requestAppInfo{
    
    [[[ChoiceCycleAppRequest alloc] init] getCycleAppInfo:^(NSMutableArray *result) {
        //        NSLog(@"success dic:%@", dic);
        listItemArray = result;
        [appInfoTable reloadData];
        
        [appInfoTable.mj_header endRefreshing];
    } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@", [dic objectForKey:@"return_msg"]];
        NSLog(@"errorMsg:%@", errorMsg);
        
        [appInfoTable.mj_header endRefreshing];
    }];
}

#pragma mark - DownloadAppDelegate

-(void) startDownloadApp:(NSInteger)section index:(NSInteger)index{
    if(listItemArray.count <= section){
        return;
    }
    ChoiceListItem *listitem = listItemArray[section];;
    
    NomalFrame *frame = [listitem.appInfoArray objectAtIndex:index];
    NSString *downUrl = frame.packetInfo.downloadUrl;
    NSLog(@"%ld_url: %@", (long)index, downUrl);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downUrl]];
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
