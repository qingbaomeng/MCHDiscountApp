//
//  InstallAppRequest.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/9/12.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface InstallAppRequest : NSObject

@property (nonatomic, copy) NSString *gameAppId;

-(void)getAppList:(void(^)(NSString *resultStr))result failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock;


@end
