//
//  AppInfoTableView.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/26.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "AppInfoTableView.h"

#import "MJRefresh.h"

#import "ChoiceCycleAppRequest.h"

#import "NomalFrame.h"
#import "AppPacketInfo.h"
#import "ChoiceHeadeView.h"
#import "ChoiceListItem.h"
#import "CycleScrollCell.h"

#define TopViewHeight 100

@interface AppInfoTableView(){
    UITableView *appInfoTable;
}


@end

@implementation AppInfoTableView

@synthesize listItemArray;

-(instancetype) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initData];
        
        [self addScrollView];
    }
    return self;
}

-(void) initData{
    listItemArray = [[NSMutableArray alloc] init];
    
}

-(void) addScrollView{
    appInfoTable = [[UITableView alloc] initWithFrame:self.bounds];
    appInfoTable.delegate = self;
    appInfoTable.dataSource = self;
    
    // 下拉刷新
    appInfoTable.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
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
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [appInfoTable.mj_footer endRefreshing];
        });
    }];
    
    [self addSubview:appInfoTable];
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
    if(listitem.cellType == CellStyle_Cycle){
        CycleScrollCell *cycleCell = [CycleScrollCell cellWithTableView:tableView];
        //        [cycleCell setScrollFrame:listitem.imageURLArray];
        [cycleCell setScrollFrame:listitem.appInfoArray];
        [cycleCell setScrollViewDelegate:self];
        return cycleCell;
    }else{
        NomalCell *appcell = [NomalCell cellWithTableView:tableView];
        NomalFrame *frame = listitem.appInfoArray[indexPath.row];
        [appcell setNomalFrame:frame section:indexPath.section pos:indexPath.row];
        appcell.delegate = self;
        
        return appcell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChoiceListItem *listitem = listItemArray[indexPath.section];
    if(listitem.cellType == CellStyle_Cycle){
        return TopViewHeight;
    }else{
        NomalFrame *frame = listitem.appInfoArray[indexPath.row];
        return frame.cellHeight;
    }
}

//-(CGFloat)tableView:(UITableView *) tableView heightForHeaderInSection:(NSInteger)section{
//    return 0.1;
//}
//
//-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 1;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_delegate showAppInfo];
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

#pragma mark - CycleScrollItemDelegate

-(void) clickItem:(NSInteger)selectedIndex{
    NSLog(@"clickItem : %ld", (long)selectedIndex);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
