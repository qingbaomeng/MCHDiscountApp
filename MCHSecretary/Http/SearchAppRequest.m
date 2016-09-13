//
//  SearchOpenServerRequest.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/9/2.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "SearchAppRequest.h"

#import "BaseNetManager.h"
#import "StringUtils.h"
#import "OpenServerEntity.h"

//#import "OpenServerItem.h"
#import "OpenServerSearchFrame.h"

#define checkNull(__X__) (__X__) == [NSNull null] || (__X__) == nil ? @"" : [NSString stringWithFormat:@"%@", (__X__)]
                           
#define searchopenserverurl @"/app.php/server/seach_game"
#define defaultserverurl @"/app.php/server/default_search/version/0"

@implementation SearchAppRequest

-(void)gamename:(NSString *)gameName serverInfo:(void(^)(NSMutableArray * serverArray))resultBlock failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:gameName forKey:@"gamename"];
    [dic setObject:@"0" forKey:@"version"];
    [dic setObject:_limit forKey:@"limit"];
    
    [[BaseNetManager sharedInstance]httpPost:searchopenserverurl datas:dic success:^(NSDictionary *dic) {
        int status = [dic[@"status"] intValue];
        if (status == 1)
        {
            NSLog(@"[SearchServerRequest]====%@",dic);
            NSMutableArray *result = [self dicToArray:dic];
            
            resultBlock(result);
        }
        else
        {
            NSLog(@"请求失败");
        }
    } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
        
        NSLog(@"请求失败");
    }];
}

-(NSMutableArray *) dicToArray:(NSDictionary *)dic{
    NSString *dataListStr = checkNull([dic objectForKey:@"list"]);
    
    //        NSLog(@"ChoiceCycleAppRequest# packsListStr: %@", dataListStr);
    if(![StringUtils isBlankString:dataListStr]){
        NSMutableArray *dataArray = [self getData:[dic objectForKey:@"list"]];
        return dataArray;
    }
    return nil;
}

-(NSMutableArray *) getData:(NSArray *)datas{
    if(datas && [datas count] > 0){
        NSMutableArray *openServerArray = [NSMutableArray arrayWithCapacity:datas.count];
        for (int i = 0; i < [datas count]; i++) {
            NSDictionary *dataDic = [datas objectAtIndex:i];
            OpenServerEntity *openserver = [OpenServerEntity packWithDict:dataDic];
            
            OpenServerSearchFrame *frame = [[OpenServerSearchFrame alloc] init];
            [frame setPacketInfo:openserver];
            
            [openServerArray addObject:frame];
        }
        return openServerArray;
    }else{
        return nil;
    }
    
}
-(void)requstForDefaultGameserverInfo:(void(^)(NSMutableArray * array))resultBlock failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock
{
    [[BaseNetManager sharedInstance] noget:defaultserverurl success:^(NSDictionary *dic) {
        int status = [dic[@"status"] intValue];
        if (status == 1)
        {
            NSLog(@"[DefaultAppRequest] takeTransUrl : %@", dic);
            NSMutableArray *result = [self defaultDicToArray:dic];
            resultBlock(result);
        }
        else
        {
            NSLog(@"请求失败");
        }
    } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
        //        NSLog(@"[ChoiceCycleAppRequest] error message : %@", dic);
        failureBlock(response, error, dic);
    }];
}
-(NSMutableArray *)defaultDicToArray:(NSDictionary *)dict
{
    NSString *dataListStr = checkNull([dict objectForKey:@"list"]);
    if(![StringUtils isBlankString:dataListStr]){
       NSMutableArray *dataArray = [self getDefaultInfo:[dict objectForKey:@"list"]];
      return dataArray;
    }
    return nil;
}
-(NSMutableArray *)getDefaultInfo:(NSArray *)datas
{
    if(datas && [datas count] > 0){
        NSMutableArray *openServerArray = [NSMutableArray arrayWithCapacity:datas.count];
        for (int i = 0; i < [datas count]; i++) {
            NSDictionary *dataDic = [datas objectAtIndex:i];
            OpenServerEntity *openserver = [OpenServerEntity packWithDict:dataDic];
            [openServerArray addObject:openserver];
        }
        return openServerArray;
    }else{
        return nil;
    }

}
@end
