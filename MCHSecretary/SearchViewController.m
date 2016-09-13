//
//  SearchViewController.m
//  MCHSecretary
//
//  Created by 朱进 on 16/8/12.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "SearchViewController.h"

#import "StringUtils.h"
#import "TopSearchView.h"
#import "MJRefresh.h"
#import "FileUtils.h"
#import "WebImage.h"

#import "InstallAppInfo.h"

#import "DetailsInfoViewController.h"
#import "OpenServerSearchFrame.h"
#import "OpenServerEntity.h"
#import "SearchOpenServerRequest.h"
#import "SearchAppRequest.h"
#import "InstallAppRequest.h"

//#import "ChoiceCycleAppRequest.h"

#define AppSearchHisFile @"appsearch.txt"
#define OpenServerHisFile @"openserver.txt"

#define TopViewH 65
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

#define GetColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define TopBackColor GetColor(18,205,176,1.0)
#define BackColor GetColor(162,235,224,1.0)
#define TitleColor GetColor(200,200,200,1.0)
#define AppNameColor GetColor(100,100,100,1.0)
#define LABLEColor GetColor(98,170,162,1.0)
#define SearchContentColor GetColor(14,83,71,1.0)

#define GetFont(s) [UIFont systemFontOfSize:s]
#define SearchFont GetFont(15)
#define TitleFont GetFont(15)
#define ResultFont GetFont(17)
#define AppNameFont GetFont(13)
#define SearchBtnFont GetFont(13)
#define ClearFont GetFont(10)

@interface SearchViewController(){
    UIView *topview;
    
    UIView *backView;
    UIButton *leftImage;
    UIButton *btnSearchContent;
    
    UIImageView *imageIcon;
    UITextField *searchField;
    
    UIView *recommentView;
    
    UIView *searchButtonView;
    UIButton *clearBtn;
    
    UITableView *appInfoTable;
    
    
    BOOL isSearchOpenServerGame;
    NSMutableArray *appSearchHisArray;
    CGFloat searchHisY;
    
    BOOL isAddRommentView;
    
    NSString *searchKey;
}

@end


@implementation SearchViewController

@synthesize listItemArray, listsearchItemArray,defaultItemArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isAddRommentView = YES;
    searchKey = @"";
    page = 1;
    [self requestForRecommandApp];
}

-(void) viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [super.navigationController setToolbarHidden:YES animated:TRUE];
    [super viewWillAppear:animated];
    
    
    appSearchHisArray = [[NSMutableArray alloc] init];
    listItemArray = [[NSMutableArray alloc] init];
    listsearchItemArray = [[NSMutableArray alloc] init];
    defaultItemArray = [[NSMutableArray alloc]init];
    
    [self initSearchKey];
    
    if ([searchKey isEqualToString:@""])
    {
        [self addTopView];
    }
    else
    {
        [self showSearchView];
        [self requestAppInfo];
    }

}
-(void)requestForRecommandApp
{
    [[[SearchAppRequest alloc]init]requstForDefaultGameserverInfo:^(NSMutableArray *array) {
        [defaultItemArray addObjectsFromArray:array];
        
        if (isAddRommentView) {
            [self addRecommentView:NO];
        }else{
            [self showSearchView];
        }
        
    } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
        
    }];
}

//设置搜索开服游戏
-(void) searchOpenServerGame{
    isSearchOpenServerGame = YES;
}

//获取所有搜索关键字
-(void) initSearchKey{
    NSString *fileName = @"";
    if(isSearchOpenServerGame){
//        NSLog(@"SearchOpenServer");
        fileName = OpenServerHisFile;
    }else{
//        NSLog(@"Search nomal App");
        fileName = AppSearchHisFile;
    }
    
    NSMutableArray *hisArray = [[FileUtils loadArrayList:fileName] mutableCopy];
    if(hisArray != nil){
        [appSearchHisArray addObjectsFromArray:hisArray];
    }else{
        NSLog(@"appSearchHisArray is null");
    }
}

//头部搜索栏
-(void) addTopView{
    topview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopViewH)];
    [topview setBackgroundColor:TopBackColor];
    [self.view addSubview:topview];
    
    CGFloat topY = 30;
    CGFloat searchPosX = 10;
    CGRect searchFrame = CGRectMake(10, 30, kScreenWidth - 20, TopViewH - 30 - 10);
    if(isSearchOpenServerGame){//搜索开服游戏
        leftImage = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftImage setFrame:CGRectMake(10, topY, 16, 25)];
        [leftImage setImage:[UIImage imageNamed:@"viewback.png"] forState:UIControlStateNormal];
        [leftImage addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
        [topview addSubview:leftImage];
        
        searchPosX = CGRectGetMaxX(leftImage.frame) + 25;
        searchFrame = CGRectMake(searchPosX, topY, kScreenWidth - searchPosX - 10, TopViewH - 30 - 10);
    }
    
    backView = [[UIView alloc] initWithFrame:searchFrame];
    backView.layer.cornerRadius = 13;
    [backView setBackgroundColor:BackColor];
    [topview addSubview:backView];
    
    btnSearchContent = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, backView.frame.size.width, backView.frame.size.height)];
    [btnSearchContent addTarget:self action:@selector(setSearchContent:) forControlEvents:UIControlEventTouchUpInside];
    [btnSearchContent setBackgroundColor:[UIColor clearColor]];
    
    [backView addSubview:btnSearchContent];
    
    CGFloat searchH = 15;
    CGFloat searchY = (backView.frame.size.height - searchH) / 2;
    CGSize lblSize = [StringUtils sizeWithString:NSLocalizedString(@"SearchTipText", @"") font:SearchFont maxSize:CGSizeMake(backView.frame.size.width - searchH, searchH)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((backView.frame.size.width - lblSize.width)/2, searchY, lblSize.width, searchH)];
    label.textColor = LABLEColor;
    [label setFont:SearchFont];
    [label setText:NSLocalizedString(@"SearchTipText", @"")];
    [btnSearchContent addSubview:label];
    
    CGFloat imageX = (backView.frame.size.width - CGRectGetWidth(label.frame)) / 2 - 20;
    UIImage *image = [UIImage imageNamed:@"choice_search.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, searchY, searchH, searchH)];
    [imageView setImage:image];
    [btnSearchContent addSubview:imageView];
    
    
}

//添加推荐区域
-(void) addRecommentView:(BOOL)isShowSearchTip{
    if(recommentView){
        [recommentView removeFromSuperview];
    }
    CGFloat posy = CGRectGetMaxY(topview.frame);
    CGFloat tableH = kScreenHeight - posy - 49;
    if(isSearchOpenServerGame){
        tableH = kScreenHeight - posy;
    }
    recommentView = [[UIView alloc] initWithFrame:CGRectMake(0, posy, kScreenWidth, tableH)];
    [self.view addSubview:recommentView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [recommentView addGestureRecognizer:singleTap];
    
    //无搜索结果提示
    CGFloat lblY = 15;
    if(isShowSearchTip){
        UILabel *lblSrarchResult = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
        [lblSrarchResult setFont:ResultFont];
        [lblSrarchResult setTextColor:TitleColor];
        [lblSrarchResult setText:NSLocalizedString(@"SearchResult", @"")];
        [lblSrarchResult setTextAlignment:NSTextAlignmentCenter];
        [recommentView addSubview:lblSrarchResult];
        
        lblY = CGRectGetMaxY(lblSrarchResult.frame) + 10;
    }
    
    //推荐游戏区域
    UILabel *lblRecomment = [[UILabel alloc] initWithFrame:CGRectMake(15, lblY, kScreenWidth, 15)];
    [lblRecomment setFont:TitleFont];
    [lblRecomment setTextColor:TitleColor];
    [lblRecomment setText:NSLocalizedString(@"SearchRecommentTitle", @"")];
    [recommentView addSubview:lblRecomment];
    
    [self addRecommentApp:recommentView posy:(CGFloat)CGRectGetMaxY(lblRecomment.frame) + 10];
}

//添加推荐游戏
-(void) addRecommentApp:(UIView *)parentView posy:(CGFloat)posy{
    int btnNum;
    CGFloat iconW = 60;
    CGFloat nameW = 20;
    CGFloat spaceW = (kScreenWidth - iconW * 4) / 5;
    if (defaultItemArray.count < 4)
    {
        btnNum = (int)defaultItemArray.count;
    }
    else
    {
        btnNum = 4;
    }
    for (int i = 0; i < btnNum; i++) {
        UIButton *btnRecoment = [[UIButton alloc] initWithFrame:CGRectMake(spaceW + (spaceW + iconW) * i, posy, iconW, iconW + nameW)];
        btnRecoment.tag = 10+i;
        [btnRecoment addTarget:self action:@selector(recomentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [parentView addSubview:btnRecoment];
        
        UIImageView *iconApp = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iconW, iconW)];
        
        [btnRecoment addSubview:iconApp];
        
        UILabel *lblRecomment = [[UILabel alloc] initWithFrame:CGRectMake(0, iconW + 2, iconW, 13)];
        [lblRecomment setFont:AppNameFont];
        [lblRecomment setTextColor:AppNameColor];
        
        [lblRecomment setTextAlignment:NSTextAlignmentCenter];
        [btnRecoment addSubview:lblRecomment];
        
        OpenServerEntity *info = defaultItemArray[i];
        [iconApp sd_setImageWithURL:[NSURL URLWithString:info.smallImageUrl] placeholderImage:[UIImage imageNamed:@"appinstall.png"]];
        [lblRecomment setText:info.packetName];
      }
   

    UILabel *lblSearchHis = [[UILabel alloc] initWithFrame:CGRectMake(15, posy + iconW + nameW + 10, kScreenHeight, 15)];
    [lblSearchHis setFont:TitleFont];
    [lblSearchHis setTextColor:TitleColor];
    [lblSearchHis setText:NSLocalizedString(@"SearchHistoary", @"")];
    [recommentView addSubview:lblSearchHis];
    
    clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 70, posy + iconW + nameW + 10, 70, 10)];
    [clearBtn setImage:[UIImage imageNamed:@"clear_btn"] forState:UIControlStateNormal];
    [clearBtn setTitleColor:AppNameColor forState:UIControlStateNormal];
    [clearBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    clearBtn.titleLabel.font = ClearFont;
    [clearBtn setTitle:NSLocalizedString(@"ClearSearchHis", @"") forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearSearchHisList:) forControlEvents:UIControlEventTouchUpInside];
    [clearBtn setHidden:YES];
    
    [recommentView addSubview:clearBtn];
    
    searchHisY = CGRectGetMaxY(lblSearchHis.frame) + 10;
    
    [self addSearchHistoary];
}
-(void)recomentBtnClick:(UIButton *)btn
{
    OpenServerEntity *info = defaultItemArray[btn.tag - 10];
    searchKey = info.packetName;
    [self showSearchView];
    [searchField setText:searchKey];
    [self saveSearchKey];
    [self requestAppInfo];
}
//添加搜索文字记录
-(void) addSearchHistoary{
    if(searchButtonView){
        [searchButtonView removeFromSuperview];
    }
    
    if(appSearchHisArray && appSearchHisArray.count > 0){
        [clearBtn setHidden:NO];
        searchButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, searchHisY, kScreenWidth, kScreenHeight - searchHisY)];
        [searchButtonView setBackgroundColor:[UIColor whiteColor]];
        [recommentView addSubview:searchButtonView];
        
        CGFloat preX = 10;
        CGFloat preY = 10;
        
        for (NSInteger i = appSearchHisArray.count - 1; i >= 0; i--) {
            CGRect frame = [self nextBtnFrame:appSearchHisArray[i] posX:preX posY:preY];
            
            UIButton *btn = [self createSearchButton:appSearchHisArray[i] frame:frame];
            btn.tag = i;
            [searchButtonView addSubview:btn];
            preX = CGRectGetMaxX(btn.frame) + 10;
            preY = btn.frame.origin.y;
        }
        
//        for (int i = 0; i < appSearchHisArray.count; i++) {
//            CGRect frame = [self nextBtnFrame:appSearchHisArray[i] posX:preX posY:preY];
//            
//            UIButton *btn = [self createSearchButton:appSearchHisArray[i] frame:frame];
//            btn.tag = i;
//            [searchButtonView addSubview:btn];
//            preX = CGRectGetMaxX(btn.frame) + 10;
//            preY = btn.frame.origin.y;
//        }
    }else{
        [clearBtn setHidden:YES];
    }
    
}

//清除搜索历史文本
-(void) clearSearchHisList:(UIButton *)MACH_NOTIFY_NO_SENDERS{
    [appSearchHisArray removeAllObjects];
    
    if(isSearchOpenServerGame){
        [FileUtils delete:OpenServerHisFile];
    }else{
        [FileUtils delete:AppSearchHisFile];
    }
    
    [self addSearchHistoary];
}

//获取下一个按钮的Frame
-(CGRect) nextBtnFrame:(NSString *)txt posX:(CGFloat)posx posY:(CGFloat)posy{
    CGFloat spaceBtn = 10;//按钮两边空白区域
    CGFloat btnX = posx;
    CGFloat btnY = posy;
    int btnH = 25;//按钮高度
    
    CGFloat contentW = kScreenWidth - 20;
    NSInteger strlenght = [StringUtils stringByteLength:txt];
    CGFloat btnW = (strlenght / 2) * 13 + spaceBtn;
    
    CGFloat btnMaxY = btnW + posx;
    
    if (btnMaxY > contentW) {
        btnY += 10 + btnH;
        btnX = 10;
    }
    
    CGRect btnFrame = CGRectMake(btnX, btnY , btnW, btnH);
    return btnFrame;
}

//创建搜索按钮
-(UIButton *) createSearchButton:(NSString *)txt frame:(CGRect)frame{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    btn.layer.cornerRadius = 10;
    [btn setBackgroundColor:[UIColor whiteColor]];
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [TopBackColor CGColor];
    [btn setTitle:txt forState:UIControlStateNormal];
    [btn setTitleColor:TopBackColor forState:UIControlStateNormal];
    btn.titleLabel.font = SearchBtnFont;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [btn addTarget:self action:@selector(startSearchkey:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

-(void) startSearchkey:(UIButton *)sender{
    NSInteger index = sender.tag;
    NSString *key = appSearchHisArray[index];
//    NSLog(@"key:%@",key);
    searchKey = key;
    
    [self showSearchView];
    [self saveSearchKey];
    [self requestAppInfo];
    
}

//添加搜索游戏结果
-(void) addScrollView{
    if(appInfoTable){
        [appInfoTable removeFromSuperview];
    }
    CGFloat posy = CGRectGetMaxY(topview.frame);
    CGFloat tableH = kScreenHeight - posy - 49;
    if(isSearchOpenServerGame){
        tableH = kScreenHeight - posy;
    }
    appInfoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, posy, kScreenWidth, tableH)];
    appInfoTable.separatorStyle = UITableViewCellSelectionStyleNone;
    appInfoTable.delegate = self;
    appInfoTable.dataSource = self;
    appInfoTable.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);;
    
    // 下拉刷新
    appInfoTable.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self requestAppInfo];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    appInfoTable.mj_header.automaticallyChangeAlpha = YES;
    
    appInfoTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            page++;
            [self loadMore];
            // 结束刷新
            [appInfoTable.mj_footer endRefreshing];
        });
    }];
     [self.view addSubview:appInfoTable];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(isSearchOpenServerGame){
         return listsearchItemArray.count;
    }
    return listItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(isSearchOpenServerGame){
        OpenServerSearchFrame *serverFrame = listsearchItemArray[indexPath.row];
        NSLog(@"123123===%@",serverFrame.openServerFrameArray);
        OpenServerSearchCell * serverCell = [OpenServerSearchCell cellWithTableView:tableView];
        serverCell.delegate = self;
        [serverCell setOpenServerSearchFrame:serverFrame pos:indexPath.row openserver:YES];
        return serverCell;
    }
    OpenServerSearchFrame *frame = listItemArray[indexPath.row];
    OpenServerSearchCell * cell = [OpenServerSearchCell cellWithTableView:tableView];
    [cell setOpenServerSearchFrame:frame pos:indexPath.row openserver:NO];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(isSearchOpenServerGame){
        OpenServerSearchFrame *serverFrame = listsearchItemArray[indexPath.row];
        return serverFrame.cellHeight;
    }
    OpenServerSearchFrame *frame = listItemArray[indexPath.row];
    return frame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int infoid;
    if (isSearchOpenServerGame)
    {
        OpenServerSearchFrame *serverFrame = listsearchItemArray[indexPath.row];
        infoid = serverFrame.packetInfo.gameID;
    }
    else
    {
     OpenServerSearchFrame *frame = listItemArray[indexPath.row];
        infoid = frame.packetInfo.gameID;
    }
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    DetailsInfoViewController *detailsView = [mainStoryboard instantiateViewControllerWithIdentifier:@"detailsinfo"];
    detailsView.appId = [NSString stringWithFormat:@"%d", infoid];
    [self.navigationController pushViewController:detailsView animated:YES];
    isAddRommentView = NO;
}
//搜索app
-(void) requestAppInfo{
    if ([searchKey isEqualToString:@""])
    {
        return;
    }
    if(isSearchOpenServerGame){
      SearchOpenServerRequest *searchOpenRequest =[[SearchOpenServerRequest alloc] init];
        [searchOpenRequest setLimit:[NSString stringWithFormat:@"%d",page]];
        [searchOpenRequest search:searchKey FromOpenServerInfo:^(NSMutableArray *opserverArray) {
            [listsearchItemArray removeAllObjects];
            if(opserverArray != nil){
                [listsearchItemArray addObjectsFromArray:opserverArray];
                [self addScrollView];
            }else{
                [self addRecommentView:YES];
            }
            [appInfoTable.mj_header endRefreshing];
        } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
            [self addRecommentView:YES];
            NSString *errorMsg = [NSString stringWithFormat:@"%@", [dic objectForKey:@"return_msg"]];
            NSLog(@"errorMsg:%@", errorMsg);
            [appInfoTable.mj_header endRefreshing];
        }];
        return;
    }
    
  SearchAppRequest *searchRequest  = [[SearchAppRequest alloc] init];
    [searchRequest setLimit:[NSString stringWithFormat:@"%d",page]];
    [searchRequest gamename:searchKey serverInfo:^(NSMutableArray *serverArray) {
        [listItemArray removeAllObjects];
        //        result = nil;
        if(serverArray != nil){
            [listItemArray addObjectsFromArray:serverArray];
            [self addScrollView];
        }else{
            [self addRecommentView:YES];
        }
        [appInfoTable.mj_header endRefreshing];
    } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
        [self addRecommentView:YES];
        NSString *errorMsg = [NSString stringWithFormat:@"%@", [dic objectForKey:@"return_msg"]];
        NSLog(@"errorMsg:%@", errorMsg);
        [appInfoTable.mj_header endRefreshing]; 
    }];
}
-(void)loadMore
{
    if(isSearchOpenServerGame){
        SearchOpenServerRequest *searchOpenRequest =[[SearchOpenServerRequest alloc] init];
        [searchOpenRequest setLimit:[NSString stringWithFormat:@"%d",page]];
        [searchOpenRequest search:searchKey FromOpenServerInfo:^(NSMutableArray *opserverArray) {
            [listsearchItemArray removeAllObjects];
            if(opserverArray != nil){
                listItemArray = opserverArray;
                [listsearchItemArray addObjectsFromArray:opserverArray];
                [self addScrollView];
            }else{
                
            }
            [appInfoTable.mj_footer endRefreshing];
        } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
            [self addRecommentView:YES];
            NSString *errorMsg = [NSString stringWithFormat:@"%@", [dic objectForKey:@"return_msg"]];
            NSLog(@"errorMsg:%@", errorMsg);
            [appInfoTable.mj_footer endRefreshing];
        }];
        return;
    }
    
    SearchAppRequest *searchRequest  = [[SearchAppRequest alloc] init];
    [searchRequest setLimit:[NSString stringWithFormat:@"%d",page]];
    [searchRequest gamename:searchKey serverInfo:^(NSMutableArray *serverArray) {
        [listItemArray removeAllObjects];
        //        result = nil;
        if(serverArray != nil){
            [listItemArray addObjectsFromArray:serverArray];
            [self addScrollView];
        }else{
           
        }
        [appInfoTable.mj_footer endRefreshing];
    } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
        [self addRecommentView:YES];
        NSString *errorMsg = [NSString stringWithFormat:@"%@", [dic objectForKey:@"return_msg"]];
        NSLog(@"errorMsg:%@", errorMsg);
        [appInfoTable.mj_footer endRefreshing];
    }];

}
//显示搜索
-(void)setSearchContent:(UIButton *)sender{
    [self showSearchView];
}

-(void) showSearchView{
    [btnSearchContent setHidden:YES];
    
    [self addSearchInputView];
}

//添加搜索文本框
-(void)addSearchInputView{
    if(imageIcon){
        [imageIcon removeFromSuperview];
    }
    if(searchField){
        [searchField removeFromSuperview];
    }
    CGFloat searchH = 15;
    CGFloat searchY = (backView.frame.size.height - searchH) / 2;
    
    UIImage *image = [UIImage imageNamed:@"choice_search.png"];
    imageIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, searchY, 15, 15)];
    [imageIcon setImage:image];
    [backView addSubview:imageIcon];
    
    CGFloat tfX = CGRectGetMaxX(imageIcon.frame) + 5;
    searchField = [[UITextField alloc] initWithFrame:CGRectMake(tfX, searchY, backView.frame.size.width - tfX, searchH)];
    searchField.textColor = SearchContentColor;
    searchField.placeholder = NSLocalizedString(@"SearchTipText", @"");
    searchField.returnKeyType = UIReturnKeySearch;
    [searchField setFont:SearchFont];
    searchField.enablesReturnKeyAutomatically = YES;
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [searchField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [searchField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    searchField.delegate = self;
    [searchField setText:searchKey];
    
    
    [backView addSubview:searchField];
    if([searchKey isEqualToString:@""]){
        [searchField becomeFirstResponder];
    }
}

//保存搜索关键字
-(void) saveSearchKey{
    NSString *con = [[searchField text] stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSLog(@"con:%@",con);
    if(![StringUtils isBlankString:con]){
        searchKey = con;
//        BOOL isContrain = false;
        int curIndex = -1;
        for (int i = 0; i < appSearchHisArray.count; i++) {
            if([con isEqualToString:appSearchHisArray[i]]){
//                isContrain = true;
                curIndex = i;
                break;
            }
        }
        if(curIndex != -1){
            [appSearchHisArray removeObjectAtIndex:curIndex];
        }
        [appSearchHisArray addObject:con];
        NSString *fileName = @"";
        if(isSearchOpenServerGame){
            fileName = OpenServerHisFile;
        }else{
            fileName = AppSearchHisFile;
        }
        [FileUtils saveOrderArrayList:appSearchHisArray FileUrl:fileName];
    }
}

//键盘Done代理，键盘消失
#pragma UITextFieldDelegate

//开始搜索
- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    if(aTextfield){
        [aTextfield resignFirstResponder];
    }
    [self saveSearchKey];
    
    [self requestAppInfo];
    return YES;
}

//清除输入框内容
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    searchKey = @"";
    isAddRommentView = YES;
    
    [self addRecommentView:NO];
    
    if(appInfoTable){
        [appInfoTable removeFromSuperview];
    }
    
    return YES;
}

#pragma 触摸空白区域

- (void)handleTap:(UITapGestureRecognizer *)tap {
    if(searchField){
        [searchField resignFirstResponder];
    }
    [btnSearchContent setHidden:NO];
    
    [imageIcon removeFromSuperview];
    [searchField removeFromSuperview];
}

-(void)btnBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - OpenServerSearchDelegate

-(void) startDownloadApp:(NSInteger)index{
    OpenServerEntity *selGame;
    if(isSearchOpenServerGame && index < listsearchItemArray.count){
        OpenServerSearchFrame *serverFrame = listsearchItemArray[index];
        selGame = serverFrame.packetInfo;
    }else if(!isSearchOpenServerGame && index < listItemArray.count){
        OpenServerSearchFrame *frame = listItemArray[index];
        selGame = frame.packetInfo;
    }
    
    [self requestDownloadUrl:selGame.gameID];
    
    InstallAppInfo *appInfo = [[InstallAppInfo alloc] init];
    appInfo.appid = selGame.gameID;
    appInfo.iconUrl = selGame.smallImageUrl;
    appInfo.gameName = selGame.packetName;
    appInfo.gameSize = selGame.gameSize;
    appInfo.gameType = selGame.game_type_name;
    appInfo.gameDescribe = selGame.gameDesc;
    appInfo.gameDiscount = selGame.appDiscount;
    appInfo.gameBundleId = selGame.appBundleId;
    
    if([@"" isEqualToString:appInfo.gameBundleId]){
        NSLog(@"BundleId is null");
        return;
    }
    
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
        NSLog(@"fun# errorMsg:%@", errorMsg);
    }];
}



-(void) showAllOpenServerInfo:(NSInteger)index{
     NSLog(@"[SearchViewController] fun#showAllOpenServer:%ld", (long)index);
    if(listsearchItemArray){
        NSLog(@"[SearchViewController] listsearchItemArray:%ld", (long)listsearchItemArray.count);
    }
    if(listItemArray){
        NSLog(@"[SearchViewController] istItemArray:%ld", (long)listItemArray.count);
    }
    if (appInfoTable) {
        [appInfoTable reloadData];
    }
}

@end
