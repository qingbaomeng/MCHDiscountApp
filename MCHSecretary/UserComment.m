//
//  UserComment.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/24.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "UserComment.h"

@implementation UserComment

@synthesize headerImage, nikeName, content, createtime;

-(id) init{
    if (self = [super init]) {
        headerImage = @"";
        nikeName = @"";
        content = @"";
        createtime = @"";
    }
    return self;
}

+ (id)packWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

- (id)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesByDic:dict];
    }
    return self;
}

-(void) setValuesByDic:(NSDictionary *)dict{
    
    headerImage = [NSString stringWithFormat:@"%@", [dict objectForKey:@"headerimage"]];
    nikeName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"nikename"]];
    content = [NSString stringWithFormat:@"%@", [dict objectForKey:@"content"]];
    createtime = [NSString stringWithFormat:@"%@", [dict objectForKey:@"createtime"]];

}

@end
