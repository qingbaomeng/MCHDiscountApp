//
//  DetailDescribeView.m
//  MCHSecretary
//
//  Created by 朱进 on 16/8/19.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "DetailDescribeView.h"

#import "WebImage.h"
#import "StringUtils.h"

#import "AppPacketInfo.h"

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width

#define LABWIDTH kScreenWidth/2-15

#define GetColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define LineColor GetColor(230,230,230,1.0)
#define TextColor GetColor(102,102,102,1.0)

#define GetFont(s) [UIFont systemFontOfSize:s]
#define TitleFont GetFont(18)
#define ContentTextSize 13
#define TextFont GetFont(ContentTextSize)

CGFloat LineY;
UIView *bgView;

@implementation DetailDescribeView

-(instancetype) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initSubView];
    }
    return self;
}

-(instancetype) initWithFrame:(CGRect)frame appInfo:(AppPacketInfo *)info{
    if(self = [super initWithFrame:frame]){
        [self initAppDetail:info];
    }
    return self;
}

-(void) initSubView{
    
}

-(void)initAppDetail:(AppPacketInfo *)info{
    CGFloat ivScrollY = 0;
    UIScrollView *imageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ivScrollY, kScreenWidth, 304)];
    imageScroll.backgroundColor = [UIColor cyanColor];
    imageScroll.scrollEnabled = YES;
    imageScroll.showsHorizontalScrollIndicator = NO;
    imageScroll.showsVerticalScrollIndicator = NO;
    //    imageScroll.bounces = YES;
    
    NSString *imageUrls = info.describeImages;
    NSArray *array = [imageUrls componentsSeparatedByString:@","];
    CGFloat contentW = 0;
    for (int i = 0; i < array.count; i++) {
        //        NSLog(@"image url(%d):%@", i, [array objectAtIndex:i]);
        UIImageView *ivDesc = [[UIImageView alloc] initWithFrame:CGRectMake(10 + (10 + 160) * i, 10, 160, 284)];
        [ivDesc sd_setImageWithURL:array[i] placeholderImage:[UIImage imageNamed:@"load_fail"]];
        contentW = CGRectGetMaxX(ivDesc.frame) + 10;
        [imageScroll addSubview:ivDesc];
    }
    CGSize scrollSize = CGSizeMake(contentW, 304);
    imageScroll.contentSize = scrollSize;
    [self addSubview:imageScroll];
    //    NSLog(@"contentSize :%@", NSStringFromCGSize(imageScroll.contentSize));
    //    NSLog(@"frame.size :%@", NSStringFromCGSize(imageScroll.frame.size));
    
    
    CGFloat sLineY = CGRectGetMaxY(imageScroll.frame);
    UIView *scrollLine = [[UIView alloc] initWithFrame:CGRectMake(0, sLineY, kScreenWidth, 1)];
    [scrollLine setBackgroundColor:LineColor];
    [self addSubview:scrollLine];
    
    [self addDescribeView:info position:CGRectGetMaxY(scrollLine.frame) + 15 extend:YES];
    
}
//内容简介
-(void)addDescribeView:(AppPacketInfo*)info position:(CGFloat)posY extend:(BOOL)isextend{
    
    UILabel *lblDescribe = [[UILabel alloc] init];
    [lblDescribe setFrame:CGRectMake(15, posY, 100, 20)];
    [lblDescribe setFont:TitleFont];
    [lblDescribe setTextColor:[UIColor blackColor]];
    [lblDescribe setNumberOfLines:1];
    [lblDescribe setText:NSLocalizedString(@"ContentDescribe", @"")];
    
    LineY = posY + 30;
    
    txtDescribe = [[UILabel alloc] init];
    if(isextend){
        [txtDescribe setNumberOfLines:3];
        descMax = [StringUtils sizeWithString:info.contentDescribe font:TextFont maxSize:CGSizeMake(kScreenWidth - 30, 0)];
        [txtDescribe setFrame:CGRectMake(15, LineY, descMax.width, 50)];
    }else{
        [txtDescribe setNumberOfLines:2];
        [txtDescribe setFrame:CGRectMake(15, posY + 30, kScreenWidth - 30, ContentTextSize * 2)];
    }
    [txtDescribe setFont:TextFont];
    [txtDescribe setTextColor:TextColor];
    [txtDescribe setText:info.contentDescribe];
    [self addSubview:lblDescribe];
    [self addSubview:txtDescribe];
    
    CGFloat sLineY = CGRectGetMaxY(txtDescribe.frame) + 15;
    descriptLine = [[UIView alloc] initWithFrame:CGRectMake(0, sLineY, kScreenWidth - 100, 1)];
    [descriptLine setBackgroundColor:LineColor];
    [self addSubview:descriptLine];
    
    moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreButton setTitle:@"展开更多 V" forState:UIControlStateNormal];
    [moreButton setTitleColor:TextColor forState:UIControlStateNormal];
    moreButton.titleLabel.font = [UIFont systemFontOfSize:13];
    moreButton.frame = CGRectMake(descriptLine.frame.size.width, CGRectGetMaxY(txtDescribe.frame), 100, 30);
    [moreButton addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:moreButton];
    
    [self addVerisionView:info position:CGRectGetMaxY(descriptLine.frame)+ 15 extend:YES];
}
-(void)moreClick
{
    txtDescribe.numberOfLines = 0;
    [txtDescribe setFrame:CGRectMake(15, LineY, descMax.width, descMax.height)];
    descriptLine.hidden = YES;
    moreButton.hidden = YES;
    bgView.frame = CGRectMake(0,txtDescribe.frame.origin.y + descMax.height + 15, kScreenWidth, ContentTextSize * 4 +160);
}
//版本信息
-(void)addVerisionView:(AppPacketInfo*)info position:(CGFloat)posY extend:(BOOL)isextend{
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, posY, kScreenWidth, ContentTextSize * 4 +160)];
    [self addSubview:bgView];
    
    UILabel *lblVerision = [[UILabel alloc] init];
    [lblVerision setFrame:CGRectMake(15, 0, 100, 20)];
    [lblVerision setFont:TitleFont];
    [lblVerision setTextColor:[UIColor blackColor]];
    [lblVerision setNumberOfLines:1];
    [lblVerision setText:NSLocalizedString(@"VersionInfo", @"")];
    [bgView addSubview:lblVerision];
    
    float padding = 15;
    
    //应用包大小
    
    UILabel *lblSize = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, LABWIDTH, ContentTextSize)];
    [lblSize setFont:TextFont];
    [lblSize setTextColor:TextColor];
    lblSize.text = [NSString stringWithFormat:@"%@ : %@MB",NSLocalizedString(@"AppSize", @""),info.packetSize];
    [bgView addSubview:lblSize];
    
    //版本信息
    UILabel *lblVersionNum = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2,30, LABWIDTH, ContentTextSize)];
    [lblVersionNum setFont:TextFont];
    [lblVersionNum setTextColor:TextColor];
    lblVersionNum.text = [NSString stringWithFormat:@"%@ : %@",NSLocalizedString(@"VersionNumber", @""),info.versionInfo];
    [bgView addSubview:lblVersionNum];
    
    //更新时间
    CGFloat upDataY = CGRectGetMaxY(lblSize.frame) + padding;
    UILabel *lblUpdateData = [[UILabel alloc] initWithFrame:CGRectMake(15, upDataY, LABWIDTH, ContentTextSize)];
    [lblUpdateData setFont:TextFont];
    [lblUpdateData setTextColor:TextColor];
    lblUpdateData.text = [NSString stringWithFormat:@"%@ : %@",NSLocalizedString(@"AppUpdateData", @""),info.updateData];
    [bgView addSubview:lblUpdateData];
    
    
    //应用类型
    UILabel *lblType = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2, upDataY, LABWIDTH, ContentTextSize)];
    [lblType setFont:TextFont];
    [lblType setTextColor:TextColor];
    lblType.text = [NSString stringWithFormat:@"%@ : %@",NSLocalizedString(@"AppType", @""),info.appType];
    [bgView addSubview:lblType];
    
    //语言
    CGFloat languageY = CGRectGetMaxY(lblType.frame) + padding;
    UILabel *lblLanguage = [[UILabel alloc] initWithFrame:CGRectMake(15, languageY, LABWIDTH, ContentTextSize)];
    [lblLanguage setFont:TextFont];
    [lblLanguage setTextColor:TextColor];
    lblLanguage.text = [NSString stringWithFormat:@"%@ :%@",NSLocalizedString(@"AppLanguage", @""),info.language];
    [bgView addSubview:lblLanguage];
    
    //开发商
    UILabel *lblDevelop = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2, languageY, LABWIDTH, ContentTextSize)];
    [lblDevelop setFont:TextFont];
    [lblDevelop setTextColor:TextColor];
    lblDevelop.text = [NSString stringWithFormat:@"%@ :%@",NSLocalizedString(@"AppDeveloper", @""),info.developCompany];
    [bgView addSubview:lblDevelop];
    
    //兼容性
    CGFloat compatibleY = CGRectGetMaxY(lblDevelop.frame) + padding;
    UILabel *lblCompatible = [[UILabel alloc] initWithFrame:CGRectMake(15, compatibleY, kScreenWidth - 30, ContentTextSize*3)];
    [lblCompatible setFont:TextFont];
    [lblCompatible setTextColor:TextColor];
    lblCompatible.text = [NSString stringWithFormat:@"%@ : %@",NSLocalizedString(@"AppCompatible", @""),info.compatible];
    [lblCompatible setNumberOfLines:0];
    [bgView addSubview:lblCompatible];
    
    //    NSLog(@"%@", NSStringFromCGRect(txtVerision.frame));
    CGFloat detailY = CGRectGetMaxY(bgView.frame);
    CGRect r = self.frame;
    r.size.height = detailY;
    [self setFrame:r];
    //    NSLog(@"%f", detailY);
//    detailScrollView.contentSize = CGSizeMake(kScreenWidth, detailY);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
