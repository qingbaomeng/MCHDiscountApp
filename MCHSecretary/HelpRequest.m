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
#define addGroupUrl @"/app.php/server/get_add_group/type/1"
#define feedback @"/app.php/user/feedback"
#define appupdataurl @"/app.php/server/ios_app_updata"
#define tooldownurl @"/app.php/server/get_shan_url"
@implementation HelpRequest
-(void)requestForHelp:(void(^)(NSDictionary *dict))resultDic failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock
{
  [[[BaseNetManager alloc]init]get:helpurl success:^(NSDictionary *dic) {
      resultDic(dic);
  } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
      failureBlock(response,error,dic);
  }];
}
-(void)getRequestForAddGroup:(void(^)(NSDictionary *dict))resultDic failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock
{
    [[[BaseNetManager alloc]init]get:addGroupUrl success:^(NSDictionary *dic) {
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
    if (![promoreid isEqualToString:@"0"])
    {
        NSString *version = [CurrentAppUtils appVersion];
        
        urlstr = [NSString stringWithFormat:@"%@/promote_id/%@/version/%@",appupdataurl,promoreid,version];
    }
    else
    {
        urlstr = [NSString stringWithFormat:@"%@/promote_id/%@",appupdataurl,promoreid];
    }
   
    [[[BaseNetManager alloc]init]get:urlstr success:^(NSDictionary *dic) {
              result(dic);
    } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
        failureBlock(response,error,dic);
    }];
}
-(void)requestForToolDownWith:(NSString *)num success:(void(^)(NSDictionary *Dic))resultDic failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock{
    
    //端口号
    NSString *url = [NSString stringWithFormat:@"%@/port/%@",tooldownurl,num];
    
    [[[BaseNetManager alloc]init]get:url success:^(NSDictionary *dic) {
        resultDic(dic);
    } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
        failureBlock(response,error,dic);
    }];
}
@end
