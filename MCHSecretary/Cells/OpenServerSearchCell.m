//
//  NomalCell.m
//  MCHSecretary
//
//  Created by 朱进 on 16/8/9.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "OpenServerSearchCell.h"

#import "AppPacketInfo.h"
#import "openServerSearchFrame.h"
#import "WebImage.h"
#import "StringUtils.h"

#define kScreesWidth [[UIScreen mainScreen] bounds].size.width

#define GetFont(s) [UIFont systemFontOfSize:s]
#define ServerFont GetFont(10)
#define NameFont [UIFont systemFontOfSize:15]
#define MiddleFont [UIFont systemFontOfSize:10]
#define DescribeFont [UIFont systemFontOfSize:12]
#define LineColor [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1.0]
#define MiddleTextColor [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1.0]
#define DescribeColor [UIColor colorWithRed:50 / 255.0 green:50 / 255.0 blue:50 / 255.0 alpha:1.0]

@interface OpenServerSearchCell(){
    NSInteger currentSection;
}

@property (nonatomic, weak) UIImageView * ivAppIcon;
@property (nonatomic, weak) UILabel * lblName;
@property (nonatomic, weak) UILabel * lblMiddle;
@property (nonatomic, weak) UILabel * lblDescribe;
@property (nonatomic, weak) UIButton * btnDiscount;
@property (nonatomic, weak) UIButton * btnDownload;
@property (nonatomic, weak) UIButton * btnDownloadText;
@property (nonatomic, weak) UIView * lineview;

@end



@implementation OpenServerSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+(instancetype) cellWithTableView:(UITableView *)tableView{
    static NSString *identifer = @"nomallist";
    
    OpenServerSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if(cell == nil){
        cell = [[OpenServerSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        UIImageView *icon = [[UIImageView alloc] init];
        icon.layer.cornerRadius = 13;
        icon.layer.borderWidth = 0.5;
        icon.layer.borderColor = [LineColor CGColor];
        [self.contentView addSubview:icon];
        self.ivAppIcon = icon;
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = NameFont;
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.numberOfLines = 1;
        [self.contentView addSubview:nameLabel];
        self.lblName = nameLabel;
        
        UILabel *middleLabel = [[UILabel alloc] init];
        middleLabel.font = MiddleFont;
        middleLabel.textColor = MiddleTextColor;
        middleLabel.numberOfLines = 1;
        [self.contentView addSubview:middleLabel];
        self.lblMiddle = middleLabel;
        
        UIButton *discount = [[UIButton alloc] init];
        [discount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        discount.titleLabel.font = ServerFont;
        [discount setBackgroundImage:[UIImage imageNamed:@"discount.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:discount];
        self.btnDiscount = discount;
        
        UILabel *describeLabel = [[UILabel alloc] init];
        describeLabel.font = DescribeFont;
        describeLabel.textColor = DescribeColor;
        describeLabel.numberOfLines = 1;
        [self.contentView addSubview:describeLabel];
        self.lblDescribe = describeLabel;
        
        UIButton *btndown = [[UIButton alloc] init];
        [self.contentView addSubview:btndown];
        self.btnDownload = btndown;
        
        //        UIButton *btndowntext = [[UIButton alloc] init];
        //        [btndowntext setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        //        btndowntext.titleLabel.font = DescribeFont;
        //        btndowntext.titleLabel.numberOfLines = 1;
        //        btndowntext.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        //        [self.contentView addSubview:btndowntext];
        //        self.btnDownloadText = btndowntext;
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = LineColor;
        [self.contentView addSubview:line];
        self.lineview = line;
    }
    return self;
}

-(void) setOpenServerSearchFrame:(OpenServerSearchFrame *)openServerSearchFrame section:(NSInteger)section pos:(NSInteger)index{
    _openServerSearchFrame = openServerSearchFrame;
    
    [self setSubViewData:section pos:index];
    [self setSubViewFrame];
    
    [self addOpenServerList];
}

-(void) setSubViewData:(NSInteger)section pos:(NSInteger)index{
    AppPacketInfo * packInfo = self.openServerSearchFrame.packetInfo;
    currentSection = section;
    
    [self.ivAppIcon sd_setImageWithURL:[NSURL URLWithString:packInfo.smallImageUrl] placeholderImage:[UIImage imageNamed:@"tabbtn_choice_select"]];
    
    self.lblName.text = packInfo.packetName;
    
    NSString *packetDown = [NSString stringWithFormat:@"%@%@", packInfo.appDownloadNum, NSLocalizedString(@"AppDownNumber", @"")];
    NSString *packetSize = [NSString stringWithFormat:@"%@MB", packInfo.packetSize];
    self.lblMiddle.text = [NSString stringWithFormat:@"%@ · %@", packetDown, packetSize];
    
    self.lblDescribe.text = packInfo.appDescribe;
    
    [self.btnDownload setBackgroundImage:[UIImage imageNamed:@"appinstall"] forState:UIControlStateNormal];
    self.btnDownload.tag = index;
    [self.btnDownload addTarget:self action:@selector(downloadApp:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnDownloadText setTitle:NSLocalizedString(@"AppDownload", @"") forState:UIControlStateNormal];
    
    if ([StringUtils isBlankString:packInfo.appDiscount]) {
        [self.btnDiscount setHidden:YES];
    }else{
        NSString *leftdiscountStr = [NSString stringWithFormat:@"%@%@", packInfo.appDiscount, NSLocalizedString(@"AppDiscount", @"")];
        [self.btnDiscount setTitle:leftdiscountStr forState:UIControlStateNormal];
    }
    
}

-(void) setSubViewFrame{
    self.ivAppIcon.frame = self.openServerSearchFrame.imageFrame;
    self.lblName.frame = self.openServerSearchFrame.nameFrame;
    self.lblMiddle.frame = self.openServerSearchFrame.middleFrame;
    self.lblDescribe.frame = self.openServerSearchFrame.describeFrame;
    self.btnDiscount.frame = self.openServerSearchFrame.discountFrame;
    self.btnDownload.frame = self.openServerSearchFrame.downloadFrame;
    self.btnDownloadText.frame = self.openServerSearchFrame.downloadTextFrame;
    self.lineview.frame = self.openServerSearchFrame.lineFrame;
}

-(void) addOpenServerList{
    if(_openServerSearchFrame.openServerFrameArray &&
       _openServerSearchFrame.openServerFrameArray.count > 0){
        
    }else{
//        UILabel *lblos = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, kScreesWidth - 20, 30)];
//        lblos.layer.cornerRadius = 10;
//        [lblos setBackgroundColor:[UIColor whiteColor]];
//        lblos.layer.borderWidth = 1;
//        lblos.layer.borderColor = [TopBackColor CGColor];
//        [lblos setTitle:txt forState:UIControlStateNormal];
//        [lblos setTitleColor:TopBackColor forState:UIControlStateNormal];
//        lblos.titleLabel.font = SearchBtnFont;
//        lblos.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//        lblos.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
}

-(void) downloadApp:(UIButton *)sender{
    //    NSLog(@"%ld", (long)currentSection);
    NSInteger index = sender.tag;
    if (_delegate) {
        [_delegate startDownloadApp:currentSection index:index];
    }
}










@end
