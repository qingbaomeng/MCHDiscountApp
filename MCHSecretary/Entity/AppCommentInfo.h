//
//  AppCommentInfo.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/24.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserComment.h"

@interface AppCommentInfo : NSObject

@property (nonatomic, copy) NSString *version;

@property (nonatomic, assign) int totalstar;

@property (nonatomic, assign) float averagestar;

@property (nonatomic, assign) int fivestar;

@property (nonatomic, assign) int fourstar;

@property (nonatomic, assign) int threestar;

@property (nonatomic, assign) int twostar;

@property (nonatomic, assign) int onestar;

@property (nonatomic, strong) NSMutableArray *commentArray;


- (id)initWithDict:(NSDictionary *)dict;

+ (id)packWithDict:(NSDictionary *)dict;

@end
