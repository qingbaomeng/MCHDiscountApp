//
//  ScoreLineView.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/23.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreLineView : UIView


@property (nonatomic, assign) float score;

-(void) setStarNumber:(int)curstar totalstar:(int)totalstar;

@end
