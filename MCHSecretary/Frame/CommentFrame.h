//
//  CommentFrame.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/24.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class UserComment;

@interface CommentFrame : NSObject


@property (nonatomic, strong) UserComment *commentInfo;

@property (nonatomic, assign) CGRect imageFrame;

@property (nonatomic, assign) CGRect nickNameFrame;

@property (nonatomic, assign) CGRect timeFrame;

@property (nonatomic, assign) CGRect contentFrame;

@property (nonatomic, assign) CGRect replyBtnFrame;

@property (nonatomic, assign) CGRect lineFrame;

@property (nonatomic, assign) CGFloat cellHeight;

@end
