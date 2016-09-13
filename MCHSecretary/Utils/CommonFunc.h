//
//  CommonFunc.h
//  Payment
//
//  Created by 朱进 on 16/6/1.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define __BASE64( text )        [CommonFunc base64StringFromText:text]
//#define __TEXT( base64 )        [CommonFunc textFromBase64String:base64]

@interface CommonFunc : NSObject

/******************************************************************************
 函数名称 : + (NSString *)base64StringFromText:(NSString *)text
 函数描述 : 将文本转换为base64格式字符串
 输入参数 : (NSString *)text    文本
 输出参数 : N/A
 返回参数 : (NSString *)    base64格式字符串
 备注信息 :
 ******************************************************************************/
+ (NSString *)base64StringFromText:(NSString *)text;

/******************************************************************************
 函数名称 : + (NSString *)textFromBase64String:(NSString *)base64
 函数描述 : 将base64格式字符串转换为文本
 输入参数 : (NSString *)base64  base64格式字符串
 输出参数 : N/A
 返回参数 : (NSString *)    文本
 备注信息 :
 ******************************************************************************/
+ (NSString *)textFromBase64String:(NSString *)base64;

//将文本转换为md5格式字符串
+ (NSString *)md5:(NSString *)str;

//获取随机值
+ (NSString *)generateTradeNO;

//对支付宝的sign进行urlencode
/**
 * 对支付宝的sign进行urlencode
 **/
+(NSString*)encodeString:(NSString*)unencodedString;
@end
