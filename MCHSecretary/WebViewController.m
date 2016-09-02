//
//  WebViewController.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/9/1.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "WebViewController.h"
#import "NJKWebViewProgress.h"

#define TopViewH 65
#define BarWIDTH 30

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

#define GetColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define TopBackColor GetColor(18,205,176,1.0)

@interface WebViewController ()

@end

@implementation WebViewController

-(void) viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [super.navigationController setToolbarHidden:YES animated:TRUE];
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTopView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    progressProxy = [[NJKWebViewProgress alloc]init];
    
    CGRect rect = CGRectMake(0, TopViewH, kScreenWidth, kScreenHeight-TopViewH);
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:rect];
    webView.delegate = progressProxy;
    progressProxy.webViewProxyDelegate = self;
    progressProxy.progressDelegate = self;
    [self.view addSubview:webView];
    
    NSURL *url;
    
    if ([self.descriptStr isEqualToString:@"安装工具"])
    {
        url  = [[NSURL alloc]initWithString:@"http://www.baidu.com"];
    }
    else
    {
        url = [[NSURL alloc]initWithString:@"http://www.weibo.com"];
    }
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
    progressView.frame = CGRectMake(0, 65, self.view.frame.size.width, 3);
    progressView.progressTintColor = [UIColor blueColor];
    [self.view addSubview:progressView];
}
#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    if (progress == 0.0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        progressView.progress = 0;
        [UIView animateWithDuration:0.27 animations:^{
            progressView.alpha = 1.0;
        }];
    }
    if (progress == 1.0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [UIView animateWithDuration:0.27 delay:progress - progressView.progress options:0 animations:^{
            progressView.alpha = 0.0;
        } completion:nil];
    }
    [progressView setProgress:progress animated:NO];
}
-(void) addTopView{
    topview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopViewH)];
    [topview setBackgroundColor:TopBackColor];
    [self.view addSubview:topview];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     leftBtn.frame = CGRectMake(20, 25, BarWIDTH*2, BarWIDTH);
    [leftBtn setImage:[UIImage imageNamed:@"导航栏-箭头"] forState:UIControlStateNormal];
    [leftBtn setTitle:@"帮助" forState:UIControlStateNormal];
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
