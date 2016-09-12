//
//  Share.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/9/5.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Share : NSObject
+(void)shareWithTitle:(NSString *)title ImageUrl:(NSString *)imageURl Message:(NSString *)msg URL:(NSString *)url ViewControl:(UIViewController *)vc;

+(void)shareWithURLImageTitle:(NSString *)title ImageUrl:(NSArray*)imageArray Message:(NSString *)msg URL:(NSString *)url ViewControl:(UIViewController *)vc;
@end
