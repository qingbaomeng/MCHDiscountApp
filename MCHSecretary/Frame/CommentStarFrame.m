//
//  CommentStarFrame.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/25.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "CommentStarFrame.h"

#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight  [[UIScreen mainScreen] bounds].size.height


@implementation CommentStarFrame

-(void) setCommentInfo:(AppCommentInfo *)commentInfo{
    _commentInfo = commentInfo;
    
    int padding = 15;
    
    self.totalStarFrame = CGRectMake(15, padding + 2, 60, 8);
    
    CGFloat totalCommentX = CGRectGetMaxX(self.totalStarFrame) + padding;
    CGRectMake(totalCommentX, padding, kScreenWidth - totalCommentX, 12);
    self.totalStarTextFrame = CGRectMake(15, padding, 60, 8);
    
    CGFloat fiveStarY = CGRectGetMaxY(self.totalStarTextFrame) + padding - 5;
    self.fiveStarFrame  = CGRectMake(15, fiveStarY, 60, 8);
    
    self.fiveStarLineFrame = CGRectMake(90, fiveStarY, kScreenWidth - 110, 10);
    
    self.fourStarFrame = CGRectMake(15, fiveStarY + 12 * 1, 60, 8);
    
    self.fourStarLineFrame = CGRectMake(90, fiveStarY+ 12 * 1, kScreenWidth - 110, 10);
    
    self.threeStarFrame = CGRectMake(15, fiveStarY + 12 * 2, 60, 8);
    
    self.threeStarLineFrame = CGRectMake(90, fiveStarY+ 12 * 2, kScreenWidth - 110, 10);
    
    self.twoStarFrame = CGRectMake(15, fiveStarY + 12 * 3, 60, 8);
    
    self.twoStarLineFrame = CGRectMake(90, fiveStarY+ 12 * 3, kScreenWidth - 110, 10);
    
    self.oneStarFrame = CGRectMake(15, fiveStarY + 12 * 4, 60, 8);
    
    self.oneStarLineFrame = CGRectMake(90, fiveStarY+ 12 * 4, kScreenWidth - 110, 10);
    
    CGFloat lblCommentStarY = CGRectGetMaxY(self.oneStarLineFrame) + padding;
    CGFloat lblCommentStarW = kScreenWidth - 15;
    self.addStarScoreTextFrame = CGRectMake(15, lblCommentStarY, lblCommentStarW, 10);
    
    CGFloat clickStarY = CGRectGetMaxY(self.addStarScoreTextFrame) + 10;
    CGFloat clickStarW = lblCommentStarW - 80;
    self.addStarScoreFrame = CGRectMake(15, clickStarY, clickStarW, 20);
    
    CGFloat submitX = CGRectGetMaxX(self.addStarScoreFrame);
    self.submitStarScoreFrame = CGRectMake(submitX, clickStarY - 5, 55, 30);
    
    CGFloat sLineY = CGRectGetMaxY(self.submitStarScoreFrame) + 5;
    self.lineFrame = CGRectMake(0, sLineY, kScreenWidth, 1);
    
    self.cellHeight = CGRectGetMaxY(self.lineFrame);
    
}
@end
