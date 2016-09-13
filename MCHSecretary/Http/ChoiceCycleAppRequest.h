//
//  ChoiceCycleAppRequest.h
//  MCHSecretary
//
//  Created by 朱进 on 16/8/11.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChoiceCycleAppRequest : NSObject

/**
 * 游戏名称
 */
@property (nonatomic, copy) NSString *gameName;

/**
 * 推荐状态 0不推荐 1推荐 2热门 3最新
 */
@property (nonatomic, copy) NSString *type;

/**
 * 平台 0:ios 1：android
 */
@property (nonatomic, copy) NSString *gameServer;

/**
 * 分页 一页10条数据
 */
@property (nonatomic, copy) NSString *limit;

-(void)requestForShare:(void(^)(NSDictionary *dict))resultBlock failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock;

-(void) getScrollViewInfo:(void(^)(NSMutableArray * array))resultBlock failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock;

-(void) getCycleAppInfo:(void(^)(NSMutableArray * array))resultBlock failure:(void(^)(NSURLResponse * response, NSError * error, NSDictionary * dic))failureBlock;

@end
