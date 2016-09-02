//
//  SearchOpenServerRequest.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/9/2.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "SearchOpenServerRequest.h"

#import "BaseNetManager.h"
#import "StringUtils.h"
#import "OpenServerEntity.h"

//#import "OpenServerItem.h"
#import "OpenServerSearchFrame.h"

#define checkNull(__X__) (__X__) == [NSNull null] || (__X__) == nil ? @"" : [NSString stringWithFormat:@"%@", (__X__)]

#define searchopenserverurl @"/searchopenserver.html"


@implementation SearchOpenServerRequest

-(void) searchOpenServerInfo:(void(^)(NSMutableArray * opserverArray))resultBlock failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock{
    
    [[BaseNetManager sharedInstance] get:searchopenserverurl success:^(NSDictionary *dic) {
        //        NSLog(@"[DetailInfoRequest] resultStr : %@", dic);
        NSString *status = [NSString stringWithFormat:@"%@", [dic objectForKey:@"status"]];
        if([@"1" isEqualToString:status]){
            //            NSMutableArray *result = [self dicToArray:dic];
            //            AppPacketInfo *appInfo = [self analysisJsonStrToClass:dic];
            resultBlock([self dicToArray:dic]);
        }else{
            NSString *errorMsg = [NSString stringWithFormat:@"%@", [dic objectForKey:@"return_msg"]];
            if([StringUtils isBlankString:errorMsg]){
                errorMsg = NSLocalizedString(@"HTTPDataException", @"");
            }
            
            failureBlock(nil, nil, @{@"status":@"-1001", @"return_msg":errorMsg});
        }
        
    } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
        //        NSLog(@"[ChoiceCycleAppRequest] error message : %@", dic);
        failureBlock(response, error, dic);
    }];
    
}

-(NSMutableArray *) dicToArray:(NSDictionary *)dic{
    NSString *dataListStr = checkNull([dic objectForKey:@"gamelist"]);
    
    //        NSLog(@"ChoiceCycleAppRequest# packsListStr: %@", dataListStr);
    if(![StringUtils isBlankString:dataListStr]){
        NSMutableArray *dataArray = [self getData:[dic objectForKey:@"gamelist"]];
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
            [frame setPacketInfo:openserver openserver:YES];
            
            [openServerArray addObject:frame];
        }
        return openServerArray;
    }else{
        return nil;
    }
    
}


@end
