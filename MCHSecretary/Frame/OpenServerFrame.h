//
//  OpenServerFrame.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/26.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class OpenServerEntity;

@interface OpenServerFrame : NSObject

@property (nonatomic, strong) OpenServerEntity *leftApp;
@property (nonatomic, strong) OpenServerEntity *rightApp;

@property (nonatomic, assign) CGRect leftViewFrame;

@property (nonatomic, assign) CGRect leftImageFrame;
@property (nonatomic, assign) CGRect leftNameFrame;
@property (nonatomic, assign) CGRect leftServerFrame;
@property (nonatomic, assign) CGRect leftDiscountFrame;

@property (nonatomic, assign) CGRect rightViewFrame;

//@property (nonatomic, assign) CGRect rightImageFrame;
//@property (nonatomic, assign) CGRect rightNameFrame;
//@property (nonatomic, assign) CGRect rightServerFrame;
//@property (nonatomic, assign) CGRect rightDiscountFrame;

@property (nonatomic, assign) CGRect lineFrame;

@property (nonatomic, assign) CGFloat cellHeight;

-(void) setData:(OpenServerEntity*)firstApp secondApp:(OpenServerEntity*)secondApp;

@end
