//
//  OpenServerEntity.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/30.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenServerEntity : NSObject

//应用名称
@property (nonatomic, copy) NSString *packetName;
//图片地址
@property (nonatomic, copy) NSString *smallImageUrl;
//服务器描述
@property (nonatomic, copy) NSString *serverDesc;
//折扣
@property (nonatomic, copy) NSString *appDiscount;



- (id)initWithDict:(NSDictionary *)dict;

+ (id)packWithDict:(NSDictionary *)dict;

@end
