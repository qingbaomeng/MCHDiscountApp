//
//  TabbarBtn.m
//  XiGuMobileGame
//
//  Created by zhujin zhujin on 17/2/15.
//  Copyright © 2017年 zhujin zhujin. All rights reserved.
//

#import "TabbarBtn.h"
#define K_ScreenWidth [UIScreen mainScreen].bounds.size.width
#define K_ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface TabbarBtn ()

@property (nonatomic,retain) UIButton *btn;

@end

@implementation TabbarBtn

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
//        [self addSubview:self.btn];
    }
    
    return self;
}

//加载子视图的时候调用
- (void)layoutSubviews{
    
    [super layoutSubviews];
    //tabbar 遮挡了按钮
    [self bringSubviewToFront:_btn];
   
}

#pragma mark  setter && getter

- (UIButton *)btn{
    //    screen/2 - btn/2
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake((K_ScreenWidth-64)/2.0, 2, 64, 44);
//        [_btn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
//        [_btn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        [_btn setImage:[UIImage imageNamed:@"barBtn_home_select"] forState:UIControlStateNormal];
        [_btn setImage:[UIImage imageNamed:@"barBtn_home_select"] forState:UIControlStateHighlighted];
//        [_btn setTitle:@"官网" forState:UIControlStateNormal];
//        [_btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
       
    }
    
    return _btn;
    
    
}

- (void)click:(id)btn{
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL * stop) {
                NSLog(@"obj>>>>>>%ld::%@",idx,obj);
        //tabbar 上面有几个模块，就有几个<UITabBarButton: 0x79f944c0; frame = (109 1; 102 48); opaque = NO; layer = <CALayer: 0x79f93660>>
        //索引是2的时候 就是大按钮对应的    中间模块
        if (idx==3) {
            //           注册事件
            UIControl *control = obj;
            [control sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }];
    
}
@end
