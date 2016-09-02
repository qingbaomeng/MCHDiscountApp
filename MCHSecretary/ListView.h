//
//  ListView.h
//  ShareAndCell
//
//  Created by zhujin zhujin on 16/8/29.
//  Copyright © 2016年 zhujin zhujin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListView : UIView

@property(nonatomic,retain)UILabel *titleLab;

-(void)addImageAndLabWithNum:(int)num;

-(void)addSmallLab;

@end
