//
//  CommentFrame.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/24.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "CommentFrame.h"
#import "UserComment.h"

#define mScreenWidth [[UIScreen mainScreen] bounds].size.width
#define mScreenHeight [[UIScreen mainScreen] bounds].size.height

@implementation CommentFrame

-(void) setCommentInfo:(UserComment *)commentInfo {
    //    if(!packetInfo){
    //        return;
    //    }
    //    self.packetInfo = packetInfo;
    _commentInfo = commentInfo;
    
    CGFloat leftPadding = 20;
    CGFloat topPadding = 15;
    CGFloat lblNameViewH = 13;
    CGFloat lblMiddleViewH = 10;
    CGFloat lblDescribeViewH = 16;
    CGFloat rightDownW = 60;
    
    self.imageFrame = CGRectMake(leftPadding, topPadding, 40, 40);
    
    CGFloat nicknameX = CGRectGetMaxX(self.imageFrame) + topPadding;
    CGFloat contentW = mScreenWidth - nicknameX - rightDownW;
    CGFloat nicknameY = topPadding + 10;
    self.nickNameFrame = CGRectMake(nicknameX, nicknameY, contentW, lblNameViewH);
    
    CGFloat timeY = CGRectGetMaxY(self.nickNameFrame) + 3;
    self.timeFrame = CGRectMake(nicknameX, timeY, contentW, lblMiddleViewH);
    
    CGFloat contentY = CGRectGetMaxY(self.imageFrame) + topPadding;
    self.contentFrame = CGRectMake(leftPadding, contentY, mScreenWidth - leftPadding, lblDescribeViewH);
    
    CGFloat lineY = CGRectGetMaxY(self.contentFrame) + lblMiddleViewH;
    self.lineFrame = CGRectMake(0, lineY, mScreenWidth + 10, 1);
    
    self.cellHeight = CGRectGetMaxY(self.lineFrame);

    CGFloat replyBtnY = (contentY - 20) / 2;
    self.replyBtnFrame = CGRectMake(mScreenWidth - rightDownW, replyBtnY, 20, 20);

    
}

@end
