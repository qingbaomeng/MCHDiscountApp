//
//  WebViewController.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/9/1.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "WebViewController.h"
#import "HelpRequest.h"
#import "NJKWebViewProgress.h"
#import "WebImage.h"
#import "ToolView.h"
#import "SVProgressHUD.h"

#define TopViewH 65
#define BarWIDTH 30

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

#define GetColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define TopBackColor GetColor(18,205,176,1.0)

@interface WebViewController ()

@end

 NSURL *url;

@implementation WebViewController

-(void) viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
//    [super.navigationController setToolbarHidden:YES animated:TRUE];
    self.tabBarController.tabBar.hidden = YES;
    [super viewWillAppear:animated];
    [self initView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addTopView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
}
-(void)initView
{
    CGRect rect = CGRectMake(0, TopViewH, kScreenWidth, kScreenHeight-TopViewH);
    
    if ([self.descriptStr isEqualToString:@"安装工具"])
    {
        ToolView *toolView = [[ToolView alloc]initWithFrame:rect];
        [toolView.downToolBtn addTarget:self action:@selector(requestForDownTool) forControlEvents:UIControlEventTouchUpInside];
//        [toolView viewFrame];
        [self.view addSubview:toolView];
    
    }
    else
    {
        [SVProgressHUD show];
        UIWebView *webView = [[UIWebView alloc]initWithFrame:rect];
        webView.delegate = self;
        webView.scalesPageToFit = YES;
//        progressProxy.webViewProxyDelegate = self;
//        progressProxy.progressDelegate = self;
        if ([self.descriptStr isEqualToString:@"充值中心"])
        {
        url  = [[NSURL alloc]initWithString:@"http://www.tym1.com/media.php?s=/Recharge/index.html"];
        }
        else if ([self.descriptStr isEqualToString:@"推广分成"])
        {
        url  = [[NSURL alloc]initWithString:@"http://www.tym1.com/index.php"];
        }
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
        [self.view addSubview:webView];
        
//        progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
//        progressView.frame = CGRectMake(0, 85, self.view.frame.size.width, 3);
//        progressView.progressTintColor = [UIColor blueColor];
//        [self.view addSubview:progressView];
    }
}
-(void)requestForDownTool
{
    [[[HelpRequest alloc]init]requestForToolDownWith:@"8888" success:^(NSDictionary *Dic) {
        if ([Dic[@"status"]intValue] == 1)
        {
            NSLog(@"===%@",[Dic objectForKey:@"url"]);
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[Dic objectForKey:@"url"]]];
//          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://iosdemo.vlcms.com:8888/mchsdkdemo.mobileprovision"]];
        }
        else
        {
            NSLog(@"失败了");
        }
    } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
    }];
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    [SVProgressHUD show];
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"加载失败"];
}
-(void) addTopView{
    topview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopViewH)];
    [topview setBackgroundColor:TopBackColor];
    [self.view addSubview:topview];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     leftBtn.frame = CGRectMake(20, 25, BarWIDTH*2, BarWIDTH);
    [leftBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [leftBtn setTitle:NSLocalizedString(@"帮助", @"") forState:UIControlStateNormal];
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [leftBtn addTarget:self action:@selector(barbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [topview addSubview:leftBtn];
}
-(void)barbuttonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
