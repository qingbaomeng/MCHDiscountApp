//
//  OpenServerFrame.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/26.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "OpenServerFrame.h"
#import "OpenServerEntity.h"

#define mScreenWidth [[UIScreen mainScreen] bounds].size.width
#define mScreenHeight [[UIScreen mainScreen] bounds].size.height

#define ViewHeight 80
#define ImageHeight 50

@implementation OpenServerFrame{
    
    
}

-(void) setData:(OpenServerEntity*)firstApp secondApp:(OpenServerEntity*)secondApp{
    _leftApp = firstApp;
    _rightApp = secondApp;
    
    CGFloat viewWeight = mScreenWidth / 2;
    CGFloat vPadding = (ViewHeight - ImageHeight) / 2;
    
    self.leftViewFrame = CGRectMake(0, 0, viewWeight, ViewHeight);
    
    self.leftImageFrame = CGRectMake(5, vPadding, ImageHeight, ImageHeight);
    
    CGFloat leftnameX = CGRectGetMaxX(self.leftImageFrame) + 5;
    self.leftNameFrame = CGRectMake(leftnameX, vPadding, viewWeight - leftnameX, 12);
    
//    CGFloat leftserverY = CGRectGetMaxY(self.leftNameFrame) + 5;
    CGFloat leftserverY = CGRectGetMaxY(self.leftImageFrame) - 18;
    self.leftServerFrame = CGRectMake(leftnameX, leftserverY + 2.5, 20, 10);
    
    CGFloat leftdiscountX = CGRectGetMaxX(self.leftServerFrame) + 10;
    self.leftDiscountFrame = CGRectMake(leftdiscountX, leftserverY, 40, 15);
    
    
    
    self.rightViewFrame = CGRectMake(viewWeight, 0, viewWeight, ViewHeight);
    
//    self.rightImageFrame = CGRectMake(5, vPadding, ImageHeight, ImageHeight);
//    
//    CGFloat rightnameX = CGRectGetMaxX(self.rightImageFrame) + 3;
//    self.rightNameFrame = CGRectMake(rightnameX, vPadding, viewWeight - rightnameX, 12);
//    
////    CGFloat rightserverY = CGRectGetMaxY(self.rightNameFrame) + 5;
//    CGFloat rightserverY = CGRectGetMaxY(self.rightImageFrame) - 18;
//    self.rightServerFrame = CGRectMake(rightnameX, rightserverY + 2, 20, 10);
//    
//    CGFloat rightdiscountX = CGRectGetMaxX(self.rightServerFrame) + 3;
//    self.rightDiscountFrame = CGRectMake(rightdiscountX, rightserverY, 40, 15);
    
    
    
    
    CGFloat lineY = CGRectGetMaxY(self.rightViewFrame);
    self.lineFrame = CGRectMake(0, lineY, mScreenWidth, 1);
    
    self.cellHeight = CGRectGetMaxY(self.lineFrame);
}

@end
