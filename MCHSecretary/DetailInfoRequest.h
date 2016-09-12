//
//  DetailInfoRequest.h
//  MCHSecretary
//
//  Created by 朱进 on 16/8/15.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HomeGameInfo;
@class AppPacketInfo;

@interface DetailInfoRequest : NSObject

-(void)request:(HomeGameInfo *)info getAppInfo:(void(^)(AppPacketInfo * appinfo))resultBlock failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock;

@end
