//
//  AppInfoTableView.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/26.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HomeGameInfo.h"
#import "NomalCell.h"
#import "CycleScrollerView.h"

@protocol AppInfoDelegate <NSObject>

-(void) showAppInfo:(int)infoID;

@end

@interface AppInfoTableView : UIView
<
UITableViewDelegate,
UITableViewDataSource,
DownloadAppDelegate,
CycleScrollItemDelegate
>
@property (strong, nonatomic) NSMutableArray *listItemArray;
@property (strong, nonatomic) NSMutableArray *scrolImagesArray;
@property (nonatomic, assign) id<AppInfoDelegate> delegate;

-(void) requestAppInfo;


@end
