//
//  DetailCommentView.h
//  MCHSecretary
//
//  Created by 朱进 on 16/8/19.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CWStarRateView.h"

@interface DetailCommentView : UIView
<
CWStarRateViewDelegate,
UITableViewDelegate,
UITableViewDataSource
>
{
    NSInteger selectStar;
    NSArray *commentArray;
}

-(void) requestAppComment;

@end
