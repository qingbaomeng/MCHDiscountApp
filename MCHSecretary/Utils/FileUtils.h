//
//  FileUtils.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/30.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtils : NSObject

+(void)saveOrderArrayList:(NSMutableArray *)list  FileUrl :(NSString*) FileUrl;

+(NSArray *)loadArrayList: (NSString*) FileUrl;

+(void) delete:(NSString*) FileUrl;

@end
