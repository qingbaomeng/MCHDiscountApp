//
//  HttpEngine.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/9/8.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpEngine : NSObject
//-(void)getForAllGameListComplation:(void(^)(NSDictionary *dict))listDict errorMessage:(void(^)(NSError *err))err;
+ (void)get:(NSString *)urlstr success:(void(^)(NSArray * allInfo))successblock failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock;
@end
