//
//  CurrentAppUtils.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/23.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentAppUtils : NSObject

+(NSString *) appVersion;

+(void) updateInstalledAppBundleid;

+(BOOL) isContainBundle:(NSMutableArray *)appInfo bundleid:(NSString *)bundleid;

+(void)openAPPWithBundleID:(NSString *)bundleID;
@end
