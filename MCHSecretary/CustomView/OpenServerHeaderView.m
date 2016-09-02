//
//  OpenServerHeaderView.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/29.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "OpenServerHeaderView.h"

#define BackColor [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0]

@interface OpenServerHeaderView(){
    UILabel *lblTitle;
}

@end

@implementation OpenServerHeaderView

+(instancetype) headerWithTableView:(UITableView *)tableView{
    NSString *identifier = @"openserverheaderview";
    
    OpenServerHeaderView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if(!headerView){
        headerView = [[OpenServerHeaderView alloc] initWithReuseIdentifier:identifier];
    }
    return headerView;
}

-(instancetype) initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width + 5, 20)];
        [view setBackgroundColor:BackColor];
        
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, view.bounds.size.width - 20, view.bounds.size.height)];
        [lblTitle setFont:[UIFont systemFontOfSize:12]];
        [lblTitle setTextColor:[UIColor blackColor]];
        [lblTitle setNumberOfLines:1];
        [lblTitle setTextAlignment:NSTextAlignmentCenter];
        [lblTitle setText:@""];
        
        [view addSubview:lblTitle];
        
        [self.contentView addSubview:view];
    }
    return self;
}

-(void) setTitleContent:(NSString *)title{
    [lblTitle setText:title];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
