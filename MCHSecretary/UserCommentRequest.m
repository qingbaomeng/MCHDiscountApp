//
//  UserCommentRequest.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/24.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "UserCommentRequest.h"

#import "BaseNetManager.h"
#import "StringUtils.h"

#import "AppCommentInfo.h"

#define appdetailinfourl @"/sigleappcomment.html"

@implementation UserCommentRequest

-(void) commentInfo:(void(^)(AppCommentInfo * commentinfo))resultBlock failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock{
    
    [[BaseNetManager sharedInstance] get:appdetailinfourl success:^(NSDictionary *dic) {
        //        NSLog(@"[DetailInfoRequest] resultStr : %@", dic);
        NSString *status = [NSString stringWithFormat:@"%@", [dic objectForKey:@"status"]];
        if([@"1" isEqualToString:status]){
            //            NSMutableArray *result = [self dicToArray:dic];
            //            AppPacketInfo *appInfo = [self analysisJsonStrToClass:dic];
            resultBlock([self analysisJsonStrToClass:dic]);
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

-(AppCommentInfo *) analysisJsonStrToClass:(NSDictionary *)dic{
    AppCommentInfo *commentInfo = [AppCommentInfo packWithDict:dic];
        NSLog(@"UserCommentRequest : %@", commentInfo.version);
    return commentInfo;
}

@end
