//
//  SearchOpenServerRequest.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/9/2.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchAppRequest : NSObject

@property(nonatomic,copy)NSString *limit;

-(void)gamename:(NSString *)gameName serverInfo:(void(^)(NSMutableArray * serverArray))resultBlock failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock;


-(void)requstForDefaultGameserverInfo:(void(^)(NSMutableArray * array))resultBlock failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock;
@end
