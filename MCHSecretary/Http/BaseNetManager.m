//
//  BaseNetManager.m
//  Payment
//
//  Created by 朱进 on 16/6/3.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "BaseNetManager.h"
#import "DialogTipView.h"
#import "StringUtils.h"
#import "CommonFunc.h"

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define checkNull(__X__) (__X__) == [NSNull null] || (__X__) == nil ? @"" : [NSString stringWithFormat:@"%@", (__X__)]
//static AFHTTPSessionManager *httpManager = nil;
void (^completionBlock)(NSData *data, NSURLResponse *response, NSError *error);

BaseNetManager *baseManger;
DialogTipView *dialogView;

@implementation BaseNetManager

+ (BaseNetManager*) sharedInstance {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        baseManger = [[BaseNetManager alloc] init];
    });
    return baseManger;
}

-(id)init{
    if(self = [super init]){
//        dialogView = [[DialogTipView alloc] initWithFrame:CGRectMake((kScreenWidth - 30) / 2, (kScreenHeight - 30) / 2, 30, 30)];
    }
    return self;
}

/// 向网络请求数据
- (void)get:(NSString *)urlstr success:(void(^)(NSDictionary * dic))successblock failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock{
    
//    [self showIndicatorView];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", urlpre, urlstr];
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self removeIndicatorView];
                    
                    NSString *res = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
//                    NSLog(@"[BaseNetManager] resultStr : %@", res);
                    if(![StringUtils isBlankString:res]){
                        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                        if(responseDictionary != nil){
                            successblock(responseDictionary);
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self removeIndicatorView];
                    
                    failureBlock(response, error, @{@"status":@"-1000", @"return_msg":NSLocalizedString(@"HTTPStatusException", @"")});
                });
            }
            
        } else {
            NSLog(@"[BaseNetManager] error=%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self removeIndicatorView];
                
                failureBlock(response, error, @{@"status":@"-1000", @"return_msg":NSLocalizedString(@"HTTPError", @"")});
            });
        }
    }];
    [dataTask resume];
}
- (void)getWithIndicator:(NSString *)urlstr success:(void(^)(NSDictionary * dic))successblock failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock{
    
    //    [self showIndicatorView];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", urlpre, urlstr];
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self removeIndicatorView];
                    
                    NSString *res = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
                    //                    NSLog(@"[BaseNetManager] resultStr : %@", res);
                    if(![StringUtils isBlankString:res]){
                        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                        if(responseDictionary != nil){
                            successblock(responseDictionary);
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self removeIndicatorView];
                    
                    failureBlock(response, error, @{@"status":@"-1000", @"return_msg":NSLocalizedString(@"HTTPStatusException", @"")});
                });
            }
            
        } else {
            NSLog(@"[BaseNetManager] error=%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self removeIndicatorView];
                
                failureBlock(response, error, @{@"status":@"-1000", @"return_msg":NSLocalizedString(@"HTTPError", @"")});
            });
        }
    }];
    [dataTask resume];
}

-(void) httpPost:(NSString *)urlstr datas:(NSDictionary *)dic success:(void(^)(NSDictionary * dic))successblock failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock{
    [self showIndicatorView];
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *param=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];

    NSString *strURL = [NSString stringWithFormat:@"%@%@",urlpre,urlstr];
    
    NSURL *url = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:5.0];
    [request setHTTPMethod:@"POST"];
    
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];

     request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];

//    NSLog(@"%@",[param dataUsingEncoding:NSUTF8StringEncoding]);
    completionBlock = ^(NSData *data, NSURLResponse *response, NSError *error){
        //             NSLog(@"response : %@", response);
        if (data && (error == nil)) {
            NSLog(@"[BaseNetManager] data=%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            long status = (long)httpResponse.statusCode;
            if(status >= 200 && status < 299) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *res = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
//                    NSLog(@"[BaseNetManager] resultStr : %@", res);
                    if(![StringUtils isBlankString:res]){
                        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                        if(responseDictionary != nil){
                            successblock(responseDictionary);
                            
                        }else{
                            NSLog(@"[BaseNetManager] resultStr : %@", res);
                            NSDictionary *resultDic = @{@"status":@"-1001", @"return_msg":NSLocalizedString(@"HTTPDataException", @"")};
                            failureBlock(response, error, resultDic);
                        }
                    }else{
                        NSDictionary *resultDic = @{@"status":@"-1",@"return_msg":NSLocalizedString(@"HTTPDataException", @"")};
                        successblock(resultDic);
                    }
                    [self removeIndicatorView];
                });
                
            } else {
                NSLog(@"[BaseNetManager] http response status : %ld",status);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self removeIndicatorView];
                    
                    failureBlock(response, error, @{@"return_msg":NSLocalizedString(@"HTTPStatusException", @"")});
                });
            }
        } else {
            NSLog(@"[BaseNetManager] error=%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self removeIndicatorView];
                
                failureBlock(response, error, @{@"return_msg":NSLocalizedString(@"HTTPError", @"")});
            });
        }
    };
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:completionBlock];
    [task resume];
}

-(void) httpPostByBaseResult:(NSString *)urlstr datas:(NSDictionary *)dic success:(void(^)(NSString * result))successblock failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock{
    [self showIndicatorView];
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *param=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@",urlpre,urlstr];
    
    NSURL *url = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:5.0];
    [request setHTTPMethod:@"POST"];
    
//    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    
//    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = [[CommonFunc base64StringFromText:param] dataUsingEncoding:NSUTF8StringEncoding];
    
    //    NSLog(@"%@",[param dataUsingEncoding:NSUTF8StringEncoding]);
    completionBlock = ^(NSData *data, NSURLResponse *response, NSError *error){
        //             NSLog(@"response : %@", response);
        if (data && (error == nil)) {
//            NSLog(@"[BaseNetManager] data=%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            long status = (long)httpResponse.statusCode;
            if(status >= 200 && status < 299) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *res = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
                    NSLog(@"[BaseNetManager] data : %@", res);
                    successblock(res);
                    [self removeIndicatorView];
                });
                
            } else {
                NSLog(@"[BaseNetManager] http response status : %ld",status);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self removeIndicatorView];
                    
                    failureBlock(response, error, @{@"return_msg":NSLocalizedString(@"HTTPStatusException", @"")});
                });
            }
        } else {
            NSLog(@"[BaseNetManager] error=%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self removeIndicatorView];
                
                failureBlock(response, error, @{@"return_msg":NSLocalizedString(@"HTTPError", @"")});
            });
        }
    };
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:completionBlock];
    [task resume];
}


-(void) showIndicatorView {
//    DialogTipView *dialogView = [[DialogTipView alloc] initWithFrame:CGRectMake((kScreenWidth - 30) / 2, (kScreenHeight - 30) / 2, 30, 30)];
    if(!dialogView){
        dialogView = [[DialogTipView alloc] initWithFrame:CGRectMake((kScreenWidth - 30) / 2, (kScreenHeight - 30) / 2, 30, 30)];
    }
    [[[UIApplication sharedApplication] keyWindow] addSubview:dialogView];
}

-(void) removeIndicatorView {
    if(dialogView){
        [dialogView removeFromSuperview];
    }
}

- (Boolean) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    //    if([[NSNull null] isEqual:(NSNull *)string])
    //    {
    //        return YES;
    //    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end
