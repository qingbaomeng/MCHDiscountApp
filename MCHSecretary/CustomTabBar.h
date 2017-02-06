//
//  CustomTabBar.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 2017/2/3.
//  Copyright © 2017年 朱进. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE  // 动态刷新
@interface CustomTabBar : UITabBar
// 加上IBInspectable就可以可视化显示相关的属性哦

/** 可视化tabBar点击时颜色 */
@property (nonatomic, strong)IBInspectable UIColor *TabBartintColor;

@end
