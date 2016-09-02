//
//  UserCommentRequest.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/24.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AppCommentInfo;

@interface UserCommentRequest : NSObject

-(void) commentInfo:(void(^)(AppCommentInfo * commentinfo))resultBlock failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock;

@end
