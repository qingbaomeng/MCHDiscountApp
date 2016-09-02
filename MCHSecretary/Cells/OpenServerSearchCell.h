//
//  OpenServerSearchCell.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/9/1.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol OpenServerSearchDelegate <NSObject>

-(void) startDownloadApp:(NSInteger)index;

-(void) showAllOpenServerInfo:(NSInteger)index;

@end

@class OpenServerSearchFrame;

@interface OpenServerSearchCell : UITableViewCell

@property (nonatomic, strong) OpenServerSearchFrame *openServerSearchFrame;

+(instancetype) cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id<OpenServerSearchDelegate> delegate;

-(void) setOpenServerSearchFrame:(OpenServerSearchFrame *)openServerSearchFrame pos:(NSInteger)index openserver:(BOOL)isshow;


@end
