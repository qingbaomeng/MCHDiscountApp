//
//  InstallAppViewController.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/30.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstallAppCell.h"

@interface InstallAppViewController : UIViewController
<
UITextFieldDelegate,
UITableViewDelegate,
UITableViewDataSource,
InstallAppDelegate
>

@property (strong, nonatomic) NSMutableArray *listItemArray;


@end
