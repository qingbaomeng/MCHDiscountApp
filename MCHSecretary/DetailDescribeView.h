//
//  DetailDescribeView.h
//  MCHSecretary
//
//  Created by 朱进 on 16/8/19.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppPacketInfo;

@interface DetailDescribeView : UIView

{
    UILabel *txtDescribe;
    CGSize descMax;
    UIView *descriptLine;
    UIButton *moreButton;
    
}

-(instancetype) initWithFrame:(CGRect)frame appInfo:(AppPacketInfo *)info;

@end
