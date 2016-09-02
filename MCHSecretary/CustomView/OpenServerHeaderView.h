//
//  OpenServerHeaderView.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/29.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenServerHeaderView : UITableViewHeaderFooterView

+(instancetype) headerWithTableView:(UITableView *)tableView;

-(void) setTitleContent:(NSString *)title;

@end
