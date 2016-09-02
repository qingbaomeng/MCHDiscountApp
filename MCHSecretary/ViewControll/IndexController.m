//
//  IndexController.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/26.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "IndexController.h"

#import "DetailsInfoViewController.h"
#import "SearchViewController.h"


#define TopViewH 65
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

#define GetColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define TopBackColor GetColor(18,205,176,1.0)
#define TopBtnNomalColor GetColor(7,186,157,1.0)
#define TopBtnSelectColor GetColor(255,255,255,1.0)

@interface IndexController (){
    UIButton *appBtn;
    UIButton *openServerBtn;
}

@end

@implementation IndexController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
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

-(void) initView{
    [self addTopView];
    
    [self addScrollView];
}

-(void) addTopView{
    UIView *topview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopViewH)];
    [topview setBackgroundColor:TopBackColor];
    [self.view addSubview:topview];
    
    CGFloat topWHalf = CGRectGetMaxX(topview.frame) / 2;
    CGFloat btnH = 30;
    CGFloat btnW = 90;
    CGFloat btnY = (TopViewH - 20 - btnH) / 2 + 20;
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(topWHalf - btnW, btnY, btnW * 2, btnH)];
    [btnView setBackgroundColor:TopBtnNomalColor];
    btnView.layer.cornerRadius = 5;
    
    [topview addSubview:btnView];
    
    appBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnW, btnH)];
    appBtn.layer.cornerRadius = 5;
    [appBtn setTitle:NSLocalizedString(@"Game", @"") forState:UIControlStateNormal];
    [appBtn addTarget:self action:@selector(showGame) forControlEvents:UIControlEventTouchUpInside];
    
    [btnView addSubview:appBtn];
    
    openServerBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnW, 0, btnW, btnH)];
    openServerBtn.layer.cornerRadius = 5;
    [openServerBtn setTitle:NSLocalizedString(@"OpenServer", @"") forState:UIControlStateNormal];
    [openServerBtn addTarget:self action:@selector(showOpenServer) forControlEvents:UIControlEventTouchUpInside];
    
    [btnView addSubview:openServerBtn];
    
    [self setTopBtnStatus:NO];
}

-(void)showGame{
    [self setTopBtnStatus:NO];
    [switchScrollView setContentOffset:CGPointMake(0, 0)];
}

-(void)showOpenServer{
    [self setTopBtnStatus:YES];
    
    [switchScrollView setContentOffset:CGPointMake(kScreenWidth, 0)];
}

-(void) setTopBtnStatus:(BOOL)isopenserver{
    if (isopenserver) {
        [appBtn setBackgroundColor:TopBtnNomalColor];
        [appBtn setTitleColor:TopBtnSelectColor forState:UIControlStateNormal];
        
        [openServerBtn setBackgroundColor:TopBtnSelectColor];
        [openServerBtn setTitleColor:TopBackColor forState:UIControlStateNormal];
    }else{
        [appBtn setBackgroundColor:TopBtnSelectColor];
        [appBtn setTitleColor:TopBackColor forState:UIControlStateNormal];
        
        [openServerBtn setBackgroundColor:TopBtnNomalColor];
        [openServerBtn setTitleColor:TopBtnSelectColor forState:UIControlStateNormal];
    }
}

-(void) addScrollView{
    CGFloat scrollH = kScreenHeight - TopViewH - 49;
    switchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TopViewH, kScreenWidth, scrollH)];
    switchScrollView.contentSize = CGSizeMake(kScreenWidth * 2, scrollH);
    switchScrollView.delegate = self;
    switchScrollView.pagingEnabled = YES;
    switchScrollView.bounces = NO;
    switchScrollView.showsHorizontalScrollIndicator = NO;
    
//    NSLog(@"Scroll frame%@", NSStringFromCGRect(switchScrollView.frame));
//    NSLog(@"Scroll W:%f, SW:%f", CGRectGetMaxX(switchScrollView.frame), kScreenWidth);
    CGSize scrollSize =  switchScrollView.frame.size;
    AppInfoTableView *firstTable = [[AppInfoTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, scrollSize.height)];
    firstTable.delegate = self;
    [firstTable requestAppInfo];
    [switchScrollView addSubview:firstTable];
    
    
    OpenServerTableView *secondTable = [[OpenServerTableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, scrollSize.height)];
//    [second setBackgroundColor:[UIColor blueColor]];
    [secondTable requestAppInfo];
    secondTable.delegate = self;
    [switchScrollView addSubview:secondTable];
    
    [self.view addSubview:switchScrollView];
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.x;
//    NSLog(@"offsetY:%f", offsetY);
    if(offsetY >= kScreenWidth){
        [self setTopBtnStatus:YES];
    }else{
        [self setTopBtnStatus:NO];
    }
}

#pragma mark - AppInfoDelegate

-(void) showAppInfo{
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    //        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    //    }
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    DetailsInfoViewController *detailsView = [mainStoryboard instantiateViewControllerWithIdentifier:@"detailsinfo"];
    [self.navigationController pushViewController:detailsView animated:YES];
}

#pragma mark - OpenServerDelegate

-(void) startSearchApp{
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    SearchViewController *searchView = [mainStoryboard instantiateViewControllerWithIdentifier:@"searchapp"];
    [searchView searchOpenServerGame];
    
    [self.navigationController pushViewController:searchView animated:YES];
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
