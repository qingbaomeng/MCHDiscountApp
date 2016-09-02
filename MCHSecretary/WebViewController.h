//
//  WebViewController.h
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/9/1.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgress.h"

@interface WebViewController : UIViewController<UIWebViewDelegate,NJKWebViewProgressDelegate>
{
    UIView *topview;
    NJKWebViewProgress *progressProxy;
    UIProgressView *progressView;
}
@property(nonatomic,copy)NSString *descriptStr;

@end
