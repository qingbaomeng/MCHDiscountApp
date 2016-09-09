//
//  RecommendAppInfo.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/9/9.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "RecommendAppInfo.h"

#import "StringUtils.h"

#define appdownloadpre @"itms-services://?action=download-manifest&url="
#define checkNull(__X__) (__X__) == [NSNull null] || (__X__) == nil ? @"" : [NSString stringWithFormat:@"%@", (__X__)]


@implementation RecommendAppInfo

@synthesize gameIconUrl, gameName, gameBundleID, packetSize, game_type_name, introduction, downloadUrl, gameID, appDiscount;


-(id) init{
    if (self = [super init]) {
        gameID = -1;
        gameIconUrl = @"";
        gameBundleID = @"";
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

+ (id)packWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

-(void) setValuesByDic:(NSDictionary *)dict{
    
    gameID = [[dict objectForKey:@"id"] intValue];
//    gameName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"game_name"]];
    gameName = checkNull([dict objectForKey:@"game_name"]);
//    gameIconUrl = [NSString stringWithFormat:@"%@", [dict objectForKey:@"icon"]];
    gameIconUrl = checkNull([dict objectForKey:@"icon"]);
//    gameBundleID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"marking"]];
    gameBundleID = checkNull([dict objectForKey:@"marking"]);
    packetSize = [NSString stringWithFormat:@"%@", [dict objectForKey:@"game_size"]];
    packetSize = checkNull([dict objectForKey:@"game_size"]);
//    game_type_name = [NSString stringWithFormat:@"%@", [dict objectForKey:@"game_type_name"]];
    game_type_name = checkNull([dict objectForKey:@"game_type_name"]);
//    introduction = [NSString stringWithFormat:@"%@", [dict objectForKey:@"introduction"]];
    introduction = checkNull([dict objectForKey:@"introduction"]);
//    downloadUrl = [NSString stringWithFormat:@"%@", [dict objectForKey:@"and_dow_address"]];
    NSString *downurl = checkNull([dict objectForKey:@"and_dow_address"]);
    if(![StringUtils isBlankString:downurl]){
        downloadUrl = [appdownloadpre stringByAppendingString:downloadUrl];
    }else{
        downloadUrl = @"";
    }
    appDiscount = checkNull([dict objectForKey:@"discount"]);
}








@end
