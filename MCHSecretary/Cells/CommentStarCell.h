//
//  CommentStarCell.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/25.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWStarRateView.h"

@class CommentStarFrame;

@interface CommentStarCell : UITableViewCell<CWStarRateViewDelegate>

@property (nonatomic, strong) CommentStarFrame * starFrame;


+(instancetype) cellWithTableView:(UITableView *)tableView;

@end
