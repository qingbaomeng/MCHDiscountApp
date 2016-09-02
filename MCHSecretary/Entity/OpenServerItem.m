//
//  OpenServerItem.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/26.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "OpenServerItem.h"

@implementation OpenServerItem

@synthesize openServerTime, appInfoArray;

-(instancetype) init{
    if (self = [super init]) {
        openServerTime = @"";
        appInfoArray = [[NSMutableArray alloc] init];
        
    }
    return self;
}


@end
