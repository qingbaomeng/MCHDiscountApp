//
//  ListView.m
//  ShareAndCell
//
//  Created by zhujin zhujin on 16/8/29.
//  Copyright © 2016年 zhujin zhujin. All rights reserved.
//

#import "ListView.h"

#define ImageWidth 20
#define TitleWidth 150
#define TitleHeight 30

#define ImageRectY (self.frame.size.height-ImageWidth)/2
#define TitleRectY (self.frame.size.height-TitleHeight)/2
#define TitleRectX ImageWidth + 40

#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height

@implementation ListView
-(void)addImageAndLabWithNum:(int)num
{
    NSArray *titleArr = [NSArray arrayWithObjects:@"安装闪退修复工具",@"关于折扣和充值",@"反馈",@"更新", nil];
    
    NSArray *imageArr =[NSArray arrayWithObjects:@"xiu",@"money",@"edit",@"update", nil];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(20, ImageRectY, ImageWidth, ImageWidth)];
    
    imageV.image = [UIImage imageNamed:imageArr[num]];
    
    [self addSubview:imageV];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(TitleRectX, TitleRectY, TitleWidth, TitleHeight)];
    
    titleLab.text = titleArr[num];
    
    [self addSubview:titleLab];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, HEIGHT - 1, WIDTH - 20, 1)];
    
    label.backgroundColor = [UIColor grayColor];
    
    [self addSubview:label];
}
-(void)addSmallLab
{
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH - 120, TitleRectY, 100, TitleHeight)];
    
    _titleLab.textAlignment = NSTextAlignmentRight;
    
    _titleLab.font = [UIFont systemFontOfSize:13];
    
    _titleLab.textColor = [UIColor grayColor];
    
    _titleLab.text = @"v1.0.0";
    
    [self addSubview:_titleLab];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
