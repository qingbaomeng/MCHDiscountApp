//
//  OpenServerEntity.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/30.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenServerEntity : NSObject

//游戏id
@property(nonatomic,assign)int gameID;
//应用名称
@property (nonatomic, copy) NSString *packetName;
//图片地址
@property (nonatomic, copy) NSString *smallImageUrl;
//类型名称
@property(nonatomic,copy)NSString *game_type_name;
//游戏简介
@property (nonatomic, copy) NSString *gameDesc;
//折扣
@property (nonatomic, copy) NSString *appDiscount;
//游戏大小
@property(nonatomic,copy)NSString *gameSize;

//开服信息
@property (nonatomic, strong) NSArray *openServerArray;
//下载地址
@property (nonatomic, copy) NSString *downloadUrl;
//区服
@property(nonatomic,copy)NSString *serverDesc;

- (id)initWithDict:(NSDictionary *)dict;

+ (id)packWithDict:(NSDictionary *)dict;

- (id)initWithDictByString:(NSDictionary *)dict;


@end
