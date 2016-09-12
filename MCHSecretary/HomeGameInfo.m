//
//  HomeGameInfo.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/9/8.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "HomeGameInfo.h"

#define checkNull(__X__) (__X__) == [NSNull null] || (__X__) == nil ? @"" : [NSString stringWithFormat:@"%@", (__X__)]

@implementation HomeGameInfo

@synthesize gameID,recommend_status;
@synthesize gameIconUrl, gameName,gameBundleID, packetSize,game_type_name, introduction, downloadUrl,appDiscount;

-(id) init{
    if (self = [super init]) {
        gameIconUrl = @"";
        gameName = @"";
        packetSize = @"";
        game_type_name = @"";
        introduction = @"";
        downloadUrl = @"";
        appDiscount = @"";
    }
    return self;
}

- (id)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesByDic:dict];
    }
    return self;
}

+ (id)infoWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

-(void)setValuesByDic:(NSDictionary *)dict
{
        //游戏id
        gameID = [[dict objectForKey:@"id"] intValue];
        //应用名称
        gameName = checkNull([dict objectForKey:@"game_name"]);
        //图片地址
        gameIconUrl = checkNull([dict objectForKey:@"icon"]);
        //游戏标识
        gameBundleID = checkNull([dict objectForKey:@"marking"]);
        //应用包大小
        packetSize = checkNull([dict objectForKey:@"game_size"]);
        //游戏类型
        game_type_name = checkNull([dict objectForKey:@"game_type_name"]);
        //应用描述
        introduction = checkNull([dict objectForKey:@"features"]);
        //推荐状态(0不推荐；1推荐；2热门；3最新)
        recommend_status = [[dict objectForKey:@"recommend_status"] intValue];
        //下载地址
        downloadUrl = checkNull([dict objectForKey:@"and_dow_address"]);
        //折扣
        appDiscount = checkNull([dict objectForKey:@"discount"]);
}
@end
