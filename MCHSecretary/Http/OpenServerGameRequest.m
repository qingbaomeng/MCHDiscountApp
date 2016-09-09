//
//  OpenServerGameRequest.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/26.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "OpenServerGameRequest.h"

#import "BaseNetManager.h"
#import "StringUtils.h"
#import "OpenServerEntity.h"

#import "OpenServerItem.h"
#import "NomalFrame.h"

#define checkNull(__X__) (__X__) == [NSNull null] || (__X__) == nil ? @"" : [NSString stringWithFormat:@"%@", (__X__)]

#define appdetailinfourl @"/app.php/server/open_server_game"
//searchopenserver.html

@implementation OpenServerGameRequest

-(void) requestOpenServerGame:(void(^)(NSMutableArray * opserverArray))resultBlock failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock{
    
    [[BaseNetManager sharedInstance] get:appdetailinfourl success:^(NSDictionary *dic) {
        
        NSMutableArray *result = [self dicToArray:dic];
        
        resultBlock(result);
        
//        NSLog(@"[DetailInfoRequest] resultStr : %@", dic);
        
    } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
        //        NSLog(@"[ChoiceCycleAppRequest] error message : %@", dic);
        failureBlock(response, error, dic);
    }];
    
}

-(NSMutableArray *) dicToArray:(NSDictionary *)dic{
    NSString *dataListStr = checkNull([dic objectForKey:@"list"]);
    
//        NSLog(@"ChoiceCycleAppRequest# packsListStr: %@", dataListStr);
    if(![StringUtils isBlankString:dataListStr]){
        NSMutableArray *dataArray = [self getItems:[dic objectForKey:@"list"]];
        return dataArray;
    }
    return nil;
}

//-(NSMutableArray *) getData:(NSArray *)datas{
//    if(datas && [datas count] > 0){
//        NSMutableArray *openServerArray = [NSMutableArray arrayWithCapacity:datas.count];
//        for (int i = 0; i < [datas count]; i++) {
//            
//            OpenServerItem *openserveritem = [[OpenServerItem alloc] init];
//            
//            NSDictionary *dataDic = [datas objectAtIndex:i];
//            
//            [openserveritem setOpenServerTime:[NSString stringWithFormat:@"%@", [dataDic objectForKey:@"servertime"]]];
//            
//            NSMutableArray *itemArray = [self getItems:[dataDic objectForKey:@"gamelist"]];
//            [openserveritem setAppInfoArray:itemArray];
//            
//            [openServerArray addObject:openserveritem];
//        }
//        return openServerArray;
//    }else{
//        return nil;
//    }
//    
//}

-(NSMutableArray *) getItems:(NSArray *)lists{
    if(lists && [lists count] > 0){
        NSMutableArray *frameArray = [NSMutableArray arrayWithCapacity:lists.count];
        for (int i = 0; i < [lists count]; i++){
            NSDictionary *listDic = [lists objectAtIndex:i];
            NomalFrame *frame = [[NomalFrame alloc] init];
            OpenServerEntity *packInfo = [OpenServerEntity packWithDict:listDic];

            [frame setOpenServerInfo:packInfo];
            
            [frameArray addObject:frame];
        }
        
        return frameArray;
    }else{
        return nil;
    }
}


@end

