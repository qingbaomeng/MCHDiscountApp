//
//  SearchOpenServerRequest.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/9/2.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchOpenServerRequest : NSObject

-(void) searchOpenServerInfo:(void(^)(NSMutableArray * opserverArray))resultBlock failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock;

@end