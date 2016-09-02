//
//  AppCommentInfo.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/24.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "AppCommentInfo.h"
#import "CommentFrame.h"

@implementation AppCommentInfo

@synthesize version, totalstar, fivestar, fourstar, threestar, twostar, onestar, commentArray, averagestar;

-(id) init{
    if (self = [super init]) {
        version = @"";
        totalstar = 1;
        averagestar = 0;
        fivestar = 0;
        fourstar = 0;
        threestar = 0;
        twostar = 0;
        onestar = 0;
        commentArray = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (id)packWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

- (id)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesByDic:dict];
    }
    return self;
}

-(void) setValuesByDic:(NSDictionary *)dict{
    commentArray = [[NSMutableArray alloc] init];
    
    NSDictionary *starComment = [dict objectForKey:@"starcomment"];
    
    version = [NSString stringWithFormat:@"%@", [starComment objectForKey:@"verision"]];
    totalstar = [[NSString stringWithFormat:@"%@", [starComment objectForKey:@"totalstar"]] intValue];
    averagestar = [[NSString stringWithFormat:@"%@", [starComment objectForKey:@"averagestar"]] floatValue];
    fivestar = [[NSString stringWithFormat:@"%@", [starComment objectForKey:@"fivestar"]] intValue];
    fourstar = [[NSString stringWithFormat:@"%@", [starComment objectForKey:@"fourstar"]] intValue];
    threestar = [[NSString stringWithFormat:@"%@", [starComment objectForKey:@"threestar"]] intValue];
    twostar = [[NSString stringWithFormat:@"%@", [starComment objectForKey:@"twostar"]] intValue];
    onestar = [[NSString stringWithFormat:@"%@", [starComment objectForKey:@"onestar"]] intValue];
    
    NSArray *textComment = [dict objectForKey:@"textcomment"];
//    NSLog(@"%lu", (unsigned long)textComment.count);
    for (NSInteger i = 0; i < textComment.count; i++) {
        NSDictionary *commentDic = textComment[i];
        CommentFrame *frame = [[CommentFrame alloc] init];
        
        UserComment *userComment = [UserComment packWithDict:commentDic];
        frame.commentInfo = userComment;
        
        [commentArray addObject:frame];
    }
}

@end
