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
@synthesize largeImageUrl, describeimageUrl, describeImages;
@synthesize contentDescribe, updateLogs, versionInfo;
@synthesize updateData, appType, language, developCompany, compatible, appDiscount;

-(id) init{
    if (self = [super init]) {
        gameIconUrl = @"";
        gameName = @"";
        packetSize = @"";
        game_type_name = @"";
        introduction = @"";
        downloadUrl = @"";
        largeImageUrl = @"";
        describeimageUrl = @"";
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
    gameName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"game_name"]];
    //图片地址
    gameIconUrl = [NSString stringWithFormat:@"%@", [dict objectForKey:@"icon"]];
    //游戏标识
    gameBundleID = [dict objectForKey:@"marking"];
    //应用包大小
    packetSize = [NSString stringWithFormat:@"%@", [dict objectForKey:@"game_size"]];
    //游戏类型
    game_type_name = [dict objectForKey:@"game_type_name"];
    //应用描述
    introduction = [NSString stringWithFormat:@"%@", [dict objectForKey:@"introduction"]];
    //推荐状态(0不推荐；1推荐；2热门；3最新)
    recommend_status = [[dict objectForKey:@"recommend_status"] intValue];
    
    
//    //应用下载量
//    appDownloadNum = [NSString stringWithFormat:@"%@", [dict objectForKey:@"downloadnum"]];
    
    //下载地址
    downloadUrl = [NSString stringWithFormat:@"%@", [dict objectForKey:@"downloadurl"]];
    //图片地址
    largeImageUrl = [NSString stringWithFormat:@"%@", [dict objectForKey:@"largeiconurl"]];
    //应用介绍图片地址
    describeimageUrl = [NSString stringWithFormat:@"%@", [dict objectForKey:@"describeurl"]];
    describeImages = [NSString stringWithFormat:@"%@", [dict objectForKey:@"describeimages"]];
    
    contentDescribe = [NSString stringWithFormat:@"%@", [dict objectForKey:@"describecontent"]];
    updateLogs = [NSString stringWithFormat:@"%@", [dict objectForKey:@"updatelogs"]];
    versionInfo = [NSString stringWithFormat:@"%@", [dict objectForKey:@"versioninfo"]];
    
    updateData = [NSString stringWithFormat:@"%@", [dict objectForKey:@"updatedata"]];
    appType = [NSString stringWithFormat:@"%@", [dict objectForKey:@"apptype"]];
    language = [NSString stringWithFormat:@"%@", [dict objectForKey:@"language"]];
    developCompany = [NSString stringWithFormat:@"%@", [dict objectForKey:@"developcompany"]];
    compatible = [NSString stringWithFormat:@"%@", [dict objectForKey:@"compatible"]];
    
    //折扣
    NSString *resultDiscount = checkNull([dict objectForKey:@"Discount"]);
    if(![StringUtils isBlankString:resultDiscount]){
        appDiscount = [NSString stringWithFormat:@"%@", resultDiscount];
    }else{
        appDiscount = @"";
    }
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
