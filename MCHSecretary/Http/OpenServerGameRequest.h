//
//  OpenServerGameRequest.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/26.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenServerGameRequest : NSObject

-(void) requestOpenServerGame:(void(^)(NSMutableArray * opserverArray))resultBlock failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock;

@end
