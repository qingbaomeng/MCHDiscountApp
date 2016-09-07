//
//  InstallAppCell.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/9/7.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InstallAppDelegate <NSObject>

-(void) repairApp:(NSInteger)index;

@end

@class InstallAppFrame;

@interface InstallAppCell : UITableViewCell

@property (nonatomic, strong) InstallAppFrame *installAppFrame;

+(instancetype) cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id<InstallAppDelegate> delegate;

-(void) setFrame:(InstallAppFrame *)frame pos:(NSInteger)index;

@end
