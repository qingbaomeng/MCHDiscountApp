//
//  OpenServerTableView.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/26.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenServerCell.h"


@protocol OpenServerDelegate <NSObject>

-(void) startSearchApp;

-(void) showAppDetailInfo:(NSString *)appid;

@end

@interface OpenServerTableView : UIView<UITableViewDelegate, UITableViewDataSource, OpenServerDetailDelegate>{
    UITableView *openserverTable;
    
    UIButton *btnToday;
    UIButton *btnTomorrow;
    UIView *selectLineView;
}

@property (strong, nonatomic) NSMutableArray *listItemArray;

@property(nonatomic,retain)UIButton *btnSearchContent;

@property (nonatomic, assign) id<OpenServerDelegate> delegate;

-(void)requestAppInfo;

@end
