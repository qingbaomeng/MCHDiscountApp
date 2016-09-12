//
//  HelpRequest.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/9/12.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "HelpRequest.h"
#import "BaseNetManager.h"
#define helpurl @"/app.php/server/get_help_info"
#define feedback @"/app.php/user/feedback"

@implementation HelpRequest
-(void)requestForHelp:(void(^)(NSDictionary *dict))resultDic failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock
{
  [[[BaseNetManager alloc]init]noget:helpurl success:^(NSDictionary *dic) {
      
      resultDic(dic);
      
  } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
    
  }];
}

-(void)postMessage:(NSDictionary *)dict success:(void(^)(NSString *resultStr))result failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock
{
    [[BaseNetManager sharedInstance]httpPost:feedback datas:dict success:^(NSDictionary *dic) {
        int status = [dic[@"status"] intValue];
        if (status == 1)
        {
//            NSLog(@"[SearchOpenServerRequest]====%@",dic);
            
            result(@"反馈成功");
        }
        else
        {
            NSLog(@"反馈失败");
        }
    } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
        
        NSLog(@"请求失败");
    }];
}

@end
