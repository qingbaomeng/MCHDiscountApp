//
//  IndexController.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/26.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppInfoTableView.h"
#import "OpenServerTableView.h"

@interface IndexController : UIViewController<UIScrollViewDelegate, AppInfoDelegate, OpenServerDelegate>{
    UIScrollView *switchScrollView;
}

@end
