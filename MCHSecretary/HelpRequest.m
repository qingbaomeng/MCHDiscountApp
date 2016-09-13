//
//  HelpRequest.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/9/12.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "HelpRequest.h"
#import "BaseNetManager.h"
#import "PreferencesUtils.h"
#import "CurrentAppUtils.h"

#define helpurl @"/app.php/server/get_help_info"
#define feedback @"/app.php/user/feedback"
#define appupdataurl @"/app.php/server/ios_app_updata"
@implementation HelpRequest
-(void)requestForHelp:(void(^)(NSDictionary *dict))resultDic failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock
{
  [[[BaseNetManager alloc]init]noget:helpurl success:^(NSDictionary *dic) {
      NSLog(@"get_help_info===%@",dic);
      resultDic(dic);
  } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
      failureBlock(response,error,dic);
  }];
}

-(void)postMessage:(NSDictionary *)dict success:(void(^)(NSString *resultStr))result failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock
{
    [[BaseNetManager sharedInstance]httpPost:feedback datas:dict success:^(NSDictionary *dic) {
        result(dic[@"msg"]);
    } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
        failureBlock(response,error,dic);
    }];
}
-(void)requestForUpdata:(void(^)(NSDictionary *dict))result failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock{
    
     NSString *urlstr;
    
    NSString *promoreid = [PreferencesUtils getPromoteId];
    if (![promoreid isEqualToString:@""])
    {
        NSString *version = [CurrentAppUtils appVersion];
        
        urlstr = [NSString stringWithFormat:@"%@/promote_id/%@/version/%@",appupdataurl,promoreid,version];
        NSLog(@"requestForUpdata=======%@",urlstr);
    }
    else
    {
    urlstr = [NSString stringWithFormat:@"%@/promote_id/0",appupdataurl];
         NSLog(@"requestForUpdata=======%@",urlstr);
    }
   
    
    [[[BaseNetManager alloc]init]noget:urlstr success:^(NSDictionary *dic) {
        NSLog(@"ios_app_updata===%@",dic);
              result(dic);
    } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
        failureBlock(response,error,dic);
    }];
    
}
@end
