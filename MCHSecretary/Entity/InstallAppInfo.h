//
//  InstallAppInfo.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/9/7.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKDBModel.h"

@interface InstallAppInfo : JKDBModel


@property (nonatomic, copy) NSString *iconUrl;

@property (nonatomic, copy) NSString *gameName;

@property (nonatomic, copy) NSString *gameSize;

@property (nonatomic, copy) NSString *gameType;

@property (nonatomic, copy) NSString *gameDescribe;

@property (nonatomic, copy) NSString *gameDiscount;

@property (nonatomic, copy) NSString *gameBundleId;

@property (nonatomic, copy) NSString *gameInstallUrl;

@end
