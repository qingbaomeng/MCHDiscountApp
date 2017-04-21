//
//  AppDelegate.m
//  MCHSecretary
//
//  Created by 朱进 on 16/8/4.
//  Copyright © 2016年 朱进. All rights reserved.


#import "AppDelegate.h"
#import "CurrentAppUtils.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"

#import <ShareSDKUI/SSUIShareActionSheetStyle.h>

#import "TabBarController.h"

#import "InstallAppViewController.h"//我的
#import "SearchViewController.h"//搜索
#import "IndexController.h"//首页
#import "HelpViewController.h" //帮助

#define K_ScreenWidth [UIScreen mainScreen].bounds.size.width
#define K_ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface AppDelegate ()<UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [CurrentAppUtils updateInstalledAppBundleid];
    
    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
    
    [ShareSDK registerApp:@"c45faff1e059"
     
          activePlatforms:@[
                            @(SSDKPlatformSubTypeWechatTimeline),
                            @(SSDKPlatformSubTypeWechatSession),
                            @(SSDKPlatformTypeQQ),]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
//             case SSDKPlatformTypeSinaWeibo:
//                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
//                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
                case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxc399a0a165791e6d"
                                       appSecret:@"5c9c50a13d946d5b781d3268ffeacc51"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105694509"
                                      appKey:@"kC31STImZkPdn1mw"
                                    authType:SSDKAuthTypeSSO];
                 break;
             default:
                 break;
         }
     }];
    [self customTo];
    return YES;
}
-(void)customTo
{
    TabBarController *tvc = [[TabBarController alloc]init];
    tvc.tabBar.tintColor = [UIColor colorWithRed:0.12 green:0.77 blue:0.63 alpha:1.00];
    tvc.delegate = self;
    
    UIImage *homeImageNorm = [[UIImage imageNamed:@"barBtn_home_unselect"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *homeImageSec = [[UIImage imageNamed:@"barBtn_home_select"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    IndexController *homeVC = [[IndexController alloc]init];
    homeVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"首页" image:homeImageNorm selectedImage:homeImageSec];
    UINavigationController *homeNav = [[UINavigationController alloc]initWithRootViewController:homeVC];
    
    
    UIImage *classImageNorm = [[UIImage imageNamed:@"barBtn_search_unselect"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *classImageSec = [[UIImage imageNamed:@"barBtn_search_select"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    SearchViewController *classVC = [[SearchViewController alloc]init];
    classVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"搜索" image:classImageNorm selectedImage:classImageSec];
    UINavigationController *classNav = [[UINavigationController alloc]initWithRootViewController:classVC];
    
    UIImage *shopImageNorm = [[UIImage imageNamed:@"barBtn_mine_unselect"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *shopImageSec = [[UIImage imageNamed:@"barBtn_mine_select"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    InstallAppViewController *shopVC = [[InstallAppViewController alloc]init];
    shopVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的" image:shopImageNorm selectedImage:shopImageSec];
    UINavigationController *shopNav = [[UINavigationController alloc]initWithRootViewController:shopVC];

    UIImage *personalImageNorm = [[UIImage imageNamed:@"tabbtn_help_unselect"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *personalImageSec = [[UIImage imageNamed:@"tabbtn_help_select"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    HelpViewController *personalVC = [[HelpViewController alloc]init];
    personalVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"帮助" image:personalImageNorm selectedImage:personalImageSec];
    UINavigationController *personalNav = [[UINavigationController alloc]initWithRootViewController:personalVC];
    
    UIImage *publishNorm = [[UIImage imageNamed:@"icon_web_nor"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *publishSec = [[UIImage imageNamed:@"icon_web_pre"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIViewController *publish = [[UIViewController alloc]init];
    publish.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"官网" image:publishNorm selectedImage:publishSec];
    UINavigationController *publishNav = [[UINavigationController alloc]initWithRootViewController:publish];
    //    tvc.viewControllers = @[homeVC,classVC,publish,shopVC,personalVC];
    tvc.viewControllers = @[homeNav,classNav,publishNav,shopNav,personalNav];
    _window.rootViewController = tvc;
}

#pragma mark   tabBarController delegate
//是否可以选中对应模块，no表示不可选中，yes是可以选中
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
//    NSLog(@"indexo--------------------%ld",[tabBarController.viewControllers indexOfObject:viewController]);
    //视图控制器对应的索引
    if ([tabBarController.viewControllers indexOfObject:viewController]==2) {
        
        NSLog(@"=====++++++++++++++++======");
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.tym1.com/mobile.php"]];
        // no 不弹出占位vc，需要弹出新的界面
        return NO;//
    }
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}




- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
