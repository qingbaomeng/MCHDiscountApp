//
//  DetailInfoRequest.m
//  MCHSecretary
//
//  Created by 朱进 on 16/8/15.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "DetailInfoRequest.h"

#import "BaseNetManager.h"
#import "StringUtils.h"

#import "HomeGameInfo.h"
#import "AppPacketInfo.h"

#define appdetailinfourl @"/app.php?s=/server/get_game_info"

@implementation DetailInfoRequest

-(void)request:(int)infoID getAppInfo:(void(^)(AppPacketInfo * appinfo))resultBlock failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/id/%d",appdetailinfourl,infoID];
    
//    NSLog(@"[DetailInfoRequest] URLStr : %@",urlStr);
    
    [[BaseNetManager sharedInstance] get:urlStr success:^(NSDictionary *dic) {
        NSLog(@"[DetailInfoRequest] resultStr : %@", dic);
        
        NSString *status = [NSString stringWithFormat:@"%@", [dic objectForKey:@"status"]];
        if([@"1" isEqualToString:status]){
//            NSMutableArray *result = [self dicToArray:dic];
//            AppPacketInfo *appInfo = [self analysisJsonStrToClass:dic];
            resultBlock([self analysisJsonStrToClass:dic[@"data"]]);
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

-(AppPacketInfo *) analysisJsonStrToClass:(NSDictionary *)dic{
    AppPacketInfo *appInfo = [AppPacketInfo packWithDict:dic];
//    NSLog(@"DetailInfoRequest : %@", appInfo.packetName);
    
    return appInfo;
}

@end
