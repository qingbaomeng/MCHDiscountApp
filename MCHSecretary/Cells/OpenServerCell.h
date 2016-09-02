//
//  OpenServerCell.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/26.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OpenServerFrame;

@interface OpenServerCell : UITableViewCell

@property (nonatomic, strong) OpenServerFrame *openServerFrame;

+(instancetype) cellWithTableView:(UITableView *)tableView;

@end
