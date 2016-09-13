//
//  AppPacketInfo.h
//  MCHSecretary
//
//  Created by 朱进 on 16/8/9.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppPacketInfo : NSObject

//id;Game_name;leen;Marking;game_size;game_type_name;Introduction;recommend_status;Discount

//游戏id
@property(nonatomic,assign)int gameID;
//图片地址
@property (nonatomic, copy) NSString *gameIconUrl;
//应用名称
@property (nonatomic, copy) NSString *gameName;
//折扣
@property (nonatomic, copy) NSString *appDiscount;
//游戏简介
@property(nonatomic,copy)NSString *introduction;


//游戏标识
@property(nonatomic,copy)NSString *gameBundleID;
//推荐状态
@property(nonatomic,assign)int recommend_status;

//图片介绍
@property (nonatomic, copy) NSArray *describeImages;

//内容简介
@property (nonatomic, copy) NSString *contentDescribe;


//应用包大小
@property (nonatomic, copy) NSString *packetSize;
//游戏类型
@property(nonatomic,copy)NSString *game_type_name;
//版本信息
@property (nonatomic, copy) NSString *versionInfo;
//更新时间
@property (nonatomic, copy) NSString *updateData;
//语言
@property (nonatomic, copy) NSString *language;
//系统
@property (nonatomic, copy) NSString *appOS;
//系统
@property (nonatomic, copy) NSString *appUrl;




- (id)initWithDict:(NSDictionary *)dict;

+ (id)packWithDict:(NSDictionary *)dict;

@end
