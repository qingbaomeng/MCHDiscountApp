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

@synthesize packetName, smallImageUrl, serverDesc, appDiscount;

-(id) init{
    if (self = [super init]) {
        smallImageUrl = @"";
        packetName = @"";
        serverDesc = @"";
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
    
    smallImageUrl = [NSString stringWithFormat:@"%@", [dict objectForKey:@"smalliconurl"]];

    packetName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"name"]];
    
    NSString *resultDesc = checkNull([dict objectForKey:@"serverdesc"]);
    if(![StringUtils isBlankString:resultDesc]){
        serverDesc = [NSString stringWithFormat:@"%@", resultDesc];
    }else{
        serverDesc = @"";
    }

    NSString *resultDiscount = checkNull([dict objectForKey:@"discount"]);
    if(![StringUtils isBlankString:resultDiscount]){
        appDiscount = [NSString stringWithFormat:@"%@", resultDiscount];
    }else{
        appDiscount = @"";
    }
    
}



@end
