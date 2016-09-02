//
//  StringUtils.m
//  Payment
//
//  Created by 朱进 on 16/5/30.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "StringUtils.h"

#define checkNull(__X__) (__X__) == [NSNull null] || (__X__) == nil ? @"" : [NSString stringWithFormat:@"%@", (__X__)]



@implementation StringUtils


+ (Boolean) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if([NSNull null] == (NSNull *)string)
    {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

+(Boolean) isCheckNull:(NSString *) string{
    if((NSNull *)string == [NSNull null] || string == nil){
        return true;
    }
    
    if([self isBlankString:string]){
        return true;
    }
    return false;
}

/**
 *  计算文本的宽高
 *
 *  @param str     需要计算的文本
 *  @param font    文本显示的字体
 *  @param maxSize 文本显示的范围
 *
 *  @return 文本占用的真实宽高
 */
+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

/**
 *  时间戳转化为字符串
 **/
+ (NSString *)TimeLongToString:(NSString *)str{
    NSTimeInterval time = [str doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
//    NSLog(@"date:%@",[detaildate description]);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yy-MM-dd HH:mm"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
    return currentDateStr;
}

//得到中英文混合字符串长度 方法1
+ (int)stringByteLength:(NSString*)strtemp {
    return (short)[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding];
//    int strlength = 0;
//    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];//以一定格式转成C字符串
//    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
//        if (*p) {//字符串是否存在
//            p++;
//            strlength++;
//        }
//        else {
//            p++;
//        }
//        
//    }
//    return strlength;
}


//得到中英文混合字符串长度 方法2
- (int)getToInt:(NSString*)strtemp {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [strtemp dataUsingEncoding:enc];
    return (short)[da length];
}

@end
