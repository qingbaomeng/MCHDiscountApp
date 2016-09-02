//
//  OpenServerTableView.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/26.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "OpenServerTableView.h"

#import "MJRefresh.h"

#import "OpenServerItem.h"
#import "OpenServerFrame.h"
#import "OpenServerCell.h"
#import "OpenServerHeaderView.h"

#import "OpenServerGameRequest.h"

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

#define SelectDateH 35

#define GetColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define LineColor GetColor(230,230,230,1.0)
#define SelectDateColor GetColor(18,205,176,1.0)
#define NomalDateColor GetColor(0,0,0,1.0)

#define GetFont(s) [UIFont systemFontOfSize:s]
#define DateFont GetFont(15)

#define halfW kScreenWidth / 2
#define btnW 100

@implementation OpenServerTableView

@synthesize listItemArray;

-(instancetype) initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self initData];
        [self initView];
    }
    return self;
}

-(void) initData{
    listItemArray = [[NSMutableArray alloc] init];
}

-(void) initView{
    [self addSelectDateView];
    [self addTableView];
}

-(void) addSelectDateView{
    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, SelectDateH)];
    [selectView setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat todayX = halfW - btnW;
    btnToday = [[UIButton alloc] initWithFrame:CGRectMake(todayX, 0, btnW, SelectDateH)];
    [btnToday setTitle:NSLocalizedString(@"Today", @"") forState:UIControlStateNormal];
    btnToday.titleLabel.font = DateFont;
    [btnToday setTitleColor:SelectDateColor forState:UIControlStateNormal];
    [btnToday addTarget:self action:@selector(requestTodayGame:) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:btnToday];
    
    
    btnTomorrow = [[UIButton alloc] initWithFrame:CGRectMake(halfW, 0, btnW, SelectDateH)];
    [btnTomorrow setTitle:NSLocalizedString(@"Tomorrow", @"") forState:UIControlStateNormal];
    [btnTomorrow setTitleColor:NomalDateColor forState:UIControlStateNormal];
    btnTomorrow.titleLabel.font = DateFont;
    [btnTomorrow addTarget:self action:@selector(requestTomorrowGame:) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:btnTomorrow];
    
    UIButton *btnSearch = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 90, 0, 80, SelectDateH)];
    [btnSearch setTitle:@"搜开服" forState:UIControlStateNormal];
    [btnSearch setTitleColor:NomalDateColor forState:UIControlStateNormal];
    btnSearch.titleLabel.font = DateFont;
    [btnSearch addTarget:self action:@selector(serachOpenServerApp:) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:btnSearch];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, SelectDateH - 1, kScreenWidth, 1)];
    [lineView setBackgroundColor:LineColor];
    [selectView addSubview:lineView];
    
    
    selectLineView = [[UIView alloc] initWithFrame:CGRectMake(todayX, SelectDateH - 2, btnW, 2)];
    [selectLineView setBackgroundColor:SelectDateColor];
    [selectView addSubview:selectLineView];
    
    
    [self addSubview:selectView];
}

-(void) addTableView{
    
    openserverTable = [[UITableView alloc] initWithFrame:CGRectMake(0, SelectDateH, kScreenWidth, kScreenHeight - SelectDateH - 65)];
    openserverTable.delegate = self;
    openserverTable.dataSource = self;
    
    // 下拉刷新
    openserverTable.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self requestAppInfo];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    openserverTable.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    openserverTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [openserverTable.mj_footer endRefreshing];
        });
    }];
    
    [self addSubview:openserverTable];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return listItemArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    OpenServerItem *listitem = listItemArray[section];
    
//    NSInteger rowsCount = listitem.appInfoArray.count;
//    int curCount = (short)rowsCount / 2;
//    int temp = rowsCount % 2;
//    if(temp > 0){
//        curCount += 1;
//    }
    return listitem.appInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OpenServerItem *openserveritem = listItemArray[indexPath.section];
    OpenServerFrame *frame = openserveritem.appInfoArray[indexPath.row];
    
    OpenServerCell *cell = [OpenServerCell cellWithTableView:tableView];
    [cell setOpenServerFrame:frame];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    OpenServerItem *openserveritem = listItemArray[indexPath.section];
    OpenServerFrame *frame = openserveritem.appInfoArray[indexPath.row];
//    NSLog(@"cellHeight:%f", frame.cellHeight);
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
    
    return 10;
}

-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    OpenServerItem *openserveritem = listItemArray[section];
    OpenServerHeaderView *header = [OpenServerHeaderView headerWithTableView:tableView];
    
    [header setTitleContent:openserveritem.openServerTime];
    return header;
}

-(void)requestTodayGame:(UIButton *)sender{
    [btnToday setTitleColor:SelectDateColor forState:UIControlStateNormal];
    [btnTomorrow setTitleColor:NomalDateColor forState:UIControlStateNormal];
    [selectLineView setFrame:CGRectMake(halfW - btnW, SelectDateH - 2, btnW, 2)];
    
    if(listItemArray == nil || listItemArray.count <= 0){
        [self requestAppInfo];
    }
}

-(void)requestTomorrowGame:(UIButton *)sender{
    [btnToday setTitleColor:NomalDateColor forState:UIControlStateNormal];
    [btnTomorrow setTitleColor:SelectDateColor forState:UIControlStateNormal];
    [selectLineView setFrame:CGRectMake(halfW, SelectDateH - 2, btnW, 2)];
    
    if(listItemArray == nil || listItemArray.count <= 0){
        [self requestAppInfo];
    }
}

-(void)serachOpenServerApp:(UIButton *)sender{
    [_delegate startSearchApp];
}

-(void)requestAppInfo{
    OpenServerGameRequest *gameRequest = [[OpenServerGameRequest alloc] init];
    [gameRequest requestOpenServerGame:^(NSMutableArray *opserverArray) {
        listItemArray = opserverArray;
//        NSLog(@"count:%lu", (unsigned long)listItemArray.count);
        [openserverTable reloadData];
        [openserverTable.mj_header endRefreshing];
    } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
        
    }];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
