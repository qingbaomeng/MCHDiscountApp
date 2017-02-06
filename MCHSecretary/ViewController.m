//
//  ViewController.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 2017/2/4.
//  Copyright © 2017年 朱进. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import "HelpRequest.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    load_fail
    [[[HelpRequest alloc]init]requestForHelp:^(NSDictionary *dict) {
        NSLog(@"requestForHelpView:%@",dict);
        
        NSString *imgURL = nil;
        imgURL = dict[@"icon"];
        
        [_bgImageView sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"load_fail"]];
        
        [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(customTo) userInfo:nil repeats:NO];
        
    } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
        [self performSegueWithIdentifier:@"customToTabBar" sender:nil];
    }];

}
-(void)customTo
{
    [self performSegueWithIdentifier:@"customToTabBar" sender:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
