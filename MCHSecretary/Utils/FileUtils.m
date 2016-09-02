//
//  FileUtils.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/30.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "FileUtils.h"

#define SearchFile @"/search/"

@implementation FileUtils

//判断文件是否存在

+(BOOL) FileIsExists:(NSString*) checkFile{
    if([[NSFileManager defaultManager]fileExistsAtPath:checkFile]) {

        return YES;
    }
//    NSLog(@"checkFile=%@",checkFile);
    [[NSFileManager defaultManager] createDirectoryAtPath:checkFile withIntermediateDirectories:YES attributes:nil error:nil];//创建文件夹
    return  NO;
}

//获得document

+(NSString *)documentsPath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    return [paths objectAtIndex:0];
    
}

//获得document文件路径

+(NSString *)fullpathOfFilename:(NSString *)filename {
    
    NSString *documentsPath = [self documentsPath];
    
//    NSLog(@"documentsPath=%@",documentsPath);
    
    return [documentsPath stringByAppendingPathComponent:filename];
}



//获得Library

+(NSString *) libraryPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

//获得Library文件路径

+(NSString *)fullpathOfLibraryFilename:(NSString *)filename {
    
    NSString *libraryPath = [self libraryPath];
    NSString *filepath = [SearchFile stringByAppendingString:filename];
    
//    NSLog(@"libraryPath=%@",libraryPath);
    
    return [libraryPath stringByAppendingPathComponent:filepath];
}


//写入文件 Array 沙盒

+(void)saveOrderArrayList:(NSMutableArray *)list  FileUrl :(NSString*) FileUrl {
//    NSLog(@"saveArray:%@",list);
    NSString *f = [self fullpathOfLibraryFilename:FileUrl];
    if(![self FileIsExists:[f stringByDeletingLastPathComponent]]){
//        NSLog(@"saveArray_此文件不存在:%@",FileUrl);
    }
    
    [list writeToFile:f atomically:YES];
}

//加载文件沙盒NSArray

+(NSArray *)loadArrayList: (NSString*) FileUrl {
    
    NSString *f = [self fullpathOfLibraryFilename:FileUrl];
    if(![self FileIsExists:[f stringByDeletingLastPathComponent]]){
//        NSLog(@"loadArray_此文件不存在:%@",FileUrl);
        return nil;
    }
    NSArray *list = [NSArray  arrayWithContentsOfFile:f];
    
    return list;
}


//写入文件沙盒位置NSDictionary

+(void)saveNSDictionaryForDocument:(NSDictionary *)list  FileUrl:(NSString*) FileUrl  {
    
    NSString *f = [self fullpathOfFilename:FileUrl];
    if(![self FileIsExists:f]){
//        NSLog(@"saveNSDictionary_此文件不存在:%@",FileUrl);
        return;
    }
    [list writeToFile:f atomically:YES];
}

//加载文件沙盒NSDictionary

+(NSDictionary *)loadNSDictionaryForDocument  : (NSString*) FileUrl {
    
    NSString *f = [self fullpathOfFilename:FileUrl];
    if(![self FileIsExists:f]){
//        NSLog(@"loadNSDictionary_此文件不存在:%@",FileUrl);
        return nil;
    }
    NSDictionary *list = [ [NSDictionary alloc] initWithContentsOfFile:f];
    
    return list;
    
}

+(void) delete:(NSString*) FileUrl{
    NSString *f = [self fullpathOfLibraryFilename:FileUrl];
    if([[NSFileManager defaultManager] fileExistsAtPath:[f stringByDeletingLastPathComponent]]) {
        [[NSFileManager defaultManager]  removeItemAtPath:[f stringByDeletingLastPathComponent] error:nil];
    }
}

@end
