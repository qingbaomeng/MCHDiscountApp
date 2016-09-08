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
#import "AppPacketInfo.h"

#import "TopCycleImage.h"

#define TopViewHeight 70
#define checkNull(__X__) (__X__) == [NSNull null] || (__X__) == nil ? @"" : [NSString stringWithFormat:@"%@", (__X__)]

#define cycleappinfourl @"/appinfo.html"
#define allGameInfoUrl @"/app.php/server/get_game_list"
#define takeTransUrl @"/app.php/server/rotation_img"

@implementation ChoiceCycleAppRequest

//轮番图
-(void) getScrollViewInfo:(void(^)(NSMutableArray * array))resultBlock failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock{
    
    [[BaseNetManager sharedInstance] get:takeTransUrl success:^(NSDictionary *dic) {
        //临时测试
        NSLog(@"[ChoiceCycleAppRequest] takeTransUrl : %@", dic);
        NSMutableArray *result = [self cycleDictToArray:dic];
        resultBlock(result);
        
        } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
        //        NSLog(@"[ChoiceCycleAppRequest] error message : %@", dic);
            failureBlock(response, error, dic);
    }];
    
}

-(void) getCycleAppInfo:(void(^)(NSMutableArray * array))resultBlock failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock{
    
    [[BaseNetManager sharedInstance] get:allGameInfoUrl success:^(NSDictionary *dic) {
        //临时测试
        
        NSMutableArray *result = [self dicToArray:dic];
        resultBlock(result);
        
//        NSLog(@"[ChoiceCycleAppRequest] resultStr : %@", dic);
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
    
     NSString *dataListStr = checkNull([dic objectForKey:@"data"]);
     
     //    NSLog(@"ChoiceCycleAppRequest# packsListStr: %@", dataListStr);
     if(![StringUtils isBlankString:dataListStr]){
         NSMutableArray *dataArray = [self getData:[dic objectForKey:@"data"]];
         return dataArray;
     }
     return nil;
}

-(NSMutableArray *) getData:(NSArray *)datas{
    if(datas && [datas count] > 0){
        
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < [datas count]; i++) {
            NSDictionary *listDic = [datas objectAtIndex:i];
            TopCycleImage *cyucleImage = [[TopCycleImage alloc] init];
            [cyucleImage setImageUrl:[NSString stringWithFormat:@"%@", [listDic objectForKey:@"data"]]];
            
            [array addObject:cyucleImage];
        }
        return array;
    }else{
        return nil;
    }
    
}



//游戏列表
-(NSMutableArray *) dicToArray:(NSDictionary *)dic{
    /*
     NSString *dataListStr = checkNull([dic objectForKey:@"data"]);
     
     //    NSLog(@"ChoiceCycleAppRequest# packsListStr: %@", dataListStr);
     if(![StringUtils isBlankString:dataListStr]){
     NSMutableArray *dataArray = [self getData:[dic objectForKey:@"data"]];
     return dataArray;
     }
     return nil;
     */
    
    //临时测试
    NSString *dataListStr = checkNull([dic objectForKey:@"list"]);
    
    //    NSLog(@"ChoiceCycleAppRequest# packsListStr: %@", dataListStr);
    if(![StringUtils isBlankString:dataListStr]){
        NSMutableArray *dataArray = [self getItems:[dic objectForKey:@"list"]];
        return dataArray;
    }
    return nil;
}


-(NSMutableArray *) getItems:(NSArray *)lists{
    if(lists && [lists count] > 0){
        NSMutableArray *frameArray = [NSMutableArray arrayWithCapacity:lists.count];
        for (int i = 0; i < [lists count]; i++){
            NSDictionary *listDic = [lists objectAtIndex:i];
            AppPacketInfo *packInfo = [AppPacketInfo packWithDict:listDic];
            
            NomalFrame *frame = [[NomalFrame alloc] init];
            [frame setPacketInfo:packInfo];
            
            [frameArray addObject:frame];
        }
        return frameArray;
    }else{
        return nil;
    }
    
    
    
}

@end
