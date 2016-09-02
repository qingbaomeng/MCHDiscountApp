//
//  NomalFrame.m
//  MCHSecretary
//
//  Created by 朱进 on 16/8/9.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "OpenServerSearchFrame.h"
#import "AppPacketInfo.h"
#import "OpenServerPostion.h"

#import "StringUtils.h"

#define mScreenWidth [[UIScreen mainScreen] bounds].size.width
#define mScreenHeight [[UIScreen mainScreen] bounds].size.height

@implementation OpenServerSearchFrame

-(void) setPacketInfo:(AppPacketInfo *)packetInfo{
    //    if(!packetInfo){
    //        return;
    //    }
    //    self.packetInfo = packetInfo;
    _packetInfo = packetInfo;
    self.openServerFrameArray = [[NSMutableArray alloc] init];
    
    
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
    
    //    CGFloat downTextY = CGRectGetMaxY(self.downloadFrame) + 5;
    //    self.downloadTextFrame = CGRectMake(mScreenWidth - rightDownW, downTextY, 30, lblMiddleViewH);
    
    if(_packetInfo.openServerArray && _packetInfo.openServerArray.count > 0){
        int row = 0;
        int col = 0;
        CGFloat x, y;
        CGFloat btnW = 100, btnH = 30;
        for (int i = 0; i < _packetInfo.openServerArray.count; i++) {
            row = i / 2;
            col = i % 2;
            
            x = col * (itempadding + btnW) + itempadding;
            y = row * (itempadding + btnH) + padding;
            
            OpenServerPostion *pos = [[OpenServerPostion alloc] init];
            [pos setPosX:x];
            [pos setPosY:y];
            
            [self.openServerFrameArray addObject:pos];
        }
        
    }else{
        OpenServerPostion *pos = [[OpenServerPostion alloc] init];
        [pos setPosX:padding];
        [pos setPosY:itempadding];
        
        [self.openServerFrameArray addObject:pos];
    }
    
    
}
@end
