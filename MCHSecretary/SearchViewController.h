//
//  SearchViewController.h
//  MCHSecretary
//
//  Created by 朱进 on 16/8/12.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenServerSearchCell.h"

@interface SearchViewController : UIViewController
<
UITextFieldDelegate,
UITableViewDelegate,
UITableViewDataSource,
OpenServerSearchDelegate
>
{
    int page;
}
@property (strong, nonatomic) NSMutableArray *listItemArray;
@property (strong, nonatomic) NSMutableArray *listsearchItemArray;
@property (strong,nonatomic) NSMutableArray *defaultItemArray;

-(void) searchOpenServerGame;

@end
