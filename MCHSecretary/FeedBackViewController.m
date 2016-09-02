//
//  FeedBackViewController.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/9/1.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "FeedBackViewController.h"

#define TopViewH 65
#define BarWIDTH 30

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

#define GetColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define TopBackColor GetColor(18,205,176,1.0)

@interface FeedBackViewController ()



@end

UITextView *textView;

UITextField *textField;

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addTopView];
    
    [self addTtextViewAndTextField];
}
-(void) addTopView{
    topview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopViewH)];
    [topview setBackgroundColor:TopBackColor];
    [self.view addSubview:topview];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(20, 25, BarWIDTH*2, BarWIDTH);
    [leftBtn setImage:[UIImage imageNamed:@"导航栏-箭头"] forState:UIControlStateNormal];
    [leftBtn setTitle:@"帮助" forState:UIControlStateNormal];
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    leftBtn.tag = 1;
    [leftBtn addTarget:self action:@selector(barbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [topview addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(kScreenWidth - BarWIDTH - 20, 25, BarWIDTH *2, BarWIDTH);
    [rightBtn setTitle:@"发送" forState:UIControlStateNormal];
    rightBtn.tag = 2;
    [rightBtn addTarget:self action:@selector(barbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [topview addSubview:rightBtn];
}
-(void)addTtextViewAndTextField
{
    textView = [[UITextView alloc]initWithFrame:CGRectMake(10, TopViewH+10, kScreenWidth - 20, 180)];
    textView.delegate = self;
    textView.layer.cornerRadius = 5;
    [textView.layer setBorderWidth:1];
    [textView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.view addSubview:textView];
    
    textField = [[UITextField alloc]initWithFrame:CGRectMake(10, TopViewH + 200, kScreenWidth - 20, 30)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.delegate = self;
    textField.placeholder = @"手机/QQ/邮箱";
    [self.view addSubview:textField];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(3, 5, 200, 20)];
    label.enabled = NO;
    label.text = @"在此输入反馈意见";
    label.font =  [UIFont systemFontOfSize:15];
    label.textColor = [UIColor lightGrayColor];
    [textView addSubview:label];
    
    numLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 160, kScreenWidth - 40, 20)];
    
    numLab.textAlignment = NSTextAlignmentRight;
    
    numLab.text = @"0/225";
    numLab.font = [UIFont systemFontOfSize:15];
    numLab.textColor = [UIColor lightGrayColor];
    
    [textView addSubview:numLab];
}
-(void)barbuttonClick:(UIButton *)btn
{
    if (btn.tag == 1)
    {
       [self.navigationController popViewControllerAnimated:YES];
    }
    if (btn.tag == 2)
    {
        UIAlertController *alertVC;
        if (textView.text.length == 0)
        {
            alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"反馈信息不能为空" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *alert = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            
            [alertVC addAction:alert];
            
            [self presentViewController:alertVC animated:YES completion:nil];
        }
        else
        {
            alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"反馈信息发送成功" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                
                [self performSelector:@selector(dismiss:) withObject:alertVC afterDelay:1.0f];
                
            }];
        }
    }
}
-(void)dismiss:(UIAlertController *)alertVC
{
    
    [alertVC dismissViewControllerAnimated:YES completion:nil];
    
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if(textView.tag == 0)
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
        textView.tag = 1;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    if([textView.text length] == 0)
    {
        [label setHidden:NO];
    }
    else
    {
        [label setHidden:YES];
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{
    numLab.text = [NSString stringWithFormat:@"%lu/225",(unsigned long)range.location];
    
    if (range.location > 225)
    {
        [self alertViewWithMessage:@"超出字数限制"];
        return NO;
    }
    return YES;
}
-(void)alertViewWithMessage:(NSString *)msg
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    
    [alertVC addAction:action];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [textField resignFirstResponder];
    
    [textView resignFirstResponder];
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
