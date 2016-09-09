//
//  RecommendAppInfo.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/9/9.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendAppInfo : NSObject

//游戏id
@property(nonatomic,assign)int gameID;
//图片地址
@property (nonatomic, copy) NSString *gameIconUrl;
//应用名称
@property (nonatomic, copy) NSString *gameName;
//游戏标识
@property(nonatomic,copy)NSString *gameBundleID;
//应用包大小
@property (nonatomic, copy) NSString *packetSize;
//游戏类型
@property(nonatomic,copy)NSString *game_type_name;
//游戏简介
@property(nonatomic,copy)NSString *introduction;
//下载地址
@property (nonatomic, copy) NSString *downloadUrl;
//折扣
@property (nonatomic, copy) NSString *appDiscount;


- (id)initWithDict:(NSDictionary *)dict;

+ (id)packWithDict:(NSDictionary *)dict;

@end
