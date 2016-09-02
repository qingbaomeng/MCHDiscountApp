//
//  CommentStarFrame.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/25.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AppCommentInfo;

@interface CommentStarFrame : NSObject

@property (nonatomic, strong) AppCommentInfo *commentInfo;

@property (nonatomic, assign) CGRect totalStarFrame;

@property (nonatomic, assign) CGRect totalStarTextFrame;

@property (nonatomic, assign) CGRect fiveStarFrame;

@property (nonatomic, assign) CGRect fiveStarLineFrame;

@property (nonatomic, assign) CGRect fourStarFrame;

@property (nonatomic, assign) CGRect fourStarLineFrame;

@property (nonatomic, assign) CGRect threeStarFrame;

@property (nonatomic, assign) CGRect threeStarLineFrame;

@property (nonatomic, assign) CGRect twoStarFrame;

@property (nonatomic, assign) CGRect twoStarLineFrame;

@property (nonatomic, assign) CGRect oneStarFrame;

@property (nonatomic, assign) CGRect oneStarLineFrame;

@property (nonatomic, assign) CGRect addStarScoreTextFrame;

@property (nonatomic, assign) CGRect addStarScoreFrame;

@property (nonatomic, assign) CGRect submitStarScoreFrame;

@property (nonatomic, assign) CGRect lineFrame;


@property (nonatomic, assign) CGFloat cellHeight;

@end
