//
//  ToolView.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/9/18.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "ToolView.h"

#define CENTERX self.center.x
#define CENTERY self.center.y
#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height

UIImageView *imageV;

@implementation ToolView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img"]];
        imageV.center = CGPointMake(CENTERX, CENTERY *0.5);
        imageV.bounds = CGRectMake(0, 0, WIDTH *0.5, WIDTH *0.5);
        imageV.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:imageV];
        
        UILabel *orangeLab = [[UILabel alloc]init];
        orangeLab.center = CGPointMake(CENTERX,imageV.frame.origin.y + imageV.frame.size.height + 50);
        orangeLab.bounds = CGRectMake(0, 0, 310, 60);
        orangeLab.textColor = [UIColor orangeColor];
        orangeLab.font = [UIFont systemFontOfSize:17];
        orangeLab.textAlignment = NSTextAlignmentCenter;
        orangeLab.text = @"点击下方按钮安装[折扣修复工具]。折扣手游发生闪退时，可用该工具进行修复。";
        orangeLab.numberOfLines = 2;
        

        [self addSubview:orangeLab];
        
        _downToolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _downToolBtn.center = CGPointMake(CENTERX, orangeLab.frame.origin.y + orangeLab.frame.size.height + 30);
        _downToolBtn.bounds = CGRectMake(0, 0, 260, 50);
        _downToolBtn.backgroundColor = [UIColor orangeColor];
        _downToolBtn.layer.cornerRadius = 5;
        [_downToolBtn setTitle:@"立即安装(只需1秒)" forState:UIControlStateNormal];
        [self addSubview:_downToolBtn];
        
        UILabel *lable = [[UILabel alloc]init];
        lable.center = CGPointMake(CENTERX, _downToolBtn.frame.size.height + _downToolBtn.frame.origin.y + 50);
        lable.textColor = [UIColor lightGrayColor];
        lable.bounds = CGRectMake(0, 0, 315, 60);
        lable.font = [UIFont systemFontOfSize:17];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text = @"如不选择安装，发生闪退时请前往官网http://zhekou.vlcms.com安装新客户端。";
        lable.numberOfLines = 2;
        [self addSubview:lable];
    }
    return self;
}
-(void)viewFrame
{
    [imageV addConstraints:
     @[
       [NSLayoutConstraint constraintWithItem:imageV attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:100],
       [NSLayoutConstraint constraintWithItem:imageV attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:100],
       
       [NSLayoutConstraint constraintWithItem:imageV attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-100],
       
       [NSLayoutConstraint constraintWithItem:imageV attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-100],
       ]
     ];
    

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
