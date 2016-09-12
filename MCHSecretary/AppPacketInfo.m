//
//  AppPacketInfo.m
//  MCHSecretary
//
//  Created by 朱进 on 16/8/9.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "AppPacketInfo.h"

#import "StringUtils.h"
#define checkNull(__X__) (__X__) == [NSNull null] || (__X__) == nil ? @"" : [NSString stringWithFormat:@"%@", (__X__)]

@implementation AppPacketInfo

@synthesize gameID,recommend_status;
@synthesize gameIconUrl, gameName,gameBundleID, packetSize,game_type_name, introduction, downloadUrl;
@synthesize describeImages, contentDescribe, versionInfo;
@synthesize language, appDiscount, appOS, appUrl;

-(id) init{
    if (self = [super init]) {
        gameIconUrl = @"";
        gameName = @"";
        packetSize = @"";
        game_type_name = @"";
        introduction = @"";
        downloadUrl = @"";
        describeImages = @"";
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
    introduction = checkNull([dict objectForKey:@"introduction"]);
    if ([StringUtils isBlankString:introduction]) {
        introduction = NSLocalizedString(@"AppDescribeContent", @"");
    }
    //推荐状态(0不推荐；1推荐；2热门；3最新)
    recommend_status = [[dict objectForKey:@"recommend_status"] intValue];
    
    //下载地址
    downloadUrl = checkNull([dict objectForKey:@"downloadurl"]);
    describeImages = checkNull([dict objectForKey:@"describeimages"]);
    contentDescribe = checkNull([dict objectForKey:@"describecontent"]);
    if ([StringUtils isBlankString:contentDescribe]) {
        contentDescribe = NSLocalizedString(@"AppDescribeContent", @"");
    }
    versionInfo = checkNull([dict objectForKey:@"version"]);
    
    _updateData = checkNull([dict objectForKey:@"create_time"]);
    language = checkNull([dict objectForKey:@"language"]);
    
    //折扣
    appDiscount = checkNull([dict objectForKey:@"discount"]);
    
    appOS = checkNull([dict objectForKey:@"appos"]);
    appUrl = checkNull([dict objectForKey:@"appurl"]);
    if ([StringUtils isBlankString:appUrl]) {
        appUrl = @"http://www.baidu.com";
    }
}

-(NSString *) updateData{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yy-MM-dd"];
    return [StringUtils TimeLongToString:_updateData dataDormatter:dateFormatter];
}

//-(NSString *)appDownloadNum{
//    float downNum = [appDownloadNum floatValue];
//    if(downNum >= 10000){
//        float w = downNum / 10000;
//        return [NSString stringWithFormat:@"%.1f%@", w, NSLocalizedString(@"DownLoadUnit", @"")];
//    }
//    return appDownloadNum;
//}
@end
