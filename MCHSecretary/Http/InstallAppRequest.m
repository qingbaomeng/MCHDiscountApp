//
//  InstallAppRequest.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/9/12.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "InstallAppRequest.h"
#import "BaseNetManager.h"
#import "StringUtils.h"
#import "CommonFunc.h"
#import "PreferencesUtils.h"

#define checkNull(__X__) (__X__) == [NSNull null] || (__X__) == nil ? @"" : [NSString stringWithFormat:@"%@", (__X__)]


#define installappUrl @"/app.php/server/ios_game_pack_down"

@implementation InstallAppRequest


-(void)getAppList:(void(^)(NSString *resultStr))success failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock{
    NSLog(@"[ChoiceCycleAppRequest] url : %@", installappUrl);
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //{"game_id":"5","promote_id":"1"}
    [dic setObject:_gameAppId forKey:@"game_id"];
    [dic setObject:[PreferencesUtils getPromoteId] forKey:@"promote_id"];
    NSLog(@"[ChoiceCycleAppRequest] InstallAppRequest :%@", dic);
    
    [[BaseNetManager sharedInstance] httpPostByBaseResult:installappUrl datas:dic success:^(NSString *result) {
        
        NSData* decodeData = [[NSData alloc] initWithBase64EncodedString:result options:0];
        NSString* decodeStr = [[NSString alloc] initWithData:decodeData encoding:NSASCIIStringEncoding];
        NSLog(@"[ChoiceCycleAppRequest] decodeStr : %@", decodeStr);
        NSData *jsonData = [decodeStr dataUsingEncoding:NSUTF8StringEncoding];
        
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        if(responseDictionary != nil){
            NSString *status = [NSString stringWithFormat:@"%@", [responseDictionary objectForKey:@"status"]];
            
            if([@"1" isEqualToString:status]){
                
                success(checkNull([responseDictionary objectForKey:@"url"]));
            }else{
                NSString *errorMsg = [NSString stringWithFormat:@"%@", [responseDictionary objectForKey:@"msg"]];
                if([StringUtils isBlankString:errorMsg]){
                    errorMsg = NSLocalizedString(@"HTTPDataException", @"");
                }
                
                failureBlock(nil, nil, @{@"status":@"-1001", @"return_msg":errorMsg});
            }
            
        }else{
//            NSLog(@"[BaseNetManager] resultStr : %@", res);
            NSDictionary *resultDic = @{@"status":@"-1001", @"return_msg":NSLocalizedString(@"HTTPDataException", @"")};
            failureBlock(nil, nil, resultDic);
        }
        
        
    } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
        failureBlock(response, error, dic);
    }];
}

@end
