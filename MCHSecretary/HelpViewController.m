//
//  HelpViewController.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/9/1.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "HelpViewController.h"

#import "ListView.h"

#import "SVProgressHUD.h"

#import "WebViewController.h"

#import "FeedBackViewController.h"

#import <ShareSDK/ShareSDK.h>

#import <ShareSDKUI/ShareSDK+SSUI.h>

#import <ShareSDKUI/ShareSDKUI.h>

@interface HelpViewController ()

@end

#define TopViewH 65
#define BarWIDTH 30
#define VIEHEIGHT 50
#define BTNHEIGHT 80
#define LABORFRAME CGRectMake(0, -300, kScreenWidth, 60)
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

#define GetColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define TopBackColor GetColor(18,205,176,1.0)

#define GetFont(s) [UIFont systemFontOfSize:s]
#define TitleFont GetFont(18)


@implementation HelpViewController

-(void) viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [super.navigationController setToolbarHidden:YES animated:TRUE];
    _lab.frame = LABORFRAME;
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addTopView];
    
    [self addSCrollView];
}
-(void) addTopView{
    topview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopViewH)];
    [topview setBackgroundColor:TopBackColor];
    [self.view addSubview:topview];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, TopViewH - 20)];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [lblTitle setText:NSLocalizedString(@"帮助", @"")];
    [lblTitle setFont:TitleFont];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    
    [topview addSubview:lblTitle];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kScreenWidth -20-BarWIDTH, 25, BarWIDTH, BarWIDTH);
    [button setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(barImageTap) forControlEvents:UIControlEventTouchUpInside];
    [topview addSubview:button];
}
-(void)addSCrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, TopViewH, kScreenWidth, kScreenHeight - TopViewH)];
    scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight - 60);
    [self.view addSubview:scrollView];
    for (int a = 0;  a< 4; a ++)
    {
        ListView *vie = [[ListView alloc]init];
        
        vie.frame = CGRectMake(0, a * VIEHEIGHT, kScreenWidth, VIEHEIGHT);
        
        [vie addImageAndLabWithNum:a];
        
        if (a == 0)
        {
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap1:)];
            
            [vie addGestureRecognizer:tapRecognizer];
        }
        if (a ==1)
        {
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap2)];
            
            [vie addGestureRecognizer:tapRecognizer];
        }
        if (a ==2)
        {
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap3)];
            
            [vie addGestureRecognizer:tapRecognizer];
        }
        if (a == 3)
        {
            [vie addSmallLab];
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap4)];
            
            [vie addGestureRecognizer:tapRecognizer];
        }
        
        [scrollView addSubview:vie];
    }
    _lab = [[UILabel alloc]init];
    
    _lab.backgroundColor = [UIColor grayColor];
    
    _lab.alpha = 0.5;
    
    [scrollView addSubview:_lab];
    
    for (int a = 0; a < 2; a++)
    {
        NSArray *arr = @[@"phone",@"qq"];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.bounds = CGRectMake(0, 0, BTNHEIGHT, BTNHEIGHT);
        
        if (a == 0)
        {
            btn.center = CGPointMake(self.view.center.x -50, self.view.center.y * 1.25);
        }
        else
        {
            btn.center = CGPointMake(self.view.center.x + 50,self.view.center.y * 1.25);
        }
        
        [btn setBackgroundImage:[UIImage imageNamed:arr[a]] forState:UIControlStateNormal];
        
        btn.tag = 11 + a;
        
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [scrollView addSubview:btn];
    }

}
-(void)buttonClick:(UIButton *)btn
{
    
    if (btn.tag == 11)
    {
        [self cellUS];
    }
    else
    {
        [self joinGroup:@"微微一笑再一笑" key:@"微微一笑再一笑"];
    }
}
-(void)cellUS
{
    //拨电话
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"0775-27812882"];
    
    UIWebView * callWebview = [[UIWebView alloc] init];
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    
    [self.view addSubview:callWebview];
}

- (BOOL)joinGroup:(NSString *)groupUin key:(NSString *)key
{
    //一键添加QQ群
    
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", @"580687890",@"ddd6433f481109643677839e21a17bf41a995e633a34fb8e4806075d676afe10"];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }
    else return NO;
}

-(void)barImageTap
{
    NSArray* imageArray = @[[UIImage imageNamed:@"qq"]];
    //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:@"我的软件-"
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"分享成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                               
                               [self presentViewController:alertVC animated:YES completion:^{
                                   
                                   [NSThread sleepForTimeInterval:1.0f];
                                   
                                   [alertVC dismissViewControllerAnimated:YES completion:nil];
                               }];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"分享成功" message:[NSString stringWithFormat:@"%@",error] preferredStyle:UIAlertControllerStyleAlert];
                               
                               UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                               
                               [alertVC addAction:action];
                               
                               [self presentViewController:alertVC animated:YES completion:nil];
                               
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}

}
#pragma mark 手势
-(void)handleTap1:(UITapGestureRecognizer *)tap
{
    WebViewController *webVC = [[WebViewController alloc]init];
    
    webVC.descriptStr = @"安装工具";
    
    _lab.frame = CGRectMake(0, 0,kScreenWidth, VIEHEIGHT);
    
    [self.navigationController pushViewController:webVC animated:YES];
}
-(void)handleTap2
{
    _lab.frame = CGRectMake(0, VIEHEIGHT,kScreenWidth, VIEHEIGHT);
    
    WebViewController *webVC = [[WebViewController alloc]init];
    
    webVC.descriptStr = @"折扣";
    
    [self.navigationController pushViewController:webVC animated:YES];
    
}
-(void)handleTap3
{
    _lab.frame = CGRectMake(0, VIEHEIGHT *2,kScreenWidth, VIEHEIGHT);
    
    FeedBackViewController *feedVC = [[FeedBackViewController alloc]init];;
    
    [self.navigationController pushViewController:feedVC animated:YES];
}
-(void)handleTap4
{
    _lab.frame = CGRectMake(0, VIEHEIGHT *3,kScreenWidth, VIEHEIGHT);
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    [SVProgressHUD showWithStatus:@"检查更新中...."];
    
    [self performSelector:@selector(dismissSVPressHUD) withObject:nil afterDelay:3.0f];
    
    //    [self checkVersionUpdata];
}
-(void)dismissSVPressHUD
{
    _lab.frame = LABORFRAME;
    
    [SVProgressHUD dismiss];
}
#pragma mark 检查更新
-(void)checkVersionUpdata{
    //    NSLog(@"输出当前的版本%@",currentVersion);
    NSString *urlStr = @"http://itunes.apple.com/lookup?id=1071365437";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:req delegate:self];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(nonnull NSData *)data{
    NSError *error;
    id jsonObject =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSDictionary *appInfo =(NSDictionary*)jsonObject;
    NSArray *infoContent = [appInfo objectForKey:@"results"];
    NSString * version =[[infoContent objectAtIndex:0]objectForKey:@"version"];
    double doubleVersion = [version doubleValue];
    //    trackViewUrl =[[infoContent objectAtIndex:0]objectForKey:@"trackViewUrl"];
    NSLog(@"获取服务器的版本%@",version);
    //获取当前版本
    NSString *currentVersion =[[NSUserDefaults standardUserDefaults] objectForKey:@"CFBundleShortVersionString"];
    double doubleCurrentVersion = [currentVersion doubleValue];
    NSLog(@"获取当前的版本%@",currentVersion);
    if (doubleCurrentVersion<doubleVersion) {
        
        //        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"更新" message:@"有新的版本" preferredStyle: UIAlertControllerStyleAlert];
        
        //        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:<#^(UIAlertAction * _Nonnull action)handler#>];
        
        
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
        //        alert.delegate =self;
        //        [alert show];
        //        alert.tag =20;
    }else{
        
//        [SVProgressHUD dismiss];
        
        //[[[UIAlertView alloc] initWithTitle:nil message:@"已是最高版本" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil]show];
    }
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
