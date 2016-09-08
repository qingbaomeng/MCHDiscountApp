//
//  HttpEngine.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/9/8.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "HttpEngine.h"
#import "AppPacketInfo.h"
#import "StringUtils.h"

#define URL @"https://zhekou.vlcms.com"
#define AllGameList @"/app.php/server/get_game_list"

@implementation HttpEngine

//请求游戏列表
//-(void)getForAllGameListComplation:(void(^)(NSDictionary *dict))listDict errorMessage:(void(^)(NSError *err))err
//{
//
//    NSString *urlString = [NSString stringWithFormat:@"%@%@", URL, AllGameList];
//    // 一些特殊字符编码
//    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSURL *url = [NSURL URLWithString:urlString];
//    
//    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
//    
//    NSURLSession *sharedSession = [NSURLSession sharedSession];
//    
//    NSURLSessionDataTask *dataTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (data && (error == nil)) {
//            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
//            long status = (long)httpResponse.statusCode;
//            if(status >= 200 && status < 299) {
//                dispatch_sync(dispatch_get_main_queue(), ^{
//                    
//                    
//                    NSString *res = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
//                    //                    NSLog(@"[BaseNetManager] resultStr : %@", res);
//                    if(![StringUtils isBlankString:res]){
//                        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//                        if(responseDictionary != nil){
////                            successblock(responseDictionary);
//                        }else{
//                            NSLog(@"[BaseNetManager] response json exception : %@", res);
//                            NSDictionary *resultDic = @{@"status":@"-1001", @"return_msg":NSLocalizedString(@"HTTPDataException", @"")};
////                            failureBlock(response, error, resultDic);
//                        }
//                        
//                    }else{
//                        NSLog(@"[BaseNetManager] response is null : %@", res);
//                        NSDictionary *resultDic = @{@"status":@"-1001", @"return_msg":NSLocalizedString(@"HTTPDataException", @"")};
////                        failureBlock(response, error, resultDic);
//                    }
//                });
//            } else {
//                NSLog(@"[BaseNetManager] http response status : %ld",status);
//                dispatch_sync(dispatch_get_main_queue(), ^{
//                    
//                    failureBlock(response, error, @{@"status":@"-1000", @"return_msg":NSLocalizedString(@"HTTPStatusException", @"")});
//                });
//            }
//            
//        } else {
//            NSLog(@"[BaseNetManager] error=%@",error);
//            dispatch_sync(dispatch_get_main_queue(), ^{
//                
//                failureBlock(response, error, @{@"status":@"-1000", @"return_msg":NSLocalizedString(@"HTTPError", @"")});
//            });
//        }
//  
//    }];
//    
//}
/// 向网络请求数据
+ (void)get:(NSString *)urlstr success:(void(^)(NSArray * allInfo))successblock failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", URL, AllGameList];
    // 一些特殊字符编码
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //        NSLog(@"%@",[NSThread currentThread]);
        if (data && (error == nil)) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            long status = (long)httpResponse.statusCode;
            if(status >= 200 && status < 299) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    
                    NSString *res = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
                    //                    NSLog(@"[BaseNetManager] resultStr : %@", res);
                    if(![StringUtils isBlankString:res]){
                        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                        if(responseDictionary != nil){
                            NSMutableArray *infos = [NSMutableArray array];
                            NSArray *list = [responseDictionary objectForKey:@"list"];
                            for(NSDictionary *listDict in list)
                            {
                                NSLog(@"字典%@",listDict);
                                
                                AppPacketInfo *info = [AppPacketInfo packWithDict:listDict];
                                [infos addObject:info];
                            }
                            successblock(infos);
                        }else{
                            NSLog(@"[BaseNetManager] response json exception : %@", res);
                            NSDictionary *resultDic = @{@"status":@"-1001", @"return_msg":NSLocalizedString(@"HTTPDataException", @"")};
                            failureBlock(response, error, resultDic);
                        }
                        
                    }else{
                        NSLog(@"[BaseNetManager] response is null : %@", res);
                        NSDictionary *resultDic = @{@"status":@"-1001", @"return_msg":NSLocalizedString(@"HTTPDataException", @"")};
                        failureBlock(response, error, resultDic);
                    }
                });
            } else {
                NSLog(@"[BaseNetManager] http response status : %ld",status);
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    failureBlock(response, error, @{@"status":@"-1000", @"return_msg":NSLocalizedString(@"HTTPStatusException", @"")});
                });
            }
            
        } else {
            NSLog(@"[BaseNetManager] error=%@",error);
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                failureBlock(response, error, @{@"status":@"-1000", @"return_msg":NSLocalizedString(@"HTTPError", @"")});
            });
        }
    }];
    [dataTask resume];
}


@end
