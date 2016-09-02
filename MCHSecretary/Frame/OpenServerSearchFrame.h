//
//  OpenServerSearchFrame.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/9/1.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class OpenServerEntity;

@interface OpenServerSearchFrame : NSObject

@property (nonatomic, strong) OpenServerEntity *packetInfo;

@property (nonatomic, assign) CGRect imageFrame;

@property (nonatomic, assign) CGRect nameFrame;

@property (nonatomic, assign) CGRect middleFrame;

@property (nonatomic, assign) CGRect describeFrame;

@property (nonatomic, assign) CGRect downloadFrame;

@property (nonatomic, assign) CGRect discountFrame;

@property (nonatomic, assign) CGRect downloadTextFrame;

@property (nonatomic, strong) NSMutableArray *openServerFrameArray;

@property (nonatomic, assign) CGRect showAllServerFrame;

@property (nonatomic, assign) CGRect lineFrame;

@property (nonatomic, assign) CGFloat cellHeight;

-(void) setPacketInfo:(OpenServerEntity *)packetInfo openserver:(BOOL)isshow;

@end
