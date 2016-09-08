//
//  InstallAppFrame.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/9/7.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "InstallAppFrame.h"
#import "InstallAppInfo.h"

#import "StringUtils.h"

#define mScreenWidth [[UIScreen mainScreen] bounds].size.width
#define mScreenHeight [[UIScreen mainScreen] bounds].size.height

@implementation InstallAppFrame


-(void) setInstallAppInfo:(InstallAppInfo *)installAppInfo{
    
    _installAppInfo = installAppInfo;
    
    CGFloat padding = 20;
    CGFloat itempadding = 10;
    CGFloat lblNameViewH = 15;
    CGFloat lblMiddleViewH = 10;
    CGFloat lblDescribeViewH = 12;
    CGFloat rightDownW = 60;
    
    self.imageFrame = CGRectMake(padding, itempadding, 60, 60);
    
    CGFloat nameLabelX = CGRectGetMaxX(self.imageFrame) + itempadding;
    CGFloat contentW = mScreenWidth - nameLabelX - rightDownW - 60;
    self.nameFrame = CGRectMake(nameLabelX, itempadding, contentW, lblNameViewH);
    
    CGFloat middleY = CGRectGetMaxY(self.nameFrame) + itempadding;
    self.middleFrame = CGRectMake(nameLabelX, middleY, contentW, lblMiddleViewH);
    
    CGFloat descY = CGRectGetMaxY(self.middleFrame) + itempadding;
    self.describeFrame = CGRectMake(nameLabelX, descY, contentW, lblDescribeViewH);
    
    CGFloat lineY = CGRectGetMaxY(self.imageFrame) + itempadding;
    self.lineFrame = CGRectMake(0, lineY, mScreenWidth + 10, 1);
    
    self.cellHeight = CGRectGetMaxY(self.lineFrame);
    
    CGFloat downY = (self.cellHeight - 45) / 2;
    CGFloat downX = mScreenWidth - rightDownW;
    self.downloadFrame = CGRectMake(downX, downY, 45, 45);
    
    CGFloat discountX = CGRectGetMaxX(self.nameFrame) + 10;
    self.discountFrame = CGRectMake(discountX, itempadding, 40, lblNameViewH);
}


@end