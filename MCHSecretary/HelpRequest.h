//
//  HelpRequest.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/9/12.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HelpRequest : NSObject
-(void)requestForHelp:(void(^)(NSDictionary *dict))resultDic failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock;

-(void)postMessage:(NSDictionary *)dict success:(void(^)(NSString *resultStr))result failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock;

-(void)requestForUpdata:(void(^)(NSDictionary *dict))result failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock;

-(void)requestForToolDownWith:(NSString *)num success:(void(^)(NSDictionary *Dic))resultDic failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock;
@end
