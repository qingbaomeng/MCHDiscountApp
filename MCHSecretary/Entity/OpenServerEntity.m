//
//  OpenServerEntity.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/30.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "OpenServerEntity.h"
#import "StringUtils.h"

#define checkNull(__X__) (__X__) == [NSNull null] || (__X__) == nil ? @"" : [NSString stringWithFormat:@"%@", (__X__)]

@implementation OpenServerEntity

@synthesize gameID;
@synthesize packetName, smallImageUrl, gameDesc, appDiscount, openServerArray, downloadUrl,gameSize,game_type_name,serverDesc;

-(id) init{
    if (self = [super init]) {
        smallImageUrl = @"";
        packetName = @"";
        gameDesc = @"";
        appDiscount = @"";
        downloadUrl = @"";
        openServerArray = [[NSArray alloc] init];
        game_type_name = @"";
        gameSize = @"";
        gameID = 0;
        serverDesc= @"";
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
    gameSize = [dict objectForKey:@"game_size"];
    game_type_name = [dict objectForKey:@"game_type_name"];
    smallImageUrl = [NSString stringWithFormat:@"%@", [dict objectForKey:@"icon"]];

    packetName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"game_name"]];
    
    NSString *resultDesc = checkNull([dict objectForKey:@"server_name"]);
    if(![StringUtils isBlankString:resultDesc]){
        serverDesc = [NSString stringWithFormat:@"%@", resultDesc];
    }else{
        serverDesc = @"";
    }
    NSLog(@"===%@",serverDesc);
    
    NSString *game = checkNull([dict objectForKey:@"features"]);
    if(![StringUtils isBlankString:game]){
        gameDesc = [NSString stringWithFormat:@"%@", game];
    }else{
        gameDesc = @"";
    }

    NSString *resultDiscount = checkNull([dict objectForKey:@"discount"]);
    if(![StringUtils isBlankString:resultDiscount]){
        appDiscount = [NSString stringWithFormat:@"%@", resultDiscount];
    }else{
        appDiscount = @"";
    }
    
    NSString *openserverStr = checkNull([dict objectForKey:@"time"]);
    
    if(![StringUtils isBlankString:openserverStr]){
        openServerArray = [openserverStr componentsSeparatedByString:@","];
    }else{
        openServerArray = [[NSArray alloc] init];
    }
    NSLog(@"openserverStr1111: %@", openServerArray);
}



@end
