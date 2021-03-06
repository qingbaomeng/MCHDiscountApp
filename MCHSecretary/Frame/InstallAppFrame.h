//
//  InstallAppFrame.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/9/7.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class InstallAppInfo;

@interface InstallAppFrame : NSObject

@property (nonatomic, strong) InstallAppInfo *installAppInfo;

@property (nonatomic, assign) CGRect imageFrame;

@property (nonatomic, assign) CGRect nameFrame;

@property (nonatomic, assign) CGRect middleFrame;

@property (nonatomic, assign) CGRect describeFrame;

@property (nonatomic, assign) CGRect downloadFrame;

@property (nonatomic, assign) CGRect discountFrame;

@property (nonatomic, assign) CGRect lineFrame;

@property (nonatomic, assign) CGFloat cellHeight;

@end
