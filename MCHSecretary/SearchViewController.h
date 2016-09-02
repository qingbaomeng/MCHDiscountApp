//
//  SearchViewController.h
//  MCHSecretary
//
//  Created by 朱进 on 16/8/12.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NomalCell.h"

@interface SearchViewController : UIViewController
<
UITextFieldDelegate,
UITableViewDelegate,
UITableViewDataSource,
DownloadAppDelegate
>

@property (strong, nonatomic) NSMutableArray *listItemArray;

-(void) searchOpenServerGame;

@end
