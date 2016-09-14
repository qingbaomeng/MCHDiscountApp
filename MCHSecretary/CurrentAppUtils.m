//
//  CurrentAppUtils.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/23.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "CurrentAppUtils.h"
#include <objc/runtime.h>

#import "DeviceAppInfo.h"

@implementation CurrentAppUtils

+(NSString *) appVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
//    NSString *executableFile = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];    //获取项目名称
    
//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];      //获取项目版本号
    
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
////    CFShow((__bridge CFTypeRef)(infoDictionary));
//    // app名称
//    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
//    // app版本
//    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    // app build版本
//    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
}

/**
 * 更新数据库保存的bundleid
 */
+(void) updateInstalledAppBundleid{
    dispatch_queue_t queueAllApp = dispatch_queue_create("allapp", NULL);
    dispatch_async(queueAllApp, ^{
        NSMutableArray *appInfo = [[DeviceAppInfo findAll] mutableCopy];
//        NSLog(@"all bundleid count:%ld", appInfo.count);
        NSMutableArray *bidDic = [self gainAPPInformationFromPhone:appInfo];
        if(bidDic.count > 0){
//            NSLog(@"save bundleid count:%ld", bidDic.count);
            [DeviceAppInfo saveObjects:bidDic];
        }
    });
}

#pragma mark 获取手机内安装的程序

+ (NSMutableArray *) gainAPPInformationFromPhone:(NSMutableArray *)appInfo {
        Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
        NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
        //    NSLog(@"apps: %@", [workspace performSelector:@selector(allApplications)]);
        NSArray *array = [workspace performSelector:@selector(allApplications)];
        NSMutableArray *bidDic = [[NSMutableArray alloc] init];
        for (NSString *app in array) {
            //获取BundleID
            NSString *bundleid = [self getParseBundleIDString:app];
//            NSLog(@"%@",bundleid);
            
            if(![self isContainBundle:appInfo bundleid:bundleid]){
                DeviceAppInfo *info = [[DeviceAppInfo alloc] init];
                [info setAppBundleId:bundleid];
                [bidDic addObject:info];
            }
        }
        return bidDic;
}

+(BOOL) isContainBundle:(NSMutableArray *)appInfo bundleid:(NSString *)bundleid{
    for (int i = 0; i < appInfo.count; i++) {
        DeviceAppInfo *info = appInfo[i];
        if([bundleid isEqualToString:info.appBundleId]){
            return YES;
        }
    }
    return NO;
}

/**
 * 获取BundleID
 */
+(NSString *)getParseBundleIDString:(NSString *)description {
    NSString *ret = @"";
    NSString *target = [description description];
    // iOS8.0 "LSApplicationProxy: com.apple.videos",
    // iOS8.1 "<LSApplicationProxy: 0x898787998> com.apple.videos",
    // iOS9.0 "<LSApplicationProxy: 0x145efbb0> com.apple.PhotosViewService <file:///Applications/PhotosViewService.app>"
    if (target == nil) {
        return ret;
    }
    NSArray *arrObj = [target componentsSeparatedByString:@" "];
    switch ([arrObj count]) {
        case 2:// [iOS7.0 ~ iOS8.1)
        case 3:// [iOS8.1 ~ iOS9.0)
            ret = [arrObj lastObject];
            break;
        case 4:
            ret = [arrObj objectAtIndex:2];
            break;
        default:
            break;
    }
    return ret;
}
#pragma mark 通过包名打开软件
+(void)openAPPWithBundleID:(NSString *)bundleID
{
    Class lsawsc = objc_getClass("LSApplicationWorkspace");
    NSObject* workspace = [lsawsc performSelector:NSSelectorFromString(@"defaultWorkspace")];
    // iOS6 没有defaultWorkspace
    if ([workspace respondsToSelector:NSSelectorFromString(@"openApplicationWithBundleID:")])
    {
        [workspace performSelector:NSSelectorFromString(@"openApplicationWithBundleID:") withObject:bundleID];
    }
}
@end
