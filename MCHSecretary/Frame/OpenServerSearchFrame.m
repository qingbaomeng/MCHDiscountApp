//
//  NomalFrame.m
//  MCHSecretary
//
//  Created by 朱进 on 16/8/9.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "OpenServerSearchFrame.h"
#import "OpenServerEntity.h"
#import "OpenServerPostion.h"

#import "StringUtils.h"

#define mScreenWidth [[UIScreen mainScreen] bounds].size.width
#define mScreenHeight [[UIScreen mainScreen] bounds].size.height

@implementation OpenServerSearchFrame

-(void) setPacketInfo:(OpenServerEntity *)packetInfo{
    [self setPacketInfo:packetInfo openserver:NO];
}

-(void) setPacketInfo:(OpenServerEntity *)packetInfo  openserver:(BOOL)isshow{
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
    
    CGFloat downY = itempadding + 7.5;
    CGFloat downX = mScreenWidth - rightDownW;
    self.downloadFrame = CGRectMake(downX, downY, 45, 45);
    
    CGFloat discountX = CGRectGetMaxX(self.nameFrame) + 10;
    self.discountFrame = CGRectMake(discountX, itempadding, 40, lblNameViewH);
    
    //    CGFloat downTextY = CGRectGetMaxY(self.downloadFrame) + 5;
    //    self.downloadTextFrame = CGRectMake(mScreenWidth - rightDownW, downTextY, 30, lblMiddleViewH);
    CGFloat lineY = CGRectGetMaxY(self.imageFrame) + itempadding;
    
    if(isshow){
        CGFloat btnW = (mScreenWidth - itempadding * 3) / 2, btnH = 30;
        if(_packetInfo.openServerArray != nil && _packetInfo.openServerArray.count > 0){
            int row = 0;
            int col = 0;
            CGFloat x, y;
            
            for (int i = 0; i < _packetInfo.openServerArray.count; i++) {
                row = i / 2;
                col = i % 2;
                
                x = col * (itempadding + btnW) + itempadding;
                y = row * (itempadding + btnH) + itempadding + CGRectGetMaxY(self.imageFrame);
                
                OpenServerPostion *pos = [[OpenServerPostion alloc] init];
                [pos setPosX:x];
                [pos setPosY:y];
                [pos setPosW:(mScreenWidth - itempadding * 3) / 2];
                NSLog(@"openServertime: %@", _packetInfo.openServerArray[i]);
                [pos setOpenTime:_packetInfo.openServerArray[i]];
                
                [self.openServerFrameArray addObject:pos];
            }
            
        }else{
            OpenServerPostion *pos = [[OpenServerPostion alloc] init];
            [pos setPosX:itempadding];
            [pos setPosY:padding + CGRectGetMaxY(self.imageFrame)];
            [pos setPosW:(mScreenWidth - itempadding * 2)];
            [pos setOpenTime:NSLocalizedString(@"NoOpenServerInfo", @"")];
            
            [self.openServerFrameArray addObject:pos];
        }
        
        lineY += padding + btnH;
    }
    
    CGFloat allServerW = 13 * 9;
    self.showAllServerFrame = CGRectMake(mScreenWidth - allServerW - 20, lineY - 6, allServerW, 13);
    
//    CGFloat lineY = CGRectGetMaxY(self.imageFrame) + itempadding;
    CGFloat lineW = mScreenWidth - 10;
    if(_packetInfo.openServerArray.count > 2){
        lineW  = mScreenWidth - 10 - allServerW - 10;
    }
    self.lineFrame = CGRectMake(10, lineY, lineW, 1);
    
    self.cellHeight = CGRectGetMaxY(self.lineFrame) + 10;
    
    
}
@end
