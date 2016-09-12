//
//  AppInfoTableView.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/26.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "AppInfoTableView.h"

#import "MJRefresh.h"
#import "StringUtils.h"
#import "ChoiceCycleAppRequest.h"

#import "NomalFrame.h"
#import "HomeGameInfo.h"
#import "ChoiceHeadeView.h"
#import "ChoiceListItem.h"
#import "CycleScrollCell.h"

#import "InstallAppInfo.h"

#define TopViewHeight 100

@interface AppInfoTableView(){
    UITableView *appInfoTable;
    int page;
}


@end

@implementation AppInfoTableView

@synthesize listItemArray,scrolImagesArray;

-(instancetype) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initData];
        
        [self addScrollView];
    }
    return self;
}

-(void) initData{
    page = 1;
    listItemArray = [[NSMutableArray alloc] init];
    scrolImagesArray = [[NSMutableArray alloc]init];
    
}

-(void) addScrollView{
    appInfoTable = [[UITableView alloc] initWithFrame:self.bounds];
    appInfoTable.separatorStyle = UITableViewCellSelectionStyleNone;
    appInfoTable.delegate = self;
    appInfoTable.dataSource = self;
    
    // 下拉刷新
    appInfoTable.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self requestAppInfo];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    appInfoTable.mj_header.automaticallyChangeAlpha = YES;
    
//    appInfoTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            // 结束刷新
//            [appInfoTable.mj_footer endRefreshing];
//        });
//    }];
    // 上拉刷新
    appInfoTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page++;
        [self loadMoreAppInfo];
    }];
    
    [self addSubview:appInfoTable];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //    NSLog(@"%ld, %ld", (long)section, (long)listitem.itemNumber);
    if(section == 0){
        return 1;
    }
    return listItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if(indexPath.section == 0){
        CycleScrollCell *cycleCell = [CycleScrollCell cellWithTableView:tableView];
        //        [cycleCell setScrollFrame:listitem.imageURLArray];
        [cycleCell setScrollFrame:scrolImagesArray];
        [cycleCell setScrollViewDelegate:self];
        return cycleCell;
    }else{
        NomalCell *appcell = [NomalCell cellWithTableView:tableView];
        
        NomalFrame *frame = listItemArray[indexPath.row];
        [appcell setNomalFrame:frame section:indexPath.section pos:indexPath.row];
        
        appcell.delegate = self;
        
        return appcell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        return TopViewHeight;
    }else{
        NomalFrame *frame = listItemArray[indexPath.row];
        return frame.cellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NomalFrame *frame = listItemArray[indexPath.row];
    
    HomeGameInfo *gameInfo = frame.packetInfo;
    if(_delegate){
        [_delegate showAppInfo: [NSString stringWithFormat:@"%d", gameInfo.gameID]];
    }
}

-(void) requestAppInfo{
    
    [[[ChoiceCycleAppRequest alloc] init] getScrollViewInfo:^(NSMutableArray *array) {
        
        scrolImagesArray = array;
        [appInfoTable reloadData];
        
    } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
        
    }];
    
    ChoiceCycleAppRequest *appRequest = [[ChoiceCycleAppRequest alloc] init];
    [appRequest setLimit:[NSString stringWithFormat:@"%d", page]];
    [appRequest getCycleAppInfo:^(NSMutableArray *result) {
//                NSLog(@"success dic:%@", result);
        listItemArray = result;
        [appInfoTable reloadData];
        
        [appInfoTable.mj_header endRefreshing];
    } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@", [dic objectForKey:@"return_msg"]];
        NSLog(@"errorMsg:%@", errorMsg);
        
        [appInfoTable.mj_header endRefreshing];
    }];
}

-(void) loadMoreAppInfo{
    
    ChoiceCycleAppRequest *appRequest = [[ChoiceCycleAppRequest alloc] init];
    [appRequest setLimit:[NSString stringWithFormat:@"%d", page]];
    [appRequest getCycleAppInfo:^(NSMutableArray *result) {
        //        NSLog(@"success dic:%@", dic);
        listItemArray = result;
        [listItemArray addObjectsFromArray:result];
        [appInfoTable reloadData];
        
        [appInfoTable.mj_footer endRefreshing];
    } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@", [dic objectForKey:@"return_msg"]];
        NSLog(@"errorMsg:%@", errorMsg);
        
        [appInfoTable.mj_footer endRefreshing];
    }];
}

#pragma mark - DownloadAppDelegate

-(void) startDownloadApp:(NSInteger)section index:(NSInteger)index{
    if(listItemArray.count <= section){
        return;
    }
//    ChoiceListItem *listitem = listItemArray[section];;
    NomalFrame *frame = [listItemArray objectAtIndex:index];
    
    NSString *downUrl = frame.packetInfo.downloadUrl;
//    NSLog(@"%ld_url: %@", (long)index, downUrl);
    
    if([StringUtils isBlankString:downUrl]){
        NSLog(@"download app url is null");
        return;
    }
    InstallAppInfo *appInfo = [[InstallAppInfo alloc] init];
    appInfo.iconUrl = frame.packetInfo.gameIconUrl;
    appInfo.gameName = frame.packetInfo.gameName;
    appInfo.gameSize = frame.packetInfo.packetSize;
    appInfo.gameType = frame.packetInfo.game_type_name;
    appInfo.gameDescribe = frame.packetInfo.introduction;
    appInfo.gameDiscount = frame.packetInfo.appDiscount;
    appInfo.gameBundleId = frame.packetInfo.gameBundleID;
    appInfo.gameBundleId = @"com.mchdemo.paysdk";
//    if(
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *allInstalled = [InstallAppInfo findAll];
        BOOL isHave = false;
        for (int i = 0; i < allInstalled.count; i++) {
            InstallAppInfo *info = allInstalled[i];
            if([appInfo.gameBundleId isEqualToString:info.gameBundleId]){
                isHave = true;
                break;
            }
        }
        if(!isHave){
            [appInfo save];
        }
    });
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downUrl]];
}

#pragma mark - CycleScrollItemDelegate

-(void) clickItem:(NSInteger)appid{
    NSLog(@"clickItem : %ld", (long)appid);
    if(_delegate){
        [_delegate showAppInfo: [NSString stringWithFormat:@"%ld", appid]];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
