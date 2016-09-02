//
//  CommentCell.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/24.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentFrame;

@interface CommentCell : UITableViewCell

@property (nonatomic, strong) CommentFrame *commentFrame;

+(instancetype) cellWithTableView:(UITableView *)tableView;

@end
