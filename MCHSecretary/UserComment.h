//
//  UserComment.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/24.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserComment : NSObject

@property (nonatomic, copy) NSString *headerImage;

@property (nonatomic, copy) NSString *nikeName;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *createtime;


- (id)initWithDict:(NSDictionary *)dict;

+ (id)packWithDict:(NSDictionary *)dict;

@end
