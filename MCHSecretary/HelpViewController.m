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

#import "Share.h"
#import "HelpRequest.h"
#import "InstallAppRequest.h"
#import "ChoiceCycleAppRequest.h"
#import "CurrentAppUtils.h"


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
//    [super.navigationController setToolbarHidden:YES animated:TRUE];
    self.tabBarController.tabBar.hidden = NO;
    _lab.frame = LABORFRAME;
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addTopView];
    [self addSCrollView];
    
    [[[ChoiceCycleAppRequest alloc]init]requestForShare:^(NSDictionary *dict) {
        
        if ([dict[@"status"]intValue] == 1)
        {
            shareDic = dict[@"list"];
        }
    } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
        
    }];
   
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
    [[[HelpRequest alloc]init]requestForHelp:^(NSDictionary *dict) {
        NSLog(@"requestForHelpView:%@",dict);
        resultDict = dict;
    } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
    }];
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
            
            NSString *version = [CurrentAppUtils appVersion];
            if (![version isEqualToString:@""])
            {
                 vie.titleLab.text = [NSString stringWithFormat:@"v%@",version];
            }
            else
            {
                vie.titleLab.text = [NSString stringWithFormat:@"v%@",resultDict[@"version"]];
            }
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
        
        [[[HelpRequest alloc]init]getRequestForAddGroup:^(NSDictionary *dict) {
            if ([dict[@"status"] intValue] == 1)
            {
                NSDictionary *dic = dict[@"list"];
                [self joinGroup:dic[@"group_number"] key:dic[@"key"]];
            }
        } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
            
        }];
    }
}
-(void)cellUS
{
    //拨电话
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",resultDict[@"service_tel"]];
    
    UIWebView * callWebview = [[UIWebView alloc] init];
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    
    [self.view addSubview:callWebview];
}

- (BOOL)joinGroup:(NSString *)groupUin key:(NSString *)key{
    
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", groupUin,key];
    NSURL *url = [NSURL URLWithString:urlStr];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }
    else return NO;
}
-(void)barImageTap
{
    [Share shareWithTitle:shareDic[@"title"] ImageUrl:shareDic[@"icon"] Message:shareDic[@"introduction"]  URL:shareDic[@"url"]  ViewControl:self];
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
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"检查更新中...."];
    [self performSelector:@selector(dismissSVPressHUD) withObject:nil afterDelay:3.0f];
        _lab.frame = LABORFRAME;
}
-(void)dismissSVPressHUD
{
    [SVProgressHUD dismiss];
    [[[HelpRequest alloc]init]requestForUpdata:^(NSDictionary *dict) {
        
        if ([dict[@"status"]intValue] == 1)
        {
            NSLog(@"requestForUpdata=====%@",dict);
            NSLog(@"requestForUpdataURL====%@",dict[@"url"]);
            
            NSString *url = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",dict[@"url"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
        else
        {
            [self alertViewWithMessage:@"已是最新版本"];
        }
    } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
        
    }];
}
-(void)alertViewWithMessage:(NSString *)message
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alertVC animated:YES completion:^{
        
        [self performSelector:@selector(dismiss:) withObject:alertVC afterDelay:1.0f];
        
    }];
}
-(void)dismiss:(UIAlertController *)alertVC
{
    [alertVC dismissViewControllerAnimated:YES completion:nil];
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
