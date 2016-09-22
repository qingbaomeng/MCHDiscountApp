//
//  ChoiceCycleAppRequest.m
//  MCHSecretary
//
//  Created by 朱进 on 16/8/11.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "ChoiceCycleAppRequest.h"
#import "BaseNetManager.h"
#import "StringUtils.h"

#import "ChoiceListItem.h"
#import "NomalFrame.h"
#import "HomeGameInfo.h"
#import "PreferencesUtils.h"
#import "TopCycleImage.h"

#define TopViewHeight 70
#define checkNull(__X__) (__X__) == [NSNull null] || (__X__) == nil ? @"" : [NSString stringWithFormat:@"%@", (__X__)]

#define cycleappinfourl @"/appinfo.html"
#define allGameInfoUrl @"/app.php/server/get_game_list"
#define takeTransUrl @"/app.php/server/get_app_adv"
#define shareAPP @"/app.php/server/get_share_content"

@implementation ChoiceCycleAppRequest

@synthesize gameName, gameServer, limit, type;

-(instancetype) init{
    if(self = [super init]){
        gameName = @"";
        gameServer = @"0";
        type = @"0";
        limit = @"1";
    }
    return self;
}
//分享
-(void)requestForShare:(void(^)(NSDictionary *dict))resultBlock failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock
{

    NSString *promoreid = [PreferencesUtils getPromoteId];
    
    NSString *urlstr = [NSString stringWithFormat:@"%@/promote_id/%@",shareAPP,promoreid];
    
    [[BaseNetManager sharedInstance] get:urlstr success:^(NSDictionary *dic) {
        NSLog(@"[ChoiceCycleAppRequest] Share: %@", dic);
        resultBlock(dic);
        
    } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
        //        NSLog(@"[ChoiceCycleAppRequest] error message : %@", dic);
        failureBlock(response, error, dic);
    }];
}
//轮番图
-(void) getScrollViewInfo:(void(^)(NSMutableArray * array))resultBlock failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock{
    
    [[BaseNetManager sharedInstance] get:takeTransUrl success:^(NSDictionary *dic) {
        NSLog(@"[ChoiceCycleAppRequest] takeTransUrl : %@", dic);
        NSMutableArray *result = [self cycleDictToArray:dic];
        resultBlock(result);
        
        } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
        //        NSLog(@"[ChoiceCycleAppRequest] error message : %@", dic);
            failureBlock(response, error, dic);
    }];
    
}

-(void) getCycleAppInfo:(void(^)(NSMutableArray * array))resultBlock failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock{
    NSString *url = allGameInfoUrl;
    if(![@"" isEqualToString:gameName]){
        url = [url stringByAppendingString:@"/game_name/"];
        url = [url stringByAppendingString:gameName];
    }
    if(![@"" isEqualToString:gameServer]){
        url = [url stringByAppendingString:@"/game_server/"];
        url = [url stringByAppendingString:gameServer];
    }
    if(![@"" isEqualToString:type]){
        url = [url stringByAppendingString:@"/type/"];
        url = [url stringByAppendingString:type];
    }
    if(![@"" isEqualToString:limit]){
        url = [url stringByAppendingString:@"/limit/"];
        url = [url stringByAppendingString:limit];
    }
    NSLog(@"[ChoiceCycleAppRequest] CycleAppInfo url : %@", url);
    
    [[BaseNetManager sharedInstance] get:url success:^(NSDictionary *dic) {
        
        NSLog(@"-----------[ChoiceCycleAppRequest] resultStr : %@", dic);
        
        NSMutableArray *result = [self dicToArray:dic];
        
        resultBlock(result);
        
        /*
               NSString *status = [NSString stringWithFormat:@"%@", [dic objectForKey:@"status"]];
        if([@"1" isEqualToString:status]){
            NSMutableArray *result = [self dicToArray:dic];
            resultBlock(result);
        }else{
            NSString *errorMsg = [NSString stringWithFormat:@"%@", [dic objectForKey:@"return_msg"]];
            if([StringUtils isBlankString:errorMsg]){
                errorMsg = NSLocalizedString(@"HTTPDataException", @"");
            }
            
            failureBlock(nil, nil, @{@"status":@"-1001", @"return_msg":errorMsg});
        }
          */
    } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
//        NSLog(@"[ChoiceCycleAppRequest] error message : %@", dic);
        failureBlock(response, error, dic);
    }];
    
}
-(NSMutableArray *) cycleDictToArray:(NSDictionary *)dic{
    
     NSString *dataListStr = checkNull([dic objectForKey:@"list"]);
     
     //    NSLog(@"ChoiceCycleAppRequest# packsListStr: %@", dataListStr);
     if(![StringUtils isBlankString:dataListStr]){
         NSMutableArray *dataArray = [self getData:[dic objectForKey:@"list"]];
         return dataArray;
     }
     return [[NSMutableArray alloc] init];
}

-(NSMutableArray *) getData:(NSArray *)datas{
    if(datas && [datas count] > 0){
        
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < [datas count]; i++) {
            NSDictionary *listDic = [datas objectAtIndex:i];
            TopCycleImage *cyucleImage = [[TopCycleImage alloc] init];
            [cyucleImage setAppId:[[NSString stringWithFormat:@"%@", [listDic objectForKey:@"game_id"]] intValue]];
            [cyucleImage setImageUrl:[NSString stringWithFormat:@"%@", [listDic objectForKey:@"data"]]];
            
            [array addObject:cyucleImage];
        }
        return array;
    }else{
        return [[NSMutableArray alloc] init];
    }
    
}

//游戏列表
-(NSMutableArray *) dicToArray:(NSDictionary *)dic{
//     NSLog(@"ChoiceCycleAppRequest# dic: %@", dic);
    NSString *dataListStr = checkNull([dic objectForKey:@"list"]);
    
    if(![StringUtils isBlankString:dataListStr]){
        NSMutableArray *dataArray = [self getItems:[dic objectForKey:@"list"]];
        return dataArray;
    }
    return [[NSMutableArray alloc] init];
}


-(NSMutableArray *) getItems:(NSArray *)lists{
    if(lists && [lists count] > 0){
        NSMutableArray *frameArray = [NSMutableArray arrayWithCapacity:lists.count];
        for (int i = 0; i < [lists count]; i++){
            NSDictionary *listDic = [lists objectAtIndex:i];
            HomeGameInfo *packInfo = [HomeGameInfo infoWithDict:listDic];
            
            NomalFrame *frame = [[NomalFrame alloc] init];
            [frame setPacketInfo:packInfo];
            
            [frameArray addObject:frame];
        }
        return frameArray;
    }else{
        return [[NSMutableArray alloc] init];
    }
    
    
    
}

@end
