//
//  Share.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/9/5.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "Share.h"

#import <ShareSDK/ShareSDK.h>

#import <ShareSDKUI/ShareSDK+SSUI.h>

#import <ShareSDKUI/ShareSDKUI.h>

@implementation Share
+(void)shareWithTitle:(NSString *)title ImageUrl:(NSString *)imageURl Message:(NSString *)msg URL:(NSString *)url ViewControl:(UIViewController *)vc
{
    
    NSArray* imageArray = @[imageURl];
    //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:msg
                                         images:imageArray
                                            url:[NSURL URLWithString:url]
                                          title:title
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"分享成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                               
                               [vc presentViewController:alertVC animated:YES completion:^{
                                   
                                   [NSThread sleepForTimeInterval:1.0f];
                                   
                                   [alertVC dismissViewControllerAnimated:YES completion:nil];
                               }];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"分享失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
                               
                               [vc presentViewController:alertVC animated:YES completion:^{
                                   
                                   [NSThread sleepForTimeInterval:1.0f];
                                   
                                   [alertVC dismissViewControllerAnimated:YES completion:nil];
                               }];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}

}
@end
