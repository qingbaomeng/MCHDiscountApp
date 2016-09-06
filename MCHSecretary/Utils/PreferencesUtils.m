//
//  PreferencesUtils.m
//  Payment
//
//  Created by 朱进 on 16/6/18.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "PreferencesUtils.h"

//#define accountkey @"mchaccount"
//#define passwordkey @"mchpassword"
//#define issavepwdkey @"issavepwd"

@implementation PreferencesUtils

+(NSUserDefaults *)getUserDefaults{
    return [NSUserDefaults standardUserDefaults];
}

+(void) saveStringInfo:(NSString *)value key:(NSString *)key{
//    NSLog(@"[saveStringInfo] key = %@, value = %@", key, value);
    [[self getUserDefaults] setObject:value forKey:key];
    [[self getUserDefaults] synchronize];
    
}

+(NSString *) readStringValueByKey:(NSString *)key{
    NSString *value = [[self getUserDefaults] objectForKey:key];
//    NSLog(@"[readStringValueByKey] key = %@, value = %@", key, value);
    return value;
}

//+(void) saveUserAccount:(NSString *)account{
//    [self saveStringInfo:account key:accountkey];
//}
//
//+(NSString *) getAccount{
//    return [self readStringValueByKey:accountkey];
//}
//
//+(void) saveUserPassword:(NSString *)password{
//    [self saveStringInfo:password key:passwordkey];
//}
//
//+(NSString *) getPassword{
//    return [self readStringValueByKey:passwordkey];
//}
//
//+(void) savePasswordStatue:(NSString *)issavepwd{
//    [self saveStringInfo:issavepwdkey key:issavepwd];
//}
//
//+(NSString *) getPasswordStatue{
//    return [self readStringValueByKey:issavepwdkey];
//}

+(NSDictionary *)getGameAboutInfo{
    NSString *plistpath = [[NSBundle mainBundle] pathForResource:@"mchannelinfos" ofType:@"plist"];
    NSMutableDictionary *date = [[NSMutableDictionary alloc] initWithContentsOfFile:plistpath];
//    NSLog(@"date:%@", date);
    return date;
}

+(NSString *) getGameId{
    NSString * gameId = @"";
    
    if([[self getGameAboutInfo] objectForKey:@"gameid"]){
        gameId = [[self getGameAboutInfo] objectForKey:@"gameid"];
    }
    
    return gameId;
}

+(NSString *) getGameName{
    NSString * gameName = @"";
    if([[self getGameAboutInfo] objectForKey:@"gamename"]){
        gameName = [[self getGameAboutInfo] objectForKey:@"gamename"];
    }
//    NSString * gameName = [[self getGameAboutInfo] objectForKey:@"gamename"];
//    NSLog(@"gameName:%@", gameName);
    return gameName;
}

+(NSString *) getGameAppId{
    NSString * gameAppId = @"";
    if([[self getGameAboutInfo] objectForKey:@"gameappid"]){
        gameAppId = [[self getGameAboutInfo] objectForKey:@"gameappid"];
    }
//    NSString * gameAppId = [[self getGameAboutInfo] objectForKey:@"gameappid"];
//    NSLog(@"gameAppId:%@", gameAppId);
    return gameAppId;
}

+(NSString *) getPromoteId{
    NSString * promoteId = @"";
    if([[self getGameAboutInfo] objectForKey:@"promoteid"]){
        promoteId = [[self getGameAboutInfo] objectForKey:@"promoteid"];
    }
//    NSString * promoteId = [[self getGameAboutInfo] objectForKey:@"promoteid"];
//    NSLog(@"promoteId:%@", promoteId);
    return promoteId;
}

+(NSString *) getPromoteAccount{
    NSString * promoteAccount = @"";
    if([[self getGameAboutInfo] objectForKey:@"promoteaccount"]){
        promoteAccount = [[self getGameAboutInfo] objectForKey:@"promoteaccount"];
    }
//    NSString * PromoteAccount = [[self getGameAboutInfo] objectForKey:@"promoteaccount"];
//    NSLog(@"PromoteAccount:%@", promoteAccount);
    return promoteAccount;
}




@end
