//
//  OpenServerCell.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/26.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol OpenServerDetailDelegate <NSObject>

-(void) showAppDetail:(NSInteger)section index:(NSInteger)index;

@end

@class OpenServerFrame;

@interface OpenServerCell : UITableViewCell

@property (nonatomic, strong) OpenServerFrame *openServerFrame;

@property (nonatomic, assign) id<OpenServerDetailDelegate> delegate;

+(instancetype) cellWithTableView:(UITableView *)tableView;

-(void) setSelectRow:(NSInteger)section row:(NSInteger)index;

@end
