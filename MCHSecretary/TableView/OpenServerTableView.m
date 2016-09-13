//
//  OpenServerTableView.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/26.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "OpenServerTableView.h"
#import "StringUtils.h"

#import "MJRefresh.h"

#import "NomalCell.h"
#import "OpenServerEntity.h"

#import "ChoiceListItem.h"
#import "NomalFrame.h"

#import "OpenServerItem.h"
#import "OpenServerFrame.h"

#import "OpenServerHeaderView.h"

#import "OpenServerGameRequest.h"
#import "SearchViewController.h"

#import "DetailsInfoViewController.h"

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

#define SelectDateH 35

#define GetColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define TopBackColor GetColor(18,205,176,1.0)
#define LineColor GetColor(230,230,230,1.0)
#define SelectDateColor GetColor(18,205,176,1.0)
#define NomalDateColor GetColor(0,0,0,1.0)
#define BackColor GetColor(162,235,224,1.0)
#define TitleColor GetColor(200,200,200,1.0)
#define AppNameColor GetColor(100,100,100,1.0)
#define LABLEColor GetColor(98,170,162,1.0)
#define SearchContentColor GetColor(14,83,71,1.0)

#define GetFont(s) [UIFont systemFontOfSize:s]
#define DateFont GetFont(15)
#define SearchFont GetFont(15)

#define halfW kScreenWidth / 2
#define btnW 100

@implementation OpenServerTableView

@synthesize listItemArray;

-(instancetype) initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self initData];
        [self initView];
        [self addTableView];
    }
    return self;
}

-(void) initData{
    page = 1;
    listItemArray = [[NSMutableArray alloc] init];
}

-(void) initView{
    [self addSelectDateView];
    
}

-(void) addSelectDateView{
    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, SelectDateH)];
    [selectView setBackgroundColor:[UIColor whiteColor]];

    CGRect searchFrame = CGRectMake(10, 5, kScreenWidth - 20, SelectDateH-10);
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, SelectDateH - 1, kScreenWidth, 1)];
    [lineView setBackgroundColor:LineColor];
    [selectView addSubview:lineView];
    
    UIView *backView = [[UIView alloc] initWithFrame:searchFrame];
    backView.layer.cornerRadius = 13;
    backView.layer.borderWidth = 1;
    backView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [backView setBackgroundColor:[UIColor whiteColor]];
    [selectView addSubview:backView];

   _btnSearchContent = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, backView.frame.size.width, backView.frame.size.height)];
    [_btnSearchContent setBackgroundColor:[UIColor clearColor]];
    [backView addSubview:_btnSearchContent];

    CGFloat searchH = 15;
    CGFloat searchY = (backView.frame.size.height - searchH) / 2;
    CGSize lblSize = [StringUtils sizeWithString:NSLocalizedString(@"SearchTipText", @"") font:SearchFont maxSize:CGSizeMake(backView.frame.size.width - searchH, searchH)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((backView.frame.size.width - lblSize.width)/2, searchY, lblSize.width, searchH)];
    label.textColor = [UIColor grayColor];
    [label setFont:SearchFont];
    [label setText:NSLocalizedString(@"SearchTipText", @"")];
    [_btnSearchContent addSubview:label];
    
    CGFloat imageX = (backView.frame.size.width - CGRectGetWidth(label.frame)) / 2 - 20;
    UIImage *image = [UIImage imageNamed:@"choice_search.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, searchY, searchH, searchH)];
    [imageView setImage:image];
    [_btnSearchContent addSubview:imageView];
    
    [self addSubview:selectView];
}

-(void) addTableView{
    
    openserverTable = [[UITableView alloc] initWithFrame:CGRectMake(0, SelectDateH, kScreenWidth, kScreenHeight - SelectDateH - 65)];
    openserverTable.delegate = self;
    openserverTable.dataSource = self;
    
    // 下拉刷新
    openserverTable.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
         page = 1;
        [self requestAppInfo];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    openserverTable.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    openserverTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            page++;
            [self loadMoreAppInfo];
            // 结束刷新
//            [openserverTable.mj_footer endRefreshing];
//        });
    }];
    
    [self addSubview:openserverTable];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return listItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NomalCell *appcell = [NomalCell cellWithTableView:tableView];
    
    NomalFrame *frame = listItemArray[indexPath.row];
    
    [appcell openServerSetNomalFrame:frame section:indexPath.section pos:indexPath.row];

    return appcell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NomalFrame *frame = listItemArray[indexPath.row];
    return frame.cellHeight;
}

-(CGFloat)tableView:(UITableView *) tableView heightForHeaderInSection:(NSInteger)section{
       return 0.1;
}

-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self showAppDetail:indexPath.section index:indexPath.row];
    
}
-(void)serachOpenServerApp:(UIButton *)sender{
    if(_delegate){
        [_delegate startSearchApp];
    }
}

-(void)requestAppInfo{

    OpenServerGameRequest *gameRequest = [[OpenServerGameRequest alloc] init];
    
    [gameRequest setLimit:[NSString stringWithFormat:@"%d", page]];
    [gameRequest requestOpenServerGame:^(NSMutableArray *opserverArray) {

        listItemArray = opserverArray;
        
        [openserverTable reloadData];
        
        [openserverTable.mj_header endRefreshing];

        
    } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@", [dic objectForKey:@"return_msg"]];
        NSLog(@"errorMsg:%@", errorMsg);
        
        [openserverTable.mj_header endRefreshing];

    }];
    
}
-(void)loadMoreAppInfo
{
    OpenServerGameRequest *gameRequest = [[OpenServerGameRequest alloc] init];
    [gameRequest setLimit:[NSString stringWithFormat:@"%d", page]];
    [gameRequest requestOpenServerGame:^(NSMutableArray *opserverArray) {
        
        listItemArray = opserverArray;
        
        [listItemArray addObjectsFromArray:opserverArray];
        
        [openserverTable reloadData];
        
        [openserverTable.mj_footer endRefreshing];
        
    } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@", [dic objectForKey:@"return_msg"]];
        NSLog(@"errorMsg:%@", errorMsg);
        
        [openserverTable.mj_footer endRefreshing];
        
    }];
}
#pragma OpenServerSearchDelegate

-(void) showAppDetail:(NSInteger)section index:(NSInteger)index{
    NomalFrame *frame = listItemArray[index];
    if(_delegate){
        [_delegate showAppDetailInfo:frame.openServerInfo.gameID];
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
